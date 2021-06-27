import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:outerboxadmin/src/features/database/database_helper.dart';
import 'package:outerboxadmin/src/features/login/models/token.dart';
import 'package:outerboxadmin/src/features/login/models/user_model.dart';
import 'package:outerboxadmin/src/models/FirebaseUser.dart';
import 'package:outerboxadmin/src/models/headoffice_details.dart';
import 'package:outerboxadmin/src/models/resource.dart';
import 'package:outerboxadmin/src/services/api_provider.dart';
import 'package:outerboxadmin/src/services/push_notif_manager.dart';
import 'package:outerboxadmin/src/utils/constants.dart';
import 'package:outerboxadmin/src/utils/save_image.dart';
import 'package:outerboxadmin/src/utils/user_sessions.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<String> logIn({
    @required String email,
    @required String password,
  }) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Token token = await LoginService.getToken(email: email, password: password);

      if(token != null){


        DatabaseReference usersReference = FirebaseDatabase.instance.reference().child("users");
        Resource resource = await LoginService.getResources(deviceId: androidInfo.androidId, token: token.accessToken);

        if(resource.staffDetails.role == "Cashier" || resource.staffDetails.role == "Kitchen"){
          return "Unauthorized";
        } else {
          if(resource.staffDetails != null){
            UserSessions.saveEmail(email);
            UserSessions.savePassword(password);
            UserSessions.saveAdminUID(resource.staffDetails.id);
            UserSessions.setMerchantId(resource.staffDetails.merchantId);
            UserSessions.saveCommissaryId(resource.staffDetails.commissaryId);
            UserSessions.saveClusterId(resource.staffDetails.clusterId);

            TransactionResult transactionResult = await usersReference.child(resource.staffDetails.id).runTransaction((MutableData mutableData) async {
              return mutableData;
            });


            if(transactionResult.dataSnapshot.value != null){
              FirebaseUser firebaseUser = new FirebaseUser();
              firebaseUser.uid = resource.staffDetails.id;
              firebaseUser.name = resource.staffDetails.fName + " " + resource.staffDetails.lName;
              firebaseUser.status = "Active";
              firebaseUser.email = email;
              firebaseUser.avatar = "";
              firebaseUser.pin = password;
              firebaseUser.loginName = resource.staffDetails.fName + " " + resource.staffDetails.lName;
              firebaseUser.lastActiveAt = DateTime.now().millisecondsSinceEpoch;
              firebaseUser.type = resource.staffDetails.role;
              usersReference.child(resource.staffDetails.id).update(firebaseUser.toJson());
              UserSessions.saveAdminRole(resource.staffDetails.role);
            } else {
              Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
              FirebaseUser firebaseUser = new FirebaseUser();
              firebaseUser.uid = resource.staffDetails.id;
              firebaseUser.name = resource.staffDetails.fName + " " + resource.staffDetails.lName;
              firebaseUser.status = "Active";
              firebaseUser.email = email;
              firebaseUser.avatar = "";
              firebaseUser.pin = password;
              firebaseUser.loginName = resource.staffDetails.fName + " " + resource.staffDetails.lName;
              firebaseUser.lastActiveAt = DateTime.now().millisecondsSinceEpoch;
              firebaseUser.type = resource.staffDetails.role;
              childUpdate.putIfAbsent(resource.staffDetails.id, () => firebaseUser.toJson());
              usersReference.update(childUpdate);
              UserSessions.saveAdminRole(resource.staffDetails.role);
            }
            UserSessions.saveAdminDetails(resource.staffDetails.fName + " " + resource.staffDetails.lName, resource.staffDetails.merchantId);

          }
          if(resource.headOfficeDetails != null){
            HeadOfficeDetails headOfficeDetails = resource.headOfficeDetails;
            headOfficeDetails.businessIconBlob = await SaveImage().urlToFile('https://pos.outerboxcloud.com/img/business/${resource.headOfficeDetails.businessIcon}');
            DatabaseHelper().insertHeadOffice(officeDetails: headOfficeDetails);
            UserSessions.saveHeadOfficeId(headOfficeDetails.userId);
          }
          if(resource.storeDetails != null){

            DatabaseHelper().insertStoreDetails(storeDetails: resource.storeDetails);

          }


          UserSessions.saveLastLogin(DateTime.now().toUtc().toString());
          UserSessions.setBearerToken(token.accessToken);
          UserSessions.savePinCode(password);
          UserSessions.setLoggedIn();
          PushNotificationsManager().init();
          return "Success";
        }

      } else {
        return "Invalid";
      }

    } on SocketException catch (_) {
      print("Socket Exception");
      //Session.setVerified(isVerified: false);
      //throw LoginFailure();
      return "Error";
    } on TimeoutException catch (_){
      print("Socket Timeout");
      return "Error";
    }
  }

  static Future<Token> getToken({@required String email, @required String password}) async {
    String url = "/oauth/token";
    try {
      Response response = await ApiProvider.login(url, email, password);
      if (response.statusCode == 200) {
        return Token.fromJson(jsonDecode(response.body));

      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return throw Exception("Invalid email/password");
      } else {
        return throw Exception(SOMETHING_WENT_WRONG);
      }
    } catch (error) {
      return throw Exception(error);
    }
  }


  static Future<Resource> getResources({@required String deviceId, @required String token}) async {
    String url = "pos.outerboxcloud.com";
    final resourcesRequest = Uri.https(url, '/api/resources');
    final resourceResponse = await http.get(resourcesRequest, headers: {
      HttpHeaders.authorizationHeader:'Bearer $token',
      'device': deviceId
    });
    if (resourceResponse.statusCode == 401) {
      throw Exception('Unauthorized');
    }
    if (resourceResponse.statusCode != 200) {
      throw Exception('Request failed');
    }
    return Resource.fromJson(jsonDecode(resourceResponse.body));
  }

}