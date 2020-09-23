import 'package:aiprof/models/firestore_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/models/user_model.dart';

class SimulationModel extends FirestoreModel {
  static final String collection = "Simulacao";
  UserModel userRef;
  SituationModel situationRef;
  String name;
  Map<String, Input> input = Map<String, Input>();
  Map<String, Output> output = Map<String, Output>();

  SimulationModel({
    String id,
    this.userRef,
    this.situationRef,
    this.name,
    this.input,
    this.output,
  }) : super(id);

  @override
  SimulationModel fromMap(Map<String, dynamic> map) {
//old fields
    if (map.containsKey('professor') && map['professor'] != null)
      userRef = UserModel(map['professor']['id'])
          .fromMap({'name': map['professor']['nome']});
    if (map.containsKey('problema') && map['problema'] != null)
      situationRef = SituationModel(map['problema']['id'])
          .fromMap({'name': map['problema']['nome']});
    if (map.containsKey('nome')) name = map['nome'];
    if (map["variavel"] is Map) {
      input = Map<String, Input>();
      for (var item in map["variavel"].entries) {
        input[item.key] = Input.fromMap(item.value);
      }
    }
    if (map["gabarito"] is Map) {
      output = Map<String, Output>();
      for (var item in map["gabarito"].entries) {
        output[item.key] = Output.fromMap(item.value);
      }
    }

//new fields
    if (map.containsKey('userRef') && map['userRef'] != null)
      userRef = UserModel(map['userRef']['id']).fromMap(map['userRef']);
    if (map.containsKey('situationRef') && map['situationRef'] != null)
      situationRef = SituationModel(map['situationRef']['id'])
          .fromMap(map['situationRef']);
    if (map.containsKey('name')) name = map['name'];
    if (map["input"] is Map) {
      input = Map<String, Input>();
      for (var item in map["input"].entries) {
        input[item.key] = Input.fromMap(item.value);
      }
    }
    if (map["output"] is Map) {
      output = Map<String, Output>();
      for (var item in map["output"].entries) {
        output[item.key] = Output.fromMap(item.value);
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userRef != null) {
      data['userRef'] = this.userRef.toMap();
    }
    if (this.situationRef != null) {
      data['situationRef'] = this.situationRef.toMap();
    }

    if (name != null) data['name'] = this.name;

    if (input != null && input is Map) {
      data["input"] = Map<String, dynamic>();
      for (var item in input.entries) {
        data["input"][item.key] = item.value.toMap();
      }
    }
    if (output != null && output is Map) {
      data["output"] = Map<String, dynamic>();
      for (var item in output.entries) {
        data["output"][item.key] = item.value.toMap();
      }
    }
    return data;
  }
}

/// type: number | word | text | url | urlimage
class Input {
  String name;
  String type;
  String value;

  Input({
    this.name,
    this.type,
    this.value,
  });

  Input.fromMap(Map<dynamic, dynamic> map) {
    // old fields
    if (map.containsKey('nome')) name = map['nome'];
    if (map.containsKey('tipo')) type = map['tipo'];
    if (map.containsKey('valor')) value = map['valor'];
    // new fields
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('type')) type = map['type'];
    if (map.containsKey('value')) value = map['value'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (name != null) data['name'] = this.name;
    if (type != null) data['type'] = this.type;
    if (value != null) data['value'] = this.value;
    return data;
  }
}

/// type: number | word | text | url | file
class Output {
  String name;
  String type;
  String value;
  String answer;
  int score;

  Output({
    this.name,
    this.type,
    this.value,
    this.answer,
    this.score,
  });

  Output.fromMap(Map<dynamic, dynamic> map) {
    // old fields
    if (map.containsKey('nome')) name = map['nome'];
    if (map.containsKey('tipo')) type = map['tipo'];
    if (map.containsKey('valor')) value = map['valor'];
    if (map.containsKey('resposta')) answer = map['resposta'];
    if (map.containsKey('nota')) score = map['nota'];
    //new fields
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('type')) type = map['type'];
    if (map.containsKey('value')) value = map['value'];
    if (map.containsKey('answer')) answer = map['answer'];
    if (map.containsKey('score')) score = map['score'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (name != null) data['name'] = this.name;
    if (type != null) data['type'] = this.type;
    if (value != null) data['value'] = this.value;
    if (answer != null) data['answer'] = this.answer;
    if (score != null) data['score'] = this.score;
    return data;
  }
}
