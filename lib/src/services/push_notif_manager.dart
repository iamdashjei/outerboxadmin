import 'dart:convert';
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:outerboxadmin/src/models/received_message_model.dart';


class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // Replace with server token from firebase console settings.
  final String serverToken = 'AAAAsQO7ZiU:APA91bGkxkrVXkzQeVRGgJGetPkcaJpnHEO2NkdgbxuvSgtNBX9h07Eyk9tc-9IcmlkDGMf7dQk7i_xIdLHNOV6IdZUSOJxZ5YYW05L8GOkwcGo4vr0Hs6X-q0lgOnWMlW3m7psNq95C';

  bool _initialized = false;

  SharedPreferences sharedPreferences;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions(
      );
      _firebaseMessaging.configure(
        onMessage: (message) async {
          print('onMessage received: $message');
          // Parse the message received
          ReceivedNotificationModel notification = ReceivedNotificationModel.fromJson(message);

          showSimpleNotification(
            Text(notification.title),
            leading: SvgPicture.asset('assets/image/profiles.svg', width: 25, height: 25,),
            subtitle: Text(notification.body),
            background: Colors.cyan[700],
            duration: Duration(seconds: 2),
          );
        },
        // onBackgroundMessage: (message) async {
        //   print('onLaunchMessage received: $message');
        // },
        onLaunch: (message) async {
          print('onLaunchMessage received: $message');
          // Parse the message received
          ReceivedNotificationModel notification = ReceivedNotificationModel.fromJson(message);

          showSimpleNotification(
            Text(notification.title),
            leading: SvgPicture.asset('assets/image/profiles.svg', width: 25, height: 25,),
            subtitle: Text(notification.body),
            background: Colors.cyan[700],
            duration: Duration(seconds: 2),
          );
        },
        onResume: (message) async {
          print('onResumeMessage received: $message');
          // Parse the message received
          ReceivedNotificationModel notification = ReceivedNotificationModel.fromJson(message);

          showSimpleNotification(
            Text(notification.title),
            leading: SvgPicture.asset('assets/image/profiles.svg', width: 25, height: 25,),
            subtitle: Text(notification.body),
            background: Colors.cyan[700],
            duration: Duration(seconds: 2),
          );
        },
      );
      String device = sharedPreferences.getString('deviceToken') ?? null;
      //For testing purposes print the Firebase Messaging token
      if(device == null){
        String token = await _firebaseMessaging.getToken();
        print("FirebaseMessaging token: $token");
        sharedPreferences.setString("deviceToken", token);
      }

      // String token = await _firebaseMessaging.getToken();
      // print("FirebaseMessaging token: $token");
      // sharedPreferences.setString("deviceToken", token);

      _initialized = true;
    }
  }


  Future<Map<String, dynamic>> sendAndRetrieveMessage(String deviceToken, String id, String message, String title) async {
    //sharedPreferences = await SharedPreferences.getInstance();
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
    //String token = sharedPreferences.getString("deviceToken");

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': message,
            'title': title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': id,
            'status': 'done'
          },
          'to': deviceToken,
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
}
