import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

class PostModel {
  String key;
  int id;
  String userId;
  String postDescription;
  String username;
  String status;
  String imgUrl;
  int timestamp;
  Map<dynamic, dynamic> multipleImgUrl = new HashMap<dynamic, dynamic>();
  Map<dynamic, dynamic> videoUrl = new HashMap<dynamic, dynamic>();
  Map<dynamic, dynamic> like = new HashMap<dynamic, dynamic>();
  Map<dynamic, dynamic> comments = new HashMap<dynamic, dynamic>();
  dynamic postTime;

  PostModel({this.id, this.userId,
    this.postDescription,
    this.postTime,
    this.like,
    this.comments,
    this.status,
    this.timestamp,
    this.imgUrl,
    this.multipleImgUrl,
    this.videoUrl
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    like = json['like'];
    userId = json['userId'];
    username = json['username'];
    postDescription = json['postDescription'];
    postTime = json['postTime'];
    comments = json['comments'];
    status = json['status'];
    timestamp = json['timestamp'];
    imgUrl = json['imgUrl'];
    multipleImgUrl = json['multipleImgUrl'];
    videoUrl = json['videoUrl'];
  }

  PostModel.fromJsonSF(DataSnapshot snapshot) :
        key = snapshot.key,
        id = snapshot.value['id'],
        userId = snapshot.value['userId'],
        like = snapshot.value['like'],
        username = snapshot.value['username'],
        postDescription = snapshot.value['postDescription'],
        postTime = snapshot.value['postTime'],
        comments = snapshot.value['comments'],
        status = snapshot.value['status'],
        timestamp = snapshot.value['timestamp'],
        imgUrl = snapshot.value['imgUrl'],
        multipleImgUrl = snapshot.value['multipleImgUrl'],
        videoUrl = snapshot.value['videoUrl'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['like'] = this.like;
    data['username'] = this.username;
    data['postDescription'] = this.postDescription;
    data['postTime'] = this.postTime;
    data['comments'] = this.comments;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['imgUrl'] = this.imgUrl;
    data['multipleImgUrl'] = this.multipleImgUrl;
    data['videoUrl'] = this.videoUrl;
    return data;
  }
}

class LikeUsers {
  String userId;

  LikeUsers({this.userId});

  LikeUsers.fromJsonSF(DataSnapshot snapshot) :
        userId = snapshot.value['userId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    return data;
  }
}
