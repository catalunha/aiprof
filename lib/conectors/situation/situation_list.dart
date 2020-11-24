import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/situation/situation_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final List<SituationModel> situationList;
  final Function(String) onEditSituationCurrent;
  final Function(String) onSimulationList;
  final Function(String) onSearchSituation;
  ViewModel({
    @required this.situationList,
    @required this.onEditSituationCurrent,
    @required this.onSimulationList,
    @required this.onSearchSituation,
  }) : super(equals: [
          situationList,
        ]);
}

class Factory extends VmFactory<AppState, SituationList> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        situationList: state.situationState.situationListFilter,
        onEditSituationCurrent: (String id) {
          dispatch(SetSituationCurrentSyncSituationAction(id));
          dispatch(NavigateAction.pushNamed(Routes.situationEdit));
        },
        onSimulationList: (String id) {
          dispatch(SetSituationCurrentSyncSituationAction(id));
          dispatch(NavigateAction.pushNamed(Routes.simulationList));
        },
        onSearchSituation: (String name) {
          dispatch(SearchSituationSyncSituationAction(name));
        },
      );
}

class SituationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      onInit: (store) =>
          store.dispatch(StreamColSituationAsyncSituationAction()),
      builder: (context, viewModel) => SituationListDS(
        situationList: viewModel.situationList,
        onEditSituationCurrent: viewModel.onEditSituationCurrent,
        onSimulationList: viewModel.onSimulationList,
        onSearchSituation: viewModel.onSearchSituation,
      ),
    );
  }
}
