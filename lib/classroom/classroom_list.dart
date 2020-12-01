import 'package:aiprof/app_state.dart';
import 'package:aiprof/classroom/classroom_action.dart';
import 'package:aiprof/classroom/classroom_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/uis/classroom/classroom_list_ui.dart';
import 'package:aiprof/user/user_model.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final UserModel userLogged;
  final List<ClassroomModel> classroomList;
  final Function(String) onEditClassroomCurrent;
  final Function(String) onStudentList;
  final Function(String) onExameList;
  final Function(int, int) onChangeClassroomListOrder;
  ViewModel({
    @required this.userLogged,
    @required this.classroomList,
    @required this.onEditClassroomCurrent,
    @required this.onStudentList,
    @required this.onExameList,
    @required this.onChangeClassroomListOrder,
  }) : super(equals: [
          userLogged,
          classroomList,
        ]);
}

class Factory extends VmFactory<AppState, ClassroomList> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        userLogged: state.loggedState.userModelLogged,
        classroomList: state.classroomState.classroomList,
        onEditClassroomCurrent: (String id) {
          dispatch(SetClassroomCurrentSyncClassroomAction(id));
          dispatch(NavigateAction.pushNamed(Routes.classroomEdit));
        },
        onStudentList: (String id) {
          dispatch(SetClassroomCurrentSyncClassroomAction(id));
          dispatch(NavigateAction.pushNamed(Routes.studentList));
        },
        onExameList: (String id) {
          dispatch(SetClassroomCurrentSyncClassroomAction(id));
          dispatch(NavigateAction.pushNamed(Routes.exameList));
        },
        onChangeClassroomListOrder: (int oldIndex, int newIndex) {
          dispatch(ChangeClassroomListOrderAsyncClassroomAction(
            oldIndex: oldIndex,
            newIndex: newIndex,
          ));
        },
      );
}

class ClassroomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      onInit: (store) =>
          store.dispatch(ReadyDocsClassroomListAsyncClassroomAction()),
      builder: (context, viewModel) => ClassroomListUI(
        userLogged: viewModel.userLogged,
        classroomList: viewModel.classroomList,
        onEditClassroomCurrent: viewModel.onEditClassroomCurrent,
        onStudentList: viewModel.onStudentList,
        onExameList: viewModel.onExameList,
        onChangeClassroomListOrder: viewModel.onChangeClassroomListOrder,
      ),
    );
  }
}
