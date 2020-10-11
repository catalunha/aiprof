import 'package:aiprof/actions/classroom_action.dart';
import 'package:aiprof/actions/student_action.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/student/student_edit_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  Function(String) onAdd;
  ViewModel();
  ViewModel.build({
    @required this.onAdd,
  }) : super(equals: []);
  @override
  ViewModel fromStore() => ViewModel.build(
        onAdd: (String studentsToImport) {
          // dispatch(BatchDocImportStudentAsyncStudentAction(
          //     studentsToImport: studentsToImport));
          dispatch(UpdateStudentMapTempAsyncStudentAction(
              studentListString: studentsToImport));
          dispatch(NavigateAction.pop());
          dispatch(NavigateAction.pop());
        },
      );
}

class StudentEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      builder: (context, viewModel) => StudentEditDS(
        onAdd: viewModel.onAdd,
      ),
    );
  }
}
