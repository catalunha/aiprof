import 'package:flutter/material.dart';

class FolderEditDS extends StatefulWidget {
  final String name;
  final String description;
  final bool isCreateOrUpdate;
  final Function(String, String) onCreate;
  final Function(String, String, bool) onUpdate;

  const FolderEditDS({
    Key key,
    this.name,
    this.description,
    this.isCreateOrUpdate,
    this.onCreate,
    this.onUpdate,
  }) : super(key: key);
  @override
  _FolderEditDSState createState() => _FolderEditDSState();
}

class _FolderEditDSState extends State<FolderEditDS> {
  final formKey = GlobalKey<FormState>();
  String _name;
  String _description;
  bool _remover = false;

  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.isCreateOrUpdate
          ? widget.onCreate(_name, _description)
          : widget.onUpdate(_name, _description, _remover);
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
        title: Text(widget.isCreateOrUpdate ? 'Criar folder' : 'Editar folder'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
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
              labelText: 'Nome do folder',
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
            decoration: InputDecoration(
              labelText: 'Descrição do folder',
            ),
            onSaved: (newValue) => _description = newValue,
            // validator: (value) {
            //   if (value.isEmpty) {
            //     return 'Informe o que se pede.';
            //   }
            //   return null;
            // },
          ),
          widget.isCreateOrUpdate
              ? Container()
              : SwitchListTile(
                  value: _remover,
                  title: Text(
                      'Remover este folder e todos abaixo. Isto não remove as situações.'),
                  onChanged: (value) {
                    setState(() {
                      _remover = value;
                    });
                  },
                ),
        ],
      ),
    );
  }
}
