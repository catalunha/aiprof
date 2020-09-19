import 'package:aiprof/actions/problem_action.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/problem/problem_edit_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  String area;
  String name;
  String description;
  String url;
  bool isActive;
  bool isAddOrUpdate;
  Function(String, String, String, String) onAdd;
  Function(String, String, String, String, bool) onUpdate;
  ViewModel();
  ViewModel.build({
    @required this.area,
    @required this.name,
    @required this.description,
    @required this.url,
    @required this.isActive,
    @required this.isAddOrUpdate,
    @required this.onAdd,
    @required this.onUpdate,
  }) : super(equals: [
          area,
          name,
          description,
          url,
          isActive,
          isAddOrUpdate,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        isAddOrUpdate: state.problemState.problemCurrent.id == null,
        area: state.problemState.problemCurrent.area,
        name: state.problemState.problemCurrent.name,
        description: state.problemState.problemCurrent.description,
        url: state.problemState.problemCurrent.url,
        isActive: state.problemState.problemCurrent?.isActive ?? false,
        onAdd: (
          String area,
          String name,
          String description,
          String url,
        ) {
          dispatch(AddDocProblemCurrentAsyncProblemAction(
            area: area,
            name: name,
            description: description,
            url: url,
          ));
          dispatch(NavigateAction.pop());
        },
        onUpdate: (
          String area,
          String name,
          String description,
          String url,
          bool isActive,
        ) {
          dispatch(UpdateDocProblemCurrentAsyncProblemAction(
            area: area,
            name: name,
            description: description,
            url: url,
            isActive: isActive,
          ));
          dispatch(NavigateAction.pop());
        },
      );
}

class ProblemEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      builder: (context, viewModel) => ProblemEditDS(
        isAddOrUpdate: viewModel.isAddOrUpdate,
        area: viewModel.area,
        name: viewModel.name,
        description: viewModel.description,
        url: viewModel.url,
        isActive: viewModel.isActive,
        onAdd: viewModel.onAdd,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
