import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/models/question_model.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskEditDS extends StatefulWidget {
  final String id;
  final ClassroomModel classroomRef;
  final ExameModel exameRef;
  final QuestionModel questionRef;
  final SituationModel situationRef;
  final UserModel studentUserRef;
  //dados do exame
  final dynamic start;
  final dynamic end;
  final int scoreExame;
  //dados da questao
  final int attempt;
  final int time;
  final int error;
  final int scoreQuestion;
  // gestão da tarefa
  final int attempted;
  final bool isOpen;

  final List<Input> simulationInput;
  final List<Output> simulationOutput;

  final Function(
          dynamic, dynamic, int, int, int, int, int, bool, int, bool, bool)
      onUpdateTask;
  final Function(String, bool) onUpdateOutput;
  final Function() onSeeTextTask;

  const TaskEditDS({
    Key key,
    this.start,
    this.end,
    this.scoreExame,
    this.attempt,
    this.time,
    this.error,
    this.scoreQuestion,
    this.attempted,
    this.isOpen,
    this.simulationInput,
    this.simulationOutput,
    this.onUpdateTask,
    this.onUpdateOutput,
    this.id,
    this.onSeeTextTask,
    this.classroomRef,
    this.exameRef,
    this.questionRef,
    this.situationRef,
    this.studentUserRef,
  }) : super(key: key);
  @override
  _TaskEditDSState createState() => _TaskEditDSState();
}

class _TaskEditDSState extends State<TaskEditDS> {
  final formKey = GlobalKey<FormState>();
  bool isInvisibilityDelete = true;

  //dados do exame
  dynamic _start;
  dynamic _end;
  int _scoreExame;
  //dados da questao
  int _attempt;
  int _time;
  int _error;
  int _scoreQuestion;
  // gestão da tarefa
  int _attempted;
  bool _isOpen;
  bool _nullStarted = false;
  bool _isDelete = false;
  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.onUpdateTask(_start, _end, _scoreExame, _attempt, _time, _error,
          _scoreQuestion, _nullStarted, _attempted, _isOpen, _isDelete);
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _isOpen = widget.isOpen;
    _start = widget.start != null ? widget.start : DateTime.now();
    _end = widget.end != null ? widget.end : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.classroomRef.name}/${widget.exameRef.name}/${widget.questionRef.name}/${widget.id.substring(0, 4)}: de ${widget.studentUserRef.name}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: form(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        onPressed: () {
          validateData();
        },
      ),
    );
  }

  Widget form() {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          ListTile(
            title: Text('Proposta da tarefa.'),
            leading: IconButton(
              tooltip: 'Um link ao um site ou arquivo',
              icon: Icon(Icons.link),
              onPressed: () async {
                if (widget.situationRef.url != null) {
                  if (await canLaunch(widget.situationRef.url)) {
                    await launch(widget.situationRef.url);
                  }
                }
              },
            ),
          ),
          Row(children: [
            Text(
                'Entradas para a desenvolvimento: ${widget.simulationInput.length}'),
          ]),
          ...simulationInputBuilder(context, widget.simulationInput),
          Row(children: [
            Text(
                'Saídas do desenvolvimento: ${widget.simulationOutput.length}'),
          ]),
          ...simulationOutputBuilder(context, widget.simulationOutput),
          TextFormField(
            initialValue:
                widget.scoreExame == null ? '1' : widget.scoreExame.toString(),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
            ],
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Nota ou peso da avaliação (>=0):',
            ),
            onSaved: (newValue) => _scoreExame = int.parse(newValue),
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.time == null ? '3' : widget.time.toString(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Horas para resolução após aberta a tarefa (>=1):',
            ),
            onSaved: (newValue) => _time = int.parse(newValue),
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue:
                widget.attempt == null ? '3' : widget.attempt.toString(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Número de tentativas no envio das respostas (>=1):',
            ),
            onSaved: (newValue) => _attempt = int.parse(newValue),
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.error == null ? '3' : widget.error.toString(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Erro relativo na correção numérica (>=1 e <100):',
            ),
            onSaved: (newValue) => _error = int.parse(newValue),
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.scoreQuestion == null
                ? '1'
                : widget.scoreQuestion.toString(),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
            ],
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Nota ou peso da questão (>=1):',
            ),
            onSaved: (newValue) => _scoreQuestion = int.parse(newValue),
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          Text('Inicio do desenvolvimento:'),
          Row(
            children: [
              SizedBox(
                width: 70,
              ),
              Expanded(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CupertinoDatePicker(
                    initialDateTime: _start,
                    use24hFormat: true,
                    onDateTimeChanged: (datetime) {
                      setState(() {
                        _start = datetime;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Text('Fim do desenvolvimento:'),
          Row(
            children: [
              SizedBox(
                width: 70,
              ),
              Expanded(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CupertinoDatePicker(
                    initialDateTime: _end,
                    use24hFormat: true,
                    onDateTimeChanged: (datetime) {
                      setState(() {
                        _end = datetime;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          TextFormField(
            initialValue:
                widget.attempted == null ? '0' : widget.attempted.toString(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              labelText:
                  'Número de tentativas já realizadas no envio das respostas (0>=?<=tentativas):',
            ),
            onSaved: (newValue) => _attempted = int.parse(newValue),
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          SwitchListTile(
            value: _nullStarted,
            title: _nullStarted
                ? Text('Inicio será limpo.')
                : Text('Limpar inicio da tarefa?'),
            onChanged: (value) {
              setState(() {
                _nullStarted = value;
              });
            },
          ),
          SwitchListTile(
            value: _isOpen,
            title: _isOpen
                ? Text('Tarefa será aberta.')
                : Text('Abrir da tarefa?'),
            onChanged: (value) {
              setState(() {
                _isOpen = value;
              });
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isInvisibilityDelete
                  ? Container()
                  : SwitchListTile(
                      value: _isDelete,
                      title: _isDelete
                          ? Text('Tarefa será apagada.')
                          : Text('Apagar esta tarefa ?'),
                      onChanged: (value) {
                        setState(() {
                          _isDelete = value;
                        });
                      },
                    ),
              IconButton(
                tooltip: 'Liberar opção para apagar este item',
                color: Colors.grey[400],
                icon: const Icon(
                  Icons.delete,
                  // size: 22.0,
                ),
                onPressed: () {
                  setState(() {
                    isInvisibilityDelete = !isInvisibilityDelete;
                  });
                },
              ),
            ],
          ),
          Container(
            height: 50,
          ),
        ],
      ),
    );
  }

  List<Widget> simulationInputBuilder(
      BuildContext context, List<Input> simulationInputList) {
    List<Widget> itemList = [];
    for (Input simulationInput in simulationInputList) {
      Widget icone = Icon(Icons.question_answer);
      if (simulationInput.type == 'numero') {
        icone = Icon(Icons.looks_one);
      } else if (simulationInput.type == 'palavra') {
        icone = Icon(Icons.text_format);
      } else if (simulationInput.type == 'texto') {
        // icone = Icon(Icons.text_fields);
        icone = IconButton(
          tooltip: 'ver textos desta tarefa',
          icon: Icon(Icons.text_fields),
          onPressed: () {
            widget.onSeeTextTask();
          },
        );
      } else if (simulationInput.type == 'url') {
        icone = IconButton(
          tooltip: 'Um link ao um site ou arquivo',
          icon: Icon(Icons.link),
          onPressed: () async {
            if (simulationInput.value != null) {
              if (await canLaunch(simulationInput.value)) {
                await launch(simulationInput.value);
              }
            }
          },
        );
      }
      itemList.add(Row(
        children: [
          Text('${simulationInput.name}'),
          Text(' = '),
          simulationInput.type == 'texto' || simulationInput.type == 'url'
              ? Text('(${simulationInput.value.length}c)')
              : Text('${simulationInput.value}'),
          Container(
            width: 10,
          ),
          icone,
        ],
      ));
    }
    return itemList;
  }

  List<Widget> simulationOutputBuilder(
      BuildContext context, List<Output> simulationOutputList) {
    List<Widget> itemList = [];
    for (Output simulationOutput in simulationOutputList) {
      Widget icone = Icon(Icons.question_answer);
      if (simulationOutput.type == 'numero') {
        icone = Icon(Icons.looks_one);
      } else if (simulationOutput.type == 'palavra') {
        icone = Icon(Icons.text_format);
      } else if (simulationOutput.type == 'texto') {
        icone = IconButton(
          tooltip: 'ver textos desta tarefa',
          icon: Icon(Icons.text_fields),
          onPressed: () {
            widget.onSeeTextTask();
          },
        );
      } else if (simulationOutput.type == 'url' ||
          simulationOutput.type == 'urlimagem') {
        icone = IconButton(
          tooltip: 'Um link ou URL ao um site ou arquivo',
          icon: Icon(Icons.link),
          onPressed: () async {
            if (simulationOutput.answer != null) {
              if (await canLaunch(simulationOutput.answer)) {
                await launch(simulationOutput.answer);
              }
            }
          },
        );
      } else if (simulationOutput.type == 'arquivo' ||
          simulationOutput.type == 'imagem') {
        icone = IconButton(
          tooltip: 'Upload de arquivo ou imagem',
          icon: Icon(Icons.description),
          onPressed: () async {
            if (simulationOutput.value != null) {
              if (await canLaunch(simulationOutput.value)) {
                await launch(simulationOutput.value);
              }
            }
          },
        );
      }
      itemList.add(Row(
        children: [
          Text('${simulationOutput.name}'),
          Text(' = '),
          simulationOutput.type == 'texto' || simulationOutput.type == 'url'
              ? Text('(${simulationOutput.value.length}c)')
              : Text('${simulationOutput.value} (${simulationOutput.answer})'),
          Container(
            width: 10,
          ),
          icone,
          IconButton(
            color: simulationOutput?.right != null
                ? simulationOutput.right
                    ? Colors.green
                    : Colors.red
                : Colors.black,
            icon: simulationOutput?.right != null
                ? simulationOutput.right
                    ? Icon(Icons.thumb_up)
                    : Icon(Icons.thumb_down)
                : Icon(
                    Icons.thumbs_up_down,
                    color: Colors.yellow,
                  ),
            // icon: Icon(Icons.thumb_up),
            onPressed: () {
              bool _right;
              _right = simulationOutput?.right != null
                  ? simulationOutput.right
                      ? true
                      : false
                  : false;
              widget.onUpdateOutput(simulationOutput.id, !_right);
            },
          ),
          // IconButton(
          //   color: simulationOutput?.right != null
          //       ? simulationOutput.right ? Colors.green : Colors.red
          //       : Colors.black,
          //   icon: Icon(Icons.thumb_down),
          //   onPressed: () {
          //     widget.onUpdateOutput(simulationOutput.id, false);
          //   },
          // ),
        ],
      ));
    }
    return itemList;
  }
}
