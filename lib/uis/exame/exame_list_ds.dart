import 'package:aiprof/models/exame_model.dart';
import 'package:flutter/material.dart';

class ExameListDS extends StatefulWidget {
  final List<ExameModel> exameList;
  final Function(String) onEditExameCurrent;
  final Function(String) onQuestionList;
  final Function(String) onStudentList;

  const ExameListDS({
    Key key,
    this.exameList,
    this.onEditExameCurrent,
    this.onQuestionList,
    this.onStudentList,
  }) : super(key: key);

  @override
  _ExameListDSState createState() => _ExameListDSState();
}

class _ExameListDSState extends State<ExameListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exames (${widget.exameList.length})'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: Center(
        child: Container(
          width: 600,
          child: ListView.builder(
            itemCount: widget.exameList.length,
            itemBuilder: (context, index) {
              final exame = widget.exameList[index];
              return Card(
                child: Row(
                  // alignment: WrapAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 6,
                      child: ListTile(
                        selected: exame.isDelivered,
                        title: Text('${exame.name}'),
                        subtitle: Text('${exame.toString()}'),
                      ),
                    ),
                    exame.isDelivered
                        ? Expanded(flex: 2, child: Container())
                        : Expanded(
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
                              IconButton(
                                tooltip: 'Lista de estudantes',
                                icon: Icon(Icons.person),
                                onPressed: () async {
                                  widget.onStudentList(exame.id);
                                },
                              ),
                            ])),
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
          widget.onEditExameCurrent(null);
        },
      ),
    );
  }
}
