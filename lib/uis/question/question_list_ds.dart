import 'package:aiprof/classroom/classroom_model.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuestionListDS extends StatefulWidget {
  final ClassroomModel classroomRef;
  final ExameModel exameRef;
  final List<QuestionModel> questionList;
  final Function(String) onEditQuestionCurrent;
  final Function(String) onSituationSelect;
  final Function(String) onStudentList;
  final Function(int oldIndex, int newIndex) onChangeOrderQuestionList;

  const QuestionListDS({
    Key key,
    this.questionList,
    this.onEditQuestionCurrent,
    this.onSituationSelect,
    this.onStudentList,
    this.classroomRef,
    this.exameRef,
    this.onChangeOrderQuestionList,
  }) : super(key: key);

  @override
  _QuestionListDSState createState() => _QuestionListDSState();
}

class _QuestionListDSState extends State<QuestionListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '/${widget.classroomRef.name}/${widget.exameRef.name}: com ${widget.questionList.length} questões.'),
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
      //       itemCount: widget.questionList.length,
      //       itemBuilder: (context, index) {
      //         final question = widget.questionList[index];
      //         return Card(
      //           child: Row(
      //             // alignment: WrapAlignment.spaceEvenly,
      //             children: [
      //               Expanded(
      //                 flex: 6,
      //                 child: ListTile(
      //                   selected: question.isDelivered ? true : false,
      //                   title: Text('${question.name}'),
      //                   subtitle: Text('${question.toString()}'),
      //                 ),
      //               ),
      //               Expanded(
      //                 flex: 2,
      //                 child: Column(
      //                   children: [
      //                     IconButton(
      //                       tooltip: 'Editar esta questão',
      //                       icon: Icon(Icons.edit),
      //                       onPressed: () async {
      //                         widget.onEditQuestionCurrent(question.id);
      //                       },
      //                     ),
      //                     IconButton(
      //                       tooltip: 'URL para a situação',
      //                       icon: Icon(Icons.local_library),
      //                       onPressed: () async {
      //                         if (question.situationModel?.url != null) {
      //                           if (await canLaunch(
      //                               question.situationModel.url)) {
      //                             await launch(question.situationModel.url);
      //                           }
      //                         }
      //                       },
      //                     ),
      //                     IconButton(
      //                       tooltip: 'Lista de estudantes',
      //                       icon: Icon(Icons.person),
      //                       onPressed: () async {
      //                         widget.onStudentList(question.id);
      //                       },
      //                     ),
      //                   ],
      //                 ),
      //               )
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
          widget.onEditQuestionCurrent(null);
        },
      ),
    );
  }

  buildItens() {
    List<Widget> list = [];
    for (var question in widget.questionList) {
      list.add(
        Card(
          key: ValueKey(question),
          child: Container(
            width: 600,
            height: 200,
            child: Row(
              // alignment: WrapAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 6,
                  child: ListTile(
                    selected: question.isDelivered ? true : false,
                    title: Text('${question.name}'),
                    subtitle: Text('${question.toString()}'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      IconButton(
                        tooltip: 'Editar esta questão',
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          widget.onEditQuestionCurrent(question.id);
                        },
                      ),
                      IconButton(
                        tooltip: 'URL para a situação',
                        icon: Icon(Icons.local_library),
                        onPressed: () async {
                          if (question.situationModel?.url != null) {
                            if (await canLaunch(question.situationModel.url)) {
                              await launch(question.situationModel.url);
                            }
                          }
                        },
                      ),
                      IconButton(
                        tooltip: 'Lista de estudantes',
                        icon: Icon(Icons.person),
                        onPressed: () async {
                          widget.onStudentList(question.id);
                        },
                      ),
                    ],
                  ),
                )
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
      QuestionModel todo = widget.questionList[oldIndex];
      widget.questionList.removeAt(oldIndex);
      widget.questionList.insert(newIndex, todo);
    });
    widget.onChangeOrderQuestionList(oldIndex, newIndex);
  }
}
