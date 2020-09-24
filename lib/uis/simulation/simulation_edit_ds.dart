import 'package:aiprof/models/simulation_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SimulationEditDS extends StatefulWidget {
  final String name;
  final List<Input> input;
  final List<Output> output;
  final bool isAddOrUpdate;
  final Function(String) onAdd;
  final Function(String, bool) onUpdate;
  final Function(String) onEditInput;

  const SimulationEditDS({
    Key key,
    this.name,
    this.input,
    this.output,
    this.isAddOrUpdate,
    this.onAdd,
    this.onUpdate,
    this.onEditInput,
  }) : super(key: key);
  @override
  _SimulationEditDSState createState() => _SimulationEditDSState();
}

class _SimulationEditDSState extends State<SimulationEditDS> {
  final formKey = GlobalKey<FormState>();
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
          Text('Saídas da simulação (${widget.output.length})'),
          ...outputBuilder(context, widget.output),
          widget.isAddOrUpdate
              ? Container()
              : SwitchListTile(
                  value: _isDelete,
                  title: _isDelete
                      ? Text('Simulação será removida.')
                      : Text('Remover ?'),
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
          icone,
          Container(
            width: 10,
          ),
          Text('${input.name}'),
          Text(' = '),
          Text('${input.value}'),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => widget.onEditInput(input.id)),
          // Text(' id: ${input.id.substring(0, 5)}'),
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
      } else if (output.type == 'file' ||
          output.type == 'arquivo' ||
          output.type == 'imagem') {
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
          icone,
          IconButton(icon: Icon(Icons.edit), onPressed: null),
          Text('${output.name}'),
          Text(' = '),
          Text('${output.value}'),
          IconButton(icon: Icon(Icons.delete), onPressed: null),
          Text('id: ${output.id.substring(0, 5)}'),
        ],
      ));
    }
    return itemList;
  }
}
