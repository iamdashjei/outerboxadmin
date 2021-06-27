import 'dart:collection';

import 'package:flutter/material.dart';

class CommentModel {
  String user;
  String comment;
  String time;
  String status;
  String userId;
  String userAvatar;
  String imgUrl;
  String videoUrl;
  int timestamp;
  Map<dynamic, dynamic> comments = new HashMap<dynamic, dynamic>();
  Map<dynamic, dynamic> like = new HashMap<dynamic, dynamic>();

  CommentModel({
    @required this.user,
    @required this.comment,
    @required this.time,
    @required this.status,
    @required this.userId,
    @required this.userAvatar,
    @required this.timestamp,
    @required this.imgUrl,
    @required this.videoUrl,
    @required this.comments,
    @required this.like,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['comment'] = this.comment;
    data['time'] = this.time;
    data['status'] = this.status;
    data['userId'] = this.userId;
    data['userAvatar'] = this.userAvatar;
    data['timestamp'] = this.timestamp;
    data['imgUrl'] = this.imgUrl;
    data['videoUrl'] = this.videoUrl;
    data['comments'] = this.comments;
    data['like'] = this.like;
    return data;
  }
}
