import 'package:aiprof/user/user_model.dart';
import 'package:flutter/material.dart';

class StudentListUI extends StatefulWidget {
  final List<UserModel> studentList;
  final Function() onAddStudent;
  final Function(String) onRemoveStudent;
  final Function(String) onStudentTaskList;

  const StudentListUI({
    Key key,
    this.studentList,
    this.onAddStudent,
    this.onRemoveStudent,
    this.onStudentTaskList,
  }) : super(key: key);

  @override
  _StudentListUIState createState() => _StudentListUIState();
}

class _StudentListUIState extends State<StudentListUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudantes (${widget.studentList.length})'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: Center(
        child: Container(
          width: 600,
          child: ListView.builder(
            itemCount: widget.studentList.length,
            itemBuilder: (context, index) {
              final student = widget.studentList[index];
              return Card(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Tooltip(
                          message:
                              'Deleta este estudante desta avaliação e todas as suas tarefas nesta avaliação',
                          child: Icon(
                            Icons.delete,
                            size: 15,
                          ),
                        ),
                        onDoubleTap: () {
                          widget.onRemoveStudent(student.id);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: ListTile(
                        title: Text('${student.name}'),
                        subtitle: Text('${student.toString()}'),
                        trailing: IconButton(
                          tooltip: 'Listar as tarefas deste estudante',
                          icon: Icon(Icons.art_track_sharp),
                          onPressed: () {
                            widget.onStudentTaskList(student.id);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          widget.onAddStudent();
        },
      ),
    );
  }
}
