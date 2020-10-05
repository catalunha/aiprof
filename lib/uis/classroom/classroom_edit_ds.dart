import 'package:flutter/material.dart';

class ClassroomEditDS extends StatefulWidget {
  final bool isActive;
  final String company;
  final String component;
  final String name;
  final String description;
  final String urlProgram;
  final bool isAddOrUpdate;
  final Function(String, String, String, String, String) onAdd;
  final Function(String, String, String, String, String, bool) onUpdate;

  const ClassroomEditDS({
    Key key,
    this.isActive,
    this.company,
    this.component,
    this.name,
    this.description,
    this.urlProgram,
    this.isAddOrUpdate,
    this.onAdd,
    this.onUpdate,
  }) : super(key: key);
  @override
  _ClassroomEditDSState createState() => _ClassroomEditDSState();
}

class _ClassroomEditDSState extends State<ClassroomEditDS> {
  final formKey = GlobalKey<FormState>();
  bool _isActive;
  String _company;
  String _component;
  String _name;
  String _description;
  String _urlProgram;
  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.isAddOrUpdate
          ? widget.onAdd(_company, _component, _name, _description, _urlProgram)
          : widget.onUpdate(_company, _component, _name, _description,
              _urlProgram, _isActive);
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAddOrUpdate
            ? 'Criar #Classroom Turma'
            : 'Editar Classroom/Turma'),
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
            initialValue: widget.company,
            decoration: InputDecoration(
              labelText: 'Instituição *',
            ),
            onSaved: (newValue) => _company = newValue,
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.component,
            decoration: InputDecoration(
              labelText: 'Componente curricular *',
            ),
            onSaved: (newValue) => _component = newValue,
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.name,
            decoration: InputDecoration(
              labelText: 'Nome da turma *',
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
            initialValue: widget.urlProgram,
            decoration: InputDecoration(
              labelText: 'Link para programa',
            ),
            onSaved: (newValue) => _urlProgram = newValue,
            // validator: (value) {
            //   if (value.isEmpty) {
            //     return 'Informe o que se pede.';
            //   }
            //   return null;
            // },
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
          widget.isAddOrUpdate
              ? Container()
              : SwitchListTile(
                  value: _isActive,
                  title:
                      _isActive ? Text('Turma ativa') : Text('Desativar turma'),
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
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
