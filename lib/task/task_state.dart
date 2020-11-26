import 'package:aiprof/task/task_enum.dart';
import 'package:aiprof/task/task_model.dart';
import 'package:meta/meta.dart';

@immutable
class TaskState {
  final TaskFilter taskFilter;
  final List<TaskModel> taskList;
  final TaskModel taskCurrent;
  TaskState({
    this.taskFilter,
    this.taskList,
    this.taskCurrent,
  });
  factory TaskState.initialState() => TaskState(
        taskFilter: TaskFilter.isActive,
        taskList: <TaskModel>[],
        taskCurrent: null,
      );
  TaskState copyWith({
    TaskFilter taskFilter,
    List<TaskModel> taskList,
    TaskModel taskCurrent,
  }) =>
      TaskState(
        taskFilter: taskFilter ?? this.taskFilter,
        taskList: taskList ?? this.taskList,
        taskCurrent: taskCurrent ?? this.taskCurrent,
      );
  @override
  int get hashCode =>
      taskFilter.hashCode ^ taskList.hashCode ^ taskCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskState &&
          taskFilter == other.taskFilter &&
          taskList == other.taskList &&
          taskCurrent == other.taskCurrent &&
          runtimeType == other.runtimeType;
}
