import 'package:aiprof/actions/classroom_action.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/classroom/classroom_edit_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  String company;
  String component;
  String name;
  String description;
  String urlProgram;
  bool isActive;
  bool isAddOrUpdate;
  Function(String, String, String, String, String) onAdd;
  Function(String, String, String, String, String, bool, bool) onUpdate;
  ViewModel();
  ViewModel.build({
    @required this.company,
    @required this.component,
    @required this.name,
    @required this.description,
    @required this.urlProgram,
    @required this.isActive,
    @required this.isAddOrUpdate,
    @required this.onAdd,
    @required this.onUpdate,
  }) : super(equals: [
          company,
          component,
          name,
          description,
          urlProgram,
          isActive,
          isAddOrUpdate,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        isAddOrUpdate: state.classroomState.classroomCurrent.id == null,
        company: state.classroomState.classroomCurrent.company,
        component: state.classroomState.classroomCurrent.component,
        name: state.classroomState.classroomCurrent.name,
        description: state.classroomState.classroomCurrent.description,
        urlProgram: state.classroomState.classroomCurrent.urlProgram,
        isActive: state.classroomState.classroomCurrent?.isActive ?? false,
        onAdd: (
          String company,
          String component,
          String name,
          String description,
          String urlProgram,
        ) {
          dispatch(AddDocClassroomCurrentAsyncClassroomAction(
            company: company,
            component: component,
            name: name,
            description: description,
            urlProgram: urlProgram,
          ));
          dispatch(NavigateAction.pop());
        },
        onUpdate: (String company,
            String component,
            String name,
            String description,
            String urlProgram,
            bool isActive,
            bool isDelete) {
          dispatch(UpdateDocClassroomCurrentAsyncClassroomAction(
            company: company,
            component: component,
            name: name,
            description: description,
            urlProgram: urlProgram,
            isActive: isActive,
            isDelete: isDelete,
          ));
          dispatch(NavigateAction.pop());
        },
      );
}

class ClassroomEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      builder: (context, viewModel) => ClassroomEditDS(
        isAddOrUpdate: viewModel.isAddOrUpdate,
        company: viewModel.company,
        component: viewModel.component,
        name: viewModel.name,
        description: viewModel.description,
        urlProgram: viewModel.urlProgram,
        isActive: viewModel.isActive,
        onAdd: viewModel.onAdd,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
