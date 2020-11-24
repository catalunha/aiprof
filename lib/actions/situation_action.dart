import 'dart:math';

import 'package:aiprof/actions/simulation_action.dart';
import 'package:aiprof/models/question_model.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';

// +++ Actions Sync
class SetSituationCurrentSyncSituationAction extends ReduxAction<AppState> {
  final String id;

  SetSituationCurrentSyncSituationAction(this.id);

  @override
  AppState reduce() {
    SituationModel situationModel;
    if (id == null) {
      situationModel = SituationModel(null);
    } else {
      SituationModel situationModelTemp = state.situationState.situationList
          .firstWhere((element) => element.id == id);
      situationModel = SituationModel(situationModelTemp.id)
          .fromMap(situationModelTemp.toMap());
    }
    return state.copyWith(
      situationState: state.situationState.copyWith(
        situationCurrent: situationModel,
      ),
    );
  }
}

class SetSituationCurrentASyncSituationAction extends ReduxAction<AppState> {
  final String id;

  SetSituationCurrentASyncSituationAction(this.id);

  @override
  Future<AppState> reduce() async {
    SituationModel situationModel;

    Firestore firestore = Firestore.instance;
    DocumentSnapshot docRef = await firestore
        .collection(SituationModel.collection)
        .document(id)
        .get();
    situationModel = SituationModel(docRef.documentID).fromMap(docRef.data);

    return state.copyWith(
      situationState: state.situationState.copyWith(
        situationCurrent: situationModel,
      ),
    );
  }
}

class SetSituationFilterSyncSituationAction extends ReduxAction<AppState> {
  final SituationFilter situationFilter;

  SetSituationFilterSyncSituationAction(this.situationFilter);

  @override
  AppState reduce() {
    return state.copyWith(
      situationState: state.situationState.copyWith(
        situationFilter: situationFilter,
      ),
    );
  }

  // void after() => dispatch(StreamColSituationAsyncSituationAction());
}

class SearchSituationSyncSituationAction extends ReduxAction<AppState> {
  final String name;

  SearchSituationSyncSituationAction(this.name);

  @override
  AppState reduce() {
    List<SituationModel> _situationListFilter = [];
    if (name.isNotEmpty) {
      state.situationState.situationList.forEach((item) {
        if (item.name.contains(name)) {
          _situationListFilter.add(item);
        }
      });
    } else {
      _situationListFilter.addAll(state.situationState.situationList);
    }
    return state.copyWith(
      situationState: state.situationState.copyWith(
        situationListFilter: _situationListFilter,
      ),
    );
  }
}

class SetSituationInQuestionCurrentSyncSituationAction
    extends ReduxAction<AppState> {
  final SituationModel situationRef;

  SetSituationInQuestionCurrentSyncSituationAction(this.situationRef);

  @override
  Future<AppState> reduce() async {
    print(
        'SetSituationInQuestionCurrentSyncSituationAction: ${situationRef?.id}');
    if (situationRef.id != null) {
      QuestionModel questionCurrent =
          QuestionModel(state.questionState.questionCurrent.id)
              .fromMap(state.questionState.questionCurrent.toMap());

      Firestore firestore = Firestore.instance;
      final situationSnap = await firestore
          .collection(SituationModel.collection)
          .document(situationRef.id)
          .get();

      questionCurrent.situationModel =
          SituationModel(situationSnap.documentID).fromMap(situationSnap.data);

      return state.copyWith(
        questionState: state.questionState.copyWith(
          questionCurrent: questionCurrent,
        ),
      );
    } else {
      return null;
    }
  }
}

// +++ Actions Async
class StreamColSituationAsyncSituationAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    print('StreamColSituationAsyncSituationAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    // //+++ collection old
    // if (state.situationState.situationFilter == SituationFilter.isactive) {
    //   collRef = firestore.collection(SituationModel.collection).where(
    //       'professor.id',
    //       isEqualTo: state.loggedState.userModelLogged.id);
    //   // .where('isActive', isEqualTo: true);
    // } else if (state.situationState.situationFilter ==
    //     SituationFilter.isNotactive) {
    //   collRef = firestore.collection(SituationModel.collection).where(
    //       'professor.id',
    //       isEqualTo: state.loggedState.userModelLogged.id);
    //   // .where('isActive', isEqualTo: false);
    // }
    // final docsSnapOld = await collRef.getDocuments();

    // List<SituationModel> listDocsOld = docsSnapOld.documents
    //     .map((docSnapOld) =>
    //         SituationModel(docSnapOld.documentID).fromMap(docSnapOld.data))
    //     .toList();
    // //--- collection old

    //+++ collection new
    if (state.situationState.situationFilter == SituationFilter.isActive) {
      collRef = firestore
          .collection(SituationModel.collection)
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id);
      // .where('isActive', isEqualTo: true);
    } else if (state.situationState.situationFilter ==
        SituationFilter.isNotActive) {
      collRef = firestore
          .collection(SituationModel.collection)
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id);
      // .where('isActive', isEqualTo: false);
    }
    Stream<QuerySnapshot> streamQuerySnapshot = collRef.snapshots();

    Stream<List<SituationModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.documents
            .map((docSnapshot) => SituationModel(docSnapshot.documentID)
                .fromMap(docSnapshot.data))
            .toList());
    streamList.listen((List<SituationModel> list) {
      dispatch(GetDocsSituationListAsyncSituationAction(list));
    });
    return null;
    // final docsSnapNew = await collRef.getDocuments();

    // List<SituationModel> listDocsNew = docsSnapNew.documents
    //     .map((docSnapNew) =>
    //         SituationModel(docSnapNew.documentID).fromMap(docSnapNew.data))
    //     .toList();
    //--- collection new

    // for (SituationModel item in listDocsOld) {
    //   listDocsNew.removeWhere((e) => e.id == item.id);
    // }
    // List<SituationModel> listDocsDistinct = [...listDocsOld, ...listDocsNew];

    // listDocsNew.sort((a, b) => a.name.compareTo(b.name));

    // // listDocs.forEach((element) {
    // //   print(element.id);
    // // });
    // Map<dynamic, SituationModel> mapping =
    //     Map.fromIterable(listDocs, key: (v) => v.id, value: (v) => v);
    // List<dynamic> ids = state.loggedState.userModelLogged.situationId;
    // // print(ids);
    // final listDocsSorted = [for (dynamic id in ids) mapping[id]];
    // // listDocsSorted.forEach((element) {
    // //   print(element.id);
    // // });
    // return state.copyWith(
    //   situationState: state.situationState.copyWith(
    //     situationList: listDocsNew,
    //   ),
    // );
  }
}

class GetDocsSituationListAsyncSituationAction extends ReduxAction<AppState> {
  final List<SituationModel> situationList;

  GetDocsSituationListAsyncSituationAction(this.situationList);

  @override
  AppState reduce() {
    situationList.sort((a, b) => a.name.compareTo(b.name));

    SituationModel situationModel;
    print('Get2DocsTaskListAsyncTaskAction... ${situationList.length}');

    if (state.situationState.situationCurrent != null) {
      int index = situationList.indexWhere(
          (element) => element.id == state.situationState.situationCurrent.id);
      print(index);
      if (index >= 0) {
        SituationModel situationModelTemp = situationList.firstWhere(
            (element) =>
                element.id == state.situationState.situationCurrent.id);
        situationModel = SituationModel(situationModelTemp.id)
            .fromMap(situationModelTemp.toMap());
      }
    }

    return state.copyWith(
      situationState: state.situationState.copyWith(
        situationList: situationList,
        situationListFilter: situationList,
        situationCurrent: situationModel,
      ),
    );
  }
}

class AddDocSituationCurrentAsyncSituationAction extends ReduxAction<AppState> {
  final String area;
  final String name;
  final String description;
  final String url;

  AddDocSituationCurrentAsyncSituationAction({
    this.area,
    this.name,
    this.description,
    this.url,
  });
  @override
  Future<AppState> reduce() async {
    print('AddDocSituationCurrentAsyncSituationAction...');
    Firestore firestore = Firestore.instance;
    SituationModel situationModel =
        SituationModel(state.situationState.situationCurrent.id)
            .fromMap(state.situationState.situationCurrent.toMap());
    situationModel.userRef = UserModel(state.loggedState.userModelLogged.id)
        .fromMap(state.loggedState.userModelLogged.toMapRef());
    situationModel.area = area;
    situationModel.name = name;
    situationModel.description = description;
    situationModel.url = url;
    situationModel.isActive = true;
    situationModel.isSimulationConsistent = false;
// final situationAdded =
    await firestore
        .collection(SituationModel.collection)
        .add(situationModel.toMap());
    // if (situationAdded.documentID != null) {
    //   await firestore
    //       .collection(UserModel.collection)
    //       .document(state.loggedState.userModelLogged.id)
    //       .updateData({
    //     'situationId': FieldValue.arrayUnion([situationAdded.documentID])
    //   });
    // }
    return null;
  }

  // @override
  // Object wrapError(error) => UserException("ATENÇÃO:", cause: error);
  // @override
  // void after() => dispatch(StreamColSituationAsyncSituationAction());
}

class UpdateDocSituationCurrentAsyncSituationAction
    extends ReduxAction<AppState> {
  final String area;
  final String name;
  final String description;
  final String url;
  final bool isActive;
  final bool isDelete;

  UpdateDocSituationCurrentAsyncSituationAction({
    this.area,
    this.name,
    this.description,
    this.url,
    this.isActive,
    this.isDelete,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocSituationCurrentAsyncSituationAction...');
    Firestore firestore = Firestore.instance;
    SituationModel situationModel =
        SituationModel(state.situationState.situationCurrent.id)
            .fromMap(state.situationState.situationCurrent.toMap());
    if (isDelete) {
      await firestore
          .collection(SituationModel.collection)
          .document(situationModel.id)
          .delete();
    } else {
      situationModel.area = area;
      situationModel.name = name;
      situationModel.description = description;
      situationModel.url = url;
      // if (situationModel.isActive != isActive && isActive) {
      //   await firestore
      //       .collection(UserModel.collection)
      //       .document(state.loggedState.userModelLogged.id)
      //       .updateData({
      //     'situationId': FieldValue.arrayUnion([situationModel.id])
      //   });
      // }
      // if (situationModel.isActive != isActive && !isActive) {
      //   await firestore
      //       .collection(UserModel.collection)
      //       .document(state.loggedState.userModelLogged.id)
      //       .updateData({
      //     'situationId': FieldValue.arrayRemove([situationModel.id])
      //   });
      // }
      situationModel.isActive = isActive;

      await firestore
          .collection(SituationModel.collection)
          .document(situationModel.id)
          .updateData(situationModel.toMap());
    }
    return null;
  }

  // @override
  // void after() => dispatch(StreamColSituationAsyncSituationAction());
}

class UpdateFieldDocSituationCurrentAsyncSituationAction
    extends ReduxAction<AppState> {
  final String field;
  final dynamic value;

  UpdateFieldDocSituationCurrentAsyncSituationAction({
    this.field,
    this.value,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateFieldDocSituationCurrentAsyncSituationAction...');
    Firestore firestore = Firestore.instance;
    // SituationModel situationModel =
    //     SituationModel(state.situationState.situationCurrent.id)
    //         .fromMap(state.situationState.situationCurrent.toMap());
    // situationModel.area = area;
    // situationModel.name = name;
    // situationModel.description = description;
    // situationModel.url = url;
    // // if (situationModel.isActive != isActive && isActive) {
    // //   await firestore
    // //       .collection(UserModel.collection)
    // //       .document(state.loggedState.userModelLogged.id)
    // //       .updateData({
    // //     'situationId': FieldValue.arrayUnion([situationModel.id])
    // //   });
    // // }
    // // if (situationModel.isActive != isActive && !isActive) {
    // //   await firestore
    // //       .collection(UserModel.collection)
    // //       .document(state.loggedState.userModelLogged.id)
    // //       .updateData({
    // //     'situationId': FieldValue.arrayRemove([situationModel.id])
    // //   });
    // // }
    // situationModel.isActive = isActive;

    await firestore
        .collection(SituationModel.collection)
        .document(state.situationState.situationCurrent.id)
        .updateData({field: value});
    return null;
  }
}
