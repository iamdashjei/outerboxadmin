part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  Stream<LoginState> applyAsync({LoginState currentState, LoginBloc bloc});
}

class AuthenticationEvent extends LoginEvent {
  final String userName;
  final String password;
  //final LocalDatabase appDatabase;

  //AuthenticationEvent({this.appDatabase, this.userName, this.password});
  AuthenticationEvent({this.userName, this.password});
  @override
  Stream<LoginState> applyAsync(
      {LoginState currentState, LoginBloc bloc}) async* {
    try {
      //int lastLogoutTime = await UserSessions.getLastLogoutTime();
      yield LoginStartingState();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Token login = await LoginService.getToken(password: password, email: userName);
      Resource resource = await LoginService.getResources(deviceId: androidInfo.androidId, token: login.accessToken);
      UserSessions.setBearerToken(login.accessToken);

      print("My device id => " + androidInfo.androidId);

      if(login != null){
        UserSessions.savePinCode(password);
      }

      if(resource.staffDetails != null){
        UserSessions.setMerchantId(resource.staffDetails.merchantId);
      }

      // if (login.user.merchantId != null) {
        UserSessions.setLoggedIn();



        yield LoginFinishedState();
      // } else {
      //   yield ErrorLoginState("invalid Credential");
      // }
    } on Exception catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState(_?.toString());
    }
  }
}

class FieldValidationEvent extends LoginEvent {
  final String text;
  final TextFieldType type;
  FieldValidationEvent({
    this.text,
    this.type,
  });

  @override
  Stream<LoginState> applyAsync(
      {LoginState currentState, LoginBloc bloc}) async* {
    try {
      if (currentState is LoginDefaultState ||
          currentState is ErrorLoginState) {
        if (type == TextFieldType.userName) {
          yield LoginValidatorState(
              userNameError: _userError(), type: this.type);
        } else {
          yield LoginValidatorState(
              passwordError: _passwordError(), type: this.type);
        }
        return;
      }
      if (currentState is LoginValidatorState) {
        if (type == TextFieldType.userName) {
          yield LoginValidatorState(
              userNameError: _userError(),
              passwordError: currentState.passwordError,
              text: text);
        } else {
          yield LoginValidatorState(
              passwordError: _passwordError(),
              userNameError: currentState.userNameError,
              text: text);
        }
      }
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState(_?.toString());
    }
  }

  _userError() => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text) ? null : "Invalid email";
  _passwordError() => text.length >= 3 && text.length <= 10 ? null : "Invalid password";
}
