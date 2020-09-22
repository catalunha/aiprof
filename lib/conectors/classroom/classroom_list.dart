import 'package:aiprof/actions/classroom_action.dart';
import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/classroom/classroom_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  UserModel userLogged;
  List<ClassroomModel> classroomList;
  Function(String) onEditClassroomCurrent;
  Function(String) onStudentList;
  Function() onSituationList;
  Function(int, int) onChangeClassroomListOrder;
  ViewModel();
  ViewModel.build({
    @required this.userLogged,
    @required this.classroomList,
    @required this.onEditClassroomCurrent,
    @required this.onStudentList,
    @required this.onSituationList,
    @required this.onChangeClassroomListOrder,
  }) : super(equals: [
          userLogged,
          classroomList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
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
        onSituationList: () {
          dispatch(NavigateAction.pushNamed(Routes.situationList));
        },
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
      model: ViewModel(),
      onInit: (store) =>
          store.dispatch(GetDocsClassroomListAsyncClassroomAction()),
      builder: (context, viewModel) => ClassroomListDS(
        userLogged: viewModel.userLogged,
        classroomList: viewModel.classroomList,
        onEditClassroomCurrent: viewModel.onEditClassroomCurrent,
        onStudentList: viewModel.onStudentList,
        onSituationList: viewModel.onSituationList,
        onChangeClassroomListOrder: viewModel.onChangeClassroomListOrder,
      ),
    );
  }
}
