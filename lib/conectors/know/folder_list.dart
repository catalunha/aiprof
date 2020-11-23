import 'package:aiprof/actions/know_action.dart';
import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/models/know_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/know/folder_list_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends Vm {
  final Map<String, Folder> folderMap;
  final KnowModel knowModel;
  final Function(String, bool) onSetFolderCurrent;
  final Function(String, bool) onEditFolderCurrent;
  final Function(SituationModel) onSetSituationInFolderSyncKnowAction;
  final Function(String) onEditSituation;
  final Function(String) onSimulationList;

  ViewModel({
    @required this.folderMap,
    @required this.knowModel,
    @required this.onEditFolderCurrent,
    @required this.onSetFolderCurrent,
    @required this.onSetSituationInFolderSyncKnowAction,
    @required this.onEditSituation,
    @required this.onSimulationList,
  }) : super(equals: [folderMap, knowModel]);
}

class Factory extends VmFactory<AppState, FolderList> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
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
      vm: Factory(this),
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
