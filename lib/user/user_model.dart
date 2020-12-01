import 'package:aiprof/repository/firestore_model.dart';

class UserModel extends FirestoreModel {
  static final String collection = "user";
  String name;
  String email;
  bool isTeacher;
  bool isActive;
  List<dynamic> classroomId;

  UserModel(String id) : super(id);

  @override
  UserModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('email')) email = map['email'];
    if (map.containsKey('isActive')) isActive = map['isActive'];
    if (map.containsKey('isTeacher')) isTeacher = map['isTeacher'];
    if (map.containsKey('classroomId')) classroomId = map['classroomId'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (email != null) data['email'] = this.email;
    if (isActive != null) data['isActive'] = this.isActive;
    if (isTeacher != null) data['isTeacher'] = this.isTeacher;
    if (classroomId != null) data['classroomId'] = this.classroomId;
    return data;
  }

  Map<String, dynamic> toMapRef() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (email != null) data['email'] = this.email;
    return data;
  }

  String toString() {
    String _return = '';
    _return = _return + '\nEmail: $email';
    _return = _return + '\nId: ${id.substring(0, 4)}';
    return _return;
  }
}
