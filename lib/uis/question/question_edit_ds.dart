import 'package:aiprof/models/situation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuestionEditDS extends StatefulWidget {
  final String name;
  final String description;
  final dynamic start;
  final dynamic end;
  final int scoreQuestion;
  final int attempt;
  final int time;
  final int error;
  final SituationModel situationRef;
  final bool isDelivered;
  final bool isAddOrUpdate;
  final Function() onSituationSelect;

  final Function(String, String, dynamic, dynamic, int, int, int, int) onAdd;
  final Function(String, String, dynamic, dynamic, int, int, int, int, bool)
      onUpdate;

  const QuestionEditDS({
    Key key,
    this.name,
    this.description,
    this.start,
    this.end,
    this.scoreQuestion,
    this.attempt,
    this.time,
    this.error,
    this.isAddOrUpdate,
    this.onAdd,
    this.onUpdate,
    this.situationRef,
    this.onSituationSelect,
    this.isDelivered,
  }) : super(key: key);
  @override
  _QuestionEditDSState createState() => _QuestionEditDSState();
}

class _QuestionEditDSState extends State<QuestionEditDS> {
  final formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  String _name;
  String _description;
  dynamic _start;
  dynamic _end;
  int _scoreQuestion;
  int _attempt;
  int _time;
  int _error;
  bool _isDelete = false;
  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.isAddOrUpdate
          ? widget.onAdd(
              _name,
              _description,
              _start,
              _end,
              _scoreQuestion,
              _attempt,
              _time,
              _error,
            )
          : widget.onUpdate(_name, _description, _start, _end, _scoreQuestion,
              _attempt, _time, _error, _isDelete);
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _start = widget.start != null ? widget.start : DateTime.now();
    _end = widget.end != null ? widget.end : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAddOrUpdate
            ? 'Criar #Question Questão'
            : 'Editar #Question Questão'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: form(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        onPressed: () {
          bool liberated = true;
          if (liberated) {
            Duration difference = _end.difference(_start);
            if (difference.isNegative) {
              liberated = false;
              showSnackBarHandler(
                  context, 'Data e hora do fim antes do início.');
            } else {
              liberated = true;
            }
          }
          if (liberated) {
            validateData();
          }
        },
      ),
    );
  }

  showSnackBarHandler(context, String msg) {
    scaffoldState.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget form() {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          TextFormField(
            initialValue: widget.name,
            decoration: InputDecoration(
              labelText: 'Nome *',
            ),
            onSaved: (newValue) => _name = newValue,
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.description,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Descrição',
            ),
            onSaved: (newValue) => _description = newValue,
            // validator: (value) {
            //   if (value.isEmpty) {
            //     return 'Informe o que se pede.';
            //   }
            //   return null;
            // },
          ),
          widget?.isDelivered != null && !widget.isDelivered
              ? ListTile(
                  title: Text('Selecione uma situação ou problema :'),
                  subtitle: Text('${widget.situationRef?.name}'),
                  trailing: Icon(Icons.search),
                  onTap: () => widget.onSituationSelect(),
                )
              : Text('Questão já aplicada não pode mudar situação ou problema'),
          Text('Inicio do desenvolvimento:'),
          SizedBox(
            height: 100,
            child: CupertinoDatePicker(
              initialDateTime: _start,
              use24hFormat: true,
              onDateTimeChanged: (datetime) {
                print(datetime);
                setState(() {
                  _start = datetime;
                });
              },
            ),
          ),
          Text('Fim do desenvolvimento:'),
          SizedBox(
            height: 100,
            child: CupertinoDatePicker(
              initialDateTime: _end,
              use24hFormat: true,
              onDateTimeChanged: (datetime) {
                print(datetime);
                setState(() {
                  _end = datetime;
                });
              },
            ),
          ),
          TextFormField(
            initialValue: widget.scoreQuestion == null
                ? '1'
                : widget.scoreQuestion.toString(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          widget.isAddOrUpdate
              ? Container()
              : SwitchListTile(
                  value: _isDelete,
                  title: _isDelete
                      ? Text('Questão será apagada.')
                      : Text('Apagar questão ?'),
                  onChanged: (value) {
                    setState(() {
                      _isDelete = value;
                    });
                  },
                ),
          Container(
            height: 50,
          ),
        ],
      ),
    );
  }
}
