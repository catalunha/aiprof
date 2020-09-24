import 'package:aiprof/conectors/classroom/classroom_list.dart';
import 'package:aiprof/conectors/classroom/classroom_edit.dart';
import 'package:aiprof/conectors/exame/exame_edit.dart';
import 'package:aiprof/conectors/exame/exame_list.dart';
import 'package:aiprof/conectors/know/folder_edit.dart';
import 'package:aiprof/conectors/know/folder_list.dart';
import 'package:aiprof/conectors/know/know_edit.dart';
import 'package:aiprof/conectors/know/know_list.dart';
import 'package:aiprof/conectors/simulation/input_edit.dart';
import 'package:aiprof/conectors/simulation/output_edit.dart';
import 'package:aiprof/conectors/simulation/simulation_edit.dart';
import 'package:aiprof/conectors/simulation/simulation_list.dart';
import 'package:aiprof/conectors/situation/situation_edit.dart';
import 'package:aiprof/conectors/situation/situation_list.dart';
import 'package:aiprof/conectors/student/student_edit.dart';
import 'package:aiprof/conectors/student/student_list.dart';
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
  static final situationList = '/situationList';
  static final situationEdit = '/situationEdit';
  static final knowList = '/knowList';
  static final knowEdit = '/knowEdit';
  static final folderList = '/folderList';
  static final folderEdit = '/folderEdit';
  static final simulationList = '/simulationList';
  static final simulationEdit = '/simulationEdit';
  static final inputEdit = '/inputEdit';
  static final outputEdit = '/outputEdit';
  static final exameList = '/exameList';
  static final exameEdit = '/exameEdit';
  static final questionList = '/questionList';
  static final questionEdit = '/questionEdit';
  static final studentSelect = '/studentSelect';

  static final routes = {
    welcome: (BuildContext context) => UserExceptionDialog<AppState>(
          child: Welcome(),
        ),
    classroomList: (BuildContext context) => ClassroomList(),
    classroomEdit: (BuildContext context) => ClassroomEdit(),
    studentList: (BuildContext context) => StudentList(),
    studentEdit: (BuildContext context) => StudentEdit(),
    situationList: (BuildContext context) => SituationList(),
    situationEdit: (BuildContext context) => SituationEdit(),
    knowList: (BuildContext context) => KnowList(),
    knowEdit: (BuildContext context) => KnowEdit(),
    folderList: (BuildContext context) => FolderList(),
    folderEdit: (BuildContext context) => FolderEdit(),
    simulationList: (BuildContext context) => SimulationList(),
    simulationEdit: (BuildContext context) => SimulationEdit(),
    inputEdit: (BuildContext context) => InputEdit(),
    outputEdit: (BuildContext context) => OutputEdit(),
    exameList: (BuildContext context) => ExameList(),
    exameEdit: (BuildContext context) => ExameEdit(),
  };
}

class Keys {
  static final navigatorStateKey = GlobalKey<NavigatorState>();
}
