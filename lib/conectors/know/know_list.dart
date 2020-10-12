import 'package:aiprof/actions/know_action.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/uis/know/know_list_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aiprof/models/know_model.dart';
import 'package:aiprof/states/app_state.dart';

class ViewModel extends BaseModel<AppState> {
  List<KnowModel> knowList;
  Function(String) onEditKnowCurrent;
  Function(String) onFolderList;
  ViewModel();
  ViewModel.build({
    @required this.knowList,
    @required this.onEditKnowCurrent,
    @required this.onFolderList,
  }) : super(equals: [
          knowList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
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
      model: ViewModel(),
      onInit: (store) => store.dispatch(StreamColExameAsyncExameAction()),
      builder: (context, viewModel) => KnowListDS(
        knowList: viewModel.knowList,
        onEditKnowCurrent: viewModel.onEditKnowCurrent,
        onFolderList: viewModel.onFolderList,
      ),
    );
  }
}
