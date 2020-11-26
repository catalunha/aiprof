import 'package:aiprof/repository/firestore_model.dart';
import 'package:aiprof/classroom/classroom_model.dart';
import 'package:aiprof/exame/exame_model.dart';
import 'package:aiprof/question/question_model.dart';
import 'package:aiprof/situation/simulation/simulation_model.dart';
import 'package:aiprof/situation/situation_model.dart';
import 'package:aiprof/user/user_model.dart';

class TaskModel extends FirestoreModel {
  static final String collection = "task";
  UserModel teacherUserRef;
  ClassroomModel classroomRef;
  ExameModel exameRef;
  QuestionModel questionRef;
  SituationModel situationRef;
  UserModel studentUserRef;
  //dados do exame
  dynamic start;
  dynamic end;
  int scoreExame;
  //dados da questao
  int attempt;
  int time;
  int error;
  int scoreQuestion;
  // gestão da tarefa
  dynamic started;
  dynamic lastSendAnswer;
  dynamic attempted;
  bool isOpen;
  Map<String, Input> simulationInput = Map<String, Input>();
  Map<String, Output> simulationOutput = Map<String, Output>();

  TaskModel(
    String id, {
    this.teacherUserRef,
    this.classroomRef,
    this.exameRef,
    this.questionRef,
    this.situationRef,
    this.studentUserRef,
    this.start,
    this.end,
    this.scoreExame,
    this.attempt,
    this.time,
    this.error,
    this.scoreQuestion,
    this.started,
    this.lastSendAnswer,
    this.attempted,
    this.isOpen,
    this.simulationInput,
    this.simulationOutput,
  }) : super(id);

  @override
  TaskModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('teacherUserRef') && map['teacherUserRef'] != null)
      teacherUserRef =
          UserModel(map['teacherUserRef']['id']).fromMap(map['teacherUserRef']);
    if (map.containsKey('classroomRef') && map['classroomRef'] != null)
      classroomRef = ClassroomModel(map['classroomRef']['id'])
          .fromMap(map['classroomRef']);
    if (map.containsKey('exameRef') && map['exameRef'] != null)
      exameRef = ExameModel(map['exameRef']['id']).fromMap(map['exameRef']);
    if (map.containsKey('questionRef') && map['questionRef'] != null)
      questionRef =
          QuestionModel(map['questionRef']['id']).fromMap(map['questionRef']);
    if (map.containsKey('situationRef') && map['situationRef'] != null)
      situationRef = SituationModel(map['situationRef']['id'])
          .fromMap(map['situationRef']);
    if (map.containsKey('studentUserRef') && map['studentUserRef'] != null)
      studentUserRef =
          UserModel(map['studentUserRef']['id']).fromMap(map['studentUserRef']);
    start = map.containsKey('start') && map['start'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['start'].millisecondsSinceEpoch)
        : null;
    end = map.containsKey('end') && map['end'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['end'].millisecondsSinceEpoch)
        : null;
    if (map.containsKey('scoreExame')) scoreExame = map['scoreExame'];
    if (map.containsKey('attempt')) attempt = map['attempt'];
    if (map.containsKey('time')) time = map['time'];
    if (map.containsKey('error')) error = map['error'];
    if (map.containsKey('scoreQuestion')) scoreQuestion = map['scoreQuestion'];
    started = map.containsKey('started') && map['started'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['started'].millisecondsSinceEpoch)
        : null;
    lastSendAnswer =
        map.containsKey('lastSendAnswer') && map['lastSendAnswer'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                map['lastSendAnswer'].millisecondsSinceEpoch)
            : null;
    if (map.containsKey('attempted')) attempted = map['attempted'];
    if (map.containsKey('isOpen')) isOpen = map['isOpen'];
    if (map["simulationInput"] is Map) {
      simulationInput = Map<String, Input>();
      for (var item in map["simulationInput"].entries) {
        simulationInput[item.key] = Input(item.key).fromMap(item.value);
      }
    }
    if (map["simulationOutput"] is Map) {
      simulationOutput = Map<String, Output>();
      for (var item in map["simulationOutput"].entries) {
        simulationOutput[item.key] = Output(item.key).fromMap(item.value);
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (this.teacherUserRef != null) {
      data['teacherUserRef'] = this.teacherUserRef.toMapRef();
    }
    if (this.classroomRef != null) {
      data['classroomRef'] = this.classroomRef.toMapRef();
    }
    if (this.exameRef != null) {
      data['exameRef'] = this.exameRef.toMapRef();
    }
    if (this.questionRef != null) {
      data['questionRef'] = this.questionRef.toMapRef();
    }
    if (this.situationRef != null) {
      data['situationRef'] = this.situationRef.toMapRef();
    }
    if (this.studentUserRef != null) {
      data['studentUserRef'] = this.studentUserRef.toMapRef();
    }
    data['start'] = this.start;
    data['end'] = this.end;
    if (scoreExame != null) data['scoreExame'] = this.scoreExame;
    if (attempt != null) data['attempt'] = this.attempt;
    if (time != null) data['time'] = this.time;
    if (error != null) data['error'] = this.error;
    if (scoreQuestion != null) data['scoreQuestion'] = this.scoreQuestion;
    data['started'] = this.started;
    data['lastSendAnswer'] = this.lastSendAnswer;
    if (attempted != null) data['attempted'] = this.attempted;
    if (isOpen != null) data['isOpen'] = this.isOpen;

    if (simulationInput != null && simulationInput is Map) {
      data["simulationInput"] = Map<String, dynamic>();
      for (var item in simulationInput.entries) {
        data["simulationInput"][item.key] = item.value.toMap();
      }
    }
    if (simulationOutput != null && simulationOutput is Map) {
      data["simulationOutput"] = Map<String, dynamic>();
      for (var item in simulationOutput.entries) {
        data["simulationOutput"][item.key] = item.value.toMap();
      }
    }
    return data;
  }

  @override
  String toString() {
    String _return = '';
    _return = _return +
        'Turma: ${classroomRef.name} (${classroomRef.id.substring(0, 4)}).';
    _return =
        _return + '\nExame: ${exameRef.name} (${exameRef.id.substring(0, 4)})';
    _return = _return +
        '\nQuestão: ${questionRef.name} (${questionRef.id.substring(0, 4)}).';
    _return = _return +
        '\nSituação: ${situationRef.name} (${situationRef.id.substring(0, 4)})';
    _return = _return +
        '\nProfessor: ${teacherUserRef.name.split(' ')[0]} (${teacherUserRef.id.substring(0, 4)})';
    _return = _return +
        '\nEstudante: ${studentUserRef.name} (${studentUserRef.id.substring(0, 4)})';
    _return = _return + '\nInício: $start';
    _return = _return + '\nIniciou: $started';
    _return = _return + '\nÚltimo envio: $lastSendAnswer';
    _return = _return + '\nFim: $end';
    _return = _return + '\nPeso do exame: $scoreExame.';
    _return = _return + ' Peso da questão:$scoreQuestion.';
    _return = _return + ' Tentativa: $attempted de $attempt.';
    _return = _return + ' Tempo de resolução: $time h.';
    _return = _return + ' Erro relativo: $error%.';
    _return = _return + '\nAberta: $isOpen';

    _return = _return + '\n ** Entrada: ${simulationInput.length} ** ';
    List<Input> _inputList = [];
    if (simulationInput != null) {
      for (var item in simulationInput.entries) {
        _inputList.add(Input(item.key).fromMap(item.value.toMap()));
      }
      _inputList.sort((a, b) => a.name.compareTo(b.name));
    }
    for (var item in _inputList) {
      if (item.type == 'texto' || item.type == 'url') {
        _return = _return + '\n${item.name}=... [${item.type}]';
      } else {
        _return = _return + '\n${item.name}=${item.value} [${item.type}]';
      }
    }
    // _return = _return + '\n ** Saída: ${simulationOutput.length} ** ';
    // List<Output> _outputList = [];
    // if (simulationOutput != null) {
    //   for (var item in simulationOutput.entries) {
    //     _outputList.add(Output(item.key).fromMap(item.value.toMap()));
    //   }
    //   _outputList.sort((a, b) => a.name.compareTo(b.name));
    // }
    // for (var item in _outputList) {
    //   _return = _return +
    //       '\n${item.name}=${item.value} (R.: ${item.answer}) [${item.type}] ${item?.right != null ? item.right ? "Confere" : "Não Confere" : "Não corrigido"}';
    //   // if (item.type == 'texto' || item.type == 'url') {
    //   //   _return = _return +
    //   //       '\n${item.name}=... [${item.type}=${item.value.length}c] ${item?.right != null ? item.right ? "Confere" : "Não Confere" : "Não corrigido"}';
    //   // } else {
    //   //   _return = _return +
    //   //       '\n${item.name}=${item.value} (R.: ${item.answer}) [${item.type}] ${item?.right != null ? item.right ? "Confere" : "Não Confere" : "Não corrigido"}';
    //   // }
    // }

    return _return;
  }

  bool get _isOpen {
    if (this.isOpen && this.end.isBefore(DateTime.now())) {
      this.isOpen = false;
      // print('==> Tarefa ${this.id}. aberta=${this.aberta} pois fim < now');
    }
    if (this.isOpen &&
        this.start != null &&
        this.responderAte != null &&
        this.responderAte.isBefore(DateTime.now())) {
      this.isOpen = false;
      // print('==> Tarefa ${this.id} Fechada pois responderAte < now');
    }
    if (this.isOpen &&
        this.attempted != null &&
        this.attempted >= this.attempt) {
      this.isOpen = false;
      // print('==> Tarefa ${this.id} Fechada pois tentou < tentativa');
    }
    return this.isOpen;
  }

  DateTime get responderAte {
    if (this.start != null) {
      return this.start.add(Duration(hours: this.time));
    } else {
      return null;
    }
  }

  dynamic get tempoPResponder {
    responderAte;
    if (this.start == null) {
      // return Duration(hours: this.tempo);
      return null;
    } else {
      if (this.responderAte != null && this.end.isBefore(this.responderAte)) {
        return this.end.difference(DateTime.now());
      }
      if (this.responderAte != null) {
        return this.responderAte.difference(DateTime.now());
      }
    }
  }

  void updateAll() {
    responderAte;
    tempoPResponder;
    _isOpen;
  }
}
