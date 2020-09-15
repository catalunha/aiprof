import 'package:aiprof/conectors/welcome.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class Routes {
  static final welcome = '/';

  static final routes = {
    welcome: (BuildContext context) => UserExceptionDialog<AppState>(
          child: Welcome(),
        ),
  };
}

class Keys {
  static final navigatorStateKey = GlobalKey<NavigatorState>();
}
