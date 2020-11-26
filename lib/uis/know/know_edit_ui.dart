import 'package:flutter/material.dart';

class KnowEditUI extends StatefulWidget {
  final String name;
  final String description;
  final bool isAddOrUpdate;
  final Function(String, String) onAdd;
  final Function(String, String, bool) onUpdate;

  const KnowEditUI({
    Key key,
    this.name,
    this.description,
    this.isAddOrUpdate,
    this.onAdd,
    this.onUpdate,
  }) : super(key: key);
  @override
  _KnowEditUIState createState() => _KnowEditUIState();
}

class _KnowEditUIState extends State<KnowEditUI> {
  final formKey = GlobalKey<FormState>();
  bool isInvisibilityDelete = true;

  String _description;
  String _name;
  bool _isDelete = false;

  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.isAddOrUpdate
          ? widget.onAdd(_name, _description)
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
            ? 'Criar conhecimento'
            : 'Editar conhecimento'),
      ),
      body: Center(
        child: Container(
          width: 600,
          child: Padding(
            padding: EdgeInsets.all(16),
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
              labelText: 'Nome',
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isInvisibilityDelete
                        ? Container()
                        : SwitchListTile(
                            value: _isDelete,
                            title: _isDelete
                                ? Text('Área será apagada.')
                                : Text('Remover esta área ?'),
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
