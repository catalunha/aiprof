import 'package:aiprof/app_state.dart';
import 'package:aiprof/classroom/classroom_enum.dart';
import 'package:aiprof/classroom/classroom_model.dart';
import 'package:aiprof/login/logged_action.dart';
import 'package:aiprof/user/user_model.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// +++ Actions Sync
class ReadyClassroomCurrentSyncClassroomAction extends ReduxAction<AppState> {
  final String id;
  ReadyClassroomCurrentSyncClassroomAction(this.id);
  @override
  AppState reduce() {
    ClassroomModel classroomModel = id == null
        ? ClassroomModel(null)
        : state.classroomState.classroomList
            .firstWhere((element) => element.id == id);

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
}

// class StreamColClassroomAsyncClassroomAction extends ReduxAction<AppState> {
//   @override
//   AppState reduce() {
//     print('StreamColClassroomAsyncClassroomAction...');
//     FirebaseFirestore firestore = state.dataSourceState.firebaseFirestoreRemote;
//     Query collRef;
//     collRef = firestore
//         .collection(ClassroomModel.collection)
//         .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id);

//     Stream<QuerySnapshot> streamQuerySnapshot = collRef.snapshots();

//     Stream<List<ClassroomModel>> streamList = streamQuerySnapshot.map(
//         (querySnapshot) => querySnapshot.docs
//             .map((docSnapshot) => ClassroomModel(docSnapshot.id)
//                 .fromMap(docSnapshot.data()))
//             .toList());
//     streamList.listen((List<ClassroomModel> list) {
//       dispatch(GetDocsClassroomListAsyncClassroomAction(list));
//     });
//     return null;
//   }
// }

// class GetDocsClassroomListAsyncClassroomAction extends ReduxAction<AppState> {
//   final List<ClassroomModel> classroomList;

//   GetDocsClassroomListAsyncClassroomAction(this.classroomList);

//   @override
//   AppState reduce() {
//     final Map<String, ClassroomModel> mapping = {
//       for (int i = 0; i < classroomList.length; i++)
//         classroomList[i].id: classroomList[i]
//     };
//     List<ClassroomModel> classroomListTemp = [
//       for (String id in state.loggedState.userModelLogged.classroomId)
//         mapping[id]
//     ];

//     print('Get2DocsTaskListAsyncTaskAction... ${classroomList.length}');
//     print('Get2DocsTaskListAsyncTaskAction... ${classroomListTemp.length}');

//     ClassroomModel classroomModel;
//     if (state.classroomState.classroomCurrent?.id != null) {
//       classroomModel = state.classroomState.classroomList.firstWhere(
//           (element) => element.id == state.classroomState.classroomCurrent.id);
//     }

//     return state.copyWith(
//       classroomState: state.classroomState.copyWith(
//         classroomList: classroomListTemp,
//         classroomCurrent: classroomModel,
//       ),
//     );
//   }
// }

class ReadyDocsClassroomListAsyncClassroomAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    FirebaseFirestore firestore = state.dataSourceState.firebaseFirestoreRemote;
    Query collRef;
    collRef = firestore
        .collection(ClassroomModel.collection)
        .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id);
    final docsSnap = await collRef.get();

    List<ClassroomModel> classroomList = docsSnap.docs
        .map((docSnap) => ClassroomModel(docSnap.id).fromMap(docSnap.data()))
        .toList();

    final Map<String, ClassroomModel> mapping = {
      for (int i = 0; i < classroomList.length; i++)
        classroomList[i].id: classroomList[i]
    };
    List<ClassroomModel> classroomListTemp = [
      for (String id in state.loggedState.userModelLogged.classroomId)
        mapping[id]
    ];

    print('Get2DocsTaskListAsyncTaskAction... ${classroomList.length}');
    print('Get2DocsTaskListAsyncTaskAction... ${classroomListTemp.length}');

    ClassroomModel classroomModel;
    if (state.classroomState.classroomCurrent?.id != null) {
      classroomModel = state.classroomState.classroomList.firstWhere(
          (element) => element.id == state.classroomState.classroomCurrent.id);
    }

    return state.copyWith(
      classroomState: state.classroomState.copyWith(
        classroomList: classroomListTemp,
        classroomCurrent: classroomModel,
      ),
    );
  }
}

// +++ Actions Async
class CreateDocClassroomCurrentAsyncClassroomAction
    extends ReduxAction<AppState> {
  final String company;
  final String component;
  final String name;
  final String description;
  final String urlProgram;

  CreateDocClassroomCurrentAsyncClassroomAction({
    this.company,
    this.component,
    this.name,
    this.description,
    this.urlProgram,
  });
  @override
  Future<AppState> reduce() async {
    print('CreateDocClassroomCurrentAsyncClassroomAction...');
    FirebaseFirestore firestore = state.dataSourceState.firebaseFirestoreRemote;
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
    if (classroomAdded.id != null) {
      await firestore
          .collection(UserModel.collection)
          .doc(state.loggedState.userModelLogged.id)
          .update({
        'classroomId': FieldValue.arrayUnion([classroomAdded.id])
      });
      await dispatchFuture(GetDocUserAsyncUserAction());
    }
    return null;
  }

  @override
  void after() {
    dispatch(ReadyDocsClassroomListAsyncClassroomAction());
  }
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
    FirebaseFirestore firestore = state.dataSourceState.firebaseFirestoreRemote;
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
        .doc(classroomModel.id)
        .update(classroomModel.toMap());

    return null;
  }

  @override
  void after() {
    dispatch(ReadyDocsClassroomListAsyncClassroomAction());
  }
}

class DeleteDocClassroomCurrentAsyncClassroomAction
    extends ReduxAction<AppState> {
  final String id;

  DeleteDocClassroomCurrentAsyncClassroomAction({
    this.id,
  });
  @override
  Future<AppState> reduce() async {
    print('DeleteDocClassroomCurrentAsyncClassroomAction...');
    FirebaseFirestore firestore = state.dataSourceState.firebaseFirestoreRemote;
    await firestore
        .collection(UserModel.collection)
        .doc(state.loggedState.userModelLogged.id)
        .update({
      'classroomId': FieldValue.arrayRemove([id])
    });
    await dispatchFuture(GetDocUserAsyncUserAction());
    await firestore.collection(ClassroomModel.collection).doc(id).delete();

    return state.copyWith(
      classroomState: state.classroomState.copyWith(
        classroomCurrent: ClassroomModel(null),
      ),
    );
  }

  @override
  void after() {
    dispatch(ReadyDocsClassroomListAsyncClassroomAction());
  }
}

class ChangeClassroomListOrderAsyncClassroomAction
    extends ReduxAction<AppState> {
  final int oldIndex;
  final int newIndex;

  ChangeClassroomListOrderAsyncClassroomAction({
    this.oldIndex,
    this.newIndex,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocClassroomCurrentAsyncClassroomAction...');
    FirebaseFirestore firestore = state.dataSourceState.firebaseFirestoreRemote;
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
        .doc(state.loggedState.userModelLogged.id)
        .update({'classroomId': userModel.classroomId});

    return null;
  }

  @override
  void after() {
    dispatch(GetDocsUserModelAsyncLoggedAction(
        id: state.loggedState.userModelLogged.id));
  }
}
