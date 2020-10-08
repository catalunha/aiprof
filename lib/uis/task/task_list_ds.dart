import 'package:aiprof/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskListDS extends StatefulWidget {
  final List<TaskModel> taskList;
  final Function(String) onEditTaskCurrent;

  const TaskListDS({
    Key key,
    this.taskList,
    this.onEditTaskCurrent,
  }) : super(key: key);

  @override
  _TaskListDSState createState() => _TaskListDSState();
}

class _TaskListDSState extends State<TaskListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#Task Tarefas (${widget.taskList.length})'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.taskList.length,
        itemBuilder: (context, index) {
          final task = widget.taskList[index];
          return Card(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Container(
                  width: 500,
                  child: ListTile(
                    selected: task.open,
                    title: Text('${task.id}'),
                    subtitle: Text('${task.toString()}'),
                    trailing: IconButton(
                      tooltip: 'Editar esta tarefa',
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        widget.onEditTaskCurrent(task.id);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
