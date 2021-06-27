import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:outerboxadmin/src/api_connection/stream_api.dart';
import 'package:outerboxadmin/src/features/database/database_helper.dart';
import 'package:outerboxadmin/src/utils/hex_color.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'src/features/login/screens/app_authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper().initDatabase();
  await Firebase.initializeApp();
  await FlutterStatusbarcolor.setStatusBarColor(HexColor("#0B1043"));
  FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     statusBarColor: Colors.orange
  // ));
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themes = ThemeData(
      primarySwatch: Colors.blue,
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Outerbox Admin',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //     visualDensity: VisualDensity.adaptivePlatformDensity,
    //   ),
    //   home: AppAuthentication(),
    // );
    return  StreamChat(
      streamChatThemeData: StreamChatThemeData.fromTheme(themes).copyWith(
        ownMessageTheme: MessageTheme(
          messageBackgroundColor: Colors.blueAccent,
          messageText: TextStyle(
            color: Colors.white,
          ),
          // avatarTheme: null,
        ),
        otherMessageTheme: MessageTheme(
          messageBackgroundColor: Colors.grey,
          messageText: TextStyle(
            color: Colors.black,
          ),
          // avatarTheme: null,
        ),
      ),
      client: StreamApi.client,
      child: ChannelsBloc(
        child: OverlaySupport(
          child:MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Outerbox Admin',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: AppAuthentication(),
          ),
        ),
      ),
    );
  }
}