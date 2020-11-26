import 'package:aiprof/app_state.dart';
import 'package:aiprof/login/logged_action.dart';
import 'package:aiprof/login/login_enum.dart';
import 'package:aiprof/login/login_page_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends Vm {
  final AuthenticationStatusLogged authenticationStatusLogged;
  final Function(String) onResetEmail;
  final Function(String, String) onLoginEmailPassword;

  ViewModel({
    @required this.onLoginEmailPassword,
    @required this.authenticationStatusLogged,
    @required this.onResetEmail,
  }) : super(equals: [authenticationStatusLogged]);
}

class Factory extends VmFactory<AppState, LoginPage> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        onLoginEmailPassword: (String email, String password) {
          dispatch(LoginEmailPasswordAsyncLoggedAction(
              email: email, password: password));
        },
        authenticationStatusLogged:
            state.loggedState.authenticationStatusLogged,
        onResetEmail: (String email) {
          dispatch(ResetPasswordAsyncLoggedAction(email: email));
        },
      );
}

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (BuildContext context, ViewModel viewModel) {
        return LoginPageDS(
          loginEmailPassword: viewModel.onLoginEmailPassword,
          authenticationStatusLogged: viewModel.authenticationStatusLogged,
          sendPasswordResetEmail: viewModel.onResetEmail,
        );
      },
    );
  }
}
