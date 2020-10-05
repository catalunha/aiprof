import 'package:flutter/material.dart';

class StudentEditDS extends StatefulWidget {
  final Function(String) onAdd;

  const StudentEditDS({
    Key key,
    this.onAdd,
  }) : super(key: key);
  @override
  _StudentEditDSState createState() => _StudentEditDSState();
}

class _StudentEditDSState extends State<StudentEditDS> {
  final formKey = GlobalKey<FormState>();

  String _studentsToImport;
  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.onAdd(_studentsToImport);
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
        title: Text('Importando #student estudantes'),
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
          Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                'Informe a lista de alunos a serem cadastrados.\nUsando o ponto e vírgula para separar as informações.\nUse o formato:\nmatricula ; email ; nome completo do aluno',
                style: TextStyle(fontSize: 15, color: Colors.blue),
              )),
          TextFormField(
            // initialValue:,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Lista de estudantes a serem importados',
            ),
            onSaved: (newValue) => _studentsToImport = newValue,
            // validator: (value) {
            //   if (value.isEmpty) {
            //     return 'Informe o que se pede.';
            //   }
            //   return null;
            // },
          ),
          Container(
            height: 50,
          ),
        ],
      ),
    );
  }
}
