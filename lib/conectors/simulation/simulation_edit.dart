import 'package:aiprof/actions/simulation_action.dart';
import 'package:aiprof/uis/simulation/simulation_edit_ds.dart';
import 'package:flutter/material.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends BaseModel<AppState> {
  String name;
  bool isAddOrUpdate;
  Function(
    String,
  ) onAdd;
  Function(
    String,
  ) onUpdate;
  ViewModel();
  ViewModel.build({
    @required this.name,
    @required this.isAddOrUpdate,
    @required this.onAdd,
    @required this.onUpdate,
  }) : super(equals: [
          name,
          isAddOrUpdate,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        isAddOrUpdate: state.simulationState.simulationCurrent.id == null,
        name: state.simulationState.simulationCurrent.name,
        onAdd: (
          String name,
        ) {
          dispatch(AddDocSimulationCurrentAsyncSimulationAction(
            name: name,
          ));
          dispatch(NavigateAction.pop());
        },
        onUpdate: (
          String name,
        ) {
          dispatch(UpdateDocSimulationCurrentAsyncSimulationAction(
            name: name,
          ));
          dispatch(NavigateAction.pop());
        },
      );
}

class SimulationEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      builder: (context, viewModel) => SimulationEditDS(
        isAddOrUpdate: viewModel.isAddOrUpdate,
        name: viewModel.name,
        onAdd: viewModel.onAdd,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
