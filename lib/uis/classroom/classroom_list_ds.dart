import 'package:aiprof/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:aiprof/conectors/components/logout_button.dart';
import 'package:aiprof/models/classroom_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassroomListDS extends StatefulWidget {
  final UserModel userLogged;
  final List<ClassroomModel> classroomList;
  final Function(String) onEditClassroomCurrent;
  final Function(String) onStudentList;
  final Function(String) onExameList;
  // final Function() onSituationList;
  // final Function() onKnowList;
  final Function(int oldIndex, int newIndex) onChangeClassroomListOrder;

  const ClassroomListDS({
    Key key,
    this.classroomList,
    this.onEditClassroomCurrent,
    this.onStudentList,
    this.onExameList,
    this.onChangeClassroomListOrder,
    this.userLogged,
    // this.onSituationList,
    // this.onKnowList,
  }) : super(key: key);

  @override
  _ClassroomListDSState createState() => _ClassroomListDSState();
}

class _ClassroomListDSState extends State<ClassroomListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#Classroom Turma (${widget.classroomList.length})'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              scrollDirection: Axis.vertical,
              children: buildItens(),
              onReorder: _onReorder,
            ),
          ),
        ],
      ),
      // body: ListView.builder(
      //   itemCount: widget.classroomList.length,
      //   itemBuilder: (context, index) {
      //     final classroom = widget.classroomList[index];
      //     return Card(
      //       color: !classroom.isActive
      //           ? Colors.brown
      //           : Theme.of(context).cardColor,
      //       child: Wrap(
      //         alignment: WrapAlignment.spaceEvenly,
      //         children: [
      //           Container(
      //             width: 500,
      //             child: ListTile(
      //               title: Text('${classroom.name}'),
      //               subtitle: Text('${classroom.toString()}'),
      //             ),
      //           ),
      //           IconButton(
      //             icon: Icon(Icons.edit),
      //             onPressed: () async {
      //               widget.onEditClassroomCurrent(classroom.id);
      //             },
      //           ),
      //           IconButton(
      //             icon: Icon(Icons.link),
      //             onPressed: () async {
      //               if (classroom?.urlProgram != null) {
      //                 if (await canLaunch(classroom.urlProgram)) {
      //                   await launch(classroom.urlProgram);
      //                 }
      //               }
      //             },
      //           ),
      //           IconButton(
      //             icon: Icon(Icons.people),
      //             onPressed: () async {
      //               widget.onStudentList(classroom.id);
      //             },
      //           ),
      //           IconButton(
      //             icon: Icon(Icons.today),
      //             onPressed: () async {
      //               // onStudentList(classroom.id);
      //             },
      //           ),
      //           IconButton(
      //             icon: Icon(Icons.report_situation),
      //             onPressed: () async {
      //               // onStudentList(classroom.id);
      //             },
      //           ),
      //           IconButton(
      //             icon: Icon(Icons.folder_open),
      //             onPressed: () async {
      //               // onStudentList(classroom.id);
      //             },
      //           ),
      //           IconButton(
      //             icon: Icon(Icons.assignment),
      //             onPressed: () async {
      //               // onStudentList(classroom.id);
      //             },
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          widget.onEditClassroomCurrent(null);
        },
      ),
    );
  }

  buildItens() {
    List<Widget> list = [];
    for (var classroom in widget.classroomList) {
      list.add(
        Card(
          key: ValueKey(classroom),
          color:
              !classroom.isActive ? Colors.brown : Theme.of(context).cardColor,
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
                  widget.onEditClassroomCurrent(classroom.id);
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
                tooltip: 'Listar estudantes',
                icon: Icon(Icons.people),
                onPressed: () async {
                  widget.onStudentList(classroom.id);
                },
              ),
              IconButton(
                tooltip: 'Listar avaliações',
                icon: Icon(Icons.assignment),
                onPressed: () async {
                  widget.onExameList(classroom.id);
                },
              ),
              // IconButton(
              //   tooltip: 'Lista de Situaçãos',
              //   icon: Icon(Icons.help),
              //   onPressed: () async {
              //     widget.onSituationList();
              //   },
              // ),
              // IconButton(
              //   icon: Icon(Icons.folder_open),
              //   onPressed: () async {
              //     widget.onKnowList();
              //   },
              // ),
              // IconButton(
              //   icon: Icon(Icons.assignment),
              //   onPressed: () async {
              //     // onStudentList(classroom.id);
              //   },
              // ),
            ],
          ),
        ),
      );
    }
    return list;
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      ClassroomModel todo = widget.classroomList[oldIndex];
      widget.classroomList.removeAt(oldIndex);
      widget.classroomList.insert(newIndex, todo);
    });
    widget.onChangeClassroomListOrder(oldIndex, newIndex);
  }
}
