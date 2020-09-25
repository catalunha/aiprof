import 'package:aiprof/actions/exame_action.dart';
import 'package:aiprof/actions/student_action.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/uis/student/student_select_toexame_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';

class ViewModel extends BaseModel<AppState> {
  bool waiting;
  List<UserModel> studentList;
  ExameModel exameCurrent;
  Function(UserModel, bool) onSetStudentInExameCurrent;
  Function(bool) onSetStudentListInExameCurrent;
  ViewModel();
  ViewModel.build({
    @required this.waiting,
    @required this.studentList,
    @required this.exameCurrent,
    @required this.onSetStudentInExameCurrent,
    @required this.onSetStudentListInExameCurrent,
  }) : super(equals: [
          waiting,
          studentList,
          exameCurrent,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        waiting: state.wait.isWaiting,
        studentList: state.studentState.studentList,
        exameCurrent: state.exameState.exameCurrent,
        onSetStudentInExameCurrent:
            (UserModel studentModel, bool isAddOrRemove) {
          print('id:${studentModel.id} isAddOrRemove:$isAddOrRemove');
          dispatch(UpdateDocSetStudentInExameCurrentAsyncExameAction(
            studentModel: studentModel,
            isAddOrRemove: isAddOrRemove,
          ));
        },
        onSetStudentListInExameCurrent: (bool isAddOrRemove) {
          dispatch(BatchDocsSetStudentListInExameCurrentAsyncExameAction(
            isAddOrRemove: isAddOrRemove,
          ));
        },
      );
}

class StudentSelectToExame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) => store.dispatch(GetDocsStudentListAsyncStudentAction()),
      builder: (context, viewModel) => StudentSelectToExameDS(
        waiting: viewModel.waiting,
        studentList: viewModel.studentList,
        exameCurrent: viewModel.exameCurrent,
        onSetStudentInExameCurrent: viewModel.onSetStudentInExameCurrent,
        onSetStudentListInExameCurrent:
            viewModel.onSetStudentListInExameCurrent,
      ),
    );
  }
}
