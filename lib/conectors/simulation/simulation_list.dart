import 'package:aiprof/actions/simulation_action.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/uis/simulation/simulation_list_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';

class ViewModel extends BaseModel<AppState> {
  List<SimulationModel> simulationList;
  Function(String) onEditSimulation;
  ViewModel();
  ViewModel.build({
    @required this.simulationList,
    @required this.onEditSimulation,
  }) : super(equals: [
          simulationList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        simulationList: state.simulationState.simulationList,
        onEditSimulation: (String id) {
          dispatch(SetSimulationCurrentSyncSimulationAction(id));
          dispatch(NavigateAction.pushNamed(Routes.simulationEdit));
        },
      );
}

class SimulationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) =>
          store.dispatch(GetDocsSimulationListAsyncSimulationAction()),
      builder: (context, viewModel) => SimulationListDS(
        simulationList: viewModel.simulationList,
        onEditSimulation: viewModel.onEditSimulation,
      ),
    );
  }
}
