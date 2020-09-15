import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoutButtonDS extends StatelessWidget {
  final Function logout;

  const LogoutButtonDS({Key key, this.logout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: 'Sair',
      onPressed: logout,
    );
  }
}
