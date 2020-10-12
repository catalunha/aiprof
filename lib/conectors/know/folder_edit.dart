import 'package:aiprof/actions/know_action.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/know/folder_edit_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  String name;
  String description;
  bool isAddOrUpdate;
  Function(String, String) onCreate;
  Function(String, String, bool) onUpdate;

  ViewModel();
  ViewModel.build({
    @required this.name,
    @required this.description,
    @required this.isAddOrUpdate,
    @required this.onCreate,
    @required this.onUpdate,
  }) : super(equals: [
          name,
          description,
          isAddOrUpdate,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        isAddOrUpdate: state.knowState.folderCurrent.id == null,
        name: state.knowState.folderCurrent.name,
        description: state.knowState.folderCurrent.description,
        onCreate: (String name, String description) {
          dispatch(CreateFolderSyncKnowAction(
            name: name,
            description: description,
          ));
          dispatch(NavigateAction.pop());
        },
        onUpdate: (String name, String description, bool isDelete) {
          dispatch(UpdateFolderSyncKnowAction(
            name: name,
            description: description,
            isDelete: isDelete,
          ));
          dispatch(NavigateAction.pop());
        },
      );
}

class FolderEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      builder: (context, viewModel) => FolderEditDS(
        isAddOrUpdate: viewModel.isAddOrUpdate,
        name: viewModel.name,
        description: viewModel.description,
        onCreate: viewModel.onCreate,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
