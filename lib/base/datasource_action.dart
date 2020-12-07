import 'package:aiprof/app_state.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SetFirebaseApp extends ReduxAction<AppState> {
  final Future<FirebaseApp> firebaseApp;
  SetFirebaseApp(this.firebaseApp);
  @override
  AppState reduce() {
    return state.copyWith(
      dataSourceState: state.dataSourceState.copyWith(
        firebaseApp: firebaseApp,
      ),
    );
  }
}

class SetRemoteFirebaseFirestore extends ReduxAction<AppState> {
  final FirebaseFirestore firebaseFirestoreRemote;
  SetRemoteFirebaseFirestore(this.firebaseFirestoreRemote);
  @override
  AppState reduce() {
    return state.copyWith(
      dataSourceState: state.dataSourceState.copyWith(
        firebaseFirestoreRemote: firebaseFirestoreRemote,
      ),
    );
  }
}

class SetLocalFirebaseFirestore extends ReduxAction<AppState> {
  final FirebaseFirestore firebaseFirestoreLocal;
  SetLocalFirebaseFirestore(this.firebaseFirestoreLocal);
  @override
  AppState reduce() {
    return state.copyWith(
      dataSourceState: state.dataSourceState.copyWith(
        firebaseFirestoreLocal: firebaseFirestoreLocal,
      ),
    );
  }
}
