import 'package:flutter/material.dart';

class OutputEditDS extends StatefulWidget {
  final String name;
  final String type;
  final String value;
  final bool isAddOrUpdate;
  final Function(String, String, String) onAdd;
  final Function(String, String, String, bool) onUpdate;

  const OutputEditDS({
    Key key,
    this.name,
    this.type,
    this.value,
    this.isAddOrUpdate,
    this.onAdd,
    this.onUpdate,
  }) : super(key: key);
  @override
  _OutputEditDSState createState() => _OutputEditDSState();
}

class _OutputEditDSState extends State<OutputEditDS> {
  final formKey = GlobalKey<FormState>();
  String _name;
  String _type;
  String _value;
  bool _isDelete = false;
  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.isAddOrUpdate
          ? widget.onAdd(_name, _type, _value)
          : widget.onUpdate(_name, _type, _value, _isDelete);
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _type = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAddOrUpdate
            ? 'Criar #output saída'
            : 'Editar #output saída'),
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
              labelText: 'Nome da saída *',
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
            height: 10,
          ),
          Text('Tipo da saída * $_type'),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 'numero',
                    groupValue: _type,
                    onChanged: (radioValue) {
                      setState(() {
                        _type = radioValue;
                      });
                    },
                  ),
                  IconButton(
                    tooltip: 'Um número inteiro ou decimal',
                    icon: Icon(Icons.looks_one),
                    onPressed: () {},
                  ),
                ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 'palavra',
                    groupValue: _type,
                    onChanged: (radioValue) {
                      setState(() {
                        _type = radioValue;
                      });
                    },
                  ),
                  IconButton(
                    tooltip: 'Um palavra ou frase curta',
                    icon: Icon(Icons.text_format),
                    onPressed: () {},
                  ),
                ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 'texto',
                    groupValue: _type,
                    onChanged: (radioValue) {
                      setState(() {
                        _type = radioValue;
                      });
                    },
                  ),
                  IconButton(
                    tooltip: 'Um texto com várias linhas',
                    icon: Icon(Icons.text_fields),
                    onPressed: () {},
                  ),
                ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 'url',
                    groupValue: _type,
                    onChanged: (radioValue) {
                      setState(() {
                        _type = radioValue;
                      });
                    },
                  ),
                  IconButton(
                    tooltip: 'Um link ou URL ao um site ou arquivo',
                    icon: Icon(Icons.link),
                    onPressed: () {},
                  ),
                ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 'arquivo',
                    groupValue: _type,
                    onChanged: (radioValue) {
                      setState(() {
                        _type = radioValue;
                      });
                    },
                  ),
                  IconButton(
                    tooltip: 'Upload de arquivo ou imagem',
                    icon: Icon(Icons.description),
                    onPressed: () {},
                  ),
                ]),
          ]),
          TextFormField(
            initialValue: widget.value,
            decoration: InputDecoration(
              labelText: 'Valor da saída *',
            ),
            onSaved: (newValue) => _value = newValue,
            validator: (value) {
              if (value.isEmpty) {
                return 'Informe o que se pede.';
              }
              return null;
            },
          ),
          widget.isAddOrUpdate
              ? Container()
              : SwitchListTile(
                  value: _isDelete,
                  title: _isDelete
                      ? Text('Entrada será removida.')
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
}
