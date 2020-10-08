import 'package:aiprof/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskListDS extends StatefulWidget {
  final List<TaskModel> taskList;

  const TaskListDS({
    Key key,
    this.taskList,
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
          final exame = widget.taskList[index];
          return Card(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Container(
                  width: 500,
                  child: ListTile(
                    selected: exame.open,
                    title: Text('${exame.id}'),
                    subtitle: Text('${exame.toString()}'),
                  ),
                ),
                IconButton(
                  tooltip: 'Editar esta avaliação',
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    // widget.onEditExameCurrent(exame.id);
                  },
                ),
                IconButton(
                  tooltip: 'Lista de questões',
                  icon: Icon(Icons.format_list_numbered),
                  onPressed: () async {
                    // widget.onQuestionList(exame.id);
                  },
                ),
                IconButton(
                  tooltip: 'Lista de estudantes',
                  icon: Icon(Icons.person),
                  onPressed: () async {
                    // widget.onStudentList(exame.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
