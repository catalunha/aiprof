import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/models/firestore_model.dart';
import 'package:aiprof/models/question_model.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/models/user_model.dart';

class TaskModel extends FirestoreModel {
  static final String collection = "task";
  UserModel teacherUserRef;
  ClassroomModel classroomRef;
  ExameModel exameRef;
  QuestionModel questionRef;
  SituationModel situationRef;
  UserModel studentUserRef;
  //dados do exame
  dynamic start;
  dynamic end;
  int scoreExame;
  //dados da questao
  int attempt;
  int time;
  int error;
  int scoreQuestion;
  // gestão da tarefa
  dynamic started;
  dynamic lastSendAnswer;
  dynamic attempted;
  bool open;
  Map<String, Input> simulationInput = Map<String, Input>();
  Map<String, Output> simulationOutput = Map<String, Output>();

  TaskModel(
    String id, {
    this.teacherUserRef,
    this.classroomRef,
    this.exameRef,
    this.questionRef,
    this.situationRef,
    this.studentUserRef,
    this.start,
    this.end,
    this.scoreExame,
    this.attempt,
    this.time,
    this.error,
    this.scoreQuestion,
    this.started,
    this.lastSendAnswer,
    this.attempted,
    this.open,
    this.simulationInput,
    this.simulationOutput,
  }) : super(id);

  @override
  TaskModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('teacherUserRef') && map['teacherUserRef'] != null)
      teacherUserRef =
          UserModel(map['teacherUserRef']['id']).fromMap(map['teacherUserRef']);
    if (map.containsKey('classroomRef') && map['classroomRef'] != null)
      classroomRef = ClassroomModel(map['classroomRef']['id'])
          .fromMap(map['classroomRef']);
    if (map.containsKey('exameRef') && map['exameRef'] != null)
      exameRef = ExameModel(map['exameRef']['id']).fromMap(map['exameRef']);
    if (map.containsKey('questionRef') && map['questionRef'] != null)
      questionRef =
          QuestionModel(map['questionRef']['id']).fromMap(map['questionRef']);
    if (map.containsKey('situationRef') && map['situationRef'] != null)
      situationRef = SituationModel(map['situationRef']['id'])
          .fromMap(map['situationRef']);
    if (map.containsKey('studentUserRef') && map['studentUserRef'] != null)
      studentUserRef =
          UserModel(map['studentUserRef']['id']).fromMap(map['studentUserRef']);
    start = map.containsKey('start') && map['start'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['start'].millisecondsSinceEpoch)
        : null;
    end = map.containsKey('end') && map['end'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['end'].millisecondsSinceEpoch)
        : null;
    if (map.containsKey('scoreExame')) scoreExame = map['scoreExame'];
    if (map.containsKey('attempt')) attempt = map['attempt'];
    if (map.containsKey('time')) time = map['time'];
    if (map.containsKey('error')) error = map['error'];
    if (map.containsKey('scoreQuestion')) scoreQuestion = map['scoreQuestion'];
    started = map.containsKey('started') && map['started'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['started'].millisecondsSinceEpoch)
        : null;
    lastSendAnswer =
        map.containsKey('lastSendAnswer') && map['lastSendAnswer'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                map['lastSendAnswer'].millisecondsSinceEpoch)
            : null;
    if (map.containsKey('attempted')) attempted = map['attempted'];
    if (map.containsKey('open')) open = map['open'];
    if (map["simulationInput"] is Map) {
      simulationInput = Map<String, Input>();
      for (var item in map["simulationInput"].entries) {
        simulationInput[item.key] = Input(item.key).fromMap(item.value);
      }
    }
    if (map["simulationOutput"] is Map) {
      simulationOutput = Map<String, Output>();
      for (var item in map["simulationOutput"].entries) {
        simulationOutput[item.key] = Output(item.key).fromMap(item.value);
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teacherUserRef != null) {
      data['teacherUserRef'] = this.teacherUserRef.toMapRef();
    }
    if (this.classroomRef != null) {
      data['classroomRef'] = this.classroomRef.toMapRef();
    }
    if (this.exameRef != null) {
      data['exameRef'] = this.exameRef.toMapRef();
    }
    if (this.questionRef != null) {
      data['questionRef'] = this.questionRef.toMapRef();
    }
    if (this.situationRef != null) {
      data['situationRef'] = this.situationRef.toMapRef();
    }
    if (this.studentUserRef != null) {
      data['studentUserRef'] = this.studentUserRef.toMapRef();
    }
    data['start'] = this.start;
    data['end'] = this.end;
    if (scoreExame != null) data['scoreExame'] = this.scoreExame;
    if (attempt != null) data['attempt'] = this.attempt;
    if (time != null) data['time'] = this.time;
    if (error != null) data['error'] = this.error;
    if (scoreQuestion != null) data['scoreQuestion'] = this.scoreQuestion;
    data['started'] = this.started;
    data['lastSendAnswer'] = this.lastSendAnswer;
    if (attempted != null) data['attempted'] = this.attempted;
    if (open != null) data['open'] = this.open;

    return data;
  }

  bool get isOpen {
    if (this.open && this.end.isBefore(DateTime.now())) {
      this.open = false;
      // print('==> Tarefa ${this.id}. aberta=${this.aberta} pois fim < now');
    }
    if (this.open &&
        this.start != null &&
        this.responderAte != null &&
        this.responderAte.isBefore(DateTime.now())) {
      this.open = false;
      // print('==> Tarefa ${this.id} Fechada pois responderAte < now');
    }
    if (this.open && this.attempted != null && this.attempted >= this.attempt) {
      this.open = false;
      // print('==> Tarefa ${this.id} Fechada pois tentou < tentativa');
    }
    return this.open;
  }

  DateTime get responderAte {
    if (this.start != null) {
      return this.start.add(Duration(hours: this.time));
    } else {
      return null;
    }
  }

  dynamic get tempoPResponder {
    responderAte;
    if (this.start == null) {
      // return Duration(hours: this.tempo);
      return null;
    } else {
      if (this.responderAte != null && this.end.isBefore(this.responderAte)) {
        return this.end.difference(DateTime.now());
      }
      if (this.responderAte != null) {
        return this.responderAte.difference(DateTime.now());
      }
    }
  }

  void updateAll() {
    responderAte;
    tempoPResponder;
    isOpen;
  }
}
