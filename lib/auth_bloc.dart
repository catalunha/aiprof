import 'dart:async';
import 'package:aiprof/modelos/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:firebaseauth_wrapper/firebaseauth_wrapper.dart' as fba;

enum AuthStatus {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
}

class AuthBlocEvent {}

class UpdateEmailAuthBlocEvent extends AuthBlocEvent {
  final String email;

  UpdateEmailAuthBlocEvent(this.email);
}

class UpdatePasswordAuthBlocEvent extends AuthBlocEvent {
  final String password;

  UpdatePasswordAuthBlocEvent(this.password);
}

class LoginAuthBlocEvent extends AuthBlocEvent {}

class LogoutAuthBlocEvent extends AuthBlocEvent {}

class ResetPassword extends AuthBlocEvent {}

class EhProfessor extends AuthBlocEvent {}

class AuthBlocState {
  String usuarioID;
  String email;
  String password;
}

class AuthBloc {
  // Database
  final fsw.Firestore _firestore;

  //API
  final fba.FirebaseAuth _authApi;

  //AuthStatus
  final _statusController = BehaviorSubject<AuthStatus>.seeded(AuthStatus.Uninitialized);

  Stream<AuthStatus> get status => _statusController.stream;

  //State
  final _state = AuthBlocState();

  //TODO: Creio q esta stream foi abandonada no codigo.
  final _userId = BehaviorSubject<String>();

  Stream<String> get userId => _userId.stream;

  //Usuario Model
  final _perfilController = BehaviorSubject<UsuarioModel>();
  StreamSubscription<UsuarioModel> _perfilSubscription;

  Stream<UsuarioModel> get perfil => _perfilController.stream;

  //Event
  final _inputController = BehaviorSubject<AuthBlocEvent>();

  Function get dispatch => _inputController.sink.add;

  // final dynamic firebaseMessaging = new FirebaseMessaging();

  AuthBloc(this._authApi, this._firestore) : assert(_authApi != null) {
    _statusController.sink.add(AuthStatus.Unauthenticated);
    var stream = _authApi.onUserIdChange.where((userId) => userId != null);
    stream.listen(_getPerfilUsuarioFromFirebaseUser);
    stream.listen(_getUserId);
    stream.listen(_setpushTokenfromUsuario);

    _authApi.onUserIdChange.listen(_updateStatus);
    _inputController.stream.listen(_handleInputEvent);
    // NotificacaoService.registerNotification();
  }

  void dispose() async {
    await _perfilController.drain();
    _perfilController.close();
    await _userId.drain();
    _userId.close();
    _perfilSubscription.cancel();
    await _statusController.drain();
    _statusController.close();
    await _inputController.drain();
    _inputController.close();
  }

  void _setpushTokenfromUsuario(String userId) {
    // firebaseMessaging.getToken().then((token) {
    //   _firestore
    //       .collection(UsuarioModel.collection)
    //       .document(userId)
    //       .setData({'tokenFCM': token}, merge: true);
    // }).catchError((err) {
    //   // print('authbloc: '+err.message.toString());
    // });
  }

  void _getPerfilUsuarioFromFirebaseUser(String userId) {
    _state.usuarioID = userId;
    // print('_state.usuarioID: ' + _state.usuarioID);
    final perfilRef = _firestore.collection(UsuarioModel.collection).document(userId);
    // print('perfilRef.documentID: ' + perfilRef.documentID);

    final perfilStream =
        perfilRef.snapshots().map((perfilSnap) => UsuarioModel(id: perfilSnap.documentID).fromMap(perfilSnap.data));

    // final perfilStream = perfilRef.snapshots().map((perfilSnap) {
    //   // print('perfilSnap.documentID: '+perfilSnap.documentID);
    //   return UsuarioModel(id: perfilSnap.documentID).fromMap(perfilSnap.data);
    // });
    // print('+++');
perfilStream.listen((usuarioModel){
// print('usuarioModel.nome:' + usuarioModel.nome);
});
    // print('---');
    if (_perfilSubscription != null) {
      _perfilSubscription.cancel().then((_) {
        _perfilSubscription = perfilStream.listen(_pipPerfil);
      });
    } else {
      _perfilSubscription = perfilStream.listen(_pipPerfil);
    }
  }

  void _getUserId(String userId) {
    _userId.sink.add(userId);
  }

  void _pipPerfil(UsuarioModel usuarioModel) {
    _perfilController.sink.add(usuarioModel);
    // print('+++Usuario: ${usuarioModel.nome} é professor: ${usuarioModel.professor}');
    if (!usuarioModel.professor) {
      // print('Usuario logout: ${usuarioModel.nome} é professor: ${usuarioModel.professor}');
      _authApi.logout();
    }
    // print('---Usuario: ${usuarioModel.nome} é professor: ${usuarioModel.professor}');
  }

  void _updateStatus(String userId) {
    if (userId == null) {
      _statusController.sink.add(AuthStatus.Unauthenticated);
    } else {
      _statusController.sink.add(AuthStatus.Authenticated);
    }
  }

  void _handleInputEvent(AuthBlocEvent event) {
    if (event is UpdateEmailAuthBlocEvent) {
      _state.email = event.email;
    } else if (event is UpdatePasswordAuthBlocEvent) {
      _state.password = event.password;
    } else if (event is LoginAuthBlocEvent) {
      _handleLoginAuthBlocEvent();
    } else if (event is LogoutAuthBlocEvent) {
      _authApi.logout();
    } else if (event is ResetPassword) {
      _authApi.sendPasswordResetEmail(_state.email);
    // } else if (event is EhProfessor) {
    //   _authApi.sendPasswordResetEmail(_state.email);
    }
  }

  void _handleLoginAuthBlocEvent() {
    _statusController.sink.add(AuthStatus.Authenticating);
    _authApi.loginWithEmailAndPassword(_state.email, _state.password).then((r) {
      if (r) {
        _statusController.sink.add(AuthStatus.Authenticated);
      } else {
        _statusController.sink.add(AuthStatus.Unauthenticated);
      }
    });
  }
}
