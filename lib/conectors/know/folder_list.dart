import 'package:aiprof/actions/know_action.dart';
import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/models/know_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/know/folder_list_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends BaseModel<AppState> {
  Map<String, Folder> folderMap;
  KnowModel knowModel;
  Function(String, bool) onSetFolderCurrent;
  Function(String, bool) onEditFolderCurrent;
  Function(SituationModel) onSetSituationInFolderSyncKnowAction;
  Function(String) onEditSituation;
  Function(String) onSimulationList;

  ViewModel();
  ViewModel.build({
    @required this.folderMap,
    @required this.knowModel,
    @required this.onEditFolderCurrent,
    @required this.onSetFolderCurrent,
    @required this.onSetSituationInFolderSyncKnowAction,
    @required this.onEditSituation,
    @required this.onSimulationList,
  }) : super(equals: [folderMap, knowModel]);
  @override
  ViewModel fromStore() => ViewModel.build(
        folderMap:
            state.knowState.knowCurrent?.folderMap ?? Map<String, Folder>(),
        knowModel: state.knowState.knowCurrent,
        onEditFolderCurrent: (String id, bool isAddOrUpdate) {
          dispatch(SetFolderCurrentSyncKnowAction(
              id: id, isAddOrUpdate: isAddOrUpdate));
          dispatch(NavigateAction.pushNamed(Routes.folderEdit));
        },
        onSetFolderCurrent: (String id, bool isAddOrUpdate) {
          dispatch(SetFolderCurrentSyncKnowAction(
              id: id, isAddOrUpdate: isAddOrUpdate));
        },
        onSetSituationInFolderSyncKnowAction: (SituationModel situationRef) {
          dispatch(SetSituationInFolderSyncKnowAction(
            situationRef: situationRef,
            isAddOrRemove: false,
          ));
        },
        onEditSituation: (String id) {
          dispatchFuture(SetSituationCurrentASyncSituationAction(id)).then(
              (value) =>
                  dispatch(NavigateAction.pushNamed(Routes.situationEdit)));
        },
        onSimulationList: (String id) {
          dispatchFuture(SetSituationCurrentASyncSituationAction(id)).then(
              (value) =>
                  dispatch(NavigateAction.pushNamed(Routes.simulationList)));
        },
      );
}

class FolderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      model: ViewModel(),
      builder: (context, viewModel) => FolderListDS(
        folderMap: viewModel.folderMap,
        knowModel: viewModel.knowModel,
        onEditFolderCurrent: viewModel.onEditFolderCurrent,
        onSetFolderCurrent: viewModel.onSetFolderCurrent,
        onSetSituationInFolderSyncKnowAction:
            viewModel.onSetSituationInFolderSyncKnowAction,
        onEditSituation: viewModel.onEditSituation,
        onSimulationList: viewModel.onSimulationList,
      ),
    );
  }
}
