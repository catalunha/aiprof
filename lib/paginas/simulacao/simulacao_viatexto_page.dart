import 'package:aiprof/paginas/simulacao/simulacao_viatexto_bloc.dart';
import 'package:flutter/material.dart';
import 'package:aiprof/bootstrap.dart';

class SimulacaoViatextoPage extends StatefulWidget {
  final String problemaID;

  const SimulacaoViatextoPage(this.problemaID);

  @override
  _SimulacaoViatextoPageState createState() => _SimulacaoViatextoPageState();
}

class _SimulacaoViatextoPageState extends State<SimulacaoViatextoPage> {
  SimulacaoViatextoBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = SimulacaoViatextoBloc(
      Bootstrap.instance.firestore,
    );
    bloc.eventSink(GetProblemaEvent(widget.problemaID));
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar simulação em texto'),
      ),
      floatingActionButton: StreamBuilder<SimulacaoViatextoBlocState>(
          stream: bloc.stateStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return FloatingActionButton(
              onPressed: snapshot.data.isDataValid
                  ? () {
                      bloc.eventSink(CadastrarSimulacaoEvent());
                      Navigator.pop(context);
                    }
                  : null,
              child: Icon(Icons.cloud_upload),
              backgroundColor: snapshot.data.isDataValid ? Colors.blue : Colors.grey,
            );
          }),
      body: StreamBuilder<SimulacaoViatextoBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context, AsyncSnapshot<SimulacaoViatextoBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("Existe algo errado! Informe o suporte.");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
         
          return ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Informe a lista de simulacoes a serem cadastrados.\nUsando o ponto e vírgula para separar as informações.\nUse o formato:\n* simulacaoNome ; tipoCadastro ; ordem ; nome ; tipoValor ; valor\ntipoCadastro pode ser valor ou gabarito.\nSe tipoCadastro é valor tipoValor pode ser numero|palavra|texto|link|linkImagem\nSe tipoCadastro é gabarito tipoValor pode ser numero|palavra|texto|link|linkImagem|Anexo|AnexoImagem',
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  )),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: CadastrarSimulacao(bloc),
              ),
              ListTile(
                trailing: Icon(Icons.thumbs_up_down),
                title: Text('Click aqui para conferir a lista antes de cadastrar'),
                onTap: () {
                  bloc.eventSink(UpdateAnalisarListaSimulacoesEvent());
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      elevation: 5,
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            title: Text("Lista após análise. Se estiver consistente pode enviar para cadastro."),
                          ),
                          for (var item in snapshot.data.simulacoesEmLista)
                            ListTile(
                              title: Text('Simulação nome: ${item[0]}\nTipo: ${item[1]}\nordem: ${item[2]}\nnome: ${item[3]}\nValor tipo: ${item[4]}\nValor: ${item[5]}'),
                            ),
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Container(
                padding: EdgeInsets.only(top: 70),
              ),
            ],
          );
        },
      ),
    );
  }
}

// sim1;valor;1;x;numero;11
// sim1;gabarito;1;a;numero;22
// sim1;gabarito;2;b;numero;33
// sim2;valor;1;x;numero;44
// sim2;valor;1;y;numero;55
// sim2;gabarito;1;a;numero;66
// sim3;gabarito;1;a;numero;77


class CadastrarSimulacao extends StatefulWidget {
  final SimulacaoViatextoBloc bloc;
  CadastrarSimulacao(this.bloc);
  @override
  CadastrarSimulacaoState createState() {
    return CadastrarSimulacaoState(bloc);
  }
}

class CadastrarSimulacaoState extends State<CadastrarSimulacao> {
  final _textFieldController = TextEditingController();
  final SimulacaoViatextoBloc bloc;
  CadastrarSimulacaoState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SimulacaoViatextoBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot<SimulacaoViatextoBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.simulacoesEmTexto;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateSimulacoesEmtextoEvent(text));
          },
        );
      },
    );
  }
}
