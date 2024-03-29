import 'package:aiprof/base/datasource_state.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aiprof/classroom/classroom_state.dart';
import 'package:aiprof/exame/exame_state.dart';
import 'package:aiprof/know/know_state.dart';
import 'package:aiprof/login/logged_state.dart';
import 'package:aiprof/question/question_state.dart';
import 'package:aiprof/situation/simulation/simulation_state.dart';
import 'package:aiprof/situation/situation_state.dart';
import 'package:aiprof/student/student_state.dart';
import 'package:aiprof/task/task_state.dart';
import 'package:aiprof/user/user_state.dart';

class AppState {
  final Wait wait;
  final DataSourceState dataSourceState;
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
    this.dataSourceState,
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
        dataSourceState: DataSourceState.initialState(),
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
    DataSourceState dataSourceState,
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
        dataSourceState: dataSourceState ?? this.dataSourceState,
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
      dataSourceState.hashCode ^
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
          dataSourceState == other.dataSourceState &&
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
