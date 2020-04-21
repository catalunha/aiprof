import 'dart:async';

import 'package:flutter/material.dart';
import 'package:aiprof/auth_bloc.dart';
import 'package:aiprof/naosuportato/permission_handler.dart'
    if (dart.library.io) 'package:permission_handler/permission_handler.dart';

class EmailPassword {
  String email = '';
  String password = '';
  bool validateEmail() {
    print("---" + this.email);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this.email);

    if (emailValid) {
      print("email valido: " + this.email);
      return true;
    } else {
      print("email invalido: " + this.email);
      return false;
    }
  }

  bool validatePassword() {
    print("---" + this.password);
    if (this.password.length < 6) {
      // _alerta('Informe uma senha valida.');
      return false;
    }
    return true;
  }
}

class LoginPage extends StatefulWidget {
  final AuthBloc authBloc;

  LoginPage(this.authBloc);

  @override
  LoginPageState createState() {
    return LoginPageState(this.authBloc);
  }
}

class LoginPageState extends State<LoginPage> {
  EmailPassword _emailPassword = new EmailPassword();

  // PermissionStatus _status;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthBloc authBloc;

  LoginPageState(this.authBloc);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPermission();
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  void _checkPermission() async {
    var a = PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    await a.then(_updateStatus);
  }

  FutureOr _updateStatus(PermissionStatus value) {
    if (value == PermissionStatus.denied) {
      _askPermission();
    }
  }

  _askPermission() async {
    var a = PermissionHandler().requestPermissions([
      PermissionGroup.storage,
    ]);
    await a.then(_onStatusRequested);
  }

  FutureOr _onStatusRequested(Map<PermissionGroup, PermissionStatus> value) {
    _updateStatus(value[PermissionGroup.storage]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: Center(
                          child: Text(
                            'AI - Prof',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: TextFormField(
                          onSaved: (email) {
                            this._emailPassword.email = email;
                            authBloc.dispatch(UpdateEmailAuthBlocEvent(email));
                          },
                          decoration: InputDecoration(
                            hintText: "Informe seu email",
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: TextFormField(
                          onSaved: (password) {
                            this._emailPassword.password = password;
                            authBloc.dispatch(
                                UpdatePasswordAuthBlocEvent(password));
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Informe sua senha",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: RaisedButton(
                          child: Text("Acessar",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                          color: Colors.green,
                          onPressed: () {
                            _formKey.currentState.save();
                            authBloc.dispatch(LoginAuthBlocEvent());
                            if (this._emailPassword.validateEmail() &&
                                this._emailPassword.validatePassword()) {
                              // _formKey.currentState.save();
                              authBloc.dispatch(LoginAuthBlocEvent());
                            } else {
                              _alerta(
                                  "Verifique se o campo de e-mail e senha estão preenchidos corretamente.");
                            }
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //     vertical: 12,
                      //   ),
                      // ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Text(
                              'Eita. Esqueci a senha!\nInforme seu email e click aqui.',
                              style: TextStyle(color: Colors.green[600])),
                          trailing: IconButton(
                            icon: Icon(Icons.vpn_key, color: Colors.green[600]),
                            onPressed: () {
                              _formKey.currentState.save();
                              // authBloc.dispatch(ResetPassword());
                              if (this._emailPassword.validateEmail()) {
                                authBloc.dispatch(ResetPassword());
                                _alerta(
                                    "Um link para redefinição de senha foi enviado para o seu e-mail.");
                              } else {
                                _alerta(
                                    "Para resetar sua senha preencha o campo de email.");
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   alignment: Alignment.center,
              //   child: Image.asset('assets/imagem/logo.png'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _alerta(String msgAlerta) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: PmsbColors.card,
          title: Text(msgAlerta),
          actions: <Widget>[
            FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
}
