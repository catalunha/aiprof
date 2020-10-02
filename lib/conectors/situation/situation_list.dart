import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/situation/situation_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  List<SituationModel> situationList;
  Function(String) onEditSituationCurrent;
  Function(String) onSimulationList;
  ViewModel();
  ViewModel.build({
    @required this.situationList,
    @required this.onEditSituationCurrent,
    @required this.onSimulationList,
  }) : super(equals: [
          situationList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        situationList: state.situationState.situationList,
        onEditSituationCurrent: (String id) {
          dispatch(SetSituationCurrentSyncSituationAction(id));
          dispatch(NavigateAction.pushNamed(Routes.situationEdit));
        },
        onSimulationList: (String id) {
          dispatch(SetSituationCurrentLocalSyncSituationAction(id));
          dispatch(NavigateAction.pushNamed(Routes.simulationList));
        },
      );
}

class SituationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) =>
          store.dispatch(GetDocsSituationListAsyncSituationAction()),
      builder: (context, viewModel) => SituationListDS(
        situationList: viewModel.situationList,
        onEditSituationCurrent: viewModel.onEditSituationCurrent,
        onSimulationList: viewModel.onSimulationList,
      ),
    );
  }
}
