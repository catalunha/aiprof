import 'package:aiprof/models/firestore_model.dart';

class PhotoModel extends FirestoreModel {
  static final String collection = "photo";
  String uploadID;
  String url;
  String path;

  PhotoModel(
    String id, {
    this.uploadID,
    this.url,
    this.path,
  }) : super(id);

  PhotoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('uploadID')) uploadID = map['uploadID'];
    if (map.containsKey('url')) url = map['url'];
    if (map.containsKey('path')) path = map['path'];
    return this;
  }

  Map<String, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (uploadID != null) data['uploadID'] = this.uploadID;
    if (url != null) data['url'] = this.url;
    if (path != null) data['path'] = this.path;
    return data;
  }

  Map<String, dynamic> toMapRef() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (uploadID != null) data['uploadID'] = this.uploadID;
    if (url != null) data['url'] = this.url;
    if (path != null) data['path'] = this.path;
    return data;
  }
}
