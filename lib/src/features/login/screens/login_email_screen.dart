import 'package:flutter/material.dart';
import 'package:outerboxadmin/src/utils/hex_color.dart';
import 'package:outerboxadmin/src/utils/user_sessions.dart';

import 'login_redirect_pincode.dart';

class LoginEmailScreen extends StatefulWidget {

  @override
  _LoginEmailScreenState createState() => new _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  bool isFingerprint = false;
  TextEditingController _controller = new TextEditingController();

  bool isValidEmail = false;

  List<String> recentEmails = [];

  @override
  void initState() {

    fetchRecentEmailUser();

    super.initState();
  }

  void fetchRecentEmailUser() async{
    await UserSessions.getRecentUsers().then((value) {
      setState(() {
        recentEmails = value;
      });
    });
    // print(recentEmails);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                child:  Image.asset('assets/images/outerboxmain.png',
                  height: 200.0,
                  width: 200.0,),
              ),

              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("Enter new Email Address:", style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: MediaQuery.of(context)
                        .textScaleFactor *
                        16),),
              ),
              Container(
                height: 70,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(0),
                  color: HexColor("#E1E1E1"),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextField(
                    onChanged: (email) {
                      if(email.contains("@")){
                        setState(() {
                          isValidEmail = true;
                        });
                      } else {
                        setState(() {
                          isValidEmail = false;
                        });
                      }
                    },
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: MediaQuery.of(context)
                            .textScaleFactor *
                            30),
                    // textCapitalization: TextCapitalization.sentences,
                    controller: _controller,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: HexColor("#BFBFBF"), fontSize: 30),
                        border: InputBorder.none,
                        hintText: 'Type here...'
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: FlatButton(
                  padding: EdgeInsets.only(left: 80.0, right: 80.0, bottom: 15.0, top: 15.0),
                  color:  isValidEmail == true ? HexColor("#0B1043") : HexColor("#E1E1E1"),
                  textColor: isValidEmail == true ? Colors.white : Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: isValidEmail == true ? HexColor("#0B1043") : HexColor("#E1E1E1"))
                  ),
                  onPressed: () {
                    if(_controller.text == null || _controller.text == ""){
                      showAlertDialog(context);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            LoginRedirectPinCodeScreen(email: _controller.text),
                      ));
                    }
                  },
                  child: Text("NEXT", style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: isValidEmail == true ? Colors.white : Colors.grey,
                      fontSize: MediaQuery.of(context)
                          .textScaleFactor *
                          14),),
                ),
              ),
              SizedBox(height: 30),
              recentEmails.length > 0 ?  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("Or use Existing E-mail Address (Select One)", style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: MediaQuery.of(context)
                            .textScaleFactor *
                            17),),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: recentEmails.length,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                _controller.text = recentEmails[index];
                                isValidEmail = true;
                              });
                            },
                            child: Container(
                              //margin: EdgeInsets.only(top: 5.0),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    recentEmails[index],
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ) : Container(),

              // Container(
              //   height: 50,
              //   child: ListView.builder(
              //       itemCount: 5,
              //       itemBuilder: (context, index){
              //         return GestureDetector(
              //           behavior: HitTestBehavior.translucent,
              //           onTap: () {
              //
              //           },
              //           child: Container(
              //             //margin: EdgeInsets.only(top: 5.0),
              //             padding: EdgeInsets.all(10),
              //             child: Row(
              //               children: <Widget>[
              //                 Text(
              //                   'jhenanne2315@yahoo.com',
              //                   style:
              //                   TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       }),
              // ),
            ],
          ),
        ),
      ),
    );

  }

  showAlertDialog(BuildContext context){
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Try again"),
      content: Text("Please enter your email to login."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}