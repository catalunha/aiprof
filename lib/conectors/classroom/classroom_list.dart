import 'package:aiprof/actions/classroom_action.dart';
import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/classroom/classroom_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  List<ClassroomModel> classroomList;
  Function(String) onEditClassroomCurrent;
  Function(String) onStudentList;
  ViewModel();
  ViewModel.build({
    @required this.classroomList,
    @required this.onEditClassroomCurrent,
    @required this.onStudentList,
  }) : super(equals: [
          classroomList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        classroomList: state.classroomState.classroomList,
        onEditClassroomCurrent: (String id) {
          dispatch(SetClassroomCurrentSyncClassroomAction(id));
          dispatch(NavigateAction.pushNamed(Routes.classroomEdit));
        },
        onStudentList: (String id) {
          dispatch(SetClassroomCurrentSyncClassroomAction(id));
          dispatch(NavigateAction.pushNamed(Routes.studentList));
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
        classroomList: viewModel.classroomList,
        onEditClassroomCurrent: viewModel.onEditClassroomCurrent,
        onStudentList: viewModel.onStudentList,
      ),
    );
  }
}
