import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/uis/task/task_answer_text_ds.dart';
import 'package:flutter/material.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends Vm {
  final String id;
  final List<Input> simulationInput;
  final List<Output> simulationOutput;

  ViewModel({
    @required this.id,
    @required this.simulationInput,
    @required this.simulationOutput,
  }) : super(equals: [
          id,
          simulationInput,
          simulationOutput,
        ]);
}

class Factory extends VmFactory<AppState, TaskAnswerText> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        id: state.taskState.taskCurrent.id,
        simulationInput:
            _simulationInput(state.taskState.taskCurrent.simulationInput),
        simulationOutput:
            _simulationOutput(state.taskState.taskCurrent.simulationOutput),
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

class TaskAnswerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (context, viewModel) => TaskAnswerTextDS(
        id: viewModel.id,
        simulationInput: viewModel.simulationInput,
        simulationOutput: viewModel.simulationOutput,
      ),
    );
  }
}
