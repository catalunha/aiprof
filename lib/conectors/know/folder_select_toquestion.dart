import 'package:aiprof/actions/know_action.dart';
import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/models/know_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/know/folder_select_toquestion_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends BaseModel<AppState> {
  Map<String, Folder> folderMap;
  KnowModel knowModel;
  Function(SituationModel) onSetSituationInQuestionCurrent;

  ViewModel();
  ViewModel.build({
    @required this.folderMap,
    @required this.knowModel,
    @required this.onSetSituationInQuestionCurrent,
  }) : super(equals: [folderMap, knowModel]);
  @override
  ViewModel fromStore() => ViewModel.build(
        folderMap:
            state.knowState.knowCurrent?.folderMap ?? Map<String, Folder>(),
        knowModel: state.knowState.knowCurrent,
        onSetSituationInQuestionCurrent: (SituationModel situationRef) {
          print('id1:${situationRef?.id}');
          // dispatch(SetSituationCurrentSyncSituationAction(id));
          dispatch(
              SetSituationInQuestionCurrentSyncSituationAction(situationRef));
          dispatch(NavigateAction.pop());
          dispatch(NavigateAction.pop());
        },
      );
}

class FolderSelectToQuestionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      model: ViewModel(),
      builder: (context, viewModel) => FolderSelectToQuestionDS(
        folderMap: viewModel.folderMap,
        knowModel: viewModel.knowModel,
        onSetSituationInQuestionCurrent:
            viewModel.onSetSituationInQuestionCurrent,
      ),
    );
  }
}
