import 'package:aiprof/actions/question_action.dart';
import 'package:aiprof/models/question_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/question/question_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  List<QuestionModel> questionList;
  Function(String) onEditQuestionCurrent;
  ViewModel();
  ViewModel.build({
    @required this.questionList,
    @required this.onEditQuestionCurrent,
  }) : super(equals: [
          questionList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        questionList: state.questionState.questionList,
        onEditQuestionCurrent: (String id) {
          dispatch(SetQuestionCurrentSyncQuestionAction(id));
          dispatch(NavigateAction.pushNamed(Routes.questionEdit));
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
        questionList: viewModel.questionList,
        onEditQuestionCurrent: viewModel.onEditQuestionCurrent,
      ),
    );
  }
}
