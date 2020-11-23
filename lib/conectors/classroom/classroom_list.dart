import 'package:aiprof/actions/classroom_action.dart';
import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/classroom/classroom_list_ds.dart';
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
    // @required this.onSituationList,
    // @required this.onKnowList,
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
        // onSituationList: () {
        //   dispatch(NavigateAction.pushNamed(Routes.situationList));
        // },
        // onKnowList: () {
        //   dispatch(NavigateAction.pushNamed(Routes.knowList));
        // },
        onChangeClassroomListOrder: (int oldIndex, int newIndex) {
          dispatch(UpdateDocclassroomIdInUserAsyncClassroomAction(
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
          store.dispatch(StreamColClassroomAsyncClassroomAction()),
      builder: (context, viewModel) => ClassroomListDS(
        userLogged: viewModel.userLogged,
        classroomList: viewModel.classroomList,
        onEditClassroomCurrent: viewModel.onEditClassroomCurrent,
        onStudentList: viewModel.onStudentList,
        onExameList: viewModel.onExameList,
        // onKnowList: viewModel.onKnowList,
        // onSituationList: viewModel.onSituationList,
        onChangeClassroomListOrder: viewModel.onChangeClassroomListOrder,
      ),
    );
  }
}
