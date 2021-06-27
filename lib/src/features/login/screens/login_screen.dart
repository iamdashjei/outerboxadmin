import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outerboxadmin/src/features/login/login_bloc/login_bloc.dart';

import 'login_builder.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: LoginBuilder(),
      create: (BuildContext context) => LoginBloc(),
    );
  }
}
