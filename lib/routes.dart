import 'package:aiprof/conectors/classroom/classroom_list.dart';
import 'package:aiprof/conectors/classroom/student_edit.dart';
import 'package:aiprof/conectors/welcome.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class Routes {
  static final welcome = '/';
  static final classroomList = '/classroomList';
  static final classroomEdit = '/classroomEdit';
  static final studentList = '/studentList';
  static final studentEdit = '/studentEdit';
  static final frequencyList = '/frequencyList';
  static final frequencyEdit = '/frequencyEdit';

  static final routes = {
    welcome: (BuildContext context) => UserExceptionDialog<AppState>(
          child: Welcome(),
        ),
    classroomList: (BuildContext context) => ClassroomList(),
    classroomEdit: (BuildContext context) => ClassroomEdit(),
    // studentList: (BuildContext context) => StudentList(),
    // studentEdit: (BuildContext context) => StudentEdit(),
  };
}

class Keys {
  static final navigatorStateKey = GlobalKey<NavigatorState>();
}
