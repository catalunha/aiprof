import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aiprof/actions/know_action.dart';
import 'package:aiprof/uis/know/know_edit_ds.dart';
import 'package:aiprof/states/app_state.dart';

class ViewModel extends BaseModel<AppState> {
  String name;
  String description;
  bool isCreateOrUpdate;
  Function(String, String) onCreate;
  Function(String, String) onUpdate;
  // Function(InfoCodeModel, bool) onSetInfoCodeInKnow;

  ViewModel();
  ViewModel.build({
    @required this.name,
    @required this.description,
    @required this.isCreateOrUpdate,
    @required this.onCreate,
    @required this.onUpdate,
    // @required this.onSetInfoCodeInKnow,
  }) : super(equals: [
          name,
          description,
          isCreateOrUpdate,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        isCreateOrUpdate: state.knowState.knowCurrent.id == null,
        name: state.knowState.knowCurrent.name,
        description: state.knowState.knowCurrent.description,
        onCreate: (String name, String description) {
          dispatch(AddDocKnowCurrentAsyncKnowAction(
            name: name,
            description: description,
          ));
          dispatch(NavigateAction.pop());
        },
        onUpdate: (String name, String description) {
          dispatch(UpdateDocKnowCurrentAsyncKnowAction(
            name: name,
            description: description,
          ));
          dispatch(NavigateAction.pop());
        },
      );
}

class KnowEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      builder: (context, viewModel) => KnowEditDS(
        isCreateOrUpdate: viewModel.isCreateOrUpdate,
        name: viewModel.name,
        description: viewModel.description,
        onCreate: viewModel.onCreate,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
