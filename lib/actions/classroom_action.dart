// +++ Actions Sync
import 'package:aiprof/actions/logged_action.dart';
import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart' as uuid;

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
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id);
      // .where('isActive', isEqualTo: true);
    } else if (state.classroomState.classroomFilter ==
        ClassroomFilter.isNotactive) {
      collRef = firestore
          .collection(ClassroomModel.collection)
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id);
      // .where('isActive', isEqualTo: false);
    }
    final docsSnap = await collRef.getDocuments();

    final listDocs = docsSnap.documents
        .map((docSnap) =>
            ClassroomModel(docSnap.documentID).fromMap(docSnap.data))
        .toList();
    // listDocs.forEach((element) {
    //   print(element.id);
    // });
    Map<dynamic, ClassroomModel> mapping =
        Map.fromIterable(listDocs, key: (v) => v.id, value: (v) => v);
    List<dynamic> ids = state.loggedState.userModelLogged.classroomId;
    // print(ids);
    final listDocsSorted = [for (dynamic id in ids) mapping[id]];
    // listDocsSorted.forEach((element) {
    //   print(element.id);
    // });
    return state.copyWith(
      classroomState: state.classroomState.copyWith(
        classroomList: listDocsSorted,
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
    if (classroomModel.isActive != isActive && isActive) {
      await firestore
          .collection(UserModel.collection)
          .document(state.loggedState.userModelLogged.id)
          .updateData({
        'classroomId': FieldValue.arrayUnion([classroomModel.id])
      });
    }
    if (classroomModel.isActive != isActive && !isActive) {
      await firestore
          .collection(UserModel.collection)
          .document(state.loggedState.userModelLogged.id)
          .updateData({
        'classroomId': FieldValue.arrayRemove([classroomModel.id])
      });
    }
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
    dispatch(GetDocsClassroomListAsyncClassroomAction());
    dispatch(GetDocsUserModelAsyncLoggedAction(
        id: state.loggedState.userModelLogged.id));
  }
}

class UpdateStudentMapTempAsyncClassroomAction extends ReduxAction<AppState> {
  final String studentListString;

  UpdateStudentMapTempAsyncClassroomAction({
    this.studentListString,
  });
  @override
  Future<AppState> reduce() async {
    print('AddDocStudentCurrentAsyncStudentAction...');
    Firestore firestore = Firestore.instance;
    ClassroomModel classroomModel =
        ClassroomModel(state.classroomState.classroomCurrent.id)
            .fromMap(state.classroomState.classroomCurrent.toMap());
    StudentsToImport _studentsToImport = StudentsToImport(studentListString);

    classroomModel.studentUserRefMapTemp =
        _studentsToImport.studentStringToMap();

    await firestore
        .collection(ClassroomModel.collection)
        .document(classroomModel.id)
        .updateData(classroomModel.toMap());
    return null;
  }

  // @override
  // Object wrapError(error) => UserException("ATENÇÃO:", cause: error);
  // @override
  // void after() => dispatch(GetDocsStudentListAsyncStudentAction());
}

class StudentsToImport {
  final String studentsToImport;

  StudentsToImport(this.studentsToImport);
  Map<String, UserModel> studentStringToMap() {
    Map<String, UserModel> studentMap = {};
    List<List<String>> studentList = List<List<String>>();
    studentList.clear();
    String matricula;
    String email;
    String nome;
    if (studentsToImport != null) {
      // // print('::cadastro::');
      // // print(studentsToImport);
      List<String> linhas = studentsToImport.split('\n');
      // // print('::linhas::');
      // // print(linhas);
      for (var linha in linhas) {
        // // print('::linha::');
        // // print(linha);
        if (linha != null) {
          List<String> campos = linha.trim().split(';');
          // // print('::campos::');
          // // print(campos);
          if (campos != null &&
              campos.length == 3 &&
              campos[0] != null &&
              campos[0].length >= 1 &&
              campos[1] != null &&
              campos[1].length >= 3 &&
              campos[1].contains('@') &&
              campos[2] != null &&
              campos[2].length >= 3) {
            matricula = campos[0].trim();
            email = campos[1].trim();
            nome = campos[2].trim();
            // // print('::matricula::$matricula');
            // // print('::email::$email');
            // // print('::nome::$nome');
            studentList.add([matricula, email, nome]);
            String id = uuid.Uuid().v4();
            studentMap[id] =
                UserModel(id, code: matricula, email: email, name: nome);
          }
        }
      }
    }
    print(studentList);
    return studentMap;
  }
}
