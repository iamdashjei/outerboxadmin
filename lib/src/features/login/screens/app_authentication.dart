import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outerboxadmin/src/features/login/screens/dashboard/Dashboard.dart';
import 'package:outerboxadmin/src/features/login/screens/login_pincode.dart';
import 'package:outerboxadmin/src/features/login/screens/login_screen.dart';
import 'package:outerboxadmin/src/models/current_user.dart';
import 'package:outerboxadmin/src/utils/constants.dart';
import 'package:outerboxadmin/src/utils/user_sessions.dart';

import 'login_email_screen.dart';

class AppAuthentication extends StatefulWidget {
  const AppAuthentication({Key key}) : super(key: key);

  @override
  _AppAuthenticationState createState() => _AppAuthenticationState();
}

class _AppAuthenticationState extends State<AppAuthentication> {
  Future _session;

  @override
  void initState() {
    _session = UserSessions.getBearerToken();
    //initPusher();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

          if (snapshot.hasData && snapshot.data != null) {
            //print("Snapshot data => " + snapshot.data);
            //CurrentUser currentUser = snapshot.data;
            return DashboardPage();
          } else if (snapshot.hasError && snapshot.error != null) {
            return Center(
              child: Text(snapshot.error),
            );
          } else {
            return LoginEmailScreen();
          }
        },
        future: _session,
      ),
    );
  }
}
