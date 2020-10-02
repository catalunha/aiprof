import 'package:aiprof/actions/simulation_action.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/uis/simulation/simulation_list_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';

class ViewModel extends BaseModel<AppState> {
  List<SimulationModel> simulationList;
  List<String> simulationIncosistent;
  Function(String) onEditSimulation;
  ViewModel();
  ViewModel.build({
    @required this.simulationList,
    @required this.simulationIncosistent,
    @required this.onEditSimulation,
  }) : super(equals: [
          simulationList,
          simulationIncosistent,
        ]);
  List<String> _simulationIncosistent(List<SimulationModel> simulationList) {
    List<String> _simulationIncosistent = [];
    List<String> _inputList = [];
    List<String> _outputList = [];
    int qdeInput = 0;
    int qdeOutput = 0;
    //Coleta simulação base
    if (simulationList != null && simulationList.isNotEmpty) {
      if (simulationList[0]?.input != null) {
        qdeInput = simulationList[0]?.input?.length;
        for (var item in simulationList[0].input.values.toList()) {
          _inputList.add(item.name);
        }
      }
      if (simulationList[0]?.output != null) {
        qdeOutput = simulationList[0]?.output?.length;
        for (var item in simulationList[0].output.values.toList()) {
          _outputList.add(item.name);
        }
      }
      print(_inputList);
      //quantidades de input e output iguais
      for (var simulation in simulationList) {
        if (simulation?.input == null || simulation.input.length != qdeInput) {
          _simulationIncosistent.add(simulation.id);
        }
        if (simulation?.output == null ||
            simulation.output.length != qdeOutput) {
          _simulationIncosistent.add(simulation.id);
        }
        if (simulation?.input != null) {
          for (var input in simulation.input.values.toList()) {
            print(input.name);
            if (!_inputList.contains(input.name)) {
              _simulationIncosistent.add(simulation.id);
            }
          }
        }
        if (simulation?.output != null) {
          for (var output in simulation.output.values.toList()) {
            print(output.name);
            if (!_outputList.contains(output.name)) {
              _simulationIncosistent.add(simulation.id);
            }
          }
        }
      }
    }
    return _simulationIncosistent;
  }

  @override
  ViewModel fromStore() => ViewModel.build(
        simulationList: state.simulationState.simulationList,
        simulationIncosistent:
            _simulationIncosistent(state.simulationState?.simulationList),
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
        simulationIncosistent: viewModel.simulationIncosistent,
        onEditSimulation: viewModel.onEditSimulation,
      ),
    );
  }
}
