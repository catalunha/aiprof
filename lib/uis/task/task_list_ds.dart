import 'package:aiprof/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskListDS extends StatefulWidget {
  final List<TaskModel> taskList;
  final int nota;
  final Function(String) onEditTaskCurrent;

  const TaskListDS({
    Key key,
    this.taskList,
    this.onEditTaskCurrent,
    this.nota,
  }) : super(key: key);

  @override
  _TaskListDSState createState() => _TaskListDSState();
}

class _TaskListDSState extends State<TaskListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas ${widget.taskList.length}. Nota: ${widget.nota}'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.taskList.length,
        itemBuilder: (context, index) {
          final task = widget.taskList[index];
          return Card(
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: ListTile(
                    selected: task?.isOpen != null ? task.isOpen : false,
                    title: Text('${task.id}'),
                    subtitle: Text('${task.toString()}'),
                    // trailing: IconButton(
                    //   tooltip: 'Editar esta tarefa',
                    //   icon: Icon(Icons.edit),
                    //   onPressed: () async {
                    //     widget.onEditTaskCurrent(task.id);
                    //   },
                    // ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      IconButton(
                        tooltip: 'Editar esta tarefa',
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          widget.onEditTaskCurrent(task.id);
                        },
                      ),
                      IconButton(
                        tooltip: 'Editar esta tarefa',
                        icon: Icon(Icons.local_library),
                        onPressed: () async {
                          if (task?.situationRef?.url != null) {
                            if (await canLaunch(task?.situationRef?.url)) {
                              await launch(task?.situationRef?.url);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
