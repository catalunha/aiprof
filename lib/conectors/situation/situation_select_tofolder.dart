import 'package:aiprof/actions/know_action.dart';
import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/models/know_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:aiprof/uis/situation/situation_select_tofolder_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  List<SituationModel> situationList;
  Folder folderCurrent;
  Function(SituationModel, bool) onSetSituationInKnow;
  Function(SituationOrder) onSelectOrder;

  ViewModel();
  ViewModel.build({
    @required this.situationList,
    @required this.folderCurrent,
    @required this.onSetSituationInKnow,
    @required this.onSelectOrder,
  }) : super(equals: [
          situationList,
          folderCurrent,
        ]);
  _situationList() {
    List<SituationModel> situationList = [];
    situationList.addAll(state.situationState.situationList);
    for (var folder in state.knowState.knowCurrent.folderMap.entries) {
      if (folder.value.situationRefMap != null &&
          folder.value.situationRefMap.isNotEmpty) {
        for (var situationRef in folder.value.situationRefMap.entries) {
          situationList
              .removeWhere((element) => element.id == situationRef.key);
        }
      }
    }
    return situationList;
  }

  @override
  ViewModel fromStore() => ViewModel.build(
        situationList: _situationList(),
        folderCurrent: state.knowState.folderCurrent,
        onSetSituationInKnow:
            (SituationModel situationRef, bool isAddOrRemove) {
          dispatch(SetSituationInFolderSyncKnowAction(
            situationRef: situationRef,
            isAddOrRemove: isAddOrRemove,
          ));
        },
        onSelectOrder: (SituationOrder situationOrder) {
          // dispatch(
          //   SetSituationOrderSyncSituationAction(
          //     situationOrder,
          //   ),
          // );
        },
      );
}

class SituationSelectToFolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      debug: this,
      model: ViewModel(),
      onInit: (store) =>
          store.dispatch(GetDocsSituationListAsyncSituationAction()),
      builder: (context, viewModel) => SituationSelectToFolderDS(
        situationList: viewModel.situationList,
        folderCurrent: viewModel.folderCurrent,
        onSetSituationInKnow: viewModel.onSetSituationInKnow,
        onSelectOrder: viewModel.onSelectOrder,
      ),
    );
  }
}
