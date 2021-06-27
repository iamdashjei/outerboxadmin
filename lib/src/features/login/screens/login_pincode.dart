import 'dart:async';
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart' as ftdb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outerboxadmin/src/features/login/screens/dashboard/Dashboard.dart';
import 'package:outerboxadmin/src/utils/hex_color.dart';
import 'package:outerboxadmin/src/utils/user_sessions.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginPinCodeScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPinCodeScreen());
  }
  @override
  LoginPinCodeState createState() => LoginPinCodeState();
}

class LoginPinCodeState extends State<LoginPinCodeScreen>{
  bool isFirstPin = false, isSecondPin = false, isThirdPin = false, isFourthPin = false, isFifthPin = false, isSixthPin = false;
  String firstPin = "", secondPin = "", thirdPin = "", fourthPin = "", fifthPin = "", sixthPin = "";
  String allPinCombined = "";
  SharedPreferences pref;

  Map<String, String> emailAndPin = new HashMap<String, String>();
  String pinCode = "";

  @override
  void initState() {

    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadData() async {
    pinCode = await UserSessions.getPinCode();

    pref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Image.asset(
                    'assets/images/outerboxmain.png',
                    height: 200.0,
                    width: 200.0,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 5.0,
                ),
                Center(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text('Enter your 6 digit PIN', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0B1043))),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Container(
                      height: height * 0.06,
                      width: width * 0.06,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: isFirstPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    Container(
                      height: height * 0.06,
                      width: width * 0.06,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: isSecondPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    Container(
                      height: height * 0.06,
                      width: width * 0.06,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: isThirdPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    Container(
                      height: height * 0.06,
                      width: width * 0.06,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color:  isFourthPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    Container(
                      height: height * 0.06,
                      width: width * 0.06,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color:  isFifthPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    Container(
                      height: height * 0.06,
                      width: width * 0.06,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color:  isSixthPin == true ? HexColor("#0B1043") : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF0B1043)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfff2f2f2),
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("1", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('1', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("2", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('2', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("3", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('3', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("4", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('4', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("5", context);
                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('5', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;

                        verifyPin("6", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('6', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("7", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('7', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("8", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('8', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("9", context);

                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('9', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: height * 0.10,
                      width: width * 0.18,
                      child: Center(child: Text('_', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 1.0, // soften the shadow
                              spreadRadius: 0.25, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ]
                      ),
                    ),
                    SizedBox(width: 32.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("0", context);
                      },
                      child: Container(
                        height: height * 0.10,
                        width: width * 0.18,
                        child: Center(child: Text('0', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40), )),
                        decoration: BoxDecoration(
                            color: Color(0xFF0B1043),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF0B1043)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xfff2f2f2),
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 0.25, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(!mounted) return;
                        verifyPin("del", context);

                      },
                      child: Container(
                        height: 55,
                        width: 75,
                        padding: EdgeInsets.only(left:15),
                        child: Center(child: Icon(Icons.close, color: HexColor("#0B1043"), size: 40,) ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/boxgray.png'),
                            fit: BoxFit.fill,
                          ),
                          //shape: BoxShape.circle,
                        ),
                        // decoration: BoxDecoration(
                        //     color: Color(0xFF0B1043),
                        //     shape: BoxShape.circle,
                        //     border: Border.all(color: Color(0xFF0B1043)),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Color(0xfff2f2f2),
                        //         blurRadius: 1.0, // soften the shadow
                        //         spreadRadius: 0.25, //extend the shadow
                        //         offset: Offset(
                        //           0.0, // Move to right 10  horizontally
                        //           3.0, // Move to bottom 10 Vertically
                        //         ),
                        //       )
                        //     ]
                        // ),
                      ),
                    ),
                    SizedBox(width: 20.0,),
                  ],
                ),

                SizedBox(height: 20.0),
                // Center(
                //     child: ConstrainedBox(
                //       constraints: BoxConstraints.tightFor(width: 150, height: 40),
                //       child: ElevatedButton(onPressed: (){},
                //         child: Text('Forgot Password?',  style: TextStyle(fontSize: 12, color: Colors.black),),
                //         style: ButtonStyle(
                //           backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFAA00)),
                //           padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                //         ),
                //       ),
                //     )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyPin(String input, BuildContext context){
    print("Verifying " + allPinCombined);
    setState(() {
      if(input == "del"){
        if(isFirstPin == true && isSecondPin == false && isThirdPin == false && isFourthPin == false && isFifthPin == false && isSixthPin == false){
          isFirstPin = false;
          firstPin = "";
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == false && isFourthPin == false && isFifthPin == false && isSixthPin == false){
          isSecondPin = false;
          secondPin = "";
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == false && isFifthPin == false && isSixthPin == false){
          isThirdPin = false;
          thirdPin = "";
          // 123 -> 12
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == false && isSixthPin == false){
          isFourthPin = false;
          fourthPin = "";
          // 1234 -> 123
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == true && isSixthPin == false){
          isFifthPin = false;
          fifthPin = "";
          // 123 -> 1234
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == true && isSixthPin == true){
          isFourthPin = false;
          sixthPin = "";
          // 12345 -> 1234
        }
      } else {
        if(isFirstPin == false){
          isFirstPin = true;
          firstPin = input;
        } else if(isFirstPin == true && isSecondPin == false){
          isSecondPin = true;
          secondPin = input;
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == false){
          isThirdPin = true;
          thirdPin = input;
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == false){
          isFourthPin = true;
          fourthPin = input;
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == false){
          isFifthPin = true;
          fifthPin = input;
        } else if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == true && isSixthPin == false){
          isSixthPin = true;
          sixthPin = input;
        }
        allPinCombined = firstPin + secondPin + thirdPin + fourthPin + fifthPin + sixthPin;
      }


    });

    //print(emailAndPin.values.toString());
    if(allPinCombined == pinCode){
      print("Enter now");

      Navigator.of(context).pushAndRemoveUntil<void>(
        DashboardPage.route(),
            (route) => false,
        // LoginPinCodeScreen.route(), (route) => false,
      );
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) =>
      //      // MainDashboardPage(),
      // ));
    } else {
      if(isFirstPin == true && isSecondPin == true && isThirdPin == true && isFourthPin == true && isFifthPin == true && isSixthPin == true){
        showAlertDialog(context);
      }

    }


  }

  showAlertDialog(BuildContext context){
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        setState(() {
          isFirstPin = false;
          isSecondPin = false;
          isThirdPin = false;
          isFourthPin = false;
          isFifthPin = false;
          isSixthPin = false;

          firstPin = "";
          secondPin = "";
          thirdPin = "";
          fourthPin = "";
          fifthPin = "";
          sixthPin = "";


        });
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Try again"),
      content: Text("Sorry you have entered wrong pin."),
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
