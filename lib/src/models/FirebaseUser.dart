import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

class FirebaseUser {
  String key;
  String uid;
  int dbUserId;
  String loginName;
  String name;
  String avatar;
  int lastActiveAt;
  String status;
  String type;
  String pin;
  String email;
  Map<dynamic, dynamic> assignedTeam = new HashMap<dynamic, dynamic>();
  Map<dynamic, dynamic> extraData = new HashMap<dynamic, dynamic>();

  FirebaseUser({
    this.uid,
    this.dbUserId,
    this.loginName,
    this.name,
    this.avatar,
    this.lastActiveAt,
    this.status,
    this.type,
    this.pin,
    this.extraData,
    this.assignedTeam,
    this.email
  });

  FirebaseUser.fromSnapshot(DataSnapshot dataSnapshot)
      : uid = dataSnapshot.value["uid"],
        dbUserId = dataSnapshot.value["dbUserId"],
        loginName = dataSnapshot.value["loginName"],
        name = dataSnapshot.value["name"],
        avatar = dataSnapshot.value["avatar"],
        lastActiveAt = dataSnapshot.value["lastActiveAt"],
        extraData = dataSnapshot.value["extraData"],
        assignedTeam = dataSnapshot.value["assignedTeam"],
        status = dataSnapshot.value["status"],
        pin = dataSnapshot.value["pin"],
        email = dataSnapshot.value["email"],
        type = dataSnapshot.value["type"];



  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "dbUserId": dbUserId,
      "loginName": loginName,
      "name": name,
      "avatar": avatar,
      "lastActiveAt": lastActiveAt,
      "extraData": extraData,
      "status": status,
      "type": type,
      "pin": pin,
      "email": email,
      "assignedTeam": assignedTeam,
    };
  }

  @override
  int get hashCode =>
      uid.hashCode ^
      dbUserId.hashCode ^
      loginName.hashCode ^
      name.hashCode ^
      avatar.hashCode ^
      lastActiveAt.hashCode ^
      pin.hashCode ^
      extraData.hashCode ^
      status.hashCode ^
      type.hashCode ^
      email.hashCode ^
      assignedTeam.hashCode;



}