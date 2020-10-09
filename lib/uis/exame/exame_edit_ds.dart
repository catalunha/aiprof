import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExameEditDS extends StatefulWidget {
  final String name;
  final String description;
  final dynamic start;
  final dynamic end;
  final int scoreExame;
  final int attempt;
  final int time;
  final int error;
  final int scoreQuestion;
  final bool isDelivered;
  final bool isAddOrUpdate;
  final Function(String, String, dynamic, dynamic, int, int, int, int, int)
      onAdd;
  final Function(
          String, String, dynamic, dynamic, int, int, int, int, int, bool, bool)
      onUpdate;

  const ExameEditDS({
    Key key,
    this.name,
    this.description,
    this.start,
    this.end,
    this.scoreExame,
    this.attempt,
    this.time,
    this.error,
    this.scoreQuestion,
    this.isDelivered,
    this.isAddOrUpdate,
    this.onAdd,
    this.onUpdate,
  }) : super(key: key);
  @override
  _ExameEditDSState createState() => _ExameEditDSState();
}

class _ExameEditDSState extends State<ExameEditDS> {
  final formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  String _name;
  String _description;
  dynamic _start;
  dynamic _end;
  int _scoreExame;
  int _attempt;
  int _time;
  int _error;
  int _scoreQuestion;
  bool _isDelivered;
  bool _isDelete = false;
  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.isAddOrUpdate
          ? widget.onAdd(_name, _description, _start, _end, _scoreExame,
              _attempt, _time, _error, _scoreQuestion)
          : widget.onUpdate(_name, _description, _start, _end, _scoreExame,
              _attempt, _time, _error, _scoreQuestion, _isDelivered, _isDelete);
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _isDelivered = widget.isDelivered;
    _start = widget.start != null ? widget.start : DateTime.now();
    _end = widget.end != null ? widget.end : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAddOrUpdate
            ? 'Criar #Exame Avaliação'
            : 'Editar #Exame Avaliação'),
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
          TextFormField(
            initialValue:
                widget.scoreExame == null ? '1' : widget.scoreExame.toString(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Nota ou peso da avaliação (>=1):',
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
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Nota ou peso das questões (>=1):',
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
          widget.isAddOrUpdate
              ? Container()
              : SwitchListTile(
                  value: _isDelivered,
                  title: _isDelivered
                      ? Text('Avaliação será distribuída.')
                      : Text('Distribuir avaliação ?'),
                  onChanged: (value) {
                    setState(() {
                      _isDelivered = value;
                    });
                  },
                ),
          widget.isAddOrUpdate
              ? Container()
              : SwitchListTile(
                  value: _isDelete,
                  title: _isDelete
                      ? Text('Avaliação será apagada.')
                      : Text('Apagar avaliação ?'),
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
