import 'package:aiprof/actions/problem_action.dart';
import 'package:aiprof/models/problem_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/problem/problem_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  List<ProblemModel> problemList;
  Function(String) onEditProblemCurrent;
  ViewModel();
  ViewModel.build({
    @required this.problemList,
    @required this.onEditProblemCurrent,
  }) : super(equals: [
          problemList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        problemList: state.problemState.problemList,
        onEditProblemCurrent: (String id) {
          dispatch(SetProblemCurrentSyncProblemAction(id));
          dispatch(NavigateAction.pushNamed(Routes.problemEdit));
        },
      );
}

class ProblemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) => store.dispatch(GetDocsProblemListAsyncProblemAction()),
      builder: (context, viewModel) => ProblemListDS(
        problemList: viewModel.problemList,
        onEditProblemCurrent: viewModel.onEditProblemCurrent,
      ),
    );
  }
}
