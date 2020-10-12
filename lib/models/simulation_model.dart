class SimulationModel {
  String id;
  // UserModel userRef;
  // SituationModel situationRef;
  String name;
  Map<String, Input> input = Map<String, Input>();
  Map<String, Output> output = Map<String, Output>();

  SimulationModel(
    this.id, {
    // this.userRef,
    // this.situationRef,
    this.name,
    this.input,
    this.output,
  });

  SimulationModel fromMap(Map<String, dynamic> map) {
// //old fields
//     if (map.containsKey('professor') && map['professor'] != null)
//       userRef = UserModel(map['professor']['id'])
//           .fromMap({'name': map['professor']['nome']});
//     if (map.containsKey('problema') && map['problema'] != null)
//       situationRef = SituationModel(map['problema']['id'])
//           .fromMap({'name': map['problema']['nome']});
//     if (map.containsKey('nome')) name = map['nome'];
//     if (map["variavel"] is Map) {
//       input = Map<String, Input>();
//       for (var item in map["variavel"].entries) {
//         input[item.key] = Input(item.key).fromMap(item.value);
//       }
//     }
//     if (map["gabarito"] is Map) {
//       output = Map<String, Output>();
//       for (var item in map["gabarito"].entries) {
//         output[item.key] = Output(item.key).fromMap(item.value);
//       }
//     }

//new fields
    // if (map.containsKey('userRef') && map['userRef'] != null)
    //   userRef = UserModel(map['userRef']['id']).fromMap(map['userRef']);
    // if (map.containsKey('situationRef') && map['situationRef'] != null)
    //   situationRef = SituationModel(map['situationRef']['id'])
    //       .fromMap(map['situationRef']);
    if (map.containsKey('name')) name = map['name'];
    if (map["input"] is Map) {
      input = Map<String, Input>();
      for (var item in map["input"].entries) {
        input[item.key] = Input(item.key).fromMap(item.value);
      }
    }
    if (map["output"] is Map) {
      output = Map<String, Output>();
      for (var item in map["output"].entries) {
        output[item.key] = Output(item.key).fromMap(item.value);
      }
    }
    return this;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.userRef != null) {
    //   data['userRef'] = this.userRef.toMapRef();
    // }
    // if (this.situationRef != null) {
    //   data['situationRef'] = this.situationRef.toMapRef();
    // }

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

  Map<String, dynamic> toMapRef() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    return data;
  }

  String toString() {
    String _return = '';
    _return = _return + '\n ** Entradas ** ';
    List<Input> _inputList = [];
    if (input != null) {
      for (var item in input.entries) {
        _inputList.add(Input(item.key).fromMap(item.value.toMap()));
      }
      _inputList.sort((a, b) => a.name.compareTo(b.name));
    }
    for (var item in _inputList) {
      if (item.type == 'texto' || item.type == 'url') {
        _return =
            _return + '\n${item.name}=... [${item.type}=${item.value.length}c]';
      } else {
        _return = _return + '\n${item.name}=${item.value} [${item.type}]';
      }
    }
    _return = _return + '\n ** Saídas ** ';
    List<Output> _outputList = [];
    if (output != null) {
      for (var item in output.entries) {
        _outputList.add(Output(item.key).fromMap(item.value.toMap()));
      }
      _outputList.sort((a, b) => a.name.compareTo(b.name));
    }
    for (var item in _outputList) {
      if (item.type == 'texto' || item.type == 'url') {
        _return =
            _return + '\n${item.name}=... [${item.type}=${item.value.length}c]';
      } else {
        _return = _return + '\n${item.name}=${item.value} [${item.type}]';
      }
    }

    return _return;
  }
}

/// type: numero | palavra | texto | url | arquivo
class Input {
  String id;
  String name;
  String type;
  String value;

  Input(
    this.id, {
    this.name,
    this.type,
    this.value,
  });

  Input fromMap(Map<dynamic, dynamic> map) {
    // old fields
    if (map.containsKey('nome')) name = map['nome'];
    if (map.containsKey('tipo')) type = map['tipo'];
    if (map.containsKey('valor')) value = map['valor'];
    // new fields
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('type')) type = map['type'];
    if (map.containsKey('value')) value = map['value'];
    return this;
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (name != null) data['name'] = this.name;
    if (type != null) data['type'] = this.type;
    if (value != null) data['value'] = this.value;
    return data;
  }
}

/// type: numero | palavra | texto | url | arquivo
class Output {
  String id;
  String name;
  String type;
  String value;
  String answer;
  bool right;

  Output(
    this.id, {
    this.name,
    this.type,
    this.value,
    this.answer,
    this.right,
  });

  Output fromMap(Map<dynamic, dynamic> map) {
    // old fields
    if (map.containsKey('nome')) name = map['nome'];
    if (map.containsKey('tipo')) type = map['tipo'];
    if (map.containsKey('valor')) value = map['valor'];
    if (map.containsKey('resposta')) answer = map['resposta'];
    if (map.containsKey('nota')) right = map['nota'];
    //new fields
    if (map.containsKey('name')) name = map['name'];
    if (map.containsKey('type')) type = map['type'];
    if (map.containsKey('value')) value = map['value'];
    if (map.containsKey('answer')) answer = map['answer'];
    if (map.containsKey('right')) right = map['right'];
    return this;
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (name != null) data['name'] = this.name;
    if (type != null) data['type'] = this.type;
    if (value != null) data['value'] = this.value;
    if (answer != null) data['answer'] = this.answer;
    if (right != null) data['right'] = this.right;
    return data;
  }
}
