import 'package:aiprof/classroom/classroom_model.dart';
import 'package:aiprof/models/firestore_model.dart';
import 'package:aiprof/models/user_model.dart';

class ExameModel extends FirestoreModel {
  static final String collection = "exame";
  UserModel userRef; //teacher
  ClassroomModel classroomRef;
  String name;
  String description;
  //dados do exame
  dynamic start;
  dynamic end;
  int scoreExame;
  //dados para herdar na questao
  int attempt;
  int time;
  int error;
  int scoreQuestion;
  Map<String, bool> questionMap;
  List<dynamic> questionId;

  ExameModel(
    String id, {
    this.classroomRef,
    this.start,
    this.end,
    this.scoreExame,
    this.attempt,
    this.time,
    this.error,
    this.scoreQuestion,
    this.questionMap,
    this.questionId,
    this.userRef,
    this.name,
    this.description,
  }) : super(id);

  @override
  ExameModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('userRef') && map['userRef'] != null)
      userRef = UserModel(map['userRef']['id']).fromMap(map['userRef']);
    if (map.containsKey('classroomRef') && map['classroomRef'] != null)
      classroomRef = ClassroomModel(map['classroomRef']['id'])
          .fromMap(map['classroomRef']);

    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('description')) description = map['description'];
    start = map.containsKey('start') && map['start'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['start'].millisecondsSinceEpoch)
        : null;
    end = map.containsKey('end') && map['end'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['end'].millisecondsSinceEpoch)
        : null;
    if (map.containsKey('scoreExame')) scoreExame = map['scoreExame'];
    // herdar nas questionMaps
    if (map.containsKey('attempt')) attempt = map['attempt'];
    if (map.containsKey('time')) time = map['time'];
    if (map.containsKey('error')) error = map['error'];
    if (map.containsKey('scoreQuestion')) scoreQuestion = map['scoreQuestion'];
    // functions
    if (map["questionMap"] is Map) {
      questionMap = Map<String, bool>();
      for (var item in map["questionMap"].entries) {
        questionMap[item.key] = item.value;
      }
    }
    if (map.containsKey('questionId')) questionId = map['questionId'];

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
    if (name != null) data['name'] = this.name;
    if (description != null) data['description'] = this.description;
    data['start'] = this.start;
    data['end'] = this.end;
    if (scoreExame != null) data['scoreExame'] = this.scoreExame;
    // herdar questionMap
    if (attempt != null) data['attempt'] = this.attempt;
    if (time != null) data['time'] = this.time;
    if (error != null) data['error'] = this.error;
    if (scoreQuestion != null) data['scoreQuestion'] = this.scoreQuestion;
    //function
    if (questionMap != null && questionMap is Map) {
      data["questionMap"] = Map<String, dynamic>();
      for (var item in questionMap.entries) {
        data["questionMap"][item.key] = item.value;
      }
    }
    if (questionId != null) data['questionId'] = this.questionId;

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
    _return = _return +
        '\nQuestões: ${questionMap?.length == null ? "0" : questionMap.length}';
    _return = _return + '\nInício: $start';
    _return = _return + '\nFim: $end';
    _return =
        _return + '\nPeso do exame: ${scoreExame == null ? "0" : scoreExame}.';
    _return = _return +
        ' Peso da questão: ${scoreQuestion == null ? "0" : scoreQuestion}.';
    _return = _return + ' Tempo de resolução: ${time == null ? "0" : time}h.';
    _return = _return + ' Tentativa: ${attempt == null ? "0" : attempt}.';
    _return = _return + ' Erro relativo: ${error == null ? "0" : error}%.';
    _return = _return + '\nDescrição: $description';
    _return = _return +
        '\nQuestion: ${questionId?.length != null && questionId.length > 0 ? questionId.length : "NENHUMA"}. ';
    _return = _return + '\nid: ${id.substring(0, 4)}';
    return _return;
  }
}
