import 'package:aiprof/models/firestore_model.dart';
import 'package:aiprof/models/user_model.dart';

class SituationModel extends FirestoreModel {
  static final String collection = "Problema";
  UserModel userRef;
  bool isActive;
  String area;
  String name;
  String description;
  String url;

  SituationModel(
    String id, {
    this.isActive,
    this.area,
    this.name,
    this.description,
    this.url,
    this.userRef,
  }) : super(id);

  SituationModel.clone(SituationModel origin)
      : this(
          origin.id,
          isActive: origin.isActive,
          area: origin.area,
          name: origin.name,
          description: origin.description,
          url: origin.url,
          userRef: origin.userRef,
        );

  @override
  SituationModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('ativo')) isActive = map['ativo'];
    if (map.containsKey('isActive')) isActive = map['isActive'];
    if (map.containsKey('pasta') && map['pasta'] != null)
      area = map['pasta']['nome'];
    if (map.containsKey('area')) area = map['area'];
    if (map.containsKey('nome')) name = map['nome'];
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('descricao')) description = map['descricao'];
    if (map.containsKey('description')) description = map['description'];
    if (map.containsKey('url')) url = map['url'];
    if (map.containsKey('professor') && map['professor'] != null)
      userRef = UserModel(map['professor']['id'])
          .fromMap({'name': map['professor']['nome']});
    if (map.containsKey('userRef') && map['userRef'] != null)
      userRef = UserModel(map['userRef']['id']).fromMap(map['userRef']);
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // _updateAll();
    if (isActive != null) data['isActive'] = this.isActive;
    // if (number != null) data['number'] = this.number;
    if (area != null) data['area'] = this.area;
    if (name != null) data['name'] = this.name;
    if (description != null) data['description'] = this.description;
    if (url != null) data['url'] = this.url;
    if (this.userRef != null) {
      data['userRef'] = this.userRef.toMapRef();
    }
    return data;
  }

  Map<String, dynamic> toMapRef() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (url != null) data['url'] = this.url;
    return data;
  }

  @override
  String toString() {
    String _return = '';
    _return = _return + '\nArea: $area';
    _return = _return + '\nDescrição: $description';
    _return = _return + '\nuserRef.name: ${userRef.name}';
    _return = _return + '\nid: $id';
    return _return;
  }
}
