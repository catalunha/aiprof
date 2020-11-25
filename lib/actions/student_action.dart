// +++ Actions Sync
import 'package:aiprof/classroom/classroom_model.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart' as uuid;

class SetStudentCurrentSyncStudentAction extends ReduxAction<AppState> {
  final String id;

  SetStudentCurrentSyncStudentAction(this.id);

  @override
  AppState reduce() {
    UserModel studentModel;
    if (id == null) {
      studentModel = UserModel(null);
    } else {
      UserModel studentModelTemp = state.studentState.studentList
          .firstWhere((element) => element.id == id);
      studentModel =
          UserModel(studentModelTemp.id).fromMap(studentModelTemp.toMap());
    }
    return state.copyWith(
      studentState: state.studentState.copyWith(
        studentCurrent: studentModel,
      ),
    );
  }
}

class SetStudentFilterSyncStudentAction extends ReduxAction<AppState> {
  final StudentFilter studentFilter;

  SetStudentFilterSyncStudentAction(this.studentFilter);

  @override
  AppState reduce() {
    return state.copyWith(
      studentState: state.studentState.copyWith(
        studentFilter: studentFilter,
      ),
    );
  }

  void after() => dispatch(GetDocsStudentListAsyncStudentAction());
}

class GetDocsStudentListAsyncStudentAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('GetDocsStudentListAsyncStudentAction...');
    // Firestore firestore = Firestore.instance;
    // Query collRef;
    // collRef = firestore
    //     .collection(UserModel.collection)
    //     .where('isTeacher', isEqualTo: false)
    //     .where('classroomId',
    //         arrayContains: state.classroomState.classroomCurrent.id);

    // final docsSnap = await collRef.getDocuments();

    // final listDocs = docsSnap.documents
    //     .map((docSnap) => UserModel(docSnap.documentID).fromMap(docSnap.data))
    //     .toList();
    // print(listDocs);
    // listDocs.sort((a, b) => a.name.compareTo(b.name));
    List<UserModel> studentList = [];
    if (state.classroomState.classroomCurrent.studentUserRefMap != null) {
      for (var item
          in state.classroomState.classroomCurrent.studentUserRefMap.entries) {
        studentList.add(UserModel(item.key).fromMap(item.value.toMap()));
      }
      // print(studentList);
      studentList.sort((a, b) => a.name.compareTo(b.name));
    }
    return state.copyWith(
      studentState: state.studentState.copyWith(
        studentList: studentList,
      ),
    );
  }
}

// +++ Actions Async
// class GetDocsStudentListAsyncStudentAction extends ReduxAction<AppState> {
//   @override
//   Future<AppState> reduce() async {
//     print('GetDocsStudentListAsyncStudentAction...');
//     Firestore firestore = Firestore.instance;
//     Query collRef;
//     collRef = firestore
//         .collection(UserModel.collection)
//         .where('isTeacher', isEqualTo: false)
//         .where('classroomId',
//             arrayContains: state.classroomState.classroomCurrent.id);

//     final docsSnap = await collRef.getDocuments();

//     final listDocs = docsSnap.documents
//         .map((docSnap) => UserModel(docSnap.documentID).fromMap(docSnap.data))
//         .toList();
//     print(listDocs);
//     listDocs.sort((a, b) => a.name.compareTo(b.name));
//     return state.copyWith(
//       studentState: state.studentState.copyWith(
//         studentList: listDocs,
//       ),
//     );
//   }
// }

// class BatchDocImportStudentAsyncStudentAction extends ReduxAction<AppState> {
//   final String studentsToImport;

//   BatchDocImportStudentAsyncStudentAction({
//     this.studentsToImport,
//   });
//   // @override
//   // Future<AppState> reduce() async {
//   //   print('AddDocStudentCurrentAsyncStudentAction...');
//   //   Firestore firestore = Firestore.instance;

//   //   return null;
//   // }
//   @override
//   Future<AppState> reduce() async {
//     print(studentsToImport);
//     List<List<String>> studentList = List<List<String>>();
//     studentList.clear();
//     String matricula;
//     String email;
//     String nome;
//     if (studentsToImport != null) {
//       // // print('::cadastro::');
//       // // print(studentsToImport);
//       List<String> linhas = studentsToImport.split('\n');
//       // // print('::linhas::');
//       // // print(linhas);
//       for (var linha in linhas) {
//         // // print('::linha::');
//         // // print(linha);
//         if (linha != null) {
//           List<String> campos = linha.trim().split(';');
//           // // print('::campos::');
//           // // print(campos);
//           if (campos != null &&
//               campos.length == 3 &&
//               campos[0] != null &&
//               campos[0].length >= 1 &&
//               campos[1] != null &&
//               campos[1].length >= 3 &&
//               campos[1].contains('@') &&
//               campos[2] != null &&
//               campos[2].length >= 3) {
//             matricula = campos[0].trim();
//             email = campos[1].trim();
//             nome = campos[2].trim();
//             // // print('::matricula::$matricula');
//             // // print('::email::$email');
//             // // print('::nome::$nome');
//             studentList.add([matricula, email, nome]);
//           }
//         }
//       }
//     }
//     print(studentList);
//     Firestore firestore = Firestore.instance;

//     var batch = firestore.batch();
//     if (studentList.isNotEmpty) {
//       for (var student in studentList) {
//         // var studentDoc = firestore.collection('student').document();
//         var studentDoc = firestore.collection(UserModel.collection).document();
//         batch.setData(
//             studentDoc,
//             {
//               'isActive': true,
//               'isTeacher': false,
//               'code': student[0],
//               'email': student[1],
//               'name': student[2],
//               'classroomId': FieldValue.arrayUnion(
//                   [state.classroomState.classroomCurrent.id]),
//             },
//             merge: true);
//       }
//     }
//     await batch.commit();
//     // if (studentList.isNotEmpty) {
//     //   for (var student in studentList) {
//     //     try {
//     //       AuthResult userNew = await FirebaseAuth.instance
//     //           .createUserWithEmailAndPassword(
//     //               email: student[1], password: student[0]);

//     //       userNew.user.;
//     //       print('userNew: ${userNew.user.uid}');
//     //     } catch (e) {
//     //       if (e.code == 'weak-password') {
//     //         print('The password provided is too weak.');
//     //       } else if (e.code == 'email-already-in-use') {
//     //         print('The account already exists for that email.');
//     //         // throw const UserException("Este estudante já foi cadastrado.");
//     //       }
//     //       print(e.toString());
//     //     }
//     //   }
//     // }
//     return null;
//   }
//   // @override
//   // Object wrapError(error) => UserException("ATENÇÃO:", cause: error);

// }

class RemoveStudentForClassroomAsyncStudentAction
    extends ReduxAction<AppState> {
  final String studentId;

  RemoveStudentForClassroomAsyncStudentAction(this.studentId);

  @override
  Future<AppState> reduce() async {
    Firestore firestore = Firestore.instance;
    //O user removido de uma classroom apenas nao tem mais acesso a aquela classroom. mas todo seu hitorico de task fica salvo.
    await firestore
        .collection(UserModel.collection)
        .document(studentId)
        .updateData({
      'classroomId':
          FieldValue.arrayRemove([state.classroomState.classroomCurrent.id])
    });
    await firestore
        .collection(ClassroomModel.collection)
        .document(state.classroomState.classroomCurrent.id)
        .updateData({'studentUserRefMap.$studentId': FieldValue.delete()});

    return null;
  }

  @override
  void after() => dispatch(GetDocsStudentListAsyncStudentAction());
}

// 123456;abc@gmail.com;Abc abc
// 234567;def@gmail.com;Def def
class UpdateStudentMapTempAsyncStudentAction extends ReduxAction<AppState> {
  final String studentListString;

  UpdateStudentMapTempAsyncStudentAction({
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
