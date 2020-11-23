import 'package:aiprof/actions/simulation_action.dart';
import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/uis/simulation/simulation_list_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';

class ViewModel extends Vm {
  final List<SimulationModel> simulationList;
  final List<String> simulationIncosistent;
  final Function(String) onEditSimulation;
  ViewModel({
    @required this.simulationList,
    @required this.simulationIncosistent,
    @required this.onEditSimulation,
  }) : super(equals: [
          simulationList,
          simulationIncosistent,
        ]);
}

class Factory extends VmFactory<AppState, SimulationList> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        simulationList: state.simulationState.simulationList,
        simulationIncosistent:
            _simulationIncosistent(state.simulationState?.simulationList),
        onEditSimulation: (String id) {
          dispatch(SetSimulationCurrentSyncSimulationAction(id));
          dispatch(NavigateAction.pushNamed(Routes.simulationEdit));
        },
      );
  List<String> _simulationIncosistent(List<SimulationModel> simulationList) {
    List<String> _simulationIncosistent = [];
    List<String> _inputList = [];
    List<String> _outputList = [];
    int qdeInput = 0;
    int qdeOutput = 0;
    if (simulationList != null && simulationList.isNotEmpty) {
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
        // print(_inputList);
        //quantidades de input e output iguais
        for (var simulation in simulationList) {
          if (simulation?.input != null &&
              simulation.input.length != qdeInput) {
            _simulationIncosistent.add(simulation.id);
          }
          if (simulation?.output == null ||
              simulation.output.length != qdeOutput) {
            _simulationIncosistent.add(simulation.id);
          }
          if (simulation?.input != null) {
            for (var input in simulation.input.values.toList()) {
              if (!_inputList.contains(input.name)) {
                _simulationIncosistent.add(simulation.id);
              }
            }
          }
          if (simulation?.output != null) {
            for (var output in simulation.output.values.toList()) {
              if (!_outputList.contains(output.name)) {
                _simulationIncosistent.add(simulation.id);
              }
            }
          }
        }
      }
      print('_simulationIncosistent: $_simulationIncosistent');
      if (_simulationIncosistent.isEmpty) {
        dispatch(UpdateFieldDocSituationCurrentAsyncSituationAction(
            field: 'isSimulationConsistent', value: true));
      } else {
        dispatch(UpdateFieldDocSituationCurrentAsyncSituationAction(
            field: 'isSimulationConsistent', value: false));
      }
    } else {
      dispatch(UpdateFieldDocSituationCurrentAsyncSituationAction(
          field: 'isSimulationConsistent', value: false));
    }
    return _simulationIncosistent;
  }
}

class SimulationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
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
