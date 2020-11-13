import 'package:aiprof/actions/task_action.dart';
import 'package:aiprof/models/task_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/task/task_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  List<TaskModel> taskList;
  int nota;
  Function(String) onEditTaskCurrent;

  ViewModel();
  ViewModel.build({
    @required this.taskList,
    @required this.nota,
    @required this.onEditTaskCurrent,
  }) : super(equals: [
          taskList,
        ]);
  int _nota(List<TaskModel> _taskList) {
    int _nota = 0;
    int _notaOutput;
    for (var task in _taskList) {
      _notaOutput = 0;
      for (var output in task.simulationOutput.values) {
        if (output?.right != null && output.right) {
          _notaOutput++;
        }
      }
      _nota = _nota + (task.scoreExame * task.scoreQuestion * _notaOutput);
    }
    return _nota;
  }

  @override
  ViewModel fromStore() => ViewModel.build(
        taskList: state.taskState.taskList,
        nota: _nota(state.taskState.taskList),
        onEditTaskCurrent: (String id) {
          dispatch(SetTaskCurrentSyncTaskAction(id));
          dispatch(NavigateAction.pushNamed(Routes.taskEdit));
        },
      );
}

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) => store.dispatch(StreamColTaskAsyncTaskAction()),
      builder: (context, viewModel) => TaskListDS(
        taskList: viewModel.taskList,
        nota: viewModel.nota,
        onEditTaskCurrent: viewModel.onEditTaskCurrent,
      ),
    );
  }
}
