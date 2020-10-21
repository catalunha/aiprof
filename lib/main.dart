import 'package:aiprof/actions/logged_action.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

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

  MyApp({Key key})
      : store = _store,
        super(key: key) {
    store.dispatch(OnAuthStateChangedSyncLoggedAction());
  }
  @override
  Widget build(BuildContext context) {
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
}
