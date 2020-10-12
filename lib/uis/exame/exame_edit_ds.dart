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
  bool isInvisibilityDelete = true;

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
    isInvisibilityDelete = true;
    _attempt = widget.attempt == null ? 3 : widget.attempt;
    _time = widget.time == null ? 2 : widget.time;
    _error = widget.error == null ? 10 : widget.error;
    _scoreQuestion = widget.scoreQuestion == null ? 1 : widget.scoreQuestion;
    _scoreExame = widget.scoreExame == null ? 1 : widget.scoreExame;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Text(widget.isAddOrUpdate ? 'Criar exame' : 'Editar exame'),
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
            if (_scoreExame >= 1) {
              liberated = true;
            } else {
              liberated = false;
              showSnackBarHandler(
                  context, 'Verifique o valor da nota/peso do exame');
            }
          }
          if (liberated) {
            if (_scoreQuestion >= 1) {
              liberated = true;
            } else {
              liberated = false;
              showSnackBarHandler(
                  context, 'Verifique o valor da nota/peso da questão');
            }
          }
          if (liberated) {
            if (_attempt >= 1) {
              liberated = true;
            } else {
              liberated = false;
              showSnackBarHandler(context, 'Verifique o valor da tentativa');
            }
          }
          if (liberated) {
            if (_time >= 1) {
              liberated = true;
            } else {
              liberated = false;
              showSnackBarHandler(context, 'Verifique o valor do tempo');
            }
          }
          if (liberated) {
            if (_error >= 1 && _error < 100) {
              liberated = true;
            } else {
              liberated = false;
              showSnackBarHandler(
                  context, 'Verifique o valor do erro relativo');
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
          // Text('>>> $_scoreExame $_scoreQuestion $_time $_attempt $_error'),
          TextFormField(
            initialValue:
                widget.scoreExame == null ? '1' : widget.scoreExame.toString(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Nota ou peso da avaliação (>=1):',
            ),
            onChanged: (newValue) => _scoreExame = int.parse(newValue),
            onSaved: (newValue) => _scoreExame = int.parse(newValue),
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.time == null ? '2' : widget.time.toString(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Horas para resolução após aberta a tarefa (>=1):',
            ),
            onChanged: (newValue) => _time = int.parse(newValue),
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
            onChanged: (newValue) => _attempt = int.parse(newValue),
            onSaved: (newValue) => _attempt = int.parse(newValue),
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.error == null ? '10' : widget.error.toString(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Erro relativo na correção numérica (>=1 e <100):',
            ),
            onChanged: (newValue) => _error = int.parse(newValue),
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
            onChanged: (newValue) => _scoreQuestion = int.parse(newValue),
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isInvisibilityDelete
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
            height: 100,
          ),
        ],
      ),
    );
  }
}
