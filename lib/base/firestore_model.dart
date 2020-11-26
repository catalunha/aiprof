abstract class FirestoreModel {
  static final String collection = null;
  String id;
  FirestoreModel(this.id);
  FirestoreModel fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap();
  @override
  String toString() {
    return id + ':' + toMap().toString();
  }
}
