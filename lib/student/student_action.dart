// +++ Actions Sync
import 'package:aiprof/app_state.dart';
import 'package:aiprof/classroom/classroom_model.dart';
import 'package:aiprof/student/student_enum.dart';
import 'package:aiprof/student/student_model.dart';
import 'package:aiprof/user/user_model.dart';
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

  void after() => dispatch(SetStudentListSyncStudentAction());
}

class ChangeStudentSelectedSyncStudentAction extends ReduxAction<AppState> {
  final String studentId;

  ChangeStudentSelectedSyncStudentAction(this.studentId);

  @override
  AppState reduce() {
    print(studentId);
    List<StudentModel> studentList = [];
    studentList.addAll(state.studentState.studentList);
    for (var i = 0; i < studentList.length; i++) {
      print(studentList[i].id);
      print(studentList[i].isSelected);

      if (studentList[i].id == studentId) {
        print('1');
        if (studentList[i].isSelected == null) {
          print('2');
          studentList[i].isSelected = true;
        } else {
          print('3');
          studentList[i].isSelected = !studentList[i].isSelected;
        }
      }
      print(studentList[i].isSelected);
    }
    return state.copyWith(
      studentState: state.studentState.copyWith(
        studentList: studentList,
      ),
    );
  }
}

class SetStudentListSyncStudentAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('SetStudentListSyncStudentAction...');

    List<StudentModel> studentList = [];
    if (state.classroomState.classroomCurrent.studentRef != null) {
      for (var item
          in state.classroomState.classroomCurrent.studentRef.entries) {
        studentList.add(StudentModel(item.key).fromMap(item.value.toMap()));
      }
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
  void after() => dispatch(SetStudentListSyncStudentAction());
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

    classroomModel.studentRefTemp = _studentsToImport.studentStringToMap();

    await firestore
        .collection(ClassroomModel.collection)
        .document(classroomModel.id)
        .updateData(classroomModel.toMap());
    return null;
  }

  @override
  void after() => dispatch(SetStudentListSyncStudentAction());
}

class StudentsToImport {
  final String studentsToImport;

  StudentsToImport(this.studentsToImport);
  Map<String, StudentModel> studentStringToMap() {
    Map<String, StudentModel> studentMap = {};
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
            studentMap[id] = StudentModel(id)
                .fromMap({'code': matricula, 'email': email, 'name': nome});
          }
        }
      }
    }
    print(studentList);
    return studentMap;
  }
}
