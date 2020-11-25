import 'package:async_redux/async_redux.dart';
import 'package:aiprof/classroom/classroom_action.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/classroom/classroom_edit_ds.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final String company;
  final String component;
  final String name;
  final String description;
  final String urlProgram;
  final bool isActive;
  final bool isAddOrUpdate;
  final Function(String, String, String, String, String) onAdd;
  final Function(String, String, String, String, String, bool, bool) onUpdate;
  ViewModel({
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
}

class Factory extends VmFactory<AppState, ClassroomEdit> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
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
          dispatch(CreateDocClassroomCurrentAsyncClassroomAction(
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
          if (isDelete) {
            dispatch(DeleteDocClassroomCurrentAsyncClassroomAction(
                id: state.classroomState.classroomCurrent.id));
          } else {
            dispatch(UpdateDocClassroomCurrentAsyncClassroomAction(
              company: company,
              component: component,
              name: name,
              description: description,
              urlProgram: urlProgram,
              isActive: isActive,
            ));
          }

          dispatch(NavigateAction.pop());
        },
      );
}

class ClassroomEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
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
