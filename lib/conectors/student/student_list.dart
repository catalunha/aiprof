import 'package:aiprof/actions/student_action.dart';
import 'package:aiprof/uis/student/student_list_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';

class ViewModel extends BaseModel<AppState> {
  List<UserModel> studentList;
  Function() onAddStudent;
  Function(String) onRemoveStudent;
  ViewModel();
  ViewModel.build({
    @required this.studentList,
    @required this.onAddStudent,
    @required this.onRemoveStudent,
  }) : super(equals: [
          studentList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        studentList: state.studentState.studentList,
        onAddStudent: () {
          dispatch(NavigateAction.pushNamed(Routes.studentEdit));
        },
        onRemoveStudent: (String studentId) {
          dispatch(RemoveStudentForClassroomAsyncStudentAction(studentId));
        },
      );
}

class StudentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) => store.dispatch(GetDocsStudentListAsyncStudentAction()),
      builder: (context, viewModel) => StudentListDS(
        studentList: viewModel.studentList,
        onAddStudent: viewModel.onAddStudent,
        onRemoveStudent: viewModel.onRemoveStudent,
      ),
    );
  }
}
