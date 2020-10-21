import 'package:aiprof/actions/logged_action.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:aiprof/uis/login/login_page_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends BaseModel<AppState> {
  Function(String) onResetEmail;
  Function(String, String) onLoginEmailPassword;
  AuthenticationStatusLogged authenticationStatusLogged;

  ViewModel();

  ViewModel.build({
    @required this.onLoginEmailPassword,
    @required this.authenticationStatusLogged,
    @required this.onResetEmail,
  }) : super(equals: [authenticationStatusLogged]);
  @override
  ViewModel fromStore() => ViewModel.build(
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
      model: ViewModel(),
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
