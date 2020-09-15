import 'package:aiprof/conectors/components/logout_button.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/routes.dart';
import 'package:flutter/material.dart';

class HomePageDS extends StatelessWidget {
  final UserModel userModel;

  const HomePageDS({
    Key key,
    this.userModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá ${userModel?.name}'),
        actions: [
          LogoutButton(),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.people,
            ),
            title: Text('Lista de estudantes'),
            // onTap: () => Navigator.pushNamed(context, Routes.studentList),
          ),
        ],
      ),
    );
  }
}
