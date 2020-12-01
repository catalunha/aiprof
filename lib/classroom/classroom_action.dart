import 'package:aiprof/app_state.dart';
import 'package:aiprof/classroom/classroom_enum.dart';
import 'package:aiprof/classroom/classroom_model.dart';
import 'package:aiprof/login/logged_action.dart';
import 'package:aiprof/teacher/teacher_model.dart';
import 'package:aiprof/user/user_model.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// +++ Actions Sync
class SetClassroomCurrentSyncClassroomAction extends ReduxAction<AppState> {
  final String id;
  SetClassroomCurrentSyncClassroomAction(this.id);
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

class SetClassroomListSyncClassroomAction extends ReduxAction<AppState> {
  final List<ClassroomModel> classroomList;
  SetClassroomListSyncClassroomAction(this.classroomList);
  @override
  AppState reduce() {
    final Map<String, ClassroomModel> mapping = {
      for (int i = 0; i < classroomList.length; i++)
        classroomList[i].id: classroomList[i]
    };
    List<ClassroomModel> classroomListTemp = [];
    for (String id in state.loggedState.userModelLogged.classroomId) {
      if (mapping.containsKey(id)) {
        classroomListTemp.add(mapping[id]);
      }
    }
    print('Get2DocsTaskListAsyncTaskAction... ${classroomList.length}');
    // print('Get2DocsTaskListAsyncTaskAction... $classroomList');
    print('Get2DocsTaskListAsyncTaskAction... ${classroomListTemp.length}');
    // print('Get2DocsTaskListAsyncTaskAction... $classroomListTemp');

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

// +++ Actions Async
// class StreamDocsClassroomAsyncClassroomAction extends ReduxAction<AppState> {
//   @override
//   AppState reduce() {
//     print('StreamDocsClassroomAsyncClassroomAction...');
//     Firestore firestore = Firestore.instance;
//     Query collRef;
//     collRef = firestore
//         .collection(ClassroomModel.collection)
//         .where('teacher.id', isEqualTo: state.loggedState.userModelLogged.id);

//     Stream<QuerySnapshot> streamQuerySnapshot = collRef.snapshots();

//     Stream<List<ClassroomModel>> streamList = streamQuerySnapshot.map(
//         (querySnapshot) => querySnapshot.documents
//             .map((docSnapshot) => ClassroomModel(docSnapshot.documentID)
//                 .fromMap(docSnapshot.data))
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
    Firestore firestore = Firestore.instance;
    ClassroomModel classroomModel =
        ClassroomModel(state.classroomState.classroomCurrent.id)
            .fromMap(state.classroomState.classroomCurrent.toMap());
    classroomModel.teacher = TeacherModel(state.loggedState.userModelLogged.id)
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
      await dispatchFuture(GetDocUserAsyncUserAction());
    }
    return null;
  }

  @override
  void after() {
    dispatch(ReadyDocsClassroomListAsyncClassroomAction());
  }
}

class ReadyDocsClassroomListAsyncClassroomAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    Firestore firestore = Firestore.instance;
    Query collRef;
    collRef = firestore
        .collection(ClassroomModel.collection)
        .where('teacher.id', isEqualTo: state.loggedState.userModelLogged.id);
    final docsSnap = await collRef.getDocuments();

    List<ClassroomModel> classroomList = docsSnap.documents
        .map((docSnap) =>
            ClassroomModel(docSnap.documentID).fromMap(docSnap.data))
        .toList();
    dispatch(SetClassroomListSyncClassroomAction(classroomList));

    return null;
    // final Map<String, ClassroomModel> mapping = {
    //   for (int i = 0; i < classroomList.length; i++)
    //     classroomList[i].id: classroomList[i]
    // };
    // List<ClassroomModel> classroomListTemp = [
    //   for (String id in state.loggedState.userModelLogged.classroomId)
    //     mapping[id]
    // ];

    // print('Get2DocsTaskListAsyncTaskAction... ${classroomList.length}');
    // print('Get2DocsTaskListAsyncTaskAction... ${classroomListTemp.length}');

    // ClassroomModel classroomModel;
    // if (state.classroomState.classroomCurrent?.id != null) {
    //   classroomModel = state.classroomState.classroomList.firstWhere(
    //       (element) => element.id == state.classroomState.classroomCurrent.id);
    // }

    // return state.copyWith(
    //   classroomState: state.classroomState.copyWith(
    //     classroomList: classroomListTemp,
    //     classroomCurrent: classroomModel,
    //   ),
    // );
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
    Firestore firestore = Firestore.instance;
    await firestore
        .collection(UserModel.collection)
        .document(state.loggedState.userModelLogged.id)
        .updateData({
      'classroomId': FieldValue.arrayRemove([id])
    });
    await dispatchFuture(GetDocUserAsyncUserAction());
    await firestore.collection(ClassroomModel.collection).document(id).delete();

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
    print('ChangeClassroomListOrderAsyncClassroomAction...');
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
    dispatch(GetDocUserAsyncUserAction());
  }
}
