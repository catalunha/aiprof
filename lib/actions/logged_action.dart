import 'package:aiprof/classroom/classroom_action.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// +++ Actions Sync
class AuthenticationStatusSyncLoggedAction extends ReduxAction<AppState> {
  final AuthenticationStatusLogged authenticationStatusLogged;

  AuthenticationStatusSyncLoggedAction({this.authenticationStatusLogged});

  @override
  AppState reduce() {
    print('AuthenticationStatusSyncLoggedAction...');
    return state.copyWith(
      loggedState: state.loggedState.copyWith(
        authenticationStatusLogged: this.authenticationStatusLogged,
      ),
    );
  }
}

class LoginSuccessfulSyncLoggedAction extends ReduxAction<AppState> {
  final FirebaseUser firebaseUser;

  LoginSuccessfulSyncLoggedAction({this.firebaseUser});
  @override
  AppState reduce() {
    print('LoginSuccessfulSyncLoggedAction...');
    return state.copyWith(
      loggedState: state.loggedState.copyWith(
        // authenticationStatusLogged: AuthenticationStatusLogged.authenticated,
        firebaseUserLogged: firebaseUser,
      ),
    );
  }

  @override
  void after() =>
      dispatch(GetDocsUserModelAsyncLoggedAction(id: firebaseUser.uid));
}

class LoginFailSyncLoggedAction extends ReduxAction<AppState> {
  final dynamic error;

  LoginFailSyncLoggedAction({this.error});

  @override
  AppState reduce() {
    print('LoginFailSyncLoggedAction...');
    return state.copyWith(
      loggedState: state.loggedState.copyWith(
          firebaseUserLogged: null,
          authenticationStatusLogged:
              AuthenticationStatusLogged.unAuthenticated),
    );
  }
}

class LogoutSuccessfulSyncLoggedAction extends ReduxAction<AppState> {
  LogoutSuccessfulSyncLoggedAction();
  @override
  AppState reduce() {
    print('LogoutSuccessfulSyncLoggedAction...');
    return state.copyWith(
      loggedState: state.loggedState.copyWith(
        authenticationStatusLogged: AuthenticationStatusLogged.unInitialized,
        firebaseUserLogged: null,
      ),
    );
  }
}

class CurrentUserModelSyncLoggedAction extends ReduxAction<AppState> {
  final UserModel userModel;

  CurrentUserModelSyncLoggedAction({this.userModel});
  @override
  AppState reduce() {
    print('CurrentUserModelSyncLoggedAction...');
    return state.copyWith(
      loggedState: state.loggedState.copyWith(
        userModelLogged: userModel,
      ),
      // userState: state.userState.copyWith(
      //   userCurrent: userModel,
      // ),
    );
  }
}

class GetDocUserAsyncUserAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('GetDocUserAsyncUserAction...');
    Firestore firestore = Firestore.instance;

    final docRef = firestore
        .collection(UserModel.collection)
        .document(state.loggedState.userModelLogged.id);

    final docsSnap = await docRef.get();

    UserModel userModel = UserModel(docsSnap.documentID).fromMap(docsSnap.data);
    return state.copyWith(
      loggedState: state.loggedState.copyWith(
        userModelLogged: userModel,
      ),
    );
  }

  // @override
  // void after() => dispatch(StreamColClassroomAsyncClassroomAction());
}

// class UpdateDocUserModelAsyncLoggedAction extends ReduxAction<AppState> {
//   final dynamic dateTimeOnBoard;

//   UpdateDocUserModelAsyncLoggedAction({
//     this.dateTimeOnBoard,
//   });
//   @override
//   Future<AppState> reduce() async {
//     print('UpdateDocUserModelAsyncLoggedAction...');
//     Firestore firestore = Firestore.instance;
//     UserModel userModel = state.loggedState.userModelLogged;
//     final colRef =
//         firestore.collection(UserModel.collection).document(userModel.id);
//     await colRef.updateData(userModel.toMap());
//     return state.copyWith(
//       loggedState: state.loggedState.copyWith(
//         userModelLogged: userModel,
//       ),
//     );
//   }
// }
// +++ Actions Async

class LoginEmailPasswordAsyncLoggedAction extends ReduxAction<AppState> {
  final String email;
  final String password;

  LoginEmailPasswordAsyncLoggedAction({this.email, this.password});
  @override
  Future<AppState> reduce() async {
    print('LoginEmailPasswordAsyncLoggedAction...');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser;
    try {
      store.dispatch(AuthenticationStatusSyncLoggedAction(
          authenticationStatusLogged:
              AuthenticationStatusLogged.authenticating));
      final AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = authResult.user;
      assert(!firebaseUser.isAnonymous);
      assert(await firebaseUser.getIdToken() != null);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(firebaseUser.uid == currentUser.uid);
      store.dispatch(
          LoginSuccessfulSyncLoggedAction(firebaseUser: firebaseUser));

      print(
          '_userLoginEmailPasswordAction: Login bem sucedido. ${currentUser.uid}');
    } catch (error) {
      store.dispatch(LoginFailSyncLoggedAction(error: error));
      print('_userLoginEmailPasswordAction: Login MAL sucedido. $error');
    }
    return null;
  }
}

class ResetPasswordAsyncLoggedAction extends ReduxAction<AppState> {
  final String email;

  ResetPasswordAsyncLoggedAction({this.email});
  @override
  Future<AppState> reduce() async {
    print('ResetPasswordAsyncLoggedAction...');
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      store.dispatch(AuthenticationStatusSyncLoggedAction(
          authenticationStatusLogged:
              AuthenticationStatusLogged.sendPasswordReset));
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      store.dispatch(LoginFailSyncLoggedAction());
    }
    return null;
  }
}

class LogoutAsyncLoggedAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('LogoutAsyncLoggedAction...');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signOut();
      store.dispatch(LogoutSuccessfulSyncLoggedAction());
      print('_userLogoutAction: Logout finalizado.');
    } catch (error) {
      print('_userLogoutAction: error: $error');
    }
    return null;
  }
}

// class OnAuthStateChangedSyncLoggedAction extends ReduxAction<AppState> {
//   @override
//   Future<AppState> reduce() async {
//     print('OnAuthStateChangedSyncLoggedAction...');
//     FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//     await firebaseAuth.currentUser().then((firebaseUser) {
//       if (firebaseUser?.uid != null) {
//         print('Auth de ultimo login uid: ${firebaseUser.uid}');
//         store.dispatch(
//             LoginSuccessfulSyncLoggedAction(firebaseUser: firebaseUser));
//       }
//     });
//     return null;
//   }
// }

class OnAuthStateChangedSyncLoggedAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('OnAuthStateChangedSyncLoggedAction...');

    FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      if (event == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        print('Auth de ultimo login uid: ${event.uid}');
        store.dispatch(LoginSuccessfulSyncLoggedAction(firebaseUser: event));
      }
    });
    return null;
  }
}

class GetDocsUserModelAsyncLoggedAction extends ReduxAction<AppState> {
  final String id;

  GetDocsUserModelAsyncLoggedAction({this.id});
  @override
  Future<AppState> reduce() async {
    print('GetDocsUserModelAsyncLoggedAction...$id');
    Firestore firestore = Firestore.instance;

    final docRef = firestore.collection(UserModel.collection).document(id);
    final docSnap = await docRef.get();
    if (docSnap.exists) {
      if (docSnap.data['isTeacher']) {
        print('É professor liberar acesso.');
        dispatch(CurrentUserModelSyncLoggedAction(
            userModel: UserModel(docSnap.documentID).fromMap(docSnap.data)));
        store.dispatch(AuthenticationStatusSyncLoggedAction(
            authenticationStatusLogged:
                AuthenticationStatusLogged.authenticated));
      } else {
        print('É estudante bloquear acesso.');
        dispatch(LogoutAsyncLoggedAction());
      }
    } else {
      // dispatch(CurrentUserModelSyncLoggedAction(
      //     userModel: UserModel(id)
      //         .fromMap({'email': state.loggedState.firebaseUserLogged.email})));

      dispatch(LogoutAsyncLoggedAction());
    }
    // if (docSnap.exists) {
    //   dispatch(CurrentUserModelSyncLoggedAction(
    //       userModel: UserModel(docSnap.documentID).fromMap(docSnap.data)));
    // } else {
    //   dispatch(CurrentUserModelSyncLoggedAction(
    //       userModel: UserModel(id)
    //           .fromMap({'email': state.loggedState.firebaseUserLogged.email})));

    //   // authenticationStatusLogged: AuthenticationStatusLogged.authenticated,

    // }
    // store.dispatch(AuthenticationStatusSyncLoggedAction(
    //     authenticationStatusLogged: AuthenticationStatusLogged.authenticated));
    return null;
  }
}
