import 'package:aiprof/states/classroom_state.dart';
import 'package:aiprof/states/logged_state.dart';
import 'package:aiprof/states/problem_state.dart';
import 'package:aiprof/states/student_state.dart';
import 'package:aiprof/states/user_state.dart';
import 'package:async_redux/async_redux.dart';

class AppState {
  final Wait wait;
  final LoggedState loggedState;
  final UserState userState;
  final ClassroomState classroomState;
  final StudentState studentState;
  final ProblemState problemState;

  AppState({
    this.wait,
    this.loggedState,
    this.userState,
    this.classroomState,
    this.studentState,
    this.problemState,
  });

  static AppState initialState() => AppState(
        wait: Wait(),
        loggedState: LoggedState.initialState(),
        userState: UserState.initialState(),
        classroomState: ClassroomState.initialState(),
        studentState: StudentState.initialState(),
        problemState: ProblemState.initialState(),
      );
  AppState copyWith({
    Wait wait,
    LoggedState loggedState,
    UserState userState,
    ClassroomState classroomState,
    StudentState studentState,
    ProblemState problemState,
  }) =>
      AppState(
        wait: wait ?? this.wait,
        loggedState: loggedState ?? this.loggedState,
        userState: userState ?? this.userState,
        classroomState: classroomState ?? this.classroomState,
        studentState: studentState ?? this.studentState,
        problemState: problemState ?? this.problemState,
      );
  @override
  int get hashCode =>
      problemState.hashCode ^
      studentState.hashCode ^
      classroomState.hashCode ^
      loggedState.hashCode ^
      userState.hashCode ^
      wait.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          problemState == other.problemState &&
          studentState == other.studentState &&
          classroomState == other.classroomState &&
          userState == other.userState &&
          loggedState == other.loggedState &&
          wait == other.wait &&
          runtimeType == other.runtimeType;
}
