import 'package:aiprof/user/user_model.dart';

class TeacherModel extends UserModel {
  bool selected;

  TeacherModel(String id) : super(id);

  // @override
  // TeacherModel fromMap(Map<String, dynamic> map) {
  //   // if (map.containsKey('code')) code = map['code'];
  //   return this;
  // }

  // @override
  // Map<String, dynamic> toMap() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   // if (code != null) data['code'] = this.code;
  //   return data;
  // }

  // Map<String, dynamic> toMapRef() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   if (id != null) data['id'] = this.id;
  //   return data;
  // }

  // String toString() {
  //   String _return = '';
  //   _return = _return + '\nId: ${id.substring(0, 4)}';
  //   return _return;
  // }
}
