// +++ Actions Sync
import 'package:aiprof/actions/logged_action.dart';
import 'package:aiprof/actions/user_action.dart';
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

  // void after() => dispatch(StreamColClassroomAsyncClassroomAction());
}

class StreamColClassroomAsyncClassroomAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    print('StreamColClassroomAsyncClassroomAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    collRef = firestore
        .collection(ClassroomModel.collection)
        .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id);
    // .where('isActive', isEqualTo: true);

    Stream<QuerySnapshot> streamQuerySnapshot = collRef.snapshots();

    Stream<List<ClassroomModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.documents
            .map((docSnapshot) => ClassroomModel(docSnapshot.documentID)
                .fromMap(docSnapshot.data))
            .toList());
    streamList.listen((List<ClassroomModel> list) {
      dispatch(GetDocsClassroomListAsyncClassroomAction(list));
    });
    return null;
    // final docsSnap = await collRef.getDocuments();

    // final listDocs = docsSnap.documents
    //     .map((docSnap) =>
    //         ClassroomModel(docSnap.documentID).fromMap(docSnap.data))
    //     .toList();
    // // listDocs.forEach((element) {
    // //   print(element.id);
    // // });
    // Map<dynamic, ClassroomModel> mapping =
    //     Map.fromIterable(listDocs, key: (v) => v.id, value: (v) => v);
    // List<dynamic> ids = state.loggedState.userModelLogged.classroomId;
    // // print(ids);
    // final listDocsSorted = [for (dynamic id in ids) mapping[id]];
    // // listDocsSorted.forEach((element) {
    // //   print(element.id);
    // // });
    // return state.copyWith(
    //   classroomState: state.classroomState.copyWith(
    //     classroomList: listDocsSorted,
    //   ),
    // );
  }
}

class GetDocsClassroomListAsyncClassroomAction extends ReduxAction<AppState> {
  final List<ClassroomModel> classroomList;

  GetDocsClassroomListAsyncClassroomAction(this.classroomList);

  @override
  AppState reduce() {
    final Map<String, ClassroomModel> mapping = {
      for (int i = 0; i < classroomList.length; i++)
        classroomList[i].id: classroomList[i]
    };
    List<ClassroomModel> classroomListTemp = [
      for (String id in state.loggedState.userModelLogged.classroomId)
        mapping[id]
    ];

    // ClassroomModel classroomModel;
    print('Get2DocsTaskListAsyncTaskAction... ${classroomList.length}');
    print('Get2DocsTaskListAsyncTaskAction... ${classroomListTemp.length}');

    // if (state.classroomState.classroomCurrent != null) {
    //   int index = classroomListTemp.indexWhere(
    //       (element) => element.id == state.classroomState.classroomCurrent.id);
    //   print(index);
    //   if (index >= 0) {
    //     ClassroomModel classroomModelTemp = classroomListTemp.firstWhere(
    //         (element) =>
    //             element.id == state.classroomState.classroomCurrent.id);
    //     classroomModel = ClassroomModel(classroomModelTemp.id)
    //         .fromMap(classroomModelTemp.toMap());
    //   }
    // }
    // List<UserModel> studentList = [];
    // if (state.classroomState?.classroomCurrent?.studentUserRefMap != null) {
    //   for (var item
    //       in state.classroomState.classroomCurrent.studentUserRefMap.entries) {
    //     studentList.add(UserModel(item.key).fromMap(item.value.toMap()));
    //   }
    //   // print(studentList);
    //   studentList.sort((a, b) => a.name.compareTo(b.name));
    // }
    return state.copyWith(
      classroomState: state.classroomState.copyWith(
        classroomList: classroomListTemp,
        // classroomCurrent: classroomModel,
      ),
      // studentState: state.studentState.copyWith(
      //   studentList: studentList,
      // ),
    );
  }
}

// +++ Actions Async
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
      }).then((value) {
        dispatch(GetDocUserAsyncUserAction());
        dispatch(StreamColClassroomAsyncClassroomAction());
      });
    }
    return null;
  }

  // @override
  // Object wrapError(error) => UserException("ATENÇÃO:", cause: error);
  // @override
  // void after() => dispatch(GetDocUserAsyncUserAction());
}

class UpdateDocClassroomCurrentAsyncClassroomAction
    extends ReduxAction<AppState> {
  final String company;
  final String component;
  final String name;
  final String description;
  final String urlProgram;
  final bool isActive;
  final bool isDelete;

  UpdateDocClassroomCurrentAsyncClassroomAction({
    this.company,
    this.component,
    this.name,
    this.description,
    this.urlProgram,
    this.isActive,
    this.isDelete,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocClassroomCurrentAsyncClassroomAction...');
    Firestore firestore = Firestore.instance;
    ClassroomModel classroomModel =
        ClassroomModel(state.classroomState.classroomCurrent.id)
            .fromMap(state.classroomState.classroomCurrent.toMap());
    if (isDelete) {
      await firestore
          .collection(UserModel.collection)
          .document(state.loggedState.userModelLogged.id)
          .updateData({
        'classroomId': FieldValue.arrayRemove([classroomModel.id])
      }).then((value) async {
        dispatchFuture(GetDocUserAsyncUserAction()).then((value) {
          firestore
              .collection(ClassroomModel.collection)
              .document(classroomModel.id)
              .delete();
        });
      });

      return state.copyWith(
        classroomState: state.classroomState.copyWith(
          classroomCurrent: null,
        ),
      );
    } else {
      classroomModel.company = company;
      classroomModel.component = component;
      classroomModel.name = name;
      classroomModel.description = description;
      classroomModel.urlProgram = urlProgram;
      // if (classroomModel.isActive != isActive && isActive) {
      //   await firestore
      //       .collection(UserModel.collection)
      //       .document(state.loggedState.userModelLogged.id)
      //       .updateData({
      //     'classroomId': FieldValue.arrayUnion([classroomModel.id])
      //   });
      // }

      classroomModel.isActive = isActive;

      await firestore
          .collection(ClassroomModel.collection)
          .document(classroomModel.id)
          .updateData(classroomModel.toMap());
    }
    return null;
  }

  // @override
  // void after() {
  //   dispatch(StreamColClassroomAsyncClassroomAction());
  // }
}

class UpdateDocclassroomIdInUserAsyncClassroomAction
    extends ReduxAction<AppState> {
  final int oldIndex;
  final int newIndex;

  UpdateDocclassroomIdInUserAsyncClassroomAction({
    this.oldIndex,
    this.newIndex,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocClassroomCurrentAsyncClassroomAction...');
    Firestore firestore = Firestore.instance;
    UserModel userModel = UserModel(state.loggedState.userModelLogged.id)
        .fromMap(state.loggedState.userModelLogged.toMap());
    int _newIndex = newIndex;
    if (newIndex > oldIndex) {
      _newIndex -= 1;
    }
    dynamic classroomOld = userModel.classroomId[oldIndex];
    userModel.classroomId.removeAt(oldIndex);
    userModel.classroomId.insert(_newIndex, classroomOld);

    await firestore
        .collection(UserModel.collection)
        .document(state.loggedState.userModelLogged.id)
        .updateData({'classroomId': userModel.classroomId});

    return null;
  }

  @override
  void after() {
    // dispatch(StreamColClassroomAsyncClassroomAction());
    dispatch(GetDocsUserModelAsyncLoggedAction(
        id: state.loggedState.userModelLogged.id));
  }
}
