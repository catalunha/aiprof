import 'package:aiprof/actions/know_action.dart';
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

  ViewModel();
  ViewModel.build({
    @required this.folderMap,
    @required this.knowModel,
    @required this.onEditFolderCurrent,
    @required this.onSetFolderCurrent,
    @required this.onSetSituationInFolderSyncKnowAction,
  }) : super(equals: [folderMap, knowModel]);
  @override
  ViewModel fromStore() => ViewModel.build(
        folderMap:
            state.knowState.knowCurrent?.folderMap ?? Map<String, Folder>(),
        knowModel: state.knowState.knowCurrent,
        onEditFolderCurrent: (String id, bool isCreateOrUpdate) {
          dispatch(SetFolderCurrentSyncKnowAction(
              id: id, isCreateOrUpdate: isCreateOrUpdate));
          dispatch(NavigateAction.pushNamed(Routes.folderEdit));
        },
        onSetFolderCurrent: (String id, bool isCreateOrUpdate) {
          dispatch(SetFolderCurrentSyncKnowAction(
              id: id, isCreateOrUpdate: isCreateOrUpdate));
        },
        onSetSituationInFolderSyncKnowAction: (SituationModel situationRef) {
          dispatch(SetSituationInFolderSyncKnowAction(
            situationRef: situationRef,
            isAddOrRemove: false,
          ));
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
      ),
    );
  }
}
