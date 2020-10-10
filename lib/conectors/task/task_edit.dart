import 'package:aiprof/actions/task_action.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/uis/task/task_edit_ds.dart';
import 'package:flutter/material.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends BaseModel<AppState> {
  String id;
  //dados do exame
  dynamic start;
  dynamic end;
  int scoreExame;
  //dados da questao
  int attempt;
  int time;
  int error;
  int scoreQuestion;
  // gestão da tarefa
  int attempted;
  bool isOpen;

  List<Input> simulationInput;
  List<Output> simulationOutput;

  Function(dynamic, dynamic, int, int, int, int, int, bool, int, bool, bool)
      onUpdateTask;
  Function(String, bool) onUpdateOutput;

  ViewModel();
  ViewModel.build({
    @required this.id,
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
  }) : super(equals: [
          id,
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

  @override
  ViewModel fromStore() => ViewModel.build(
        id: state.taskState.taskCurrent.id,
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
        },
        onUpdateOutput: (String id, bool isTruOrFalse) {
          dispatch(UpdateOutputAsyncTaskAction(
              taskSimulationOutputId: id, isTruOrFalse: isTruOrFalse));
        },
      );
}

class TaskEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      builder: (context, viewModel) => TaskEditDS(
        id: viewModel.id,
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
      ),
    );
  }
}