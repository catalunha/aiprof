import 'package:aiprof/classroom/classroom_model.dart';
import 'package:aiprof/exame/exame_model.dart';
import 'package:flutter/material.dart';

class ExameListUI extends StatefulWidget {
  final ClassroomModel classroomRef;
  final List<ExameModel> exameList;
  final Function(String) onEditExameCurrent;
  final Function(String) onQuestionList;
  final Function(String) onStudentList;
  final Function(int oldIndex, int newIndex) onChangeOrderExameList;

  const ExameListUI({
    Key key,
    this.exameList,
    this.onEditExameCurrent,
    this.onQuestionList,
    this.onStudentList,
    this.classroomRef,
    this.onChangeOrderExameList,
  }) : super(key: key);

  @override
  _ExameListUIState createState() => _ExameListUIState();
}

class _ExameListUIState extends State<ExameListUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '/${widget.classroomRef.name}: com ${widget.exameList.length} exame(s).'),
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
      // body: Center(
      //   child: Container(
      //     width: 600,
      //     child: ListView.builder(
      //       itemCount: widget.exameList.length,
      //       itemBuilder: (context, index) {
      //         final exame = widget.exameList[index];
      //         return Card(
      //           child: Row(
      //             // alignment: WrapAlignment.spaceEvenly,
      //             children: [
      //               Expanded(
      //                 flex: 6,
      //                 child: ListTile(
      //                   title: Text('${exame.name}'),
      //                   subtitle: Text('${exame.toString()}'),
      //                 ),
      //               ),
      //               Expanded(
      //                   flex: 2,
      //                   child: Column(children: [
      //                     IconButton(
      //                       tooltip: 'Editar esta avaliação',
      //                       icon: Icon(Icons.edit),
      //                       onPressed: () async {
      //                         widget.onEditExameCurrent(exame.id);
      //                       },
      //                     ),
      //                     IconButton(
      //                       tooltip: 'Lista de questões',
      //                       icon: Icon(Icons.format_list_numbered),
      //                       onPressed: () async {
      //                         widget.onQuestionList(exame.id);
      //                       },
      //                     ),
      //                     // IconButton(
      //                     //   tooltip: 'Lista de estudantes',
      //                     //   icon: Icon(Icons.person),
      //                     //   onPressed: () async {
      //                     //     widget.onStudentList(exame.id);
      //                     //   },
      //                     // ),
      //                   ])),
      //             ],
      //           ),
      //         );
      //       },
      //     ),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          widget.onEditExameCurrent(null);
        },
      ),
    );
  }

  buildItens() {
    List<Widget> list = [];
    for (var exame in widget.exameList) {
      list.add(
        Card(
          key: ValueKey(exame),
          child: Container(
            width: 600,
            height: 200,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // alignment: WrapAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 6,
                  child: ListTile(
                    title: Text('${exame.name}'),
                    subtitle: Text('${exame.toString()}'),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(children: [
                      IconButton(
                        tooltip: 'Editar esta avaliação',
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          widget.onEditExameCurrent(exame.id);
                        },
                      ),
                      IconButton(
                        tooltip: 'Lista de questões',
                        icon: Icon(Icons.format_list_numbered),
                        onPressed: () async {
                          widget.onQuestionList(exame.id);
                        },
                      ),
                    ])),
              ],
            ),
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
      ExameModel todo = widget.exameList[oldIndex];
      widget.exameList.removeAt(oldIndex);
      widget.exameList.insert(newIndex, todo);
    });
    widget.onChangeOrderExameList(oldIndex, newIndex);
  }
}
