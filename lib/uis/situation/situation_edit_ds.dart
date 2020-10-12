import 'package:flutter/material.dart';

class SituationEditDS extends StatefulWidget {
  final String area;
  final String name;
  final String description;
  final String url;
  final bool isActive;
  final bool isAddOrUpdate;
  final Function(String, String, String, String) onAdd;
  final Function(String, String, String, String, bool, bool) onUpdate;

  const SituationEditDS({
    Key key,
    this.area,
    this.name,
    this.description,
    this.url,
    this.isActive,
    this.isAddOrUpdate,
    this.onAdd,
    this.onUpdate,
  }) : super(key: key);
  @override
  _SituationEditDSState createState() => _SituationEditDSState();
}

class _SituationEditDSState extends State<SituationEditDS> {
  final formKey = GlobalKey<FormState>();
  bool isInvisibilityDelete = true;

  String _area;
  String _name;
  String _description;
  String _url;
  bool _isActive;
  bool _isDelete = false;
  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.isAddOrUpdate
          ? widget.onAdd(_area, _name, _description, _url)
          : widget.onUpdate(
              _area, _name, _description, _url, _isActive, _isDelete);
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
        title:
            Text(widget.isAddOrUpdate ? 'Criar situação' : 'Editar situação'),
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
            initialValue: widget.area,
            decoration: InputDecoration(
              labelText: 'Area *',
            ),
            onSaved: (newValue) => _area = newValue,
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
              labelText: 'Nome da situação *',
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
            initialValue: widget.url,
            decoration: InputDecoration(
              labelText: 'Link para situação *',
            ),
            onSaved: (newValue) => _url = newValue,
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
          widget.isAddOrUpdate
              ? Container()
              : SwitchListTile(
                  value: _isActive,
                  title: _isActive
                      ? Text('Situação ativa')
                      : Text('Desativar situação'),
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
                                ? Text('Situação será apagada.')
                                : Text('Remover esta situação ?'),
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
