import 'package:aiprof/app_state.dart';
import 'package:aiprof/know/know_enum.dart';
import 'package:aiprof/know/know_model.dart';
import 'package:aiprof/situation/situation_model.dart';
import 'package:aiprof/user/user_model.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart' as uuid;

// +++ Actions Sync
class SetKnowCurrentSyncKnowAction extends ReduxAction<AppState> {
  final String id;

  SetKnowCurrentSyncKnowAction(this.id);

  @override
  AppState reduce() {
    KnowModel knowModel;
    if (id == null) {
      knowModel = KnowModel(null);
    } else {
      KnowModel knowModelTemp =
          state.knowState.knowList.firstWhere((element) => element.id == id);
      knowModel = KnowModel.clone(knowModelTemp);
    }
    return state.copyWith(
      knowState: state.knowState.copyWith(
        knowCurrent: knowModel,
      ),
    );
  }
}

class SetKnowFilterSyncKnowAction extends ReduxAction<AppState> {
  final KnowFilter knowFilter;

  SetKnowFilterSyncKnowAction(this.knowFilter);

  @override
  AppState reduce() {
    return state.copyWith(
      knowState: state.knowState.copyWith(
        knowFilter: knowFilter,
      ),
    );
  }

  // void after() => dispatch(GetDocsKnowListAsyncKnowAction());
}

// +++ Actions Async
class StreamColExameAsyncExameAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('StreamColExameAsyncExameAction...');
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query collRef;

    if (state.knowState.knowFilter == KnowFilter.isActive) {
      collRef = firestore
          .collection(KnowModel.collection)
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id);
      // .where('isActive', isEqualTo: true);
    } else if (state.knowState.knowFilter == KnowFilter.isNotActive) {
      collRef = firestore
          .collection(KnowModel.collection)
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id);
      // .where('isActive', isEqualTo: false);
    }
    Stream<QuerySnapshot> streamQuerySnapshot = collRef.snapshots();

    Stream<List<KnowModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.docs
            .map((docSnapshot) =>
                KnowModel(docSnapshot.id).fromMap(docSnapshot.data()))
            .toList());
    streamList.listen((List<KnowModel> knowList) {
      dispatch(GetDocsKnowListAsyncKnowAction(knowList));
    });
    return null;
    // final docsSnapNew = await collRef.getDocuments();

    // List<KnowModel> listDocs = docsSnapNew.docs
    //     .map((docSnapNew) =>
    //         KnowModel(docSnapNew.id).fromMap(docSnapNew.data()))
    //     .toList();

    // return state.copyWith(
    //   knowState: state.knowState.copyWith(
    //     knowList: listDocs,
    //   ),
    // );
  }
}

class GetDocsKnowListAsyncKnowAction extends ReduxAction<AppState> {
  final List<KnowModel> knowList;

  GetDocsKnowListAsyncKnowAction(this.knowList);
  @override
  AppState reduce() {
    return state.copyWith(
      knowState: state.knowState.copyWith(
        knowList: knowList,
      ),
    );
  }
}

class AddDocKnowCurrentAsyncKnowAction extends ReduxAction<AppState> {
  final String name;
  final String description;

  AddDocKnowCurrentAsyncKnowAction({
    this.name,
    this.description,
  });
  @override
  Future<AppState> reduce() async {
    print('AddDocKnowCurrentAsyncKnowAction...');
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    KnowModel knowModel = KnowModel(state.knowState.knowCurrent.id)
        .fromMap(state.knowState.knowCurrent.toMap());
    knowModel.userRef = UserModel(state.loggedState.userModelLogged.id)
        .fromMap(state.loggedState.userModelLogged.toMapRef());
    knowModel.name = name;
    knowModel.description = description;
    await firestore.collection(KnowModel.collection).add(knowModel.toMap());
    return null;
  }

  // @override
  // void after() => dispatch(GetDocsKnowListAsyncKnowAction());
}

class UpdateDocKnowCurrentAsyncKnowAction extends ReduxAction<AppState> {
  final String name;
  final String description;
  final bool isDelete;

  UpdateDocKnowCurrentAsyncKnowAction({
    this.name,
    this.description,
    this.isDelete,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocKnowCurrentAsyncKnowAction...');
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    KnowModel knowModel = KnowModel(state.knowState.knowCurrent.id)
        .fromMap(state.knowState.knowCurrent.toMap());
    if (isDelete) {
      await firestore
          .collection(KnowModel.collection)
          .doc(knowModel.id)
          .delete();
    } else {
      knowModel.name = name;
      knowModel.description = description;
      await firestore
          .collection(KnowModel.collection)
          .doc(knowModel.id)
          .update(knowModel.toMap());
    }
    return null;
  }

  // @override
  // void after() => dispatch(GetDocsKnowListAsyncKnowAction());
}

//+++ Actions Sync for Folder

class SetFolderCurrentSyncKnowAction extends ReduxAction<AppState> {
  final String id;
  final bool isAddOrUpdate;

  SetFolderCurrentSyncKnowAction({this.id, this.isAddOrUpdate});

  @override
  AppState reduce() {
    Folder folder;
    if (isAddOrUpdate) {
      folder = Folder(null);
      folder.idParent = id;
    } else {
      folder = state.knowState.knowCurrent.folderMap[id];
    }

    return state.copyWith(
      knowState: state.knowState.copyWith(
        folderCurrent: folder,
      ),
    );
  }
}

class CreateFolderSyncKnowAction extends ReduxAction<AppState> {
  final String name;
  final String description;

  CreateFolderSyncKnowAction({
    this.name,
    this.description,
  });
  @override
  AppState reduce() {
    print('CreateKnowDataCurrentSyncKnowAction...');
    Folder folder;
    folder = state.knowState.folderCurrent;
    folder.id = uuid.Uuid().v4();
    folder.name = name;
    folder.description = description;
    folder.situationRefMap = Map<String, SituationModel>();
    KnowModel knowModel = KnowModel(state.knowState.knowCurrent.id)
        .fromMap(state.knowState.knowCurrent.toMap());
    if (knowModel.folderMap == null) {
      knowModel.folderMap = Map<String, Folder>();
    }

    knowModel.folderMap[folder.id] = folder;

    return state.copyWith(
      knowState: state.knowState.copyWith(
        knowCurrent: knowModel,
      ),
    );
  }

  // @override
  // Object wrapError(error) => UserException("ATENÇÃO1:", cause: error);
  @override
  void after() =>
      dispatch(UpdateDocKnowCurrentAsyncKnowAction(isDelete: false));
}

class UpdateFolderSyncKnowAction extends ReduxAction<AppState> {
  final String name;
  final String description;
  final bool isDelete;

  UpdateFolderSyncKnowAction({
    this.name,
    this.description,
    this.isDelete,
  });
  // String removeRecursiveFolderBack(String folderId) {
  //   print('folderId:$folderId');
  //   if (state.knowState.knowCurrent.folderMap.removeWhere((key, value) => false))) {
  //     print('folderId1:$folderId');
  //     state.knowState.knowCurrent.folderMap.remove(folderId);
  //     return null;
  //   } else {
  //     print('folderId2:$folderId');
  //     return removeRecursiveFolder(
  //         state.knowState.knowCurrent.folderMap[folderId].idParent);
  //   }
  //   //     if (state.knowState.knowCurrent.folderMap[folderId].idParent != null) {
  //   //   return removeRecursiveFolder(
  //   //       state.knowState.knowCurrent.folderMap[folderId].idParent);
  //   // } else {
  //   //   state.knowState.knowCurrent.folderMap.remove(folderId);
  //   // }
  // }

  // KnowModel removeRecursiveFolder(Folder folder, KnowModel knowModel) {
  //   print('folderId0:${folder.id}');
  //   if (folder.idParent == null) {
  //     print('folderId2:${folder.id}');
  //     Folder _folder = Folder(null);
  //     knowModel.folderMap.forEach((key, value) {
  //       if (value.idParent == folder.id) {
  //         _folder = value;
  //       }
  //     });
  //     removeRecursiveFolder(_folder, knowModel);
  //   }

  //           print('folderId1:${folder.id}');
  //     knowModel.folderMap.remove(folder.id);
  //     return removeRecursiveFolder(Folder(null), knowModel);

  //   //     if (state.knowState.knowCurrent.folderMap[folderId].idParent != null) {
  //   //   return removeRecursiveFolder(
  //   //       state.knowState.knowCurrent.folderMap[folderId].idParent);
  //   // } else {
  //   //   state.knowState.knowCurrent.folderMap.remove(folderId);
  //   // }
  // }

  @override
  AppState reduce() {
    print('UpdateKnowDataCurrentSyncKnowAction...');
    Folder folder;
    folder = state.knowState.folderCurrent;

    KnowModel knowModel = KnowModel(state.knowState.knowCurrent.id)
        .fromMap(state.knowState.knowCurrent.toMap());
    if (isDelete) {
      List<String> removeParent = [folder.id];
      List<String> removeChild = [];
      bool goBack;
      do {
        goBack = false;
        for (var folder in knowModel.folderMap.entries) {
          if (removeParent.contains(folder.value.idParent)) {
            removeChild.add(folder.key);
            goBack = true;
          }
        }
        knowModel.folderMap
            .removeWhere((key, value) => removeParent.contains(key));
        knowModel.folderMap
            .removeWhere((key, value) => removeChild.contains(key));
        removeParent.clear();
        removeParent.addAll(removeChild);
        removeChild.clear();
      } while (goBack);
    } else {
      folder.name = name;
      folder.description = description;
      knowModel.folderMap[folder.id] = folder;
    }
    return state.copyWith(
      knowState: state.knowState.copyWith(
        knowCurrent: knowModel,
      ),
    );
  }

  // @override
  // Object wrapError(error) => UserException("ATENÇÃO2:", cause: error);
  @override
  void after() =>
      dispatch(UpdateDocKnowCurrentAsyncKnowAction(isDelete: false));
}

class SetSituationInFolderSyncKnowAction extends ReduxAction<AppState> {
  final SituationModel situationRef;
  final bool isAddOrRemove;
  SetSituationInFolderSyncKnowAction({
    this.situationRef,
    this.isAddOrRemove,
  });
  @override
  AppState reduce() {
    // FirebaseFirestore firestore = FirebaseFirestore.instance;

    Folder folder;
    folder = state.knowState.folderCurrent;
    if (folder.situationRefMap == null)
      folder.situationRefMap = Map<String, SituationModel>();
    if (isAddOrRemove) {
      if (!folder.situationRefMap.containsKey(situationRef.id)) {
        folder.situationRefMap[situationRef.id] = situationRef;
      }
    } else {
      folder.situationRefMap.remove(situationRef.id);
    }
    KnowModel knowModel = KnowModel(state.knowState.knowCurrent.id)
        .fromMap(state.knowState.knowCurrent.toMap());
    knowModel.folderMap[folder.id] = folder;
    // await firestore
    //     .collection(KnowModel.collection)
    //     .doc(knowModel.id)
    //     .update(knowModel.toMap());

    return state.copyWith(
      knowState: state.knowState.copyWith(
        knowCurrent: knowModel,
      ),
    );
  }

  @override
  void after() =>
      dispatch(UpdateDocKnowCurrentAsyncKnowAction(isDelete: false));
}
//--- Actions Sync for Folder
