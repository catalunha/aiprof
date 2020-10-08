import 'package:aiprof/states/classroom_state.dart';
import 'package:aiprof/states/exame_state.dart';
import 'package:aiprof/states/know_state.dart';
import 'package:aiprof/states/logged_state.dart';
import 'package:aiprof/states/question_state.dart';
import 'package:aiprof/states/simulation_state.dart';
import 'package:aiprof/states/situation_state.dart';
import 'package:aiprof/states/student_state.dart';
import 'package:aiprof/states/task_state.dart';
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
  final ExameState exameState;
  final QuestionState questionState;
  final TaskState taskState;

  AppState({
    this.wait,
    this.loggedState,
    this.userState,
    this.classroomState,
    this.studentState,
    this.situationState,
    this.knowState,
    this.simulationState,
    this.exameState,
    this.questionState,
    this.taskState,
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
        exameState: ExameState.initialState(),
        questionState: QuestionState.initialState(),
        taskState: TaskState.initialState(),
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
    ExameState exameState,
    QuestionState questionState,
    TaskState taskState,
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
        exameState: exameState ?? this.exameState,
        questionState: questionState ?? this.questionState,
        taskState: taskState ?? this.taskState,
      );
  @override
  int get hashCode =>
      taskState.hashCode ^
      questionState.hashCode ^
      exameState.hashCode ^
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
          taskState == other.taskState &&
          questionState == other.questionState &&
          exameState == other.exameState &&
          knowState == other.knowState &&
          situationState == other.situationState &&
          studentState == other.studentState &&
          classroomState == other.classroomState &&
          userState == other.userState &&
          loggedState == other.loggedState &&
          wait == other.wait &&
          runtimeType == other.runtimeType;
}
