import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/firestore_model.dart';
import 'package:aiprof/models/user_model.dart';

class ExameModel extends FirestoreModel {
  static final String collection = "exame";
  UserModel userRef;
  ClassroomModel classroomRef;
  String name;
  String description;
  dynamic start;
  dynamic end;
  int scoreExame;
  List<String> questionOrder;
  //herdar na question
  int attempt;
  int time;
  int error;
  int scoreQuestion;
  // function
  bool isDelivery;
  bool isProcess;
  Map<String, bool> student;
  Map<String, bool> question;

  ExameModel(
    String id, {
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
    if (map.containsKey('questionOrder')) questionOrder = map['questionOrder'];
    // herdar nas questions
    if (map.containsKey('attempt')) attempt = map['attempt'];
    if (map.containsKey('time')) time = map['time'];
    if (map.containsKey('error')) error = map['error'];
    if (map.containsKey('scoreQuestion')) scoreQuestion = map['scoreQuestion'];
    // functions
    if (map.containsKey('isDelivery')) isDelivery = map['isDelivery'];
    if (map.containsKey('isProcess')) isProcess = map['isProcess'];
    if (map["student"] is Map) {
      student = Map<String, bool>();
      for (var item in map["student"].entries) {
        student[item.key] = item.value;
      }
    }
    if (map["question"] is Map) {
      question = Map<String, bool>();
      for (var item in map["question"].entries) {
        question[item.key] = item.value;
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    if (questionOrder != null) data['questionOrder'] = this.questionOrder;
    // herdar question
    if (attempt != null) data['attempt'] = this.attempt;
    if (time != null) data['time'] = this.time;
    if (error != null) data['error'] = this.error;
    if (scoreQuestion != null) data['scoreQuestion'] = this.scoreQuestion;
    //function
    if (isDelivery != null) data['isDelivery'] = this.isDelivery;
    if (isDelivery != null) data['isDelivery'] = this.isDelivery;
    if (student != null && student is Map) {
      data["student"] = Map<String, dynamic>();
      for (var item in student.entries) {
        data["student"][item.key] = item.value;
      }
    }
    if (question != null && question is Map) {
      data["question"] = Map<String, dynamic>();
      for (var item in question.entries) {
        data["question"][item.key] = item.value;
      }
    }
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
    _return = _return + '\nDescrição: $description';
    _return = _return + '\nuserRef.name: ${userRef.name}';
    _return = _return + '\classroomRef.name: ${classroomRef.name}';
    _return = _return + '\nid: $id';
    return _return;
  }
}
