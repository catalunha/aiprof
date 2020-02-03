import 'package:flutter/material.dart';
import 'package:aiprof/auth_bloc.dart';
import 'package:aiprof/bootstrap.dart';
import 'package:aiprof/componentes/default_scaffold.dart';
import 'package:aiprof/paginas/pasta/pasta_list_bloc.dart';
import 'package:aiprof/naosuportato/url_launcher.dart' if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class PastaListPage extends StatefulWidget {
  final AuthBloc authBloc;

  const PastaListPage(this.authBloc);
  @override
  _PastaListPageState createState() => _PastaListPageState();
}

class _PastaListPageState extends State<PastaListPage> {
  PastaListBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = PastaListBloc(
      Bootstrap.instance.firestore,
      widget.authBloc,
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: Text('Pastas'),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/pasta/crud",
            arguments: null,
          );
        },
      ),
      body: StreamBuilder<PastaListBlocState>(
        stream: bloc.stateStream,
        builder:
            (BuildContext context, AsyncSnapshot<PastaListBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("Existe algo errado! Informe o suporte.");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            if (snapshot.data.pedidoRelatorio != null) {
            launch(
                'https://us-central1-pi-brintec.cloudfunctions.net/relatorioOnRequest/listaproblemasdapasta?pedido=${snapshot.data.pedidoRelatorio}');
            bloc.eventSink(ResetCreateRelatorioEvent());
          }
            List<Widget> listaWidget = List<Widget>();
            // listaWidget.add(
            //   ListTile(
            //     title: Text('Lista de pasta e problemas em planilha'),
            //     trailing: Icon(Icons.grid_on),
            //     onTap: () {
            //       bloc.eventSink(CreateRelatorioEvent(widget.turmaID));
            //     },
            //   ),
            // );
            int lengthTurma = snapshot.data.pastaList.length;

            int ordemLocal = 1;
            for (var pasta in snapshot.data.pastaList) {
              print('listando pasta: ${pasta.id}');
              listaWidget.add(
                Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('${pasta.nome}'),
                        subtitle: Text('id: ${pasta.id}'),
                      ),
                      Center(
                        child: Wrap(
                          children: <Widget>[
                            IconButton(
                              tooltip: 'Editar este pasta',
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  "/pasta/crud",
                                  arguments: pasta.id,
                                );
                              },
                            ),
                            IconButton(
                              tooltip: 'Descer ordem da turma',
                              icon: Icon(Icons.arrow_downward),
                              onPressed: (ordemLocal) < lengthTurma
                                  ? () {
                                      bloc.eventSink(
                                          OrdenarEvent(pasta, false));
                                    }
                                  : null,
                            ),
                            IconButton(
                              tooltip: 'Subir ordem da turma',
                              icon: Icon(Icons.arrow_upward),
                              onPressed: ordemLocal > 1
                                  ? () {
                                      bloc.eventSink(OrdenarEvent(pasta, true));
                                    }
                                  : null,
                            ),
                            IconButton(
                                    tooltip: 'Lista de problemas desta pasta',
                                    icon: Icon(Icons.grid_on),
                                    onPressed: () {
                                                        bloc.eventSink(CreateRelatorioEvent(pasta.id));

                                    }),
                            IconButton(
                              tooltip: 'Gerenciar situações nesta pasta',
                              icon: Icon(Icons.folder),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  "/problema/list",
                                  arguments: pasta.id,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
              ordemLocal++;
            }
            listaWidget.add(Container(
              padding: EdgeInsets.only(top: 70),
            ));

            return ListView(
              children: listaWidget,
            );
          } else {
            return Text('Existem dados inválidos. Informe o suporte.');
          }
        },
      ),
    );
  }
}
