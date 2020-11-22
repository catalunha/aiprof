import 'package:aiprof/actions/question_action.dart';
import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/models/question_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/question/question_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  ClassroomModel classroomRef;
  ExameModel exameRef;
  List<QuestionModel> questionList;
  Function(String) onEditQuestionCurrent;
  Function(String) onStudentList;
  Function(int, int) onChangeOrderQuestionList;

  ViewModel();
  ViewModel.build({
    @required this.classroomRef,
    @required this.exameRef,
    @required this.questionList,
    @required this.onEditQuestionCurrent,
    @required this.onStudentList,
    @required this.onChangeOrderQuestionList,
  }) : super(equals: [
          classroomRef,
          exameRef,
          questionList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        classroomRef: state.exameState.exameCurrent.classroomRef,
        exameRef: state.exameState.exameCurrent,
        questionList: state.questionState.questionList,
        onEditQuestionCurrent: (String id) {
          dispatch(SetQuestionCurrentSyncQuestionAction(id));
          dispatch(NavigateAction.pushNamed(Routes.questionEdit));
        },
        onStudentList: (String id) {
          dispatch(SetQuestionCurrentSyncQuestionAction(id));
          dispatch(NavigateAction.pushNamed(Routes.questionStudentSelect));
        },
        onChangeOrderQuestionList: (int oldIndex, int newIndex) {
          dispatch(UpdateOrderQuestionListAsyncQuestionAction(
            oldIndex: oldIndex,
            newIndex: newIndex,
          ));
        },
      );
}

class QuestionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) => store.dispatch(StreamColQuestionAsyncQuestionAction()),
      builder: (context, viewModel) => QuestionListDS(
        classroomRef: viewModel.classroomRef,
        exameRef: viewModel.exameRef,
        questionList: viewModel.questionList,
        onEditQuestionCurrent: viewModel.onEditQuestionCurrent,
        onStudentList: viewModel.onStudentList,
        onChangeOrderQuestionList: viewModel.onChangeOrderQuestionList,
      ),
    );
  }
}
