// +++ Actions Sync
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

// +++ Actions Async
class GetDocsStudentListAsyncStudentAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('GetDocsStudentListAsyncStudentAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    if (state.studentState.studentFilter == StudentFilter.isactive) {
      collRef = firestore
          .collection(UserModel.collection)
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id)
          .where('isActive', isEqualTo: true);
    } else if (state.studentState.studentFilter == StudentFilter.isntactive) {
      collRef = firestore
          .collection(UserModel.collection)
          .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id)
          .where('isActive', isEqualTo: false);
    }
    final docsSnap = await collRef.getDocuments();

    final listDocs = docsSnap.documents
        .map((docSnap) => UserModel(docSnap.documentID).fromMap(docSnap.data))
        .toList();

    listDocs.sort((a, b) => a.name.compareTo(b.name));
    return state.copyWith(
      studentState: state.studentState.copyWith(
        studentList: listDocs,
      ),
    );
  }
}

class AddDocStudentCurrentAsyncStudentAction extends ReduxAction<AppState> {
  final List<String> studentList;

  AddDocStudentCurrentAsyncStudentAction({
    this.studentList,
  });
  @override
  Future<AppState> reduce() async {
    print('AddDocStudentCurrentAsyncStudentAction...');
    Firestore firestore = Firestore.instance;
    // UserModel studentModel = UserModel(state.studentState.studentCurrent.id)
    //     .fromMap(state.studentState.studentCurrent.toMap());
    // studentModel.userRef = UserModel(state.loggedState.userModelLogged.id)
    //     .fromMap(state.loggedState.userModelLogged.toMapRef());
    // studentModel.company = company;
    // studentModel.component = component;
    // studentModel.name = name;
    // studentModel.description = description;
    // studentModel.urlProgram = urlProgram;
    // studentModel.isActive = true;

    // await firestore.collection(UserModel.collection).add(studentModel.toMap());
    return null;
  }

  // @override
  // Object wrapError(error) => UserException("ATENÇÃO:", cause: error);
  @override
  void after() => dispatch(GetDocsStudentListAsyncStudentAction());
}

// class UpdateDocStudentCurrentAsyncStudentAction extends ReduxAction<AppState> {
//   final String company;
//   final String component;
//   final String name;
//   final String description;
//   final String urlProgram;
//   final bool isActive;

//   UpdateDocStudentCurrentAsyncStudentAction({
//     this.company,
//     this.component,
//     this.name,
//     this.description,
//     this.urlProgram,
//     this.isActive,
//   });
//   @override
//   Future<AppState> reduce() async {
//     print('UpdateDocStudentCurrentAsyncStudentAction...');
//     Firestore firestore = Firestore.instance;
//     UserModel studentModel = UserModel(state.studentState.studentCurrent.id)
//         .fromMap(state.studentState.studentCurrent.toMap());
//     studentModel.company = company;
//     studentModel.component = component;
//     studentModel.name = name;
//     studentModel.description = description;
//     studentModel.urlProgram = urlProgram;
//     studentModel.isActive = isActive;
//     await firestore
//         .collection(UserModel.collection)
//         .document(studentModel.id)
//         .updateData(studentModel.toMap());
//     return null;
//   }

//   @override
//   void after() => dispatch(GetDocsStudentListAsyncStudentAction());
// }
