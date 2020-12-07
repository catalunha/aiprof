import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

@immutable
class DataSourceState {
  final Future<FirebaseApp> firebaseApp;
  final FirebaseFirestore firebaseFirestoreRemote;
  final FirebaseFirestore firebaseFirestoreLocal;
  DataSourceState({
    this.firebaseApp,
    this.firebaseFirestoreRemote,
    this.firebaseFirestoreLocal,
  });

  factory DataSourceState.initialState() => DataSourceState(
        firebaseApp: null,
        firebaseFirestoreRemote: null,
        firebaseFirestoreLocal: null,
      );
  DataSourceState copyWith({
    Future<FirebaseApp> firebaseApp,
    FirebaseFirestore firebaseFirestoreRemote,
    FirebaseFirestore firebaseFirestoreLocal,
  }) =>
      DataSourceState(
        firebaseApp: firebaseApp ?? this.firebaseApp,
        firebaseFirestoreRemote:
            firebaseFirestoreRemote ?? this.firebaseFirestoreRemote,
        firebaseFirestoreLocal:
            firebaseFirestoreLocal ?? this.firebaseFirestoreLocal,
      );
  @override
  int get hashCode =>
      firebaseApp.hashCode ^
      firebaseFirestoreLocal.hashCode ^
      firebaseFirestoreRemote.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataSourceState &&
          firebaseApp == other.firebaseApp &&
          firebaseFirestoreLocal == other.firebaseFirestoreLocal &&
          firebaseFirestoreRemote == other.firebaseFirestoreRemote &&
          runtimeType == other.runtimeType;
}
