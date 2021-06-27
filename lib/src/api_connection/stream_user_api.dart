import 'package:flutter/foundation.dart';
import 'package:outerboxadmin/src/api_connection/stream_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:outerboxadmin/src/api_connection/stream_api.dart';
import 'package:outerboxadmin/src/models/stream_user_custom.dart' as model;

class StreamUserApi {
  static Future createUser({
    @required String idUser,
    @required String username,
    @required String urlImage,
  }) async {
    final token = StreamApi.client.devToken(idUser);

    final user = User(
      id: idUser,
      extraData: {
        'name': username,
        'image': urlImage,
      },
    );
    await StreamApi.client.setUser(user, token);
  }

  static Future login({@required String idUser, @required String fullName,
    @required String avatar, @required String merchantId, @required String headOfficeId,
    @required String commissaryId, @required String clusterId,
    @required String type, @required String uid}) async {
    final token = StreamApi.client.devToken(idUser);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final user = User(id: idUser);

    //print(StreamApi.client.wsConnectionStatus.value.index);
    // if(StreamApi.client.wsConnectionStatus.value.index == 2){
    //   //await StreamApi.client.updateUser(user);
    //
    // }

    await StreamApi.client.setUser(user, token);
    await StreamApi.client.queryUsers(
        filter: {
          "id": {
            "\$in": [idUser]
          }
        }
    ).then((value) async {
      User newUser = value.users[0];
      newUser.extraData["deviceToken"] = sharedPreferences.get("deviceToken");
      if(type.toLowerCase() == "head office"){
        newUser.extraData["fullName"] = "Head Office: "+fullName;
      } else {
        newUser.extraData["fullName"] = type + ": "+ fullName;
      }

      newUser.extraData["image"] = avatar;
      newUser.extraData["merchantId"] = merchantId;
      newUser.extraData["headOfficeId"] = headOfficeId;
      newUser.extraData["commissaryId"] = commissaryId;
      newUser.extraData["clusterId"] = clusterId;
      newUser.extraData["type"] = type;
      newUser.extraData["status"] = "Active";
      newUser.extraData["user_api_id"] = uid;
      print(newUser.toJson());
      await StreamApi.client.updateUser(newUser);
    });

    //String deviceToken = sharedPreferences.getString("deviceToken") ?? null;

    // if(deviceToken == null){
    //   final _result = await StreamApi.client.queryUsers(
    //       filter: {
    //         "id": {
    //           "\$in": [idUser]
    //         }
    //       }
    //   ).then((value) async {
    //     User newUser = value.users[0];
    //     newUser.extraData["deviceToken"] = sharedPreferences.get("deviceToken");
    //     print(newUser.toJson());
    //     await StreamApi.client.updateUser(newUser);
    //   });
    // }


    // final channel = StreamApi.client.channel('messaging', id: '2fa32251-e6ce-4398-8479-c4c1dba198c1');
    // channel.watch();
  }

  static Future queryUsers(String idUser, String status) async{

    await StreamApi.client.queryUsers(
        filter: {
          "id": {
            "\$in": [idUser]
          }
        }
    ).then((value) async {
      User newUser = value.users[0];
      newUser.extraData["status"] = status;
      print(newUser.toJson());
      await StreamApi.client.updateUser(newUser);
    });
  }

  static Future updateUserImage(String idUser, String urlImage) async{
    await StreamApi.client.queryUsers(
        filter: {
          "id": {
            "\$in": [idUser]
          }
        }
    ).then((value) async {
      User newUser = value.users[0];
      newUser.extraData["image"] = urlImage;
      print("Updated version" + newUser.toJson().toString());
      await StreamApi.client.updateUser(newUser);
    });
  }

  static Future<List<model.User>> getAllUsers({bool includeMe = false}) async {
    final sort = SortOption('last_message_at');
    final response = await StreamApi.client.queryUsers(sort: [sort]);

    final defaultImage =
        'https://raw.githubusercontent.com/socialityio/laravel-default-profile-image/master/docs/images/profile.png';

    final allUsers = response.users
        .map((user) => model.User(
      idUser: user.id,
      name: user.name,
      imageUrl: user.extraData['image'] ?? defaultImage,
      isOnline: user.online,
    ))
        .toList();

    return allUsers;
  }

  static Future<List<User>> getAllStreamUsers({bool includeMe = false}) async {
    final sort = SortOption('last_message_at');
    final response = await StreamApi.client.queryUsers(sort: [sort]);

    final defaultImage =
        'https://raw.githubusercontent.com/socialityio/laravel-default-profile-image/master/docs/images/profile.png';

    final allUsers = response.users;

    return allUsers;
  }

}