import 'package:aiprof/states/types_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPageDS extends StatefulWidget {
  final Function(String) sendPasswordResetEmail;
  final Function(String, String) loginEmailPassword;
  final AuthenticationStatusLogged authenticationStatusLogged;
  const LoginPageDS({
    Key key,
    this.loginEmailPassword,
    this.authenticationStatusLogged,
    this.sendPasswordResetEmail,
  }) : super(key: key);
  @override
  LoginPageDSState createState() {
    return LoginPageDSState();
  }
}

class LoginPageDSState extends State<LoginPageDS> {
  static final formKey = GlobalKey<FormState>();
  String _userName;
  String _password;
  void validateInputsLogin() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.loginEmailPassword(
        _userName,
        _password,
      );
    } else {
      setState(() {});
    }
  }

  void validateInputsResetPassword() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.sendPasswordResetEmail(_userName);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Ai Prof - Acessar')),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                Text('Informe os dados'),
                TextFormField(
                  initialValue: 'catalunha.mj@gmail.com',
                  decoration: InputDecoration(
                    labelText: 'Email:',
                  ),
                  onSaved: (value) => _userName = value,
                ),
                TextFormField(
                  initialValue: 'aiprof',
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password:',
                  ),
                  onSaved: (value) => _password = value,
                ),
                ListTile(
                  title: Center(child: Text('Logar')),
                  trailing: Icon(Icons.verified_user),
                  onTap: () {
                    validateInputsLogin();
                  },
                ),
                ListTile(
                  title: Center(child: Text('Pedir Reset senha via email.')),
                  trailing: Icon(Icons.settings_backup_restore),
                  onTap: () {
                    validateInputsResetPassword();
                  },
                ),
                widget.authenticationStatusLogged ==
                        AuthenticationStatusLogged.authenticating
                    ? Center(child: CircularProgressIndicator())
                    : Container(),
                widget.authenticationStatusLogged ==
                        AuthenticationStatusLogged.unAuthenticated
                    ? Center(
                        child: Text('Verifique Email e a Senha por favor.'))
                    : Container(),
                widget.authenticationStatusLogged ==
                        AuthenticationStatusLogged.unInitialized
                    ? Center(child: Text('Estamos aguardando vc logar.'))
                    : Container(),
                widget.authenticationStatusLogged ==
                        AuthenticationStatusLogged.authenticated
                    ? Center(child: Text('Acesso liberado.'))
                    : Container(),
                widget.authenticationStatusLogged ==
                        AuthenticationStatusLogged.sendPasswordReset
                    ? Center(child: Text('Veja seu email para nova senha.'))
                    : Container(),
              ],
            ),
          ),
        ));
  }
}
