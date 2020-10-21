import 'package:aiprof/actions/simulation_action.dart';
import 'package:aiprof/uis/simulation/input_edit_ds.dart';
import 'package:flutter/material.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends BaseModel<AppState> {
  String name;
  String type;
  String value;
  bool isAddOrUpdate;
  Function(String, String, String) onAdd;
  Function(String, String, String, bool) onUpdate;
  ViewModel();
  ViewModel.build({
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

  @override
  ViewModel fromStore() => ViewModel.build(
        isAddOrUpdate: state.simulationState.inputCurrent.id == null,
        name: state.simulationState.inputCurrent.name,
        type: state.simulationState.inputCurrent.type,
        value: state.simulationState.inputCurrent.value,
        onAdd: (String name, String type, String value) {
          dispatch(AddInputSyncSimulationAction(
              name: name, type: type, value: value));
          dispatch(NavigateAction.pop());
        },
        onUpdate: (String name, String type, String value, bool isRemove) {
          dispatch(UpdateInputSyncSimulationAction(
              name: name, type: type, value: value, isRemove: isRemove));
          dispatch(NavigateAction.pop());
        },
      );
}

class InputEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      builder: (context, viewModel) => InputEditDS(
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
