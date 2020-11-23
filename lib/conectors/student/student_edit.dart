import 'package:aiprof/actions/student_action.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/student/student_edit_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final Function(String) onAdd;
  ViewModel({
    @required this.onAdd,
  }) : super(equals: []);
}

class Factory extends VmFactory<AppState, StudentEdit> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
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
      vm: Factory(this),
      builder: (context, viewModel) => StudentEditDS(
        onAdd: viewModel.onAdd,
      ),
    );
  }
}
