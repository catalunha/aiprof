import 'package:aiprof/app_state.dart';
import 'package:aiprof/classroom/classroom_list.dart';
import 'package:aiprof/classroom/classroom_edit.dart';
import 'package:aiprof/exame/exame_edit.dart';
import 'package:aiprof/exame/exame_list.dart';
import 'package:aiprof/know/folder_edit.dart';
import 'package:aiprof/know/folder_list.dart';
import 'package:aiprof/know/folder_select_toquestion.dart';
import 'package:aiprof/know/know_edit.dart';
import 'package:aiprof/know/know_list.dart';
import 'package:aiprof/know/know_select_toquestion.dart';
import 'package:aiprof/login/welcome.dart';
import 'package:aiprof/question/question_edit.dart';
import 'package:aiprof/question/question_list.dart';
import 'package:aiprof/situation/simulation/input_edit.dart';
import 'package:aiprof/situation/simulation/output_edit.dart';
import 'package:aiprof/situation/simulation/simulation_edit.dart';
import 'package:aiprof/situation/simulation/simulation_list.dart';
import 'package:aiprof/situation/situation_edit.dart';
import 'package:aiprof/situation/situation_list.dart';
import 'package:aiprof/student/student_edit.dart';
import 'package:aiprof/student/student_list.dart';
import 'package:aiprof/student/student_select_toquestion.dart';
import 'package:aiprof/task/task_answer_text.dart';
import 'package:aiprof/task/task_edit.dart';
import 'package:aiprof/task/task_list.dart';
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
  static final knowSelectToQuestion = '/knowSelectToQuestion';
  static final folderSelectToQuestion = '/folderSelectToQuestion';
  static final questionStudentSelect = '/questionStudentSelect';
  static final taskList = '/taskList';
  static final taskEdit = '/taskEdit';
  static final taskAnswerText = '/taskAnswerText';

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
    questionList: (BuildContext context) => QuestionList(),
    questionEdit: (BuildContext context) => QuestionEdit(),
    knowSelectToQuestion: (BuildContext context) => KnowSelectToQuestion(),
    folderSelectToQuestion: (BuildContext context) =>
        FolderSelectToQuestionList(),
    questionStudentSelect: (BuildContext context) => StudentSelectToQuestion(),
    taskList: (BuildContext context) => TaskList(),
    taskEdit: (BuildContext context) => TaskEdit(),
    taskAnswerText: (BuildContext context) => TaskAnswerText(),
  };
}

class Keys {
  static final navigatorStateKey = GlobalKey<NavigatorState>();
}
