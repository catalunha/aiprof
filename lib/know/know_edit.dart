import 'package:aiprof/app_state.dart';
import 'package:aiprof/know/know_action.dart';
import 'package:aiprof/know/know_edit_ui.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends Vm {
  final String name;
  final String description;
  final bool isAddOrUpdate;
  final Function(String, String) onAdd;
  final Function(String, String, bool) onUpdate;

  ViewModel({
    @required this.name,
    @required this.description,
    @required this.isAddOrUpdate,
    @required this.onAdd,
    @required this.onUpdate,
  }) : super(equals: [
          name,
          description,
          isAddOrUpdate,
        ]);
}

class Factory extends VmFactory<AppState, KnowEdit> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        isAddOrUpdate: state.knowState.knowCurrent.id == null,
        name: state.knowState.knowCurrent.name,
        description: state.knowState.knowCurrent.description,
        onAdd: (String name, String description) {
          dispatch(AddDocKnowCurrentAsyncKnowAction(
            name: name,
            description: description,
          ));
          dispatch(NavigateAction.pop());
        },
        onUpdate: (String name, String description, bool isDelete) {
          dispatch(UpdateDocKnowCurrentAsyncKnowAction(
              name: name, description: description, isDelete: isDelete));
          dispatch(NavigateAction.pop());
        },
      );
}

class KnowEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (context, viewModel) => KnowEditUI(
        isAddOrUpdate: viewModel.isAddOrUpdate,
        name: viewModel.name,
        description: viewModel.description,
        onAdd: viewModel.onAdd,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
