import 'package:aiprof/app_state.dart';
import 'package:aiprof/base/datasource_action.dart';
import 'package:aiprof/login/logged_action.dart';
import 'package:aiprof/routes.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Store<AppState> _store = Store<AppState>(
  initialState: AppState.initialState(),
);
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NavigateAction.setNavigatorKey(Keys.navigatorStateKey);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({Key key})
      : store = _store,
        super(key: key) {
    // store.dispatch(OnAuthStateChangedSyncLoggedAction());
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('Erro inicialização em Firebase.initializeApp()');
          // return SomethingWentWrong();
          return null;
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          store.dispatch(SetFirebaseApp(_initialization));
          FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
          store.dispatch(SetRemoteFirebaseFirestore(firebaseFirestore));
          // String host = defaultTargetPlatform == TargetPlatform.android
          //     ? '10.0.2.2:8080'
          //     : 'localhost:8080';
          // firebaseFirestore.settings = Settings(host: host, sslEnabled: false);
          // store.dispatch(SetLocalFirebaseFirestore(firebaseFirestore));

          store.dispatch(SetFirebaseApp(_initialization));
          store.dispatch(OnAuthStateChangedSyncLoggedAction());
          return StoreProvider<AppState>(
            store: store,
            child: MaterialApp(
              theme: ThemeData.dark(),
              title: 'AI Prof',
              navigatorKey: Keys.navigatorStateKey,
              initialRoute: Routes.welcome,
              routes: Routes.routes,
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        // return Loading();
        return CircularProgressIndicator();
      },
    );

    // return StoreProvider<AppState>(
    //   store: store,
    //   child: MaterialApp(
    //     theme: ThemeData.dark(),
    //     title: 'AI Prof',
    //     navigatorKey: Keys.navigatorStateKey,
    //     initialRoute: Routes.welcome,
    //     routes: Routes.routes,
    //   ),
    // );
  }
}
