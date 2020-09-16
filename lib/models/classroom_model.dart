import 'package:aiprof/models/firestore_model.dart';
import 'package:aiprof/models/user_model.dart';

class ClassroomModel extends FirestoreModel {
  static final String collection = "classroom";
  bool isActive;
  String company;
  String component;
  String name;
  String description;
  String urlProgram;
  UserModel userRef;
  // dynamic number;
  dynamic questionNumber;

  ClassroomModel(
    String id, {
    this.isActive,
    // this.number,
    this.company,
    this.component,
    this.name,
    this.description,
    this.urlProgram,
    this.userRef,
    this.questionNumber,
  }) : super(id);

  @override
  ClassroomModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('isActive')) isActive = map['isActive'];
    // if (map.containsKey('number')) number = map['number'];
    if (map.containsKey('company')) company = map['company'];
    if (map.containsKey('component')) component = map['component'];
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('description')) description = map['description'];
    if (map.containsKey('urlProgram')) urlProgram = map['urlProgram'];
    userRef = map.containsKey('userRef') && map['userRef'] != null
        ? UserModel(map['userRef']['id']).fromMap(map['userRef'])
        : null;
    if (map.containsKey('questionNumber'))
      questionNumber = map['questionNumber'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // _updateAll();
    if (isActive != null) data['isActive'] = this.isActive;
    // if (number != null) data['number'] = this.number;
    if (company != null) data['company'] = this.company;
    if (component != null) data['component'] = this.component;
    if (name != null) data['name'] = this.name;
    if (description != null) data['description'] = this.description;
    if (urlProgram != null) data['urlProgram'] = this.urlProgram;
    if (this.userRef != null) {
      data['userRef'] = this.userRef.toMapRef();
    }
    if (questionNumber != null) data['questionNumber'] = this.questionNumber;
    return data;
  }

  Map<String, dynamic> toMapref() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (company != null) data['company'] = this.company;
    if (component != null) data['component'] = this.component;
    if (name != null) data['name'] = this.name;
    return data;
  }

  @override
  String toString() {
    String _return = '';
    _return = _return + 'I/C: $company - $component';
    _return = _return + '\nTurma: $name';
    _return = _return + '\nuserRef.name: ${userRef.name}';
    _return = _return + '\nid: $id';
    return _return;
  }
}