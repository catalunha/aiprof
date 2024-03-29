import 'package:aiprof/app_state.dart';
import 'package:aiprof/classroom/classroom_model.dart';
import 'package:aiprof/exame/exame_model.dart';
import 'package:aiprof/question/question_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/situation/simulation/simulation_model.dart';
import 'package:aiprof/situation/situation_model.dart';
import 'package:aiprof/task/task_action.dart';
import 'package:aiprof/task/task_edit_ui.dart';
import 'package:aiprof/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends Vm {
  final String id;
  final ClassroomModel classroomRef;
  final ExameModel exameRef;
  final QuestionModel questionRef;
  final SituationModel situationRef;
  final UserModel studentUserRef;
  //dados do exame
  final dynamic start;
  final dynamic end;
  final int scoreExame;
  //dados da questao
  final int attempt;
  final int time;
  final int error;
  final int scoreQuestion;
  // gestão da tarefa
  final int attempted;
  final bool isOpen;

  final List<Input> simulationInput;
  final List<Output> simulationOutput;

  final Function(
          dynamic, dynamic, int, int, int, int, int, bool, int, bool, bool)
      onUpdateTask;
  final Function(String, String, bool) onUpdateOutput;
  final Function() onSeeTextTask;

  ViewModel({
    @required this.id,
    @required this.classroomRef,
    @required this.exameRef,
    @required this.questionRef,
    @required this.situationRef,
    @required this.studentUserRef,
    @required this.start,
    @required this.end,
    @required this.scoreExame,
    @required this.attempt,
    @required this.time,
    @required this.error,
    @required this.scoreQuestion,
    @required this.attempted,
    @required this.isOpen,
    @required this.simulationInput,
    @required this.simulationOutput,
    @required this.onUpdateTask,
    @required this.onUpdateOutput,
    @required this.onSeeTextTask,
  }) : super(equals: [
          id,
          classroomRef,
          exameRef,
          questionRef,
          situationRef,
          studentUserRef,
          start,
          end,
          scoreExame,
          attempt,
          time,
          error,
          scoreQuestion,
          attempted,
          isOpen,
          simulationInput,
          simulationOutput,
        ]);
}

class Factory extends VmFactory<AppState, TaskEdit> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        id: state.taskState.taskCurrent.id,
        classroomRef: state.taskState.taskCurrent.classroomRef,
        exameRef: state.taskState.taskCurrent.exameRef,
        questionRef: state.taskState.taskCurrent.questionRef,
        situationRef: state.taskState.taskCurrent.situationRef,
        studentUserRef: state.taskState.taskCurrent.studentUserRef,
        start: state.taskState.taskCurrent.start,
        end: state.taskState.taskCurrent.end,
        scoreExame: state.taskState.taskCurrent.scoreExame,
        attempt: state.taskState.taskCurrent.attempt,
        time: state.taskState.taskCurrent.time,
        error: state.taskState.taskCurrent.error,
        scoreQuestion: state.taskState.taskCurrent.scoreQuestion,
        attempted: state.taskState.taskCurrent.attempted,
        isOpen: state.taskState.taskCurrent.isOpen,
        simulationInput:
            _simulationInput(state.taskState.taskCurrent.simulationInput),
        simulationOutput:
            _simulationOutput(state.taskState.taskCurrent.simulationOutput),
        onUpdateTask: (
          dynamic start,
          dynamic end,
          int scoreExame,
          int attempt,
          int time,
          int error,
          int scoreQuestion,
          bool nullStarted,
          int attempted,
          bool isOpen,
          bool isDelete,
        ) {
          dispatch(UpdateDocTaskCurrentAsyncTaskAction(
            start: start,
            end: end,
            scoreExame: scoreExame,
            attempt: attempt,
            time: time,
            error: error,
            scoreQuestion: scoreQuestion,
            nullStarted: nullStarted,
            attempted: attempted,
            isOpen: isOpen,
            isDelete: isDelete,
          ));
          dispatch(NavigateAction.pop());
          dispatch(NavigateAction.pop());
        },
        onUpdateOutput: (String taskId, String outputId, bool isTruOrFalse) {
          dispatch(UpdateOutputAsyncTaskAction(
              taskId: taskId,
              taskSimulationOutputId: outputId,
              isTruOrFalse: isTruOrFalse));
        },
        onSeeTextTask: () {
          dispatch(NavigateAction.pushNamed(Routes.taskAnswerText));
        },
      );
  List<Input> _simulationInput(Map<String, Input> simulationInput) {
    List<Input> _simulationInput = [];
    if (simulationInput != null) {
      for (var item in simulationInput.entries) {
        _simulationInput.add(Input(item.key).fromMap(item.value.toMap()));
      }
      _simulationInput.sort((a, b) => a.name.compareTo(b.name));
    }
    return _simulationInput;
  }

  List<Output> _simulationOutput(Map<String, Output> simulationOutput) {
    List<Output> _simulationOutput = [];
    if (simulationOutput != null) {
      for (var item in simulationOutput.entries) {
        _simulationOutput.add(Output(item.key).fromMap(item.value.toMap()));
      }
      _simulationOutput.sort((a, b) => a.name.compareTo(b.name));
    }
    return _simulationOutput;
  }
}

class TaskEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (context, viewModel) => TaskEditUI(
        id: viewModel.id,
        classroomRef: viewModel.classroomRef,
        exameRef: viewModel.exameRef,
        questionRef: viewModel.questionRef,
        situationRef: viewModel.situationRef,
        studentUserRef: viewModel.studentUserRef,
        start: viewModel.start,
        end: viewModel.end,
        scoreExame: viewModel.scoreExame,
        attempt: viewModel.attempt,
        time: viewModel.time,
        error: viewModel.error,
        scoreQuestion: viewModel.scoreQuestion,
        attempted: viewModel.attempted,
        simulationInput: viewModel.simulationInput,
        simulationOutput: viewModel.simulationOutput,
        isOpen: viewModel.isOpen,
        onUpdateTask: viewModel.onUpdateTask,
        onUpdateOutput: viewModel.onUpdateOutput,
        onSeeTextTask: viewModel.onSeeTextTask,
      ),
    );
  }
}
