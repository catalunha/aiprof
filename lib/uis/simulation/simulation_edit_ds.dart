import 'package:flutter/material.dart';

class SimulationEditDS extends StatefulWidget {
  final String name;
  final bool isAddOrUpdate;
  final Function(String) onAdd;
  final Function(String) onUpdate;

  const SimulationEditDS({
    Key key,
    this.name,
    this.isAddOrUpdate,
    this.onAdd,
    this.onUpdate,
  }) : super(key: key);
  @override
  _SimulationEditDSState createState() => _SimulationEditDSState();
}

class _SimulationEditDSState extends State<SimulationEditDS> {
  final formKey = GlobalKey<FormState>();
  String _name;
  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.isAddOrUpdate ? widget.onAdd(_name) : widget.onUpdate(_name);
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
          Container(
            height: 50,
          ),
        ],
      ),
    );
  }
}
