import 'package:aiprof/app_state.dart';
import 'package:aiprof/uis/situation/simulation/output_edit_ui.dart';
import 'package:aiprof/situation/simulation/simulation_action.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends Vm {
  final String name;
  final String type;
  final String value;
  final bool isAddOrUpdate;
  final Function(String, String, String) onAdd;
  final Function(String, String, String, bool) onUpdate;
  ViewModel({
    @required this.name,
    @required this.type,
    @required this.value,
    @required this.isAddOrUpdate,
    @required this.onAdd,
    @required this.onUpdate,
  }) : super(equals: [
          name,
          type,
          value,
          isAddOrUpdate,
        ]);
}

class Factory extends VmFactory<AppState, OutputEdit> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        isAddOrUpdate: state.simulationState.outputCurrent.id == null,
        name: state.simulationState.outputCurrent.name,
        type: state.simulationState.outputCurrent.type,
        value: state.simulationState.outputCurrent.value,
        onAdd: (String name, String type, String value) {
          dispatch(AddOutputSyncSimulationAction(
              name: name, type: type, value: value));
          dispatch(NavigateAction.pop());
        },
        onUpdate: (String name, String type, String value, bool isRemove) {
          dispatch(UpdateOutputSyncSimulationAction(
              name: name, type: type, value: value, isRemove: isRemove));
          dispatch(NavigateAction.pop());
        },
      );
}

class OutputEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (context, viewModel) => OutputEditUI(
        isAddOrUpdate: viewModel.isAddOrUpdate,
        name: viewModel.name,
        type: viewModel.type,
        value: viewModel.value,
        onAdd: viewModel.onAdd,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
