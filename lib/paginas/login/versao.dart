import 'package:flutter/material.dart';
import 'package:aiprof/naosuportato/url_launcher.dart' if (dart.library.io) 'package:url_launcher/url_launcher.dart';
import 'package:aiprof/plataforma/recursos.dart';

class Versao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Versão & Suporte'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Recursos.instance.plataforma == 'android' ? Text("Versão Android: 1.0.3 (4)") : Text("Versão Chrome: 1.0.3 (4) Build: 201912032020"),
          ),
          ListTile(
            title: Text("Suporte via WhatsApp pelo número +55 63 984495508"),
            trailing: Icon(Icons.phonelink_ring),
          ),
          ListTile(
            title: Text("Suporte via email em catalunha.mj@gmail.com"),
            trailing: Icon(Icons.email),
          ),
          ListTile(
            title: Text('Click aqui para ir ao tutorial'),
            trailing: Icon(Icons.help),
            onTap: () {
              try {
                launch('https://docs.google.com/document/d/14GAakF6y4Fjti-6TwmuiDtW-KZxXoxPqRo2kBHcwIvo/edit?usp=sharing');
              } catch (e) {}
            },
          ),
          // Container(
          //       alignment: Alignment.center,
          //       child: Image.asset('assets/imagem/logo2.png'),
          //     ),
        ],
      ),
    );
  }
}
