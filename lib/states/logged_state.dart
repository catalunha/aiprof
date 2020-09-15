import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
class LoggedState {
  final FirebaseUser firebaseUserLogged;
  final AuthenticationStatusLogged authenticationStatusLogged;
  final UserModel userModelLogged;
  LoggedState({
    this.authenticationStatusLogged,
    this.firebaseUserLogged,
    this.userModelLogged,
  });
  factory LoggedState.initialState() {
    return LoggedState(
      authenticationStatusLogged: AuthenticationStatusLogged.unInitialized,
      firebaseUserLogged: null,
      userModelLogged: null,
    );
  }
  LoggedState copyWith({
    AuthenticationStatusLogged authenticationStatusLogged,
    FirebaseUser firebaseUserLogged,
    UserModel userModelLogged,
  }) {
    return LoggedState(
      authenticationStatusLogged:
          authenticationStatusLogged ?? this.authenticationStatusLogged,
      firebaseUserLogged: firebaseUserLogged ?? this.firebaseUserLogged,
      userModelLogged: userModelLogged ?? this.userModelLogged,
    );
  }

  @override
  int get hashCode =>
      firebaseUserLogged.hashCode ^
      userModelLogged.hashCode ^
      authenticationStatusLogged.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoggedState &&
          runtimeType == other.runtimeType &&
          firebaseUserLogged == other.firebaseUserLogged &&
          userModelLogged == other.userModelLogged &&
          authenticationStatusLogged == other.authenticationStatusLogged;

  @override
  String toString() {
    return 'UserState{firebaseUser:$firebaseUserLogged,authenticationStatus:$authenticationStatusLogged,userModel:$userModelLogged}';
  }
}
