import 'package:aiprof/models/firestore_model.dart';
import 'package:aiprof/models/user_model.dart';

class ClassroomModel extends FirestoreModel {
  static final String collection = "classroom";
  UserModel userRef;
  String company;
  String component;
  String name;
  String description;
  String urlProgram;
  bool isActive;
  Map<String, UserModel> studentUserRefMapTemp;
  Map<String, UserModel> studentUserRefMap;
  // dynamic number;
  // dynamic questionNumber;

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
    this.studentUserRefMapTemp,
    this.studentUserRefMap,
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
    if (map["studentUserRefMapTemp"] is Map) {
      studentUserRefMapTemp = Map<String, UserModel>();
      for (var item in map["studentUserRefMapTemp"].entries) {
        studentUserRefMapTemp[item.key] =
            UserModel(item.key).fromMap(item.value);
      }
    }
    if (map["studentUserRefMap"] is Map) {
      studentUserRefMap = Map<String, UserModel>();
      for (var item in map["studentUserRefMap"].entries) {
        studentUserRefMap[item.key] = UserModel(item.key).fromMap(item.value);
      }
    }
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
    if (studentUserRefMapTemp != null && studentUserRefMapTemp is Map) {
      data["studentUserRefMapTemp"] = Map<String, dynamic>();
      for (var item in studentUserRefMapTemp.entries) {
        data["studentUserRefMapTemp"][item.key] = item.value.toMapRef();
      }
    }
    if (studentUserRefMap != null && studentUserRefMap is Map) {
      data["studentUserRefMap"] = Map<String, dynamic>();
      for (var item in studentUserRefMap.entries) {
        data["studentUserRefMap"][item.key] = item.value.toMapRef();
      }
    }
    return data;
  }

  Map<String, dynamic> toMapRef() {
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
    _return = _return + 'Instituição: $company';
    _return = _return + '\nComponente: $component';
    // _return = _return + '\nTurma: $name';
    _return = _return +
        '\nProfessor: ${userRef.name.split(' ')[0]} (${userRef.id.substring(0, 4)})';
    _return = _return + '\nid: ${id.substring(0, 4)}';
    _return = _return + '\nAlunos: ${studentUserRefMap?.length}';
    return _return;
  }
}
