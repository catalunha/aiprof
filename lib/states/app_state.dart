import 'package:aiprof/states/logged_state.dart';
import 'package:aiprof/states/user_state.dart';
import 'package:async_redux/async_redux.dart';

class AppState {
  final Wait wait;
  final LoggedState loggedState;
  final UserState userState;

  AppState({
    this.wait,
    this.loggedState,
    this.userState,
  });

  static AppState initialState() => AppState(
        wait: Wait(),
        loggedState: LoggedState.initialState(),
        userState: UserState.initialState(),
      );
  AppState copyWith({
    Wait wait,
    LoggedState loggedState,
    UserState userState,
  }) =>
      AppState(
        wait: wait ?? this.wait,
        loggedState: loggedState ?? this.loggedState,
        userState: userState ?? this.userState,
      );
  @override
  int get hashCode => loggedState.hashCode ^ userState.hashCode ^ wait.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          userState == other.userState &&
          loggedState == other.loggedState &&
          wait == other.wait &&
          runtimeType == other.runtimeType;
}
