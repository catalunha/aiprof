import 'package:aiprof/bootstrap.dart';
import 'package:aiprof/modelos/problema_model.dart';
import 'package:aiprof/modelos/simulacao_model.dart';
import 'package:aiprof/modelos/turma_model.dart';
import 'package:aiprof/modelos/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:aiprof/modelos/usuario_novo_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart' as uuid;

class SimulacaoViatextoBlocEvent {}

class GetProblemaEvent extends SimulacaoViatextoBlocEvent {
  final String problemaId;

  GetProblemaEvent(this.problemaId);
}

class UpdateSimulacoesEmtextoEvent extends SimulacaoViatextoBlocEvent {
  final String simulacoesEmTexto;

  UpdateSimulacoesEmtextoEvent(this.simulacoesEmTexto);
}

class UpdateAnalisarListaSimulacoesEvent extends SimulacaoViatextoBlocEvent {}

class NotaListEvent extends SimulacaoViatextoBlocEvent {
  final String problemaId;

  NotaListEvent(this.problemaId);
}

class CadastrarSimulacaoEvent extends SimulacaoViatextoBlocEvent {}

class SimulacaoViatextoBlocState {
  bool isDataValid = false;
  ProblemaModel problema = ProblemaModel();
  String simulacoesEmTexto;
  List<List<String>> simulacoesEmLista = List<List<String>>();
}

class SimulacaoViatextoBloc {
  /// Firestore
  final fsw.Firestore _firestore;
  // final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<SimulacaoViatextoBlocEvent>();
  Stream<SimulacaoViatextoBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final SimulacaoViatextoBlocState _state = SimulacaoViatextoBlocState();
  final _stateController = BehaviorSubject<SimulacaoViatextoBlocState>();
  Stream<SimulacaoViatextoBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  SimulacaoViatextoBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = true;
    if (_state.simulacoesEmLista == null || _state.simulacoesEmLista.isEmpty || _state.simulacoesEmLista.length == 0) {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(SimulacaoViatextoBlocEvent event) async {
    if (event is GetProblemaEvent) {
      final docRef = _firestore.collection(ProblemaModel.collection).document(event.problemaId);
      final snap = await docRef.get();
      if (snap.exists) {
        _state.problema = ProblemaModel(id: snap.documentID).fromMap(snap.data);
      }
    }

    if (event is UpdateSimulacoesEmtextoEvent) {
      _state.simulacoesEmTexto = event.simulacoesEmTexto.trim();
    }
    if (event is UpdateAnalisarListaSimulacoesEvent) {
      _state.simulacoesEmLista.clear();
// sim1;valor;1;x;numero;123
// sim1;gabarito;1;a;numero;1.23
// sim1;gabarito;2;b;numero;456

      String simulacaoNome; //0
      String tipoCadastro; //1
      String ordem; //2
      String nome; //3
      String tipoValor; //4
      String valor; //5
      if (_state.simulacoesEmTexto != null) {
        List<String> linhas = _state.simulacoesEmTexto.split('\n');
        for (var linha in linhas) {
          if (linha != null) {
            List<String> campos = linha.trim().split(';');
            if (campos != null &&
                campos.length == 6 &&
                (campos[1].contains('valor') || campos[1].contains('gabarito')) &&
                (campos[4].contains('numero') ||
                    campos[4].contains('palavra') ||
                    campos[4].contains('texto') ||
                    campos[4].contains('link') ||
                    campos[4].contains('linkImagem') ||
                    campos[4].contains('Anexo') ||
                    campos[4].contains('AnexoImagem'))) {
              simulacaoNome = campos[0].trim();
              tipoCadastro = campos[1].trim();
              ordem = campos[2].trim();
              nome = campos[3].trim();
              tipoValor = campos[4].trim();
              valor = campos[5].trim();
              _state.simulacoesEmLista.add([simulacaoNome, tipoCadastro, ordem, nome, tipoValor, valor]);
            }
          }
        }
      }
    }

    if (event is CadastrarSimulacaoEvent) {
      if (_state.simulacoesEmLista != null &&
          _state.simulacoesEmLista.isNotEmpty &&
          _state.simulacoesEmLista.length > 0) {
        String simulacaoNome; //0
        String tipoCadastro; //1
        String ordem; //2
        String nome; //3
        String tipoValor; //4
        String valor; //5
        String simulacaoAtual;
        SimulacaoModel simulacao = SimulacaoModel();
        Variavel variavel = Variavel();
        Gabarito gabarito = Gabarito();

        for (var simulacaoLinha in _state.simulacoesEmLista) {
          simulacaoNome = simulacaoLinha[0];
          tipoCadastro = simulacaoLinha[1];
          ordem = simulacaoLinha[2];
          nome = simulacaoLinha[3];
          tipoValor = simulacaoLinha[4];
          valor = simulacaoLinha[5];

          if (simulacaoAtual == null) {
            simulacaoAtual = simulacaoNome;
            simulacao.nome = simulacaoNome;
            simulacao.ordem = 0;
            simulacao.numero = (_state.problema.simulacaoNumero ?? 0) + 1;
            simulacao.professor = UsuarioFk(id: _state.problema.professor.id, nome: _state.problema.professor.nome);
            simulacao.problema = ProblemaFk(id: _state.problema.id, nome: _state.problema.nome);
          }
          if (simulacaoAtual == simulacaoNome && tipoCadastro == 'valor') {
            Variavel variavelUpdate = Variavel(
              ordem: simulacao.ordem ?? 1,
              nome: nome,
              tipo: tipoValor,
              valor: valor,
            );
            simulacao.ordem = simulacao.ordem + 1;
            final uuidG = uuid.Uuid();
            simulacao.variavel = {uuidG.v4(): variavelUpdate};
          }
          if (simulacaoAtual == simulacaoNome && tipoCadastro == 'gabarito') {
            Gabarito gabaritoUpdate = Gabarito(
              ordem: simulacao.ordem ?? 1,
              nome: nome,
              tipo: tipoValor,
              valor: valor,
            );
            simulacao.ordem = simulacao.ordem + 1;
            final uuidG = uuid.Uuid();
            simulacao.gabarito = {uuidG.v4(): gabaritoUpdate};
          }
          if (simulacaoAtual != simulacaoNome) {
            print(simulacao);
            // // +++ Gravar a simulacao atual
            // final docRef = _firestore.collection(SimulacaoModel.collection).document();
            // await docRef.setData(simulacao.toMap(), merge: true).then((_) async {
            //   //+++ Atualizar problema com mais uma em seu cadastro
            //   final usuarioDocRef = _firestore.collection(ProblemaModel.collection).document(_state.problema.id);
            //   await usuarioDocRef.setData({
            //     'simulacaoNumero': Bootstrap.instance.fieldValue.increment(1),
            //   }, merge: true);
            //   //---
            // });
            // // --- Gravar a simulacao atual
            simulacaoAtual = null;
            simulacao=null;
          }
        }
      }
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em SimulacaoViatextoBloc  = ${event.runtimeType}');
  }
}