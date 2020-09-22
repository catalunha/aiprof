import 'package:aiprof/models/firestore_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/models/user_model.dart';

class KnowModel extends FirestoreModel {
  static final String collection = "know";
  UserModel userRef;
  String name;
  String description;
  Map<String, Folder> folder;

  KnowModel(
    String id, {
    this.userRef,
    this.name,
    this.description,
  }) : super(id);

  @override
  KnowModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('description')) description = map['description'];
    userRef = map.containsKey('userRef') && map['userRef'] != null
        ? UserModel(map['userRef']['id']).fromMap(map['userRef'])
        : null;
    if (map["itemMap"] is Map) {
      folder = Map<String, Folder>();
      map["folder"].forEach((k, v) {
        folder[k] = Folder(k).fromMap(v);
      });
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (name != null) data['name'] = this.name;
    if (description != null) data['description'] = this.description;
    if (this.userRef != null) {
      data['userRef'] = this.userRef.toMapRef();
    }
    if (folder != null) {
      Map<String, dynamic> dataFromField = Map<String, dynamic>();
      folder.forEach((k, v) {
        dataFromField[k] = v.toMap();
      });
      data['folder'] = dataFromField;
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
    _return = _return + 'Nome da pasta: $name';
    _return = _return + '\nid: $id';
    return _return;
  }
}

class Folder {
  String id;
  String name;
  String description;
  String idParent;
  Map<String, SituationModel> situationRef;

  Folder(
    this.id, {
    this.name,
    this.description,
    this.idParent,
    this.situationRef,
  });

  Folder fromMap(Map<String, dynamic> map) {
    if (map != null) {
      if (map.containsKey('name')) this.name = map['name'];
      if (map.containsKey('description')) this.description = map['description'];
      if (map.containsKey('idParent')) this.idParent = map['idParent'];
      if (map["situationRef"] is Map) {
        this.situationRef = Map<String, SituationModel>();
        map["situationRef"].forEach((k, v) {
          this.situationRef[k] = SituationModel(k).fromMap(v);
        });
      }
    }
    return this;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.name != null) data['name'] = this.name;
    if (this.description != null) data['description'] = this.description;
    if (this.idParent != null) data['idParent'] = this.idParent;
    if (this.situationRef != null) {
      Map<String, dynamic> dataFromField = Map<String, dynamic>();
      this.situationRef.forEach((k, v) {
        dataFromField[k] = v.toMapRef();
      });
      data['situationRef'] = dataFromField;
    }
    return data;
  }

  String toString() {
    return id + ':' + toMap().toString();
  }
}
