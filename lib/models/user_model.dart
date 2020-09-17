import 'package:aiprof/models/firestore_model.dart';

class UserModel extends FirestoreModel {
  static final String collection = "user";
  String name;
  String email;
  bool isTeacher;
  bool isActive;
  // String phone;
  // String nickname;
  // String photoUrl;
  String code;
  // List<dynamic> route;
  int classNumber;
  int folderNumber;
  int problemNumber;
  List<dynamic> classroomId;

  UserModel(String id,
      {this.name,
      // this.nickname,
      this.code,
      // this.phone,
      this.email,
      this.isActive,
      this.isTeacher,
      // this.photoUrl,
      this.classNumber,
      this.folderNumber,
      this.problemNumber,
      // this.route,
      this.classroomId})
      : super(id);

  @override
  UserModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('email')) email = map['email'];
    // if (map.containsKey('nickname')) nickname = map['nickname'];
    if (map.containsKey('code')) code = map['code'];
    // if (map.containsKey('phone')) phone = map['phone'];
    if (map.containsKey('isActive')) isActive = map['isActive'];
    if (map.containsKey('isTeacher')) isTeacher = map['isTeacher'];
    if (map.containsKey('folderNumber')) folderNumber = map['folderNumber'];
    if (map.containsKey('problemNumber')) problemNumber = map['problemNumber'];
    if (map.containsKey('classNumber')) classNumber = map['classNumber'];
    // if (map.containsKey('photoUrl')) photoUrl = map['photoUrl'];
    // if (map.containsKey('route')) route = map['route'];
    if (map.containsKey('classroomId')) classroomId = map['classroomId'];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (name != null) data['name'] = this.name;
    // if (nickname != null) data['nickname'] = this.nickname;
    if (code != null) data['code'] = this.code;
    // if (phone != null) data['phone'] = this.phone;
    if (email != null) data['email'] = this.email;
    if (isActive != null) data['isActive'] = this.isActive;
    if (isTeacher != null) data['isTeacher'] = this.isTeacher;
    if (folderNumber != null) data['folderNumber'] = this.folderNumber;
    if (problemNumber != null) data['problemNumber'] = this.problemNumber;
    // if (photoUrl != null) data['photoUrl'] = this.photoUrl;
    if (classNumber != null) data['classNumber'] = this.classNumber;
    if (classroomId != null) data['classroomId'] = this.classroomId;
    // if (route != null) data['route'] = this.route;

    return data;
  }

  Map<String, dynamic> toMapRef() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    // if (photoUrl != null) data['photoUrl'] = this.photoUrl;
    return data;
  }
}
