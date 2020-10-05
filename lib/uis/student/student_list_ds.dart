import 'package:flutter/material.dart';
import 'package:aiprof/models/user_model.dart';

class StudentListDS extends StatefulWidget {
  final List<UserModel> studentList;
  final Function() onAddStudent;

  const StudentListDS({
    Key key,
    this.studentList,
    this.onAddStudent,
  }) : super(key: key);

  @override
  _StudentListDSState createState() => _StudentListDSState();
}

class _StudentListDSState extends State<StudentListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#Student Estudantes (${widget.studentList.length})'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.studentList.length,
        itemBuilder: (context, index) {
          final student = widget.studentList[index];
          return Card(
            color:
                !student.isActive ? Colors.brown : Theme.of(context).cardColor,
            child: ListTile(
              title: Text('${student.name}'),
              subtitle: Text('${student.toString()}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          widget.onAddStudent();
        },
      ),
    );
  }
}
