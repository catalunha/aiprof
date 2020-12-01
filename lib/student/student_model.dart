import 'package:aiprof/user/user_model.dart';

class StudentModel extends UserModel {
  String code;
  bool isDelivered;
  bool isSelected;

  StudentModel(String id) : super(id);

  @override
  StudentModel fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    if (map.containsKey('code')) code = map['code'];
    if (map.containsKey('isDelivered')) isDelivered = map['isDelivered'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data.addAll(super.toMap());
    if (code != null) data['code'] = this.code;
    if (isDelivered != null) data['isDelivered'] = this.isDelivered;
    return data;
  }

  Map<String, dynamic> toMapRef() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (email != null) data['email'] = this.email;
    if (code != null) data['code'] = this.code;
    return data;
  }

  String toString() {
    String _return = '';
    _return = _return + '\nMatricula: $code';
    _return = _return + '\nEmail: $email';
    _return = _return + '\nisDelivered: $isDelivered';
    _return = _return + '\nisSelected: $isSelected';
    _return = _return + '\nId: ${id.substring(0, 4)}';
    return _return;
  }
}
