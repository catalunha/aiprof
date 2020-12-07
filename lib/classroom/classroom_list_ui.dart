import 'package:aiprof/login/logout_button.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:aiprof/classroom/classroom_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassroomListUI extends StatefulWidget {
  final UserModel userLogged;
  final List<ClassroomModel> classroomList;
  final Function(String) onEditClassroomCurrent;
  final Function(String) onStudentList;
  final Function(String) onExameList;

  final Function(int oldIndex, int newIndex) onChangeClassroomListOrder;

  const ClassroomListUI({
    Key key,
    this.classroomList,
    this.onEditClassroomCurrent,
    this.onStudentList,
    this.onExameList,
    this.onChangeClassroomListOrder,
    this.userLogged,
  }) : super(key: key);

  @override
  _ClassroomListUIState createState() => _ClassroomListUIState();
}

class _ClassroomListUIState extends State<ClassroomListUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Olá ${widget.userLogged.name.split(' ')[0]}. Vc tem ${widget.classroomList.length} turma(s).'),
        actions: [
          IconButton(
              icon: Icon(Icons.line_style),
              onPressed: () => Navigator.pushNamed(context, Routes.knowList)),
          LogoutButton(),
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
          color: classroom?.isActive != null && !classroom.isActive
              ? Colors.brown
              : Theme.of(context).cardColor,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              Container(
                width: 400,
                child: ListTile(
                  title: Text('${classroom?.name}'),
                  subtitle: Text('${classroom?.toString()}'),
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
