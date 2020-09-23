import 'package:aiprof/states/classroom_state.dart';
import 'package:aiprof/states/know_state.dart';
import 'package:aiprof/states/logged_state.dart';
import 'package:aiprof/states/simulation_state.dart';
import 'package:aiprof/states/situation_state.dart';
import 'package:aiprof/states/student_state.dart';
import 'package:aiprof/states/user_state.dart';
import 'package:async_redux/async_redux.dart';

class AppState {
  final Wait wait;
  final LoggedState loggedState;
  final UserState userState;
  final ClassroomState classroomState;
  final StudentState studentState;
  final SituationState situationState;
  final KnowState knowState;
  final SimulationState simulationState;

  AppState({
    this.wait,
    this.loggedState,
    this.userState,
    this.classroomState,
    this.studentState,
    this.situationState,
    this.knowState,
    this.simulationState,
  });

  static AppState initialState() => AppState(
        wait: Wait(),
        loggedState: LoggedState.initialState(),
        userState: UserState.initialState(),
        classroomState: ClassroomState.initialState(),
        studentState: StudentState.initialState(),
        situationState: SituationState.initialState(),
        knowState: KnowState.initialState(),
        simulationState: SimulationState.initialState(),
      );
  AppState copyWith({
    Wait wait,
    LoggedState loggedState,
    UserState userState,
    ClassroomState classroomState,
    StudentState studentState,
    SituationState situationState,
    KnowState knowState,
    SimulationState simulationState,
  }) =>
      AppState(
        wait: wait ?? this.wait,
        loggedState: loggedState ?? this.loggedState,
        userState: userState ?? this.userState,
        classroomState: classroomState ?? this.classroomState,
        studentState: studentState ?? this.studentState,
        situationState: situationState ?? this.situationState,
        knowState: knowState ?? this.knowState,
        simulationState: simulationState ?? this.simulationState,
      );
  @override
  int get hashCode =>
      simulationState.hashCode ^
      knowState.hashCode ^
      situationState.hashCode ^
      studentState.hashCode ^
      classroomState.hashCode ^
      loggedState.hashCode ^
      userState.hashCode ^
      wait.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          knowState == other.knowState &&
          situationState == other.situationState &&
          studentState == other.studentState &&
          classroomState == other.classroomState &&
          userState == other.userState &&
          loggedState == other.loggedState &&
          wait == other.wait &&
          runtimeType == other.runtimeType;
}
