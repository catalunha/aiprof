import 'package:aiprof/repository/firestore_model.dart';
import 'package:aiprof/student/student_model.dart';
import 'package:aiprof/teacher/teacher_model.dart';

class ClassroomModel extends FirestoreModel {
  static final String collection = "classroom";
  String name;
  String company;
  String component;
  String urlProgram;
  String description;
  TeacherModel teacher; //change to teacherUserRef
  bool isActive;
  Map<String, StudentModel> studentRefTemp;
  Map<String, StudentModel> studentRef;
  List<dynamic> exameId;

  ClassroomModel(String id) : super(id);

  @override
  ClassroomModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('company')) company = map['company'];
    if (map.containsKey('component')) component = map['component'];
    if (map.containsKey('urlProgram')) urlProgram = map['urlProgram'];
    if (map.containsKey('description')) description = map['description'];
    if (map.containsKey('isActive')) isActive = map['isActive'];
    teacher = map.containsKey('teacher') && map['teacher'] != null
        ? TeacherModel(map['teacher']['id']).fromMap(map['teacher'])
        : null;
    if (map["studentRefTemp"] is Map) {
      studentRefTemp = Map<String, StudentModel>();
      for (var item in map["studentRefTemp"].entries) {
        studentRefTemp[item.key] = StudentModel(item.key).fromMap(item.value);
      }
    }
    if (map["studentRef"] is Map) {
      studentRef = Map<String, StudentModel>();
      for (var item in map["studentRef"].entries) {
        studentRef[item.key] = StudentModel(item.key).fromMap(item.value);
      }
    }
    if (map.containsKey('exameId')) exameId = map['exameId'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (name != null) data['name'] = this.name;
    if (company != null) data['company'] = this.company;
    if (component != null) data['component'] = this.component;
    if (urlProgram != null) data['urlProgram'] = this.urlProgram;
    if (description != null) data['description'] = this.description;
    if (isActive != null) data['isActive'] = this.isActive;
    if (this.teacher != null) {
      data['teacher'] = this.teacher.toMapRef();
    }
    if (studentRefTemp != null && studentRefTemp is Map) {
      data["studentRefTemp"] = Map<String, dynamic>();
      for (var item in studentRefTemp.entries) {
        data["studentRefTemp"][item.key] = item.value.toMapRef();
      }
    }
    if (studentRef != null && studentRef is Map) {
      data["studentRef"] = Map<String, dynamic>();
      for (var item in studentRef.entries) {
        data["studentRef"][item.key] = item.value.toMapRef();
      }
    }
    if (exameId != null) data['exameId'] = this.exameId;
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
    _return = _return +
        '\nProfessor: ${teacher.name.split(' ')[0]} (${teacher.id.substring(0, 4)})';
    _return = _return +
        '\nEstudantes: ${studentRef?.length != null ? studentRef.length : 0}';
    _return = _return +
        '\nQuestões: ${exameId?.length != null && exameId.length > 0 ? exameId.length : "NENHUMA"}. ';
    _return = _return + '\nid: ${id.substring(0, 4)}';
    return _return;
  }
}
