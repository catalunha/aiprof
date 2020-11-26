import 'package:aiprof/app_state.dart';
import 'package:aiprof/student/student_action.dart';
import 'package:aiprof/student/student_list_ui.dart';
import 'package:aiprof/task/task_action.dart';
import 'package:aiprof/task/task_enum.dart';
import 'package:aiprof/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aiprof/routes.dart';

class ViewModel extends Vm {
  final List<UserModel> studentList;
  final Function() onAddStudent;
  final Function(String) onRemoveStudent;
  final Function(String) onStudentTaskList;
  ViewModel({
    @required this.studentList,
    @required this.onAddStudent,
    @required this.onRemoveStudent,
    @required this.onStudentTaskList,
  }) : super(equals: [
          studentList,
        ]);
}

class Factory extends VmFactory<AppState, StudentList> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        studentList: state.studentState.studentList,
        onAddStudent: () {
          dispatch(NavigateAction.pushNamed(Routes.studentEdit));
        },
        onRemoveStudent: (String studentId) {
          dispatch(RemoveStudentForClassroomAsyncStudentAction(studentId));
        },
        onStudentTaskList: (String studentIdSelected) {
          dispatch(
              SetTaskFilterSyncTaskAction(TaskFilter.whereClassroomAndStudent));
          dispatch(SetStudentCurrentSyncStudentAction(studentIdSelected));
          dispatch(NavigateAction.pushNamed(Routes.taskList));
        },
      );
}

class StudentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      onInit: (store) => store.dispatch(GetDocsStudentListAsyncStudentAction()),
      builder: (context, viewModel) => StudentListUI(
        studentList: viewModel.studentList,
        onAddStudent: viewModel.onAddStudent,
        onRemoveStudent: viewModel.onRemoveStudent,
        onStudentTaskList: viewModel.onStudentTaskList,
      ),
    );
  }
}
