import 'package:aiprof/actions/simulation_action.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/uis/simulation/simulation_edit_ds.dart';
import 'package:flutter/material.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends Vm {
  final String name;
  final List<Input> input;
  final List<Output> output;
  final bool isAddOrUpdate;
  final Function(String) onAdd;
  final Function(String, bool) onUpdate;
  final Function(String) onEditInput;
  final Function(String) onEditOutput;

  ViewModel({
    @required this.name,
    @required this.input,
    @required this.output,
    @required this.isAddOrUpdate,
    @required this.onAdd,
    @required this.onUpdate,
    @required this.onEditInput,
    @required this.onEditOutput,
  }) : super(equals: [
          name,
          input,
          output,
          isAddOrUpdate,
        ]);
}

class Factory extends VmFactory<AppState, SimulationEdit> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        isAddOrUpdate: state.simulationState.simulationCurrent.id == null,
        name: state.simulationState.simulationCurrent.name,
        input: _input(state.simulationState.simulationCurrent.input),
        output: _output(state.simulationState.simulationCurrent.output),
        onAdd: (
          String name,
        ) {
          dispatch(AddDocSimulationCurrentAsyncSimulationAction(name: name));
          dispatch(NavigateAction.pop());
        },
        onUpdate: (String name, bool isDelete) {
          dispatch(UpdateDocSimulationCurrentAsyncSimulationAction(
              name: name, isDelete: isDelete));
          dispatch(NavigateAction.pop());
        },
        onEditInput: (String id) {
          dispatch(SetInputCurrentSyncSimulationAction(id));
          dispatch(NavigateAction.pushNamed(Routes.inputEdit));
        },
        onEditOutput: (String id) {
          dispatch(SetOutputCurrentSyncSimulationAction(id));
          dispatch(NavigateAction.pushNamed(Routes.outputEdit));
        },
      );
  List<Input> _input(Map<String, Input> input) {
    List<Input> _input = [];
    if (input != null) {
      for (var item in input.entries) {
        _input.add(Input(item.key).fromMap(item.value.toMap()));
      }
      _input.sort((a, b) => a.name.compareTo(b.name));
    }
    return _input;
  }

  List<Output> _output(Map<String, Output> output) {
    List<Output> _output = [];
    if (output != null) {
      for (var item in output.entries) {
        _output.add(Output(item.key).fromMap(item.value.toMap()));
      }
      _output.sort((a, b) => a.name.compareTo(b.name));
    }
    return _output;
  }
}

class SimulationEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (context, viewModel) => SimulationEditDS(
        isAddOrUpdate: viewModel.isAddOrUpdate,
        name: viewModel.name,
        input: viewModel.input,
        output: viewModel.output,
        onAdd: viewModel.onAdd,
        onUpdate: viewModel.onUpdate,
        onEditInput: viewModel.onEditInput,
        onEditOutput: viewModel.onEditOutput,
      ),
    );
  }
}
