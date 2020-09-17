import 'package:flutter/material.dart';
import 'package:aiprof/conectors/components/logout_button.dart';
import 'package:aiprof/models/classroom_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassroomListDS extends StatelessWidget {
  final List<ClassroomModel> classroomList;
  final Function(String) onEditClassroomCurrent;
  final Function(String) onStudentList;

  const ClassroomListDS({
    Key key,
    this.classroomList,
    this.onEditClassroomCurrent,
    this.onStudentList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Turmas (${classroomList.length})'),
            actions: [
              LogoutButton(),
            ],
          ),
          body: ListView.builder(
            itemCount: classroomList.length,
            itemBuilder: (context, index) {
              final classroom = classroomList[index];
              return Card(
                color: !classroom.isActive
                    ? Colors.brown
                    : Theme.of(context).cardColor,
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 500,
                      child: ListTile(
                        title: Text('${classroom.name}'),
                        subtitle: Text('${classroom.toString()}'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        onEditClassroomCurrent(classroom.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.link),
                      onPressed: () async {
                        if (classroom?.urlProgram != null) {
                          if (await canLaunch(classroom.urlProgram)) {
                            await launch(classroom.urlProgram);
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.people),
                      onPressed: () async {
                        onStudentList(classroom.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.today),
                      onPressed: () async {
                        // onStudentList(classroom.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.report_problem),
                      onPressed: () async {
                        // onStudentList(classroom.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.folder_open),
                      onPressed: () async {
                        // onStudentList(classroom.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.assignment),
                      onPressed: () async {
                        // onStudentList(classroom.id);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              onEditClassroomCurrent(null);
            },
          ),
        ),
      ],
    );
  }
}
