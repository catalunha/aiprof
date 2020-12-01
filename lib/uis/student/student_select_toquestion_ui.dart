import 'package:aiprof/question/question_model.dart';
import 'package:aiprof/user/user_model.dart';
import 'package:flutter/material.dart';

class StudentSelectToQuestionUI extends StatefulWidget {
  final bool waiting;
  final List<UserModel> studentList;
  final QuestionModel questionCurrent;
  final Function(UserModel, bool) onSetStudentInExameCurrent;
  final Function(String) onSetStudentSelected;
  final Function(String) onDeleteStudentInExameCurrent;
  final Function(bool) onSetStudentListInExameCurrent;
  const StudentSelectToQuestionUI({
    Key key,
    this.studentList,
    this.questionCurrent,
    this.onSetStudentInExameCurrent,
    this.waiting,
    this.onSetStudentListInExameCurrent,
    this.onDeleteStudentInExameCurrent,
    this.onSetStudentSelected,
  }) : super(key: key);
  @override
  _StudentSelectToQuestionUIState createState() =>
      _StudentSelectToQuestionUIState();
}

class _StudentSelectToQuestionUIState extends State<StudentSelectToQuestionUI> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
                '/${widget.questionCurrent.classroomRef.name}/${widget.questionCurrent.exameRef.name}/${widget.questionCurrent.name}: com ${widget.studentList.length} estudantes.'),
            actions: [
              IconButton(
                tooltip: 'Marcar todos os possíveis',
                icon: Icon(Icons.check_box),
                onPressed: () => widget.onSetStudentListInExameCurrent(true),
              ),
              IconButton(
                tooltip: 'Desmarcar todos os possíveis',
                icon: Icon(Icons.check_box_outline_blank),
                onPressed: () => widget.onSetStudentListInExameCurrent(false),
              ),
            ],
          ),
          body:
              //  Container(
              //   height: 500.0,
              //   width: 400.0,
              //   child:
              Center(
            child: Container(
              width: 600,
              child: ListView.builder(
                itemCount: widget.studentList.length,
                itemBuilder: (context, index) {
                  final student = widget.studentList[index];
                  // bool isStudentInExame = widget.questionCurrent.studentMap !=
                  //         null &&
                  //     widget.questionCurrent.studentMap.isNotEmpty &&
                  //     widget.questionCurrent.studentMap.containsKey(student.id);
                  bool isStudentInExame =
                      widget.questionCurrent?.studentMap != null
                          ? widget.questionCurrent.studentMap
                              .containsKey(student.id)
                          : false;
                  bool isStudentInExameWithTaskAplly =
                      widget.questionCurrent?.studentMap != null
                          ? (widget.questionCurrent.studentMap
                                  .containsKey(student.id) &&
                              widget.questionCurrent?.studentMap[student.id]
                                  .isDelivered)
                          : false;
                  // bool isStudentInExameWithTaskAplly = isStudentInExame &&
                  //     widget.questionCurrent.studentMap[student.id];
                  return Card(
                    child: Row(
                      children: [
                        // widget.questionCurrent.studentMap != null &&
                        //         widget.questionCurrent.studentMap.isNotEmpty &&
                        //         widget.questionCurrent.studentMap
                        //             .containsKey(student.id) &&
                        //         widget.questionCurrent.studentMap[student.id]
                        isStudentInExame
                            ? Expanded(
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
                                    widget.onDeleteStudentInExameCurrent(
                                        student.id);
                                  },
                                ),
                              )
                            : Container(),
                        Expanded(
                          flex: 8,
                          child: ListTile(
                            // enabled: widget.questionCurrent.studentMap != null &&
                            //         widget.questionCurrent.studentMap.isNotEmpty &&
                            //         widget.questionCurrent.studentMap
                            //             .containsKey(student.id)
                            //     ? !widget.questionCurrent.studentMap[student.id]
                            //     : true,
                            enabled: !isStudentInExame,
                            // selected: widget.questionCurrent.studentMap != null &&
                            //         widget.questionCurrent.studentMap.isNotEmpty
                            //     ? widget.questionCurrent.studentMap
                            //         .containsKey(student.id)
                            //     : false,
                            selected: isStudentInExame,
                            title: Text('${student.name}'),
                            subtitle: Text('${student.toString()}'),
                            // subtitle: Text(
                            //     '${student.id.substring(0, 4)} - ${widget.questionCurrent.studentMap[student.id]}'),
                            onTap: () {
                              widget.onSetStudentInExameCurrent(student, true
                                  // !(widget.questionCurrent.studentMap != null &&
                                  //         widget.questionCurrent.studentMap.isNotEmpty
                                  //     ? widget.questionCurrent.studentMap
                                  //         .containsKey(student.id)
                                  //     : false),
                                  );
                              setState(() {});
                            },
                          ),
                        ),
                        // widget.questionCurrent.studentMap != null &&
                        //         widget.questionCurrent.studentMap.isNotEmpty &&
                        //         widget.questionCurrent.studentMap
                        //             .containsKey(student.id) &&
                        //         widget.questionCurrent.studentMap[student.id]
                        isStudentInExameWithTaskAplly
                            ? Expanded(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {
                                    widget.onSetStudentSelected(student.id);
                                  },
                                  icon: Icon(Icons.art_track_sharp),
                                  tooltip: 'Listar as tarefas deste estudante',
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (widget.waiting)
          Material(
            child: Stack(
              children: [
                Center(child: CircularProgressIndicator()),
                Center(
                  child: Text(
                    'Processando...',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ModalBarrier(
                  color: Colors.green.withOpacity(0.4),
                ),
              ],
            ),
          )
      ],
    );
  }
}
