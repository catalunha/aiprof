import 'package:aiprof/actions/question_action.dart';
import 'package:aiprof/actions/student_action.dart';
import 'package:aiprof/actions/task_action.dart';
import 'package:aiprof/models/question_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:aiprof/uis/student/student_select_toquestion_ds.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';

class ViewModel extends Vm {
  final bool waiting;
  final List<UserModel> studentList;
  final QuestionModel questionCurrent;
  final Function(UserModel, bool) onSetStudentInExameCurrent;
  final Function(String) onSetStudentSelected;
  final Function(String) onDeleteStudentInExameCurrent;
  final Function(bool) onSetStudentListInExameCurrent;
  ViewModel({
    @required this.waiting,
    @required this.studentList,
    @required this.questionCurrent,
    @required this.onSetStudentInExameCurrent,
    @required this.onSetStudentSelected,
    @required this.onDeleteStudentInExameCurrent,
    @required this.onSetStudentListInExameCurrent,
  }) : super(equals: [
          waiting,
          studentList,
          questionCurrent,
        ]);
}

class Factory extends VmFactory<AppState, StudentSelectToQuestion> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        waiting: state.wait.isWaiting,
        studentList: state.studentState.studentList,
        questionCurrent: state.questionState.questionCurrent,
        onSetStudentInExameCurrent:
            (UserModel studentModel, bool isAddOrRemove) {
          // print('id:${studentModel.id} isAddOrRemove:$isAddOrRemove');
          dispatch(UpdateDocSetStudentInQuestionCurrentAsyncQuestionAction(
            studentModel: studentModel,
            isAddOrRemove: isAddOrRemove,
          ));
        },
        onSetStudentListInExameCurrent: (bool isAddOrRemove) {
          dispatch(UpdateDocsSetStudentListInQuestionCurrentAsyncQuestionAction(
            isAddOrRemove: isAddOrRemove,
          ));
        },
        onDeleteStudentInExameCurrent: (String studentId) {
          dispatch(DeleteStudentInQuestionCurrentAndTaskAsyncQuestionAction(
              studentId));
        },
        onSetStudentSelected: (String studentIdSelected) {
          dispatch(
              SetTaskFilterSyncTaskAction(TaskFilter.whereQuestionAndStudent));
          dispatch(SetStudentCurrentSyncStudentAction(studentIdSelected));
          dispatch(NavigateAction.pushNamed(Routes.taskList));
        },
      );
}

class StudentSelectToQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      onInit: (store) => store.dispatch(GetDocsStudentListAsyncStudentAction()),
      builder: (context, viewModel) => StudentSelectToQuestionDS(
        waiting: viewModel.waiting,
        studentList: viewModel.studentList,
        questionCurrent: viewModel.questionCurrent,
        onSetStudentInExameCurrent: viewModel.onSetStudentInExameCurrent,
        onSetStudentSelected: viewModel.onSetStudentSelected,
        onDeleteStudentInExameCurrent: viewModel.onDeleteStudentInExameCurrent,
        onSetStudentListInExameCurrent:
            viewModel.onSetStudentListInExameCurrent,
      ),
    );
  }
}
