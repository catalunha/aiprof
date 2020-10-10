import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart' as uuid;

// +++ Actions Sync
class SetSimulationCurrentSyncSimulationAction extends ReduxAction<AppState> {
  final String id;

  SetSimulationCurrentSyncSimulationAction(this.id);

  @override
  AppState reduce() {
    SimulationModel simulationModel;
    if (id == null) {
      simulationModel = SimulationModel(null);
    } else {
      // SimulationModel simulationModelTemp = state.simulationState.simulationList
      //     .firstWhere((element) => element.id == id);
      // simulationModel = SimulationModel(simulationModelTemp.id)
      //     .fromMap(simulationModelTemp.toMap());
      simulationModel = SimulationModel(id).fromMap(
          state.situationState.situationCurrent.simulationModel[id].toMap());
    }
    return state.copyWith(
      simulationState: state.simulationState.copyWith(
        simulationCurrent: simulationModel,
      ),
    );
  }
}
// class SetSimulationCurrentSyncSimulationAction extends ReduxAction<AppState> {
//   final String id;

//   SetSimulationCurrentSyncSimulationAction(this.id);

//   @override
//   AppState reduce() {
//     SimulationModel simulationModel;
//     if (id == null) {
//       simulationModel = SimulationModel(null);
//     } else {
//       SimulationModel simulationModelTemp = state.simulationState.simulationList
//           .firstWhere((element) => element.id == id);
//       simulationModel = SimulationModel(simulationModelTemp.id)
//           .fromMap(simulationModelTemp.toMap());
//     }
//     return state.copyWith(
//       simulationState: state.simulationState.copyWith(
//         simulationCurrent: simulationModel,
//       ),
//     );
//   }
// }

class SetSimulationFilterSyncSimulationAction extends ReduxAction<AppState> {
  final SimulationFilter simulationFilter;

  SetSimulationFilterSyncSimulationAction(this.simulationFilter);

  @override
  AppState reduce() {
    return state.copyWith(
      simulationState: state.simulationState.copyWith(
        simulationFilter: simulationFilter,
      ),
    );
  }

  void after() => dispatch(GetDocsSimulationListAsyncSimulationAction());
}

class GetDocsSimulationListAsyncSimulationAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    print('GetDocsSimulationListAsyncSimulationAction...');
    // Firestore firestore = Firestore.instance;
    //+++ old doc
    // DocumentSnapshot docRef = await firestore
    //     .collection(SituationModel.collection)
    //     .document(state.situationState.situationCurrent.id)
    //     .get();
    // SituationModel situationModel =
    //     SituationModel(docRef.documentID).fromMap(docRef.data);
    // //+++ Atualiza lista de situations pois uma situação foi alterar e a lista nao precisa ser relida.
    // int index = state.situationState.situationList
    //     .indexWhere((element) => element.id == situationModel.id);
    // List<SituationModel> situationList = [];
    // situationList.addAll(state.situationState.situationList);
    // situationList[index] = situationModel;
    // //---
    List<SimulationModel> simulationList = [];
    if (state.situationState.situationCurrent.simulationModel != null) {
      for (var item
          in state.situationState.situationCurrent.simulationModel.entries) {
        simulationList
            .add(SimulationModel(item.key).fromMap(item.value.toMap()));
      }
      // print(simulationList);
      simulationList.sort((a, b) => a.name.compareTo(b.name));
    }
    return state.copyWith(
      // situationState: state.situationState.copyWith(
      //   situationCurrent: situationModel,
      //   situationList: situationList,
      // ),
      simulationState: state.simulationState.copyWith(
        simulationList: simulationList,
      ),
    );
  }
}
// --- Actions Sync

// +++ Actions Async
// class GetDocsSimulationListAsyncSimulationAction extends ReduxAction<AppState> {
//   @override
//   Future<AppState> reduce() async {
//     print('GetDocsSimulationListAsyncSimulationAction...');
//     Firestore firestore = Firestore.instance;
//     Query collRef;
//     //+++ old doc
//     collRef = firestore
//         .collection(SimulationModel.collection)
//         .where('professor.id', isEqualTo: state.loggedState.userModelLogged.id)
//         .where('problema.id',
//             isEqualTo: state.situationState.situationCurrent.id);

//     final docsSnapOld = await collRef.getDocuments();

//     final listDocsOld = docsSnapOld.documents
//         .map((docSnap) =>
//             SimulationModel(docSnap.documentID).fromMap(docSnap.data))
//         .toList();
//     //--- old doc
//     //+++ new doc
//     collRef = firestore
//         .collection(SimulationModel.collection)
//         .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id)
//         .where('situationRef.id',
//             isEqualTo: state.situationState.situationCurrent.id);
//     final docsSnapNew = await collRef.getDocuments();

//     final listDocsNew = docsSnapNew.documents
//         .map((docSnap) =>
//             SimulationModel(docSnap.documentID).fromMap(docSnap.data))
//         .toList();
//     //--- new doc

//     // Map<dynamic, SimulationModel> mapping =
//     //     Map.fromIterable(listDocs, key: (v) => v.id, value: (v) => v);
//     // List<dynamic> ids = state.loggedState.userModelLogged.classroomId;
//     // final listDocsSorted = [for (dynamic id in ids) mapping[id]];

//     for (SimulationModel item in listDocsOld) {
//       listDocsNew.removeWhere((e) => e.id == item.id);
//     }
//     List<SimulationModel> listDocsDistinct = [...listDocsOld, ...listDocsNew];

//     listDocsDistinct.sort((a, b) => a.name.compareTo(b.name));

//     return state.copyWith(
//       simulationState: state.simulationState.copyWith(
//         simulationList: listDocsDistinct,
//       ),
//     );
//   }
// }

class AddDocSimulationCurrentAsyncSimulationAction
    extends ReduxAction<AppState> {
  final String name;

  AddDocSimulationCurrentAsyncSimulationAction({
    this.name,
  });
  @override
  Future<AppState> reduce() async {
    print('AddDocSimulationCurrentAsyncSimulationAction...');
    Firestore firestore = Firestore.instance;
    SituationModel situationModel =
        SituationModel(state.situationState.situationCurrent.id)
            .fromMap(state.situationState.situationCurrent.toMap());
    SimulationModel simulationModel =
        SimulationModel(state.simulationState.simulationCurrent.id)
            .fromMap(state.simulationState.simulationCurrent.toMap());
    if (situationModel.simulationModel == null) {
      situationModel.simulationModel = Map<String, SimulationModel>();
    }
    simulationModel.name = name;

    situationModel.simulationModel[uuid.Uuid().v4()] = simulationModel;
    await firestore
        .collection(SituationModel.collection)
        .document(situationModel.id)
        .updateData(situationModel.toMap());
    return null;
  }

  // @override
  // Object wrapError(error) => UserException("ATENÇÃO:", cause: error);
  @override
  void after() {
    // dispatch(GetDocsSituationListAsyncSituationAction());
    dispatch(GetDocsSimulationListAsyncSimulationAction());
  }
}

// class AddDocSimulationCurrentAsyncSimulationAction
//     extends ReduxAction<AppState> {
//   final String name;

//   AddDocSimulationCurrentAsyncSimulationAction({
//     this.name,
//   });
//   @override
//   Future<AppState> reduce() async {
//     print('AddDocSimulationCurrentAsyncSimulationAction...');
//     Firestore firestore = Firestore.instance;
//     SimulationModel simulationModel =
//         SimulationModel(state.simulationState.simulationCurrent.id)
//             .fromMap(state.simulationState.simulationCurrent.toMap());
//     // simulationModel.userRef = UserModel(state.loggedState.userModelLogged.id)
//     //     .fromMap(state.loggedState.userModelLogged.toMapRef());

//     simulationModel.name = name;

//     await firestore
//         .collection(SimulationModel.collection)
//         .add(simulationModel.toMap());
//     return null;
//   }

//   // @override
//   // Object wrapError(error) => UserException("ATENÇÃO:", cause: error);
//   @override
//   void after() => dispatch(GetDocsSimulationListAsyncSimulationAction());
// }

class UpdateDocSimulationCurrentAsyncSimulationAction
    extends ReduxAction<AppState> {
  final String name;
  final bool isDelete;

  UpdateDocSimulationCurrentAsyncSimulationAction({
    this.name,
    this.isDelete,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocSimulationCurrentAsyncSimulationAction...');
    Firestore firestore = Firestore.instance;
    SituationModel situationModel =
        SituationModel(state.situationState.situationCurrent.id)
            .fromMap(state.situationState.situationCurrent.toMap());
    SimulationModel simulationModel =
        SimulationModel(state.simulationState.simulationCurrent.id)
            .fromMap(state.simulationState.simulationCurrent.toMap());
    if (isDelete) {
      situationModel.simulationModel.remove(simulationModel.id);
    } else {
      simulationModel.name = name;
      situationModel.simulationModel[simulationModel.id] = simulationModel;
    }
    await firestore
        .collection(SituationModel.collection)
        .document(situationModel.id)
        .updateData(situationModel.toMap());
    return null;
  }

  @override
  void after() {
    // dispatch(GetDocsSituationListAsyncSituationAction());
    dispatch(GetDocsSimulationListAsyncSimulationAction());
  }
}

// class UpdateDocSimulationCurrentAsyncSimulationAction
//     extends ReduxAction<AppState> {
//   final String name;
//   final bool isDelete;

//   UpdateDocSimulationCurrentAsyncSimulationAction({
//     this.name,
//     this.isDelete,
//   });
//   @override
//   Future<AppState> reduce() async {
//     print('UpdateDocSimulationCurrentAsyncSimulationAction...');
//     Firestore firestore = Firestore.instance;
//     SimulationModel simulationModel =
//         SimulationModel(state.simulationState.simulationCurrent.id)
//             .fromMap(state.simulationState.simulationCurrent.toMap());

//     if (isDelete) {
//       await firestore
//           .collection(SimulationModel.collection)
//           .document(simulationModel.id)
//           .delete();
//     } else {
//       simulationModel.name = name;
//       await firestore
//           .collection(SimulationModel.collection)
//           .document(simulationModel.id)
//           .updateData(simulationModel.toMap());
//     }
//     return null;
//   }

//   @override
//   void after() => dispatch(GetDocsSimulationListAsyncSimulationAction());
// }

// +++ Actions Sync for Input

class SetInputCurrentSyncSimulationAction extends ReduxAction<AppState> {
  final String id;

  SetInputCurrentSyncSimulationAction(this.id);

  @override
  AppState reduce() {
    Input _input;
    if (id == null) {
      _input = Input(null);
    } else {
      _input = Input(state.simulationState.simulationCurrent.input[id].id)
          .fromMap(state.simulationState.simulationCurrent.input[id].toMap());
    }
    return state.copyWith(
      simulationState: state.simulationState.copyWith(
        inputCurrent: _input,
      ),
    );
  }
}

class AddInputSyncSimulationAction extends ReduxAction<AppState> {
  final String name;
  final String type;
  final String value;

  AddInputSyncSimulationAction({
    this.name,
    this.type,
    this.value,
  });
  @override
  AppState reduce() {
    print('AddInputSyncSimulationAction...');
    Input _input;
    _input = state.simulationState.inputCurrent;
    _input.id = uuid.Uuid().v4();
    _input.name = name;
    _input.type = type;
    _input.value = value;
    SimulationModel simulationModel =
        SimulationModel(state.simulationState.simulationCurrent.id)
            .fromMap(state.simulationState.simulationCurrent.toMap());

    if (simulationModel.input == null) {
      simulationModel.input = Map<String, Input>();
    }

    simulationModel.input[_input.id] = _input;

    return state.copyWith(
      simulationState: state.simulationState.copyWith(
        simulationCurrent: simulationModel,
      ),
    );
  }
}

class UpdateInputSyncSimulationAction extends ReduxAction<AppState> {
  final String name;
  final String type;
  final String value;
  final bool isRemove;

  UpdateInputSyncSimulationAction({
    this.name,
    this.type,
    this.value,
    this.isRemove,
  });
  @override
  AppState reduce() {
    print('UpdateInputSyncSimulationAction...');
    Input _input;
    _input = state.simulationState.inputCurrent;

    SimulationModel simulationModel =
        SimulationModel(state.simulationState.simulationCurrent.id)
            .fromMap(state.simulationState.simulationCurrent.toMap());
    if (isRemove) {
      simulationModel.input.remove(_input.id);
    } else {
      _input.name = name;
      _input.type = type;
      _input.value = value;
      simulationModel.input[_input.id] = _input;
    }

    return state.copyWith(
      simulationState: state.simulationState.copyWith(
        simulationCurrent: simulationModel,
      ),
    );
  }
}

// --- Actions Sync for Input

// +++ Actions Sync for Output

class SetOutputCurrentSyncSimulationAction extends ReduxAction<AppState> {
  final String id;

  SetOutputCurrentSyncSimulationAction(this.id);

  @override
  AppState reduce() {
    Output _output;
    if (id == null) {
      _output = Output(null);
    } else {
      _output = Output(state.simulationState.simulationCurrent.output[id].id)
          .fromMap(state.simulationState.simulationCurrent.output[id].toMap());
    }
    return state.copyWith(
      simulationState: state.simulationState.copyWith(
        outputCurrent: _output,
      ),
    );
  }
}

class AddOutputSyncSimulationAction extends ReduxAction<AppState> {
  final String name;
  final String type;
  final String value;

  AddOutputSyncSimulationAction({
    this.name,
    this.type,
    this.value,
  });
  @override
  AppState reduce() {
    print('AddOutputSyncSimulationAction...');
    Output _output;
    _output = state.simulationState.outputCurrent;
    _output.id = uuid.Uuid().v4();
    _output.name = name;
    _output.type = type;
    _output.value = value;
    SimulationModel simulationModel =
        SimulationModel(state.simulationState.simulationCurrent.id)
            .fromMap(state.simulationState.simulationCurrent.toMap());

    if (simulationModel.output == null) {
      simulationModel.output = Map<String, Output>();
    }

    simulationModel.output[_output.id] = _output;

    return state.copyWith(
      simulationState: state.simulationState.copyWith(
        simulationCurrent: simulationModel,
      ),
    );
  }
}

class UpdateOutputSyncSimulationAction extends ReduxAction<AppState> {
  final String name;
  final String type;
  final String value;
  final bool isRemove;

  UpdateOutputSyncSimulationAction({
    this.name,
    this.type,
    this.value,
    this.isRemove,
  });
  @override
  AppState reduce() {
    print('UpdateOutputSyncSimulationAction...');
    Output _output;
    _output = state.simulationState.outputCurrent;

    SimulationModel simulationModel =
        SimulationModel(state.simulationState.simulationCurrent.id)
            .fromMap(state.simulationState.simulationCurrent.toMap());
    if (isRemove) {
      simulationModel.output.remove(_output.id);
    } else {
      _output.name = name;
      _output.type = type;
      _output.value = value;
      simulationModel.output[_output.id] = _output;
    }

    return state.copyWith(
      simulationState: state.simulationState.copyWith(
        simulationCurrent: simulationModel,
      ),
    );
  }
}

// --- Actions Sync for Output
