import 'package:aiprof/actions/task_action.dart';
import 'package:aiprof/models/task_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/task/task_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  List<TaskModel> taskList;
  ViewModel();
  ViewModel.build({
    @required this.taskList,
  }) : super(equals: [
          taskList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        taskList: state.taskState.taskList,
      );
}

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) => store.dispatch(GetDocsTaskListAsyncTaskAction()),
      builder: (context, viewModel) => TaskListDS(
        taskList: viewModel.taskList,
      ),
    );
  }
}
