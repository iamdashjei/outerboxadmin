import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:outerboxadmin/src/api_connection/stream_channel_api.dart';
import 'package:outerboxadmin/src/api_connection/stream_user_api.dart';
import 'package:outerboxadmin/src/features/pages/bulletin/news_feed.dart';
import 'package:outerboxadmin/src/features/pages/chatroom/chat.dart';
import 'package:outerboxadmin/src/models/FirebaseUser.dart';
import 'package:outerboxadmin/src/models/business_info.dart';
import 'package:outerboxadmin/src/models/received_message_model.dart';
import 'package:outerboxadmin/src/utils/hex_color.dart';
import 'package:outerboxadmin/src/utils/user_sessions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as streamUser ;

import 'WebView.dart';

class DashboardPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => DashboardPage());
  }
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with WidgetsBindingObserver{

  final databaseReference = FirebaseDatabase.instance.reference();
  DatabaseReference postReference, usersReference, profileReference;

  // ignore: close_sinks
  final BehaviorSubject<ReceivedNotificationModel> didReceiveLocalNotificationSubject =
  BehaviorSubject<ReceivedNotificationModel>();

  // ignore: close_sinks
  final BehaviorSubject<String> selectNotificationSubject =
  BehaviorSubject<String>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  NotificationAppLaunchDetails notificationAppLaunchDetails;

  String currentTab = '', nameTab = '', uid = '';
  int _selectedIndex = 0;
  BusinessInfo info;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,

      appBar: currentTab != "dashboard" ? AppBar(
        centerTitle: true,
        backgroundColor: HexColor("#0B1043"),
        title: Text(nameTab),
      ) : null,
      body: bodyView(currentTab),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: HexColor("#FFAA00"),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0 ? Image.asset('assets/images/home_yellow.png', width: 25, height: 25) : Image.asset('assets/images/home_icon.png', width: 25, height: 25),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1 ? Image.asset('assets/images/bulletinyellow_icon.png', width: 25, height: 25) : Image.asset('assets/images/bulletin_icon.png', width: 25, height: 25),
            title: Text('Bulletin'),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2 ? Image.asset('assets/images/chatroom_yellow.png', width: 25, height: 25) : Image.asset('assets/images/chat_room.png', width: 25, height: 25),
            title: Text('Chatroom'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currentTab = "dashboard";
    nameTab = "Dashboard";
    WidgetsBinding.instance.addObserver(this);
    initDashboard();
    initPlatformSpecifics();
  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _updateStateUser("Active");
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        _updateStateUser("Idle");
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        _updateStateUser("Idle");
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        _updateStateUser("Inactive");
        print("app in detached");
        break;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex == 0){
        currentTab = "dashboard";
        nameTab = "Dashboard";
      } else if (_selectedIndex == 1){
        currentTab = "bulletin";
        nameTab = "Bulletin";
      } else if (_selectedIndex == 2){
        currentTab = "chatroom";
        nameTab = "Chatroom";
      }
    });

  }

  Widget bodyView(String selectTab) {
    if (selectTab == "dashboard") {
      return WebViewPage();
    }
    else if (selectTab == "bulletin") {
      setState(() {
        _selectedIndex = 1;
      });
      return NewsFeed(uid: uid, type: "admin", displayName: info.cashierName);
      return Container();
    }
    else if (selectTab == "chatroom") {
      setState(() {
        _selectedIndex = 2;
      });
      return Chat();
    } else {
      return Container();
    }

  }

  _updateStateUser(String status) async{
    DatabaseReference usersReference = databaseReference.child("users");
    TransactionResult transactionResultForUser = await profileReference.runTransaction((MutableData mutableData) async {
      return mutableData;
    });

    FirebaseUser firebaseUser = FirebaseUser.fromSnapshot(transactionResultForUser.dataSnapshot);
    firebaseUser.status = status;
    usersReference.child(uid).update(firebaseUser.toJson());


    if(uid != ""){
      print("Updating my status => " + uid);
      await StreamUserApi.queryUsers(uid, status);
    }


  }

  initDashboard() async{
     await UserSessions.getAdminDetails().then((value) async {
       setState(() {
         info = value;
       });
       await StreamUserApi.login(idUser: info.uid,
           fullName: info.cashierName,
           avatar: "",
           merchantId: info.merchantId,
           headOfficeId: info.headOfficeId,
           commissaryId: info.commissaryId,
           clusterId: info.clusterId,
           type: info.accountType,
           uid: info.uid);
       profileReference = FirebaseDatabase.instance.reference().child("users").child(info.uid);
      //createChannelWithUsers(info.uid, info.accountType, info.commissaryId, info.clusterId, info.headOfficeId, info.cashierName);
     });
    uid = await UserSessions.getAdminUID();
    await FlutterStatusbarcolor.setStatusBarColor(HexColor("#0B1043"));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  }

  void initPlatformSpecifics() async{
    notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    await initNotifications(flutterLocalNotificationsPlugin);

  }

  Future<void> initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = AndroidInitializationSettings('outerboxmain');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotificationModel(
              id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            debugPrint('notification payload: ' + payload);
          }
          selectNotificationSubject.add(payload);
        });
  }

  createChannelWithUsers(String myUserId, String type, String commissaryId,String clusterId, String headOfficeId, String myName) async {
    List<streamUser.User> allUsers = await StreamUserApi.getAllStreamUsers();
    String urlImage = "https://raw.githubusercontent.com/socialityio/laravel-default-profile-image/master/docs/images/profile.png";
    List<String> idUsers = new List();
    for(streamUser.User userItem in allUsers){
      if(type.toLowerCase() == "merchant") {
        if (userItem.id != myUserId) {
          if(userItem.extraData["type"].toString().toLowerCase() == "merchant"){
            if(userItem.extraData["clusterId"].toString() == clusterId){
              await StreamChannelApi.createChannel(
                context,
                name: userItem.extraData["fullName"],
                toName: userItem.extraData["fullName"],
                fromName: myName,
                urlImage: urlImage,
                idMembers: [userItem.id],
              );
            }
          } else if(userItem.extraData["type"].toString().toLowerCase() == "commissary"){
            if(commissaryId == userItem.id){
              await StreamChannelApi.createChannel(
                context,
                name: userItem.extraData["fullName"],
                toName: userItem.extraData["fullName"],
                fromName: myName,
                urlImage: urlImage,
                idMembers: [userItem.id],
              );
            }
          }



          //   if(userItem.extraData["type"].toString().toLowerCase() == "md"){
          //     print("MD User => " + userItem.name);
          //     //idUsers.add(userItem.id);
          //     await StreamChannelApi.createChannel(
          //       context,
          //       name: userItem.name,
          //       urlImage: urlImage,
          //       idMembers: [userItem.id],
          //     );
          //   } else if(userItem.extraData["type"].toString().toLowerCase() == "sd"){
          //     print("SD User => " + userItem.name);
          //     //idUsers.add(userItem.id);
          //     await StreamChannelApi.createChannel(
          //       context,
          //       name: userItem.name,
          //       urlImage: urlImage,
          //       idMembers: [userItem.id],
          //     );
          //   } else if(userItem.extraData["type"].toString().toLowerCase() == "retailer"){
          //     print("Retailer User => " + userItem.name);
          //     //idUsers.add(userItem.id);
          //     await StreamChannelApi.createChannel(
          //       context,
          //       name: userItem.name,
          //       urlImage: urlImage,
          //       idMembers: [userItem.id],
          //     );
          //   }
          // }
        }
      } else if (type.toLowerCase() == "commissary") {
        if (userItem.id != myUserId) {
            if(userItem.extraData["type"].toString().toLowerCase() == "head office"){
              if(userItem.id == headOfficeId){
                await StreamChannelApi.createChannel(
                  context,
                  name: userItem.extraData["fullName"],
                  toName: userItem.extraData["fullName"],
                  fromName: myName,
                  urlImage: urlImage,
                  idMembers: [userItem.id],
                );
              }

            }
        }
        // if(userItem.id != myUserId){
        //   if(userItem.extraData["type"] == "md"){
        //     print("MD User => " + userItem.name);
        //     //idUsers.add(userItem.id);
        //     await StreamChannelApi.createChannel(
        //       context,
        //       name: userItem.name,
        //       urlImage: urlImage,
        //       idMembers: [userItem.id],
        //     );
        //   }
        // }
      } else if (type.toLowerCase() == "head office") {
        if (userItem.id != myUserId) {

        }
      } else if (type.toLowerCase() == "cluster") {
        if (userItem.id != myUserId) {

        }
      }
    }

  }
}