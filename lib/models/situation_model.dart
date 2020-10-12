import 'package:aiprof/models/firestore_model.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/models/user_model.dart';

class SituationModel extends FirestoreModel {
  static final String collection = "situation";
  UserModel userRef;
  String area;
  String name;
  String description;
  String url;
  bool isActive;
  bool isSimulationConsistent;
  Map<String, SimulationModel> simulationModel;

  SituationModel(
    String id, {
    this.isActive,
    this.isSimulationConsistent,
    this.area,
    this.name,
    this.description,
    this.url,
    this.userRef,
    this.simulationModel,
  }) : super(id);

  SituationModel.clone(SituationModel origin)
      : this(
          origin.id,
          isActive: origin.isActive,
          isSimulationConsistent: origin.isSimulationConsistent,
          area: origin.area,
          name: origin.name,
          description: origin.description,
          url: origin.url,
          userRef: origin.userRef,
          simulationModel: origin.simulationModel,
        );

  @override
  SituationModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('isActive')) isActive = map['isActive'];
    if (map.containsKey('isSimulationConsistent'))
      isSimulationConsistent = map['isSimulationConsistent'];

    if (map.containsKey('area')) area = map['area'];
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('description')) description = map['description'];
    if (map.containsKey('url')) url = map['url'];

    if (map.containsKey('userRef') && map['userRef'] != null)
      userRef = UserModel(map['userRef']['id']).fromMap(map['userRef']);
    if (map["simulationModel"] is Map) {
      simulationModel = Map<String, SimulationModel>();
      for (var item in map["simulationModel"].entries) {
        simulationModel[item.key] =
            SimulationModel(item.key).fromMap(item.value);
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // _updateAll();
    if (isActive != null) data['isActive'] = this.isActive;
    if (isSimulationConsistent != null)
      data['isSimulationConsistent'] = this.isSimulationConsistent;
    if (area != null) data['area'] = this.area;
    if (name != null) data['name'] = this.name;
    if (description != null) data['description'] = this.description;
    if (url != null) data['url'] = this.url;
    if (this.userRef != null) {
      data['userRef'] = this.userRef.toMapRef();
    }
    if (simulationModel != null && simulationModel is Map) {
      data["simulationModel"] = Map<String, dynamic>();
      for (var item in simulationModel.entries) {
        data["simulationModel"][item.key] = item.value.toMap();
      }
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
    _return = _return +
        '\nSimulações: ${simulationModel?.length != null && simulationModel.length > 0 ? simulationModel.length : "NENHUMA"}. Situação: ${isSimulationConsistent != null && isSimulationConsistent ? "consistente" : "INconsistente"}';
    _return = _return + '\nArea: $area';
    _return = _return + '\nDescrição: $description';
    _return = _return +
        '\nProfessor: ${userRef.name.split(' ')[0]} (${userRef.id.substring(0, 4)})';
    // _return = _return +
    //     '\nSimulações: ${simulationModel?.length != null && simulationModel.length > 0 ? simulationModel.length : ""}';
    _return = _return + '\nid: ${id.substring(0, 4)}';
    return _return;
  }
}
