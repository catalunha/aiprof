import 'package:aiprof/situation/simulation/simulation_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SimulationEditUI extends StatefulWidget {
  final String name;
  final List<Input> input;
  final List<Output> output;
  final bool isAddOrUpdate;
  final Function(String) onAdd;
  final Function(String, bool) onUpdate;
  final Function(String) onEditInput;
  final Function(String) onEditOutput;

  const SimulationEditUI({
    Key key,
    this.name,
    this.input,
    this.output,
    this.isAddOrUpdate,
    this.onAdd,
    this.onUpdate,
    this.onEditInput,
    this.onEditOutput,
  }) : super(key: key);
  @override
  _SimulationEditUIState createState() => _SimulationEditUIState();
}

class _SimulationEditUIState extends State<SimulationEditUI> {
  final formKey = GlobalKey<FormState>();
  bool isInvisibilityDelete = true;

  String _name;
  bool _isDelete = false;
  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.isAddOrUpdate
          ? widget.onAdd(_name)
          : widget.onUpdate(_name, _isDelete);
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isAddOrUpdate ? 'Criar simulação' : 'Editar simulação'),
      ),
      body: Center(
        child: Container(
          width: 600,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: form(),
          ),
        ),
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
          TextFormField(
            initialValue: widget.name,
            decoration: InputDecoration(
              labelText: 'Nome da simulação *',
            ),
            onSaved: (newValue) => _name = newValue,
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          Row(children: [
            Text('Entradas para a simulação (${widget.input.length})'),
            IconButton(
              icon: Icon(Icons.plus_one),
              onPressed: () => widget.onEditInput(null),
            ),
          ]),
          ...inputBuilder(context, widget.input),
          Row(children: [
            Text('Saídas da simulação (${widget.output.length})'),
            IconButton(
              icon: Icon(Icons.plus_one),
              onPressed: () => widget.onEditOutput(null),
            ),
          ]),
          ...outputBuilder(context, widget.output),
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
                                ? Text('Simulação será apagada.')
                                : Text('Remover esta simulação ?'),
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

  List<Widget> inputBuilder(BuildContext context, List<Input> inputList) {
    List<Widget> itemList = [];
    for (Input input in inputList) {
      Widget icone = Icon(Icons.question_answer);
      if (input.type == 'numero') {
        icone = Icon(Icons.looks_one);
      } else if (input.type == 'palavra') {
        icone = Icon(Icons.text_format);
      } else if (input.type == 'texto') {
        icone = Icon(Icons.text_fields);
      } else if (input.type == 'url') {
        icone = IconButton(
          tooltip: 'Um link ao um site ou arquivo',
          icon: Icon(Icons.link),
          onPressed: () async {
            if (input.value != null) {
              if (await canLaunch(input.value)) {
                await launch(input.value);
              }
            }
          },
        );
      }
      itemList.add(Row(
        children: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => widget.onEditInput(input.id)),
          Text('${input.name}'),
          Text(' = '),
          Text('${input.value}'),
          Container(
            width: 10,
          ),
          icone,
        ],
      ));
    }
    return itemList;
  }

  List<Widget> outputBuilder(BuildContext context, List<Output> outputList) {
    List<Widget> itemList = [];
    for (Output output in outputList) {
      Widget icone = Icon(Icons.question_answer);
      if (output.type == 'numero') {
        icone = Icon(Icons.looks_one);
      } else if (output.type == 'palavra') {
        icone = Icon(Icons.text_format);
      } else if (output.type == 'texto') {
        icone = Icon(Icons.text_fields);
      } else if (output.type == 'url' || output.type == 'urlimagem') {
        icone = IconButton(
          tooltip: 'Um link ou URL ao um site ou arquivo',
          icon: Icon(Icons.link),
          onPressed: () async {
            if (output.value != null) {
              if (await canLaunch(output.value)) {
                await launch(output.value);
              }
            }
          },
        );
      } else if (output.type == 'arquivo' || output.type == 'imagem') {
        icone = IconButton(
          tooltip: 'Upload de arquivo ou imagem',
          icon: Icon(Icons.description),
          onPressed: () async {
            if (output.value != null) {
              if (await canLaunch(output.value)) {
                await launch(output.value);
              }
            }
          },
        );
      }
      itemList.add(Row(
        children: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => widget.onEditOutput(output.id)),
          Text('${output.name}'),
          Text(' = '),
          output.type == 'texto' || output.type == 'url'
              ? Text('...')
              : Text('${output.value}'),
          Container(
            width: 10,
          ),
          icone,
        ],
      ));
    }
    return itemList;
  }
}
