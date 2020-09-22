import 'package:aiprof/models/firestore_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/models/user_model.dart';

class KnowModel extends FirestoreModel {
  static final String collection = "know";
  UserModel userRef;
  String name;
  String description;
  Map<String, Folder> folderMap;

  KnowModel(
    String id, {
    this.userRef,
    this.name,
    this.description,
    this.folderMap,
  }) : super(id);
  KnowModel.clone(KnowModel origin)
      : this(
          origin.id,
          userRef: origin.userRef,
          name: origin.name,
          description: origin.description,
          folderMap: origin.folderMap,
        );
  @override
  KnowModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('description')) description = map['description'];
    userRef = map.containsKey('userRef') && map['userRef'] != null
        ? UserModel(map['userRef']['id']).fromMap(map['userRef'])
        : null;
    if (map["folderMap"] is Map) {
      folderMap = Map<String, Folder>();
      map["folderMap"].forEach((k, v) {
        folderMap[k] = Folder(k).fromMap(v);
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
    if (folderMap != null) {
      Map<String, dynamic> dataFromField = Map<String, dynamic>();
      folderMap.forEach((k, v) {
        dataFromField[k] = v.toMap();
      });
      data['folderMap'] = dataFromField;
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
    _return = _return + 'Descrição: $description';
    _return = _return + '\nfolder: ${folderMap.length}';
    _return = _return + '\nid: $id';
    return _return;
  }
}

class Folder {
  String id;
  String name;
  String description;
  String idParent;
  Map<String, SituationModel> situationRefMap;

  Folder(
    this.id, {
    this.name,
    this.description,
    this.idParent,
    this.situationRefMap,
  });

  Folder fromMap(Map<String, dynamic> map) {
    if (map != null) {
      if (map.containsKey('name')) this.name = map['name'];
      if (map.containsKey('description')) this.description = map['description'];
      if (map.containsKey('idParent')) this.idParent = map['idParent'];
      if (map["situationRefMap"] is Map) {
        this.situationRefMap = Map<String, SituationModel>();
        map["situationRefMap"].forEach((k, v) {
          this.situationRefMap[k] = SituationModel(k).fromMap(v);
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
    if (this.situationRefMap != null) {
      Map<String, dynamic> dataFromField = Map<String, dynamic>();
      this.situationRefMap.forEach((k, v) {
        dataFromField[k] = v.toMapRef();
      });
      data['situationRefMap'] = dataFromField;
    }
    return data;
  }

  String toString() {
    return id + ':' + toMap().toString();
  }
}
