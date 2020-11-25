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
  final Function(String, String, String, String, String, bool, bool) onUpdate;

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
  bool _isDelete = false;
  bool isInvisibilityDelete = true;

  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.isAddOrUpdate
          ? widget.onAdd(_company, _component, _name, _description, _urlProgram)
          : widget.onUpdate(_company, _component, _name, _description,
              _urlProgram, _isActive, _isDelete);
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
        title: Text(widget.isAddOrUpdate ? 'Criar Turma' : 'Editar Turma'),
      ),
      body: Center(
        child: Container(
          width: 600,
          child: Padding(
            padding: EdgeInsets.all(2),
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
                                ? Text('Turma será apagada.')
                                : Text('Remover esta turma ?'),
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
}
