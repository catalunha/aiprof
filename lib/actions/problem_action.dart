import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aiprof/models/problem_model.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';

// +++ Actions Sync
class SetProblemCurrentSyncProblemAction extends ReduxAction<AppState> {
  final String id;

  SetProblemCurrentSyncProblemAction(this.id);

  @override
  AppState reduce() {
    ProblemModel problemModel;
    if (id == null) {
      problemModel = ProblemModel(null);
    } else {
      ProblemModel problemModelTemp = state.problemState.problemList
          .firstWhere((element) => element.id == id);
      problemModel = ProblemModel.clone(problemModelTemp);
      // problemModel = ProblemModel(problemModelTemp.id)
      //     .fromMap(problemModelTemp.toMap());
    }
    return state.copyWith(
      problemState: state.problemState.copyWith(
        problemCurrent: problemModel,
      ),
    );
  }
}

class SetProblemFilterSyncProblemAction extends ReduxAction<AppState> {
  final ProblemFilter problemFilter;

  SetProblemFilterSyncProblemAction(this.problemFilter);

  @override
  AppState reduce() {
    return state.copyWith(
      problemState: state.problemState.copyWith(
        problemFilter: problemFilter,
      ),
    );
  }

  void after() => dispatch(GetDocsProblemListAsyncProblemAction());
}

// +++ Actions Async
class GetDocsProblemListAsyncProblemAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('GetDocsProblemListAsyncProblemAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    // collection old
    if (state.problemState.problemFilter == ProblemFilter.isactive) {
      collRef = firestore.collection(ProblemModel.collection).where(
          'professor.id',
          isEqualTo: state.loggedState.userModelLogged.id);
      // .where('isActive', isEqualTo: true);
    } else if (state.problemState.problemFilter == ProblemFilter.isntactive) {
      collRef = firestore.collection(ProblemModel.collection).where(
          'professor.id',
          isEqualTo: state.loggedState.userModelLogged.id);
      // .where('isActive', isEqualTo: false);
    }
    final docsSnapOld = await collRef.getDocuments();

    List<ProblemModel> listDocsOld = docsSnapOld.documents
        .map((docSnapOld) =>
            ProblemModel(docSnapOld.documentID).fromMap(docSnapOld.data))
        .toList();

    //collection new
    if (state.problemState.problemFilter == ProblemFilter.isactive) {
      collRef = firestore
          .collection(ProblemModel.collection)
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id);
      // .where('isActive', isEqualTo: true);
    } else if (state.problemState.problemFilter == ProblemFilter.isntactive) {
      collRef = firestore
          .collection(ProblemModel.collection)
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id);
      // .where('isActive', isEqualTo: false);
    }
    final docsSnapNew = await collRef.getDocuments();

    List<ProblemModel> listDocsNew = docsSnapNew.documents
        .map((docSnapNew) =>
            ProblemModel(docSnapNew.documentID).fromMap(docSnapNew.data))
        .toList();

    List<ProblemModel> listDocsDistinct = [...listDocsOld, ...listDocsNew];

    listDocsDistinct_ResolverFiltro.sort((a, b) => a.name.compareTo(b.name));

    // // listDocs.forEach((element) {
    // //   print(element.id);
    // // });
    // Map<dynamic, ProblemModel> mapping =
    //     Map.fromIterable(listDocs, key: (v) => v.id, value: (v) => v);
    // List<dynamic> ids = state.loggedState.userModelLogged.problemId;
    // // print(ids);
    // final listDocsSorted = [for (dynamic id in ids) mapping[id]];
    // // listDocsSorted.forEach((element) {
    // //   print(element.id);
    // // });
    return state.copyWith(
      problemState: state.problemState.copyWith(
        problemList: listDocs,
      ),
    );
  }
}

class AddDocProblemCurrentAsyncProblemAction extends ReduxAction<AppState> {
  final String area;
  final String name;
  final String description;
  final String url;

  AddDocProblemCurrentAsyncProblemAction({
    this.area,
    this.name,
    this.description,
    this.url,
  });
  @override
  Future<AppState> reduce() async {
    print('AddDocProblemCurrentAsyncProblemAction...');
    Firestore firestore = Firestore.instance;
    ProblemModel problemModel =
        ProblemModel(state.problemState.problemCurrent.id)
            .fromMap(state.problemState.problemCurrent.toMap());
    problemModel.userRef = UserModel(state.loggedState.userModelLogged.id)
        .fromMap(state.loggedState.userModelLogged.toMapRef());
    problemModel.area = area;
    problemModel.name = name;
    problemModel.description = description;
    problemModel.url = url;
    problemModel.isActive = true;
// final problemAdded =
    await firestore
        .collection(ProblemModel.collection)
        .add(problemModel.toMap());
    // if (problemAdded.documentID != null) {
    //   await firestore
    //       .collection(UserModel.collection)
    //       .document(state.loggedState.userModelLogged.id)
    //       .updateData({
    //     'problemId': FieldValue.arrayUnion([problemAdded.documentID])
    //   });
    // }
    return null;
  }

  // @override
  // Object wrapError(error) => UserException("ATENÇÃO:", cause: error);
  @override
  void after() => dispatch(GetDocsProblemListAsyncProblemAction());
}

class UpdateDocProblemCurrentAsyncProblemAction extends ReduxAction<AppState> {
  final String area;
  final String name;
  final String description;
  final String url;
  final bool isActive;

  UpdateDocProblemCurrentAsyncProblemAction({
    this.area,
    this.name,
    this.description,
    this.url,
    this.isActive,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocProblemCurrentAsyncProblemAction...');
    Firestore firestore = Firestore.instance;
    ProblemModel problemModel =
        ProblemModel(state.problemState.problemCurrent.id)
            .fromMap(state.problemState.problemCurrent.toMap());
    problemModel.area = area;
    problemModel.name = name;
    problemModel.description = description;
    problemModel.url = url;
    // if (problemModel.isActive != isActive && isActive) {
    //   await firestore
    //       .collection(UserModel.collection)
    //       .document(state.loggedState.userModelLogged.id)
    //       .updateData({
    //     'problemId': FieldValue.arrayUnion([problemModel.id])
    //   });
    // }
    // if (problemModel.isActive != isActive && !isActive) {
    //   await firestore
    //       .collection(UserModel.collection)
    //       .document(state.loggedState.userModelLogged.id)
    //       .updateData({
    //     'problemId': FieldValue.arrayRemove([problemModel.id])
    //   });
    // }
    problemModel.isActive = isActive;

    await firestore
        .collection(ProblemModel.collection)
        .document(problemModel.id)
        .updateData(problemModel.toMap());
    return null;
  }

  @override
  void after() => dispatch(GetDocsProblemListAsyncProblemAction());
}
