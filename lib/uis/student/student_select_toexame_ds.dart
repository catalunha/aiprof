import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:flutter/material.dart';

class StudentSelectToExameDS extends StatefulWidget {
  final bool waiting;
  final List<UserModel> studentList;
  final ExameModel exameCurrent;
  final Function(UserModel, bool) onSetStudentInExameCurrent;
  final Function(String) onSetStudentSelected;
  final Function(String) onDeleteStudentInExameCurrent;
  final Function(bool) onSetStudentListInExameCurrent;
  const StudentSelectToExameDS({
    Key key,
    this.studentList,
    this.exameCurrent,
    this.onSetStudentInExameCurrent,
    this.waiting,
    this.onSetStudentListInExameCurrent,
    this.onDeleteStudentInExameCurrent,
    this.onSetStudentSelected,
  }) : super(key: key);
  @override
  _StudentSelectToExameDSState createState() => _StudentSelectToExameDSState();
}

class _StudentSelectToExameDSState extends State<StudentSelectToExameDS> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
                '#Student2Exame Alunos nesta turma (${widget.studentList.length})'),
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
              ListView.builder(
            itemCount: widget.studentList.length,
            itemBuilder: (context, index) {
              final student = widget.studentList[index];
              bool isStudentInExame = widget.exameCurrent.studentMap != null &&
                  widget.exameCurrent.studentMap.isNotEmpty &&
                  widget.exameCurrent.studentMap.containsKey(student.id);
              bool isStudentInExameWithTaskAplly = isStudentInExame &&
                  widget.exameCurrent.studentMap[student.id];
              return Row(
                children: [
                  // widget.exameCurrent.studentMap != null &&
                  //         widget.exameCurrent.studentMap.isNotEmpty &&
                  //         widget.exameCurrent.studentMap
                  //             .containsKey(student.id) &&
                  //         widget.exameCurrent.studentMap[student.id]
                  isStudentInExameWithTaskAplly
                      ? Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Tooltip(
                              message:
                                  'Deleta este aluno desta avaliação e todas as suas tarefas nesta avaliação',
                              child: Icon(
                                Icons.delete,
                                size: 15,
                              ),
                            ),
                            onDoubleTap: () {
                              widget.onDeleteStudentInExameCurrent(student.id);
                            },
                          ),
                        )
                      : Container(),
                  Expanded(
                    flex: 8,
                    child: ListTile(
                      // enabled: widget.exameCurrent.studentMap != null &&
                      //         widget.exameCurrent.studentMap.isNotEmpty &&
                      //         widget.exameCurrent.studentMap
                      //             .containsKey(student.id)
                      //     ? !widget.exameCurrent.studentMap[student.id]
                      //     : true,
                      enabled: !isStudentInExameWithTaskAplly,
                      // selected: widget.exameCurrent.studentMap != null &&
                      //         widget.exameCurrent.studentMap.isNotEmpty
                      //     ? widget.exameCurrent.studentMap
                      //         .containsKey(student.id)
                      //     : false,
                      selected: isStudentInExame,
                      title: Text('${student.name}'),
                      subtitle: Text('${student.toString()}'),
                      // subtitle: Text(
                      //     '${student.id.substring(0, 4)} - ${widget.exameCurrent.studentMap[student.id]}'),
                      onTap: () {
                        widget.onSetStudentInExameCurrent(
                            student, !isStudentInExame
                            // !(widget.exameCurrent.studentMap != null &&
                            //         widget.exameCurrent.studentMap.isNotEmpty
                            //     ? widget.exameCurrent.studentMap
                            //         .containsKey(student.id)
                            //     : false),
                            );
                        setState(() {});
                      },
                    ),
                  ),
                  // widget.exameCurrent.studentMap != null &&
                  //         widget.exameCurrent.studentMap.isNotEmpty &&
                  //         widget.exameCurrent.studentMap
                  //             .containsKey(student.id) &&
                  //         widget.exameCurrent.studentMap[student.id]
                  isStudentInExameWithTaskAplly
                      ? Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              widget.onSetStudentSelected(student.id);
                            },
                            icon: Icon(Icons.art_track_sharp),
                            tooltip: 'Lista suas tarefas nesta avaliação',
                          ),
                        )
                      : Container(),
                ],
              );
            },
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
