import 'package:aiprof/app_state.dart';
import 'package:aiprof/uis/know/folder_select_toquestion_ui.dart';
import 'package:aiprof/know/know_model.dart';
import 'package:aiprof/situation/situation_action.dart';
import 'package:aiprof/situation/situation_model.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends Vm {
  final Map<String, Folder> folderMap;
  final KnowModel knowModel;
  final Function(SituationModel) onSetSituationInQuestionCurrent;

  ViewModel({
    @required this.folderMap,
    @required this.knowModel,
    @required this.onSetSituationInQuestionCurrent,
  }) : super(equals: [folderMap, knowModel]);
}

class Factory extends VmFactory<AppState, FolderSelectToQuestionList> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
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
      vm: Factory(this),
      builder: (context, viewModel) => FolderSelectToQuestionUI(
        folderMap: viewModel.folderMap,
        knowModel: viewModel.knowModel,
        onSetSituationInQuestionCurrent:
            viewModel.onSetSituationInQuestionCurrent,
      ),
    );
  }
}
