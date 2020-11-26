import 'package:aiprof/app_state.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/task/task_action.dart';
import 'package:aiprof/uis/task/task_list_ui.dart';
import 'package:aiprof/task/task_model.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final List<TaskModel> taskList;
  final int nota;
  final String csv;
  final Function(String) onEditTaskCurrent;
  final Function(String, String, bool) onUpdateOutput;

  ViewModel({
    @required this.taskList,
    @required this.nota,
    @required this.csv,
    @required this.onEditTaskCurrent,
    @required this.onUpdateOutput,
  }) : super(equals: [
          taskList,
          nota,
          csv,
        ]);
}

class Factory extends VmFactory<AppState, TaskList> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        taskList: state.taskState.taskList,
        nota: _nota(state.taskState.taskList),
        csv: _csv(state.taskState.taskList),
        onEditTaskCurrent: (String id) {
          dispatch(SetTaskCurrentSyncTaskAction(id));
          dispatch(NavigateAction.pushNamed(Routes.taskEdit));
        },
        onUpdateOutput: (String taskId, String outputId, bool isTruOrFalse) {
          dispatch(UpdateOutputAsyncTaskAction(
              taskId: taskId,
              taskSimulationOutputId: outputId,
              isTruOrFalse: isTruOrFalse));
        },
      );

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

  String _csv(List<TaskModel> _taskList) {
    String _csv =
        'Turma,Exame,Questão,Situação,Estudante,Nota Exame,Nota Questão,RespostasConferem,RespostasTotal' +
            '\n';
    int _notaOutput;
    for (var task in _taskList) {
      _notaOutput = 0;
      for (var output in task.simulationOutput.values) {
        if (output?.right != null && output.right) {
          _notaOutput++;
        }
      }
      _csv = _csv +
          '${task.classroomRef.name},${task.exameRef.name},${task.questionRef.name},${task.situationRef.name},${task.studentUserRef.name},${task.scoreExame},${task.scoreQuestion},$_notaOutput,${task.simulationOutput.length}' +
          '\n';
    }
    return _csv;
  }
}

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      onInit: (store) => store.dispatch(StreamColTaskAsyncTaskAction()),
      builder: (context, viewModel) => TaskListUI(
        taskList: viewModel.taskList,
        nota: viewModel.nota,
        csv: viewModel.csv,
        onEditTaskCurrent: viewModel.onEditTaskCurrent,
        onUpdateOutput: viewModel.onUpdateOutput,
      ),
    );
  }
}
