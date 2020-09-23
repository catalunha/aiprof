// +++ Actions Sync
import 'package:aiprof/actions/logged_action.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetSimulationCurrentSyncSimulationAction extends ReduxAction<AppState> {
  final String id;

  SetSimulationCurrentSyncSimulationAction(this.id);

  @override
  AppState reduce() {
    SimulationModel simulationModel;
    if (id == null) {
      simulationModel = SimulationModel(null);
    } else {
      SimulationModel simulationModelTemp = state.simulationState.simulationList
          .firstWhere((element) => element.id == id);
      simulationModel = SimulationModel(simulationModelTemp.id)
          .fromMap(simulationModelTemp.toMap());
    }
    return state.copyWith(
      simulationState: state.simulationState.copyWith(
        simulationCurrent: simulationModel,
      ),
    );
  }
}

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

// +++ Actions Async
class GetDocsSimulationListAsyncSimulationAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('GetDocsSimulationListAsyncSimulationAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    //+++ old doc
    collRef = firestore
        .collection(SimulationModel.collection)
        .where('professor.id', isEqualTo: state.loggedState.userModelLogged.id)
        .where('problema.id',
            isEqualTo: state.situationState.situationCurrent.id);

    final docsSnapOld = await collRef.getDocuments();

    final listDocsOld = docsSnapOld.documents
        .map((docSnap) =>
            SimulationModel(docSnap.documentID).fromMap(docSnap.data))
        .toList();
    //--- old doc
    //+++ new doc
    collRef = firestore
        .collection(SimulationModel.collection)
        .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id)
        .where('situationRef.id',
            isEqualTo: state.situationState.situationCurrent.id);
    final docsSnapNew = await collRef.getDocuments();

    final listDocsNew = docsSnapNew.documents
        .map((docSnap) =>
            SimulationModel(docSnap.documentID).fromMap(docSnap.data))
        .toList();
    //--- new doc

    // Map<dynamic, SimulationModel> mapping =
    //     Map.fromIterable(listDocs, key: (v) => v.id, value: (v) => v);
    // List<dynamic> ids = state.loggedState.userModelLogged.classroomId;
    // final listDocsSorted = [for (dynamic id in ids) mapping[id]];

    for (SimulationModel item in listDocsOld) {
      listDocsNew.removeWhere((e) => e.id == item.id);
    }
    List<SimulationModel> listDocsDistinct = [...listDocsOld, ...listDocsNew];

    listDocsDistinct.sort((a, b) => a.name.compareTo(b.name));

    return state.copyWith(
      simulationState: state.simulationState.copyWith(
        simulationList: listDocsDistinct,
      ),
    );
  }
}

class AddDocSimulationCurrentAsyncSimulationAction
    extends ReduxAction<AppState> {
  final String name;
  final String description;

  AddDocSimulationCurrentAsyncSimulationAction({
    this.name,
    this.description,
  });
  @override
  Future<AppState> reduce() async {
    print('AddDocSimulationCurrentAsyncSimulationAction...');
    Firestore firestore = Firestore.instance;
    SimulationModel simulationModel =
        SimulationModel(state.simulationState.simulationCurrent.id)
            .fromMap(state.simulationState.simulationCurrent.toMap());
    simulationModel.userRef = UserModel(state.loggedState.userModelLogged.id)
        .fromMap(state.loggedState.userModelLogged.toMapRef());

    simulationModel.name = name;
    simulationModel.description = description;

    await firestore
        .collection(SimulationModel.collection)
        .add(simulationModel.toMap());
    return null;
  }

  // @override
  // Object wrapError(error) => UserException("ATENÇÃO:", cause: error);
  @override
  void after() => dispatch(GetDocsSimulationListAsyncSimulationAction());
}

class UpdateDocSimulationCurrentAsyncSimulationAction
    extends ReduxAction<AppState> {
  final String name;
  final String description;

  UpdateDocSimulationCurrentAsyncSimulationAction({
    this.name,
    this.description,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocSimulationCurrentAsyncSimulationAction...');
    Firestore firestore = Firestore.instance;
    SimulationModel simulationModel =
        SimulationModel(state.simulationState.simulationCurrent.id)
            .fromMap(state.simulationState.simulationCurrent.toMap());

    simulationModel.name = name;
    simulationModel.description = description;

    await firestore
        .collection(SimulationModel.collection)
        .document(simulationModel.id)
        .updateData(simulationModel.toMap());
    return null;
  }

  @override
  void after() => dispatch(GetDocsSimulationListAsyncSimulationAction());
}
