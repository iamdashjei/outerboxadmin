import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outerboxadmin/src/features/login/login_bloc/login_bloc.dart';
import 'package:outerboxadmin/src/features/login/widgets/app_text_field.dart';
import 'package:outerboxadmin/src/features/login/widgets/login_button.dart';

import 'login_pincode.dart';

class LoginBuilder extends StatefulWidget {
  const LoginBuilder({Key key}) : super(key: key);

  @override
  _LoginBuilderState createState() => _LoginBuilderState();
}

class _LoginBuilderState extends State<LoginBuilder> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    this._userNameController.dispose();
    this._passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        if (state is LoginFinishedState) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPinCodeScreen()), (Route<dynamic> route) => false);
        }
        if (state is ErrorLoginState) {
          Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text(state.errorMessage)));
        }
      },
      bloc: BlocProvider.of<LoginBloc>(context),
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 Container(
                   child: Image.asset(
                     "assets/images/kumpares.png",
                     fit: BoxFit.cover,
                   ),
                   height: 440,
                   margin: EdgeInsets.only(bottom: 20, top: 30),
                 ),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.05),
                                  offset: Offset(0, 3),
                                  blurRadius: 7,
                                  spreadRadius: 3)
                            ]),
                        margin: EdgeInsets.all(15),
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AppTextField(
                              type: TextFieldType.userName,
                              hintText: "Email",
                              controller: this._userNameController,
                            ),
                            AppTextField(
                              type: TextFieldType.password,
                              hintText: "Password",
                              controller: this._passwordController,
                            ),
                            LoginButton(
                              userName: this._userNameController.text,
                              password: this._passwordController.text,
                            )
                          ],
                        ),
                      );
                    },
                    bloc: BlocProvider.of<LoginBloc>(context),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
