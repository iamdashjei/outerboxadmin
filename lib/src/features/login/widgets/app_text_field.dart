import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outerboxadmin/src/features/login/login_bloc/login_bloc.dart';

class AppTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final TextFieldType type;

  const AppTextField({Key key, this.controller, this.hintText, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _userError;
    String _passwordError;

    return BlocBuilder<LoginBloc, LoginState>(
        bloc: BlocProvider.of<LoginBloc>(context),
        builder: (context, state) {
          if (state is LoginValidatorState) {
            _userError = state.userNameError != null
                ? state.userNameError
                : null;

            _passwordError = state.passwordError != null
                ? state.passwordError
                : null;
          }

          return Container(
            margin: EdgeInsets.all(20),
            child: TextField(
              controller: controller,
              keyboardType: this.type == TextFieldType.userName ? TextInputType.emailAddress : TextInputType.text,
              obscureText: this.type == TextFieldType.password ? true : false,
              decoration: InputDecoration(
                errorText: this.type == TextFieldType.userName
                    ? _userError
                    : _passwordError,
                hintText: this.hintText,
              ),
              onChanged: (text) {
                BlocProvider.of<LoginBloc>(context)
                    .add(FieldValidationEvent(type: this.type, text: text));
              },
            ),
          );
        });
  }
}

enum TextFieldType { userName, password }
