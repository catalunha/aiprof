import 'package:aiprof/actions/know_action.dart';
import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/models/know_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:aiprof/uis/situation/situation_select_tofolder_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final List<SituationModel> situationList;
  final Folder folderCurrent;
  final Function(SituationModel, bool) onSetSituationInKnow;
  final Function(SituationOrder) onSelectOrder;

  ViewModel({
    @required this.situationList,
    @required this.folderCurrent,
    @required this.onSetSituationInKnow,
    @required this.onSelectOrder,
  }) : super(equals: [
          situationList,
          folderCurrent,
        ]);
}

class Factory extends VmFactory<AppState, SituationSelectToFolder> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
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
  _situationList() {
    List<SituationModel> situationList = [];
    situationList.addAll(state.situationState.situationList);
    print(situationList.length);
    situationList.removeWhere((element) =>
        element.isSimulationConsistent == false ||
        element.isSimulationConsistent == null);
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
}

class SituationSelectToFolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      debug: this,
      vm: Factory(this),
      onInit: (store) =>
          store.dispatch(StreamColSituationAsyncSituationAction()),
      builder: (context, viewModel) => SituationSelectToFolderDS(
        situationList: viewModel.situationList,
        folderCurrent: viewModel.folderCurrent,
        onSetSituationInKnow: viewModel.onSetSituationInKnow,
        onSelectOrder: viewModel.onSelectOrder,
      ),
    );
  }
}
