import 'package:aiprof/actions/exame_action.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/exame/exame_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  List<ExameModel> exameList;
  Function(String) onEditExameCurrent;
  Function(String) onQuestionList;
  Function(String) onStudentList;
  ViewModel();
  ViewModel.build({
    @required this.exameList,
    @required this.onEditExameCurrent,
    @required this.onQuestionList,
    @required this.onStudentList,
  }) : super(equals: [
          exameList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        exameList: state.exameState.exameList,
        onEditExameCurrent: (String id) {
          dispatch(SetExameCurrentSyncExameAction(id));
          dispatch(NavigateAction.pushNamed(Routes.exameEdit));
        },
        onQuestionList: (String id) {
          dispatch(SetExameCurrentSyncExameAction(id));
          dispatch(NavigateAction.pushNamed(Routes.questionList));
        },
        onStudentList: (String id) {
          dispatch(SetExameCurrentSyncExameAction(id));
          dispatch(NavigateAction.pushNamed(Routes.questionStudentSelect));
        },
      );
}

class ExameList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) => store.dispatch(StreamColExameAsyncExameAction()),
      builder: (context, viewModel) => ExameListDS(
        exameList: viewModel.exameList,
        onEditExameCurrent: viewModel.onEditExameCurrent,
        onQuestionList: viewModel.onQuestionList,
        onStudentList: viewModel.onStudentList,
      ),
    );
  }
}
