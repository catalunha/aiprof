import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/models/question_model.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';

// +++ Actions Sync
class SetExameCurrentSyncExameAction extends ReduxAction<AppState> {
  final String id;

  SetExameCurrentSyncExameAction(this.id);

  @override
  AppState reduce() {
    ExameModel exameModel;
    if (id == null) {
      exameModel = ExameModel(null);
    } else {
      ExameModel exameModelTemp =
          state.exameState.exameList.firstWhere((element) => element.id == id);
      exameModel =
          ExameModel(exameModelTemp.id).fromMap(exameModelTemp.toMap());
    }
    return state.copyWith(
      exameState: state.exameState.copyWith(
        exameCurrent: exameModel,
      ),
    );
  }
}

class SetExameFilterSyncExameAction extends ReduxAction<AppState> {
  final ExameFilter exameFilter;

  SetExameFilterSyncExameAction(this.exameFilter);

  @override
  AppState reduce() {
    return state.copyWith(
      exameState: state.exameState.copyWith(
        exameFilter: exameFilter,
      ),
    );
  }

  void after() => dispatch(GetDocsExameListAsyncExameAction());
}

// +++ Actions Async
class GetDocsExameListAsyncExameAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('GetDocsExameListAsyncExameAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    collRef = firestore
        .collection(ExameModel.collection)
        .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id)
        .where('classroomRef.id',
            isEqualTo: state.classroomState.classroomCurrent.id);
    final docsSnapOld = await collRef.getDocuments();

    List<ExameModel> listDocs = docsSnapOld.documents
        .map((docSnap) => ExameModel(docSnap.documentID).fromMap(docSnap.data))
        .toList();

    return state.copyWith(
      exameState: state.exameState.copyWith(
        exameList: listDocs,
      ),
    );
  }
}

class AddDocExameCurrentAsyncExameAction extends ReduxAction<AppState> {
  final String name;
  final String description;
  final dynamic start;
  final dynamic end;
  final int scoreExame;
  final int attempt;
  final int time;
  final int error;
  final int scoreQuestion;
  AddDocExameCurrentAsyncExameAction({
    this.name,
    this.description,
    this.start,
    this.end,
    this.scoreExame,
    this.attempt,
    this.time,
    this.error,
    this.scoreQuestion,
  });
  @override
  Future<AppState> reduce() async {
    print('AddDocExameCurrentAsyncExameAction...');
    Firestore firestore = Firestore.instance;
    ExameModel exameModel = ExameModel(state.exameState.exameCurrent.id)
        .fromMap(state.exameState.exameCurrent.toMap());
    exameModel.userRef = UserModel(state.loggedState.userModelLogged.id)
        .fromMap(state.loggedState.userModelLogged.toMapRef());
    exameModel.classroomRef =
        ClassroomModel(state.classroomState.classroomCurrent.id)
            .fromMap(state.classroomState.classroomCurrent.toMapRef());
    exameModel.name = name;
    exameModel.description = description;
    exameModel.start = start;
    exameModel.end = end;
    exameModel.scoreExame = scoreExame;
    exameModel.attempt = attempt;
    exameModel.time = time;
    exameModel.error = error;
    exameModel.scoreQuestion = scoreQuestion;
    exameModel.isDelivery = false;
    exameModel.isProcess = false;
    await firestore.collection(ExameModel.collection).add(exameModel.toMap());

    return null;
  }

  @override
  void after() => dispatch(GetDocsExameListAsyncExameAction());
}

class UpdateDocExameCurrentAsyncExameAction extends ReduxAction<AppState> {
  final String name;
  final String description;
  final dynamic start;
  final dynamic end;
  final int scoreExame;
  final int attempt;
  final int time;
  final int error;
  final int scoreQuestion;
  final bool isDelivery;
  final bool isDelete;
  UpdateDocExameCurrentAsyncExameAction({
    this.name,
    this.description,
    this.start,
    this.end,
    this.scoreExame,
    this.attempt,
    this.time,
    this.error,
    this.scoreQuestion,
    this.isDelivery,
    this.isDelete,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocExameCurrentAsyncExameAction...');
    Firestore firestore = Firestore.instance;
    ExameModel exameModel = ExameModel(state.exameState.exameCurrent.id)
        .fromMap(state.exameState.exameCurrent.toMap());
    exameModel.name = name;
    exameModel.description = description;
    exameModel.start = start;
    exameModel.end = end;
    exameModel.scoreExame = scoreExame;
    exameModel.attempt = attempt;
    exameModel.time = time;
    exameModel.error = error;
    exameModel.scoreQuestion = scoreQuestion;
    exameModel.isDelivery = isDelivery;

    if (isDelete) {
      await firestore
          .collection(ExameModel.collection)
          .document(exameModel.id)
          .delete();
    } else {
      await firestore
          .collection(ExameModel.collection)
          .document(exameModel.id)
          .updateData(exameModel.toMap());
    }
    return null;
  }

  @override
  void after() => dispatch(GetDocsExameListAsyncExameAction());
}

class UpdateDocSetStudentInExameCurrentAsyncExameAction
    extends ReduxAction<AppState> {
  final UserModel studentModel;
  final bool isAddOrRemove;
  UpdateDocSetStudentInExameCurrentAsyncExameAction({
    this.studentModel,
    this.isAddOrRemove,
  });
  @override
  Future<AppState> reduce() async {
    Firestore firestore = Firestore.instance;

    ExameModel exameModel = ExameModel(state.exameState.exameCurrent.id)
        .fromMap(state.exameState.exameCurrent.toMap());

    if (exameModel.studentMap == null)
      exameModel.studentMap = Map<String, bool>();
    if (isAddOrRemove) {
      if (!exameModel.studentMap.containsKey(studentModel.id)) {
        exameModel.studentMap.addAll({studentModel.id: false});
      }
    } else {
      exameModel.studentMap.remove(studentModel.id);
    }
    await firestore
        .collection(ExameModel.collection)
        .document(exameModel.id)
        .updateData(exameModel.toMap());
    return state.copyWith(
      exameState: state.exameState.copyWith(
        exameCurrent: exameModel,
      ),
    );
  }

  @override
  void before() => dispatch(WaitAction.add(this));
  @override
  void after() {
    dispatch(GetDocsExameListAsyncExameAction());
    dispatch(WaitAction.remove(this));
  }
}

class UpdateDocsSetStudentListInExameCurrentAsyncExameAction
    extends ReduxAction<AppState> {
  final bool isAddOrRemove;

  UpdateDocsSetStudentListInExameCurrentAsyncExameAction({
    this.isAddOrRemove,
  });
  @override
  Future<AppState> reduce() async {
    print('BatchedDocsWorkerListOnBoardAsyncWorkerAction...');
    Firestore firestore = Firestore.instance;
    ExameModel exameModel = ExameModel(state.exameState.exameCurrent.id)
        .fromMap(state.exameState.exameCurrent.toMap());
    if (exameModel.studentMap == null)
      exameModel.studentMap = Map<String, bool>();
    for (UserModel student in state.studentState.studentList) {
      if (isAddOrRemove) {
        if (!exameModel.studentMap.containsKey(student.id)) {
          exameModel.studentMap.addAll({student.id: false});
        }
      } else {
        if (exameModel.studentMap.containsKey(student.id) &&
            exameModel.studentMap[student.id] == false) {
          exameModel.studentMap.remove(student.id);
        }
      }
    }
    await firestore
        .collection(ExameModel.collection)
        .document(exameModel.id)
        .updateData(exameModel.toMap());
    return state.copyWith(
      exameState: state.exameState.copyWith(
        exameCurrent: exameModel,
      ),
    );
  }

  @override
  void before() => dispatch(WaitAction.add(this));
  @override
  void after() {
    dispatch(GetDocsExameListAsyncExameAction());
    dispatch(WaitAction.remove(this));
  }
}

class UpdateDocSetQuestionInExameCurrentAsyncExameAction
    extends ReduxAction<AppState> {
  final String questionId;
  final bool isAddOrRemove;
  UpdateDocSetQuestionInExameCurrentAsyncExameAction({
    this.questionId,
    this.isAddOrRemove,
  });
  @override
  Future<AppState> reduce() async {
    print(
        'UpdateDocSetQuestionInExameCurrentAsyncExameAction: $questionId $isAddOrRemove');
    Firestore firestore = Firestore.instance;

    ExameModel exameModel = ExameModel(state.exameState.exameCurrent.id)
        .fromMap(state.exameState.exameCurrent.toMap());

    if (exameModel.questionMap == null)
      exameModel.questionMap = Map<String, bool>();
    if (isAddOrRemove) {
      if (!exameModel.questionMap.containsKey(questionId)) {
        exameModel.questionMap.addAll({questionId: false});
      }
    } else {
      exameModel.questionMap.remove(questionId);
    }
    await firestore
        .collection(ExameModel.collection)
        .document(exameModel.id)
        .updateData(exameModel.toMap());
    return state.copyWith(
      exameState: state.exameState.copyWith(
        exameCurrent: exameModel,
      ),
    );
  }

  @override
  void before() => dispatch(WaitAction.add(this));
  @override
  void after() {
    dispatch(GetDocsExameListAsyncExameAction());
    dispatch(WaitAction.remove(this));
  }
}
