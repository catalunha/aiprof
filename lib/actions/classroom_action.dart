// +++ Actions Sync
import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetClassroomCurrentSyncClassroomAction extends ReduxAction<AppState> {
  final String id;

  SetClassroomCurrentSyncClassroomAction(this.id);

  @override
  AppState reduce() {
    ClassroomModel classroomModel;
    if (id == null) {
      classroomModel = ClassroomModel(null);
    } else {
      ClassroomModel classroomModelTemp = state.classroomState.classroomList
          .firstWhere((element) => element.id == id);
      classroomModel = ClassroomModel(classroomModelTemp.id)
          .fromMap(classroomModelTemp.toMap());
    }
    return state.copyWith(
      classroomState: state.classroomState.copyWith(
        classroomCurrent: classroomModel,
      ),
    );
  }
}

class SetClassroomFilterSyncClassroomAction extends ReduxAction<AppState> {
  final ClassroomFilter classroomFilter;

  SetClassroomFilterSyncClassroomAction(this.classroomFilter);

  @override
  AppState reduce() {
    return state.copyWith(
      classroomState: state.classroomState.copyWith(
        classroomFilter: classroomFilter,
      ),
    );
  }

  void after() => dispatch(GetDocsClassroomListAsyncClassroomAction());
}

// +++ Actions Async
class GetDocsClassroomListAsyncClassroomAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('GetDocsClassroomListAsyncClassroomAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    if (state.classroomState.classroomFilter == ClassroomFilter.isactive) {
      collRef = firestore
          .collection(ClassroomModel.collection)
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id)
          .where('isActive', isEqualTo: true);
    } else if (state.classroomState.classroomFilter ==
        ClassroomFilter.isntactive) {
      collRef = firestore
          .collection(ClassroomModel.collection)
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id)
          .where('isActive', isEqualTo: false);
    }
    final docsSnap = await collRef.getDocuments();

    final listDocs = docsSnap.documents
        .map((docSnap) =>
            ClassroomModel(docSnap.documentID).fromMap(docSnap.data))
        .toList();

    listDocs.sort((a, b) => a.name.compareTo(b.name));
    return state.copyWith(
      classroomState: state.classroomState.copyWith(
        classroomList: listDocs,
      ),
    );
  }
}

class AddDocClassroomCurrentAsyncClassroomAction extends ReduxAction<AppState> {
  final String company;
  final String component;
  final String name;
  final String description;
  final String urlProgram;

  AddDocClassroomCurrentAsyncClassroomAction({
    this.company,
    this.component,
    this.name,
    this.description,
    this.urlProgram,
  });
  @override
  Future<AppState> reduce() async {
    print('AddDocClassroomCurrentAsyncClassroomAction...');
    Firestore firestore = Firestore.instance;
    ClassroomModel classroomModel =
        ClassroomModel(state.classroomState.classroomCurrent.id)
            .fromMap(state.classroomState.classroomCurrent.toMap());
    classroomModel.userRef = UserModel(state.loggedState.userModelLogged.id)
        .fromMap(state.loggedState.userModelLogged.toMapRef());
    classroomModel.company = company;
    classroomModel.component = component;
    classroomModel.name = name;
    classroomModel.description = description;
    classroomModel.urlProgram = urlProgram;
    classroomModel.isActive = true;

    final classroomAdded = await firestore
        .collection(ClassroomModel.collection)
        .add(classroomModel.toMap());
    if (classroomAdded.documentID != null) {
      await firestore
          .collection(UserModel.collection)
          .document(state.loggedState.userModelLogged.id)
          .updateData({
        'classroomId': FieldValue.arrayUnion([classroomAdded.documentID])
      });
    }

    return null;
  }

  // @override
  // Object wrapError(error) => UserException("ATENÇÃO:", cause: error);
  @override
  void after() => dispatch(GetDocsClassroomListAsyncClassroomAction());
}

class UpdateDocClassroomCurrentAsyncClassroomAction
    extends ReduxAction<AppState> {
  final String company;
  final String component;
  final String name;
  final String description;
  final String urlProgram;
  final bool isActive;

  UpdateDocClassroomCurrentAsyncClassroomAction({
    this.company,
    this.component,
    this.name,
    this.description,
    this.urlProgram,
    this.isActive,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocClassroomCurrentAsyncClassroomAction...');
    Firestore firestore = Firestore.instance;
    ClassroomModel classroomModel =
        ClassroomModel(state.classroomState.classroomCurrent.id)
            .fromMap(state.classroomState.classroomCurrent.toMap());
    classroomModel.company = company;
    classroomModel.component = component;
    classroomModel.name = name;
    classroomModel.description = description;
    classroomModel.urlProgram = urlProgram;
    classroomModel.isActive = isActive;
    await firestore
        .collection(ClassroomModel.collection)
        .document(classroomModel.id)
        .updateData(classroomModel.toMap());
    return null;
  }

  @override
  void after() => dispatch(GetDocsClassroomListAsyncClassroomAction());
}
