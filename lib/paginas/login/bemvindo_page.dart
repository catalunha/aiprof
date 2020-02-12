import 'package:flutter/material.dart';
import 'package:aiprof/auth_bloc.dart';
import 'package:aiprof/componentes/default_scaffold.dart';
import 'package:aiprof/paginas/login/bemvindo_bloc.dart';

class BemVindoPage extends StatefulWidget {
  final AuthBloc authBloc;

  BemVindoPage(this.authBloc);

  _BemVindoPageState createState() => _BemVindoPageState(this.authBloc);
}

class _BemVindoPageState extends State<BemVindoPage> {
  BemvindoBloc bloc;
  _BemVindoPageState(AuthBloc authBloc) : bloc = BemvindoBloc(authBloc);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: StreamBuilder<BemvindoBlocState>(
        stream: bloc.stateStream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Text("ERROR");
          }
          if (!snap.hasData) {
            return Text("Buscando usuario...");
          }
          return Text("Oi Prof. ${snap.data?.usuario?.cracha}");
        },
      ),
      body: Center(
        child: Text(
            "Seja bem vindo(a)\nAo Aplicativo AI, versão para professor.\nAqui você cria e distribui de forma simples\nsuas tarefas aos alunos da escola, curso ou faculdade.\nGerando uma questão com valores individuais por aluno.",
            style: TextStyle(
              color: Colors.green,
              fontSize: 22.0,
            ),
            textAlign: TextAlign.center),
      ),
    );
  }
}
