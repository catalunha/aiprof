import 'package:flutter/material.dart';

class FolderEditDS extends StatefulWidget {
  final String name;
  final String description;
  final bool isAddOrUpdate;
  final Function(String, String) onCreate;
  final Function(String, String, bool) onUpdate;

  const FolderEditDS({
    Key key,
    this.name,
    this.description,
    this.isAddOrUpdate,
    this.onCreate,
    this.onUpdate,
  }) : super(key: key);
  @override
  _FolderEditDSState createState() => _FolderEditDSState();
}

class _FolderEditDSState extends State<FolderEditDS> {
  final formKey = GlobalKey<FormState>();
  bool isInvisibilityDelete = true;

  String _name;
  String _description;
  bool _isDelete = false;

  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.isAddOrUpdate
          ? widget.onCreate(_name, _description)
          : widget.onUpdate(_name, _description, _isDelete);
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
        title: Text(widget.isAddOrUpdate
            ? 'Criar #folder Pasta'
            : 'Editar #folder Pasta'),
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
                                ? Text('Pasta será apagada.')
                                : Text(
                                    'Remover esta pasta e seu conteúdo ? Isto não remove as situações originais.'),
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
        ],
      ),
    );
  }
}
