import 'package:aiprof/app_state.dart';
import 'package:aiprof/know/know_action.dart';
import 'package:aiprof/know/know_model.dart';
import 'package:aiprof/know/know_select_toquestion_ui.dart';
import 'package:aiprof/routes.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends Vm {
  final List<KnowModel> knowList;
  final Function(String) onFolderList;
  ViewModel({
    @required this.knowList,
    @required this.onFolderList,
  }) : super(equals: [
          knowList,
        ]);
}

class Factory extends VmFactory<AppState, KnowSelectToQuestion> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        knowList: state.knowState.knowList,
        onFolderList: (String id) {
          dispatch(SetKnowCurrentSyncKnowAction(id));
          dispatch(NavigateAction.pushNamed(Routes.folderSelectToQuestion));
        },
      );
}

class KnowSelectToQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      onInit: (store) => store.dispatch(StreamColExameAsyncExameAction()),
      builder: (context, viewModel) => KnowSelectToQuestionUI(
        knowList: viewModel.knowList,
        onFolderList: viewModel.onFolderList,
      ),
    );
  }
}
