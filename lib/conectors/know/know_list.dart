import 'package:aiprof/actions/know_action.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/uis/know/know_list_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aiprof/models/know_model.dart';
import 'package:aiprof/states/app_state.dart';

class ViewModel extends Vm {
  final List<KnowModel> knowList;
  final Function(String) onEditKnowCurrent;
  final Function(String) onFolderList;
  ViewModel({
    @required this.knowList,
    @required this.onEditKnowCurrent,
    @required this.onFolderList,
  }) : super(equals: [
          knowList,
        ]);
}

class Factory extends VmFactory<AppState, KnowList> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        knowList: state.knowState.knowList,
        onEditKnowCurrent: (String id) {
          dispatch(SetKnowCurrentSyncKnowAction(id));
          dispatch(NavigateAction.pushNamed(Routes.knowEdit));
        },
        onFolderList: (String id) {
          dispatch(SetKnowCurrentSyncKnowAction(id));
          dispatch(NavigateAction.pushNamed(Routes.folderList));
        },
      );
}

class KnowList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      onInit: (store) => store.dispatch(StreamColExameAsyncExameAction()),
      builder: (context, viewModel) => KnowListDS(
        knowList: viewModel.knowList,
        onEditKnowCurrent: viewModel.onEditKnowCurrent,
        onFolderList: viewModel.onFolderList,
      ),
    );
  }
}
