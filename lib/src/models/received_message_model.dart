import 'package:flutter/material.dart';

class ReceivedNotificationModel {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotificationModel({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  factory ReceivedNotificationModel.fromJson(Map<String, dynamic> json) {
    return ReceivedNotificationModel(
      id: json["notification"]["id"],
      payload: json["notification"]["payload"],
      title: json["notification"]["title"],
      body: json["notification"]["body"],
    );
  }
}
