import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/models/firestore_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/models/user_model.dart';

class QuestionModel extends FirestoreModel {
  static final String collection = "question";
  UserModel userRef;
  ClassroomModel classroomRef;
  ExameModel exameRef;
  SituationModel situationModel;
  String name;
  String description;
  dynamic start;
  dynamic end;
  int scoreQuestion;
  int attempt;
  int time;
  int error;
  bool isDelivered;
  bool resetTask;

  QuestionModel(
    String id, {
    this.classroomRef,
    this.exameRef,
    this.situationModel,
    this.start,
    this.end,
    this.scoreQuestion,
    this.attempt,
    this.time,
    this.error,
    this.isDelivered,
    this.userRef,
    this.name,
    this.description,
    this.resetTask,
  }) : super(id);

  @override
  QuestionModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('userRef') && map['userRef'] != null)
      userRef = UserModel(map['userRef']['id']).fromMap(map['userRef']);
    if (map.containsKey('classroomRef') && map['classroomRef'] != null)
      classroomRef = ClassroomModel(map['classroomRef']['id'])
          .fromMap(map['classroomRef']);
    if (map.containsKey('exameRef') && map['exameRef'] != null)
      exameRef = ExameModel(map['exameRef']['id']).fromMap(map['exameRef']);
    if (map.containsKey('situationModel') && map['situationModel'] != null)
      situationModel = SituationModel(map['situationModel']['id'])
          .fromMap(map['situationModel']);
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('description')) description = map['description'];
    start = map.containsKey('start') && map['start'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['start'].millisecondsSinceEpoch)
        : null;
    end = map.containsKey('end') && map['end'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['end'].millisecondsSinceEpoch)
        : null;
    if (map.containsKey('attempt')) attempt = map['attempt'];
    if (map.containsKey('time')) time = map['time'];
    if (map.containsKey('error')) error = map['error'];
    if (map.containsKey('scoreQuestion')) scoreQuestion = map['scoreQuestion'];
    if (map.containsKey('isDelivered')) isDelivered = map['isDelivered'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (this.userRef != null) {
      data['userRef'] = this.userRef.toMapRef();
    }
    if (this.classroomRef != null) {
      data['classroomRef'] = this.classroomRef.toMapRef();
    }
    if (this.exameRef != null) {
      data['exameRef'] = this.exameRef.toMapRef();
    }
    if (this.situationModel != null) {
      data['situationModel'] = this.situationModel.toMap();
    }
    if (name != null) data['name'] = this.name;
    if (description != null) data['description'] = this.description;
    data['start'] = this.start;
    data['end'] = this.end;
    if (attempt != null) data['attempt'] = this.attempt;
    if (time != null) data['time'] = this.time;
    if (error != null) data['error'] = this.error;
    if (scoreQuestion != null) data['scoreQuestion'] = this.scoreQuestion;
    if (isDelivered != null) data['isDelivered'] = this.isDelivered;
    if (resetTask != null) data['resetTask'] = this.resetTask;

    return data;
  }

  Map<String, dynamic> toMapRef() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    return data;
  }

  @override
  String toString() {
    String _return = '';
    _return = _return +
        '\nProfessor: ${userRef.name.split(' ')[0]} (${userRef.id.substring(0, 4)})';
    _return = _return +
        '\nTurma: ${classroomRef.name} (${classroomRef.id.substring(0, 4)}).';
    _return =
        _return + ' Exame: ${exameRef.name} (${exameRef.id.substring(0, 4)})';
    _return = _return +
        '\nSituação: ${situationModel?.name} (${situationModel?.id?.substring(0, 4)})';

    // _return = _return + '\nuserRef.name: ${userRef.name}';
    // _return = _return + '\nclassroomRef.name: ${classroomRef.name}';
    // _return = _return + '\nexameRef.name: ${exameRef.name}';
    _return = _return + '\nInício: $start';
    _return = _return + '\nFim: $end';
    _return = _return +
        '\nPeso da questão: ${scoreQuestion == null ? "0" : scoreQuestion}. Tempo: ${time == null ? "0" : time}h. Tentativa: ${attempt == null ? "0" : attempt}. Erro: ${error == null ? "0" : error}%.';

    _return = _return + '\nAplicada: ${isDelivered ? "Sim" : "Não"}';
    // _return = _return + '\nsituationModel.name: ${situationModel?.name}';
    // _return = _return + '\nsimulationRef.name: ${simulationRef.id}';
    _return = _return + '\nid: ${id.substring(0, 4)}';
    return _return;
  }
}
