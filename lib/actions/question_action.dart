import 'package:aiprof/actions/exame_action.dart';
import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/models/question_model.dart';
import 'package:aiprof/models/task_model.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';

// +++ Actions Sync
class SetQuestionCurrentSyncQuestionAction extends ReduxAction<AppState> {
  final String id;

  SetQuestionCurrentSyncQuestionAction(this.id);

  @override
  AppState reduce() {
    QuestionModel questionModel;
    if (id == null) {
      questionModel = QuestionModel(null);

      ExameModel exameCurrent = ExameModel(state.exameState.exameCurrent.id)
          .fromMap(state.exameState.exameCurrent.toMap());
      questionModel.start = exameCurrent.start;
      questionModel.end = exameCurrent.end;
      questionModel.scoreQuestion = exameCurrent.scoreQuestion;
      questionModel.attempt = exameCurrent.attempt;
      questionModel.time = exameCurrent.time;
      questionModel.error = exameCurrent.error;
      questionModel.isDelivered = false;
    } else {
      QuestionModel questionModelTemp = state.questionState.questionList
          .firstWhere((element) => element.id == id);
      questionModel = QuestionModel(questionModelTemp.id)
          .fromMap(questionModelTemp.toMap());
    }
    return state.copyWith(
      questionState: state.questionState.copyWith(
        questionCurrent: questionModel,
      ),
    );
  }
}

class SetQuestionFilterSyncQuestionAction extends ReduxAction<AppState> {
  final QuestionFilter questionFilter;

  SetQuestionFilterSyncQuestionAction(this.questionFilter);

  @override
  AppState reduce() {
    return state.copyWith(
      questionState: state.questionState.copyWith(
        questionFilter: questionFilter,
      ),
    );
  }

  // void after() => dispatch(StreamColQuestionAsyncQuestionAction());
}

// +++ Actions Async
class StreamColQuestionAsyncQuestionAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    print('StreamColQuestionAsyncQuestionAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    collRef = firestore
        .collection(QuestionModel.collection)
        .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id)
        .where('classroomRef.id',
            isEqualTo: state.classroomState.classroomCurrent.id)
        .where('exameRef.id', isEqualTo: state.exameState.exameCurrent.id);
    // final docsSnap =  collRef.getDocuments();

    // List<QuestionModel> listDocs = docsSnap.documents
    //     .map((docSnap) =>
    //         QuestionModel(docSnap.documentID).fromMap(docSnap.data))
    //     .toList();
    Stream<QuerySnapshot> streamQuerySnapshot = collRef.snapshots();

    Stream<List<QuestionModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.documents
            .map((docSnapshot) =>
                QuestionModel(docSnapshot.documentID).fromMap(docSnapshot.data))
            .toList());
    streamList.listen((List<QuestionModel> list) {
      dispatch(GetDocsQuestionListAsyncQuestionAction(list));
    });

    return null;
  }
}

class GetDocsQuestionListAsyncQuestionAction extends ReduxAction<AppState> {
  final List<QuestionModel> questionList;

  GetDocsQuestionListAsyncQuestionAction(this.questionList);

  @override
  AppState reduce() {
    final Map<String, QuestionModel> mapping = {
      for (int i = 0; i < questionList.length; i++)
        questionList[i].id: questionList[i]
    };
    List<QuestionModel> questionListOrdered = [];
    if (state.exameState.exameCurrent?.questionId != null) {
      for (String id in state.exameState.exameCurrent.questionId)
        questionListOrdered.add(mapping[id]);
    }
    QuestionModel questionModel;
    if (state.exameState.exameCurrent != null) {
      int index = questionListOrdered.indexWhere(
          (element) => element.id == state.questionState.questionCurrent.id);
      // print(index);
      if (index >= 0) {
        QuestionModel questionModelTemp = questionListOrdered.firstWhere(
            (element) => element.id == state.questionState.questionCurrent.id);
        questionModel = QuestionModel(questionModelTemp.id)
            .fromMap(questionModelTemp.toMap());
      }
    }

    return state.copyWith(
      questionState: state.questionState.copyWith(
        questionList: questionListOrdered,
        questionCurrent: questionModel,
      ),
    );
  }
}

class AddDocQuestionCurrentAsyncQuestionAction extends ReduxAction<AppState> {
  final String name;
  final String description;
  final dynamic start;
  final dynamic end;
  final int scoreQuestion;
  final int attempt;
  final int time;
  final int error;
  AddDocQuestionCurrentAsyncQuestionAction({
    this.name,
    this.description,
    this.start,
    this.end,
    this.scoreQuestion,
    this.attempt,
    this.time,
    this.error,
  });
  @override
  Future<AppState> reduce() async {
    print('AddDocQuestionCurrentAsyncQuestionAction...');
    Firestore firestore = Firestore.instance;
    QuestionModel questionModel =
        QuestionModel(state.questionState.questionCurrent.id)
            .fromMap(state.questionState.questionCurrent.toMap());
    questionModel.userRef = UserModel(state.loggedState.userModelLogged.id)
        .fromMap(state.loggedState.userModelLogged.toMapRef());
    questionModel.classroomRef =
        ClassroomModel(state.classroomState.classroomCurrent.id)
            .fromMap(state.classroomState.classroomCurrent.toMapRef());
    questionModel.exameRef = ExameModel(state.exameState.exameCurrent.id)
        .fromMap(state.exameState.exameCurrent.toMapRef());
    questionModel.name = name;
    questionModel.description = description;
    questionModel.start = start;
    questionModel.end = end;
    questionModel.scoreQuestion = scoreQuestion;
    questionModel.attempt = attempt;
    questionModel.time = time;
    questionModel.error = error;
    questionModel.isDelivered = false;
    questionModel.scoreExame = state.exameState.exameCurrent.scoreExame;
    var docRefQuestion =
        firestore.collection(QuestionModel.collection).document();
    print('Novo Question: ${docRefQuestion.documentID}');
    await firestore
        .collection(ExameModel.collection)
        .document(state.exameState.exameCurrent.id)
        .updateData({
      'questionId': FieldValue.arrayUnion([docRefQuestion.documentID])
    }).then((value) async {
      await firestore
          .collection(QuestionModel.collection)
          .document(docRefQuestion.documentID)
          .setData(questionModel.toMap());
    });

    // await firestore
    //     .collection(QuestionModel.collection)
    //     .add(questionModel.toMap())
    //     .then((value) =>
    //         dispatch(UpdateDocSetQuestionInExameCurrentAsyncExameAction(
    //           questionId: value.documentID,
    //           isAddOrRemove: true,
    //         )));

    return null;
  }
}

class UpdateDocQuestionCurrentAsyncQuestionAction
    extends ReduxAction<AppState> {
  final String name;
  final String description;
  final dynamic start;
  final dynamic end;
  final int scoreQuestion;
  final int attempt;
  final int time;
  final int error;
  final bool isDelivered;
  final bool isDelete;
  final bool resetTask;

  UpdateDocQuestionCurrentAsyncQuestionAction({
    this.name,
    this.description,
    this.start,
    this.end,
    this.scoreQuestion,
    this.attempt,
    this.time,
    this.error,
    this.isDelivered,
    this.isDelete,
    this.resetTask,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocQuestionCurrentAsyncQuestionAction...');
    Firestore firestore = Firestore.instance;
    QuestionModel questionModel =
        QuestionModel(state.questionState.questionCurrent.id)
            .fromMap(state.questionState.questionCurrent.toMap());

    if (isDelete) {
      await firestore
          .collection(ExameModel.collection)
          .document(state.exameState.exameCurrent.id)
          .updateData({
        'questionId': FieldValue.arrayRemove([questionModel.id])
      }).then((value) {
        firestore
            .collection(QuestionModel.collection)
            .document(questionModel.id)
            .delete();
        //TODO: Eliminar esta função
        dispatch(UpdateDocSetQuestionInExameCurrentAsyncExameAction(
          questionId: questionModel.id,
          isAddOrRemove: false,
        ));
        return state.copyWith(
          questionState: state.questionState.copyWith(
            questionCurrent: null,
          ),
        );
      });
      // await firestore
      //     .collection(QuestionModel.collection)
      //     .document(questionModel.id)
      //     .delete();
      // dispatch(UpdateDocSetQuestionInExameCurrentAsyncExameAction(
      //   questionId: questionModel.id,
      //   isAddOrRemove: false,
      // ));
    } else {
      questionModel.name = name;
      questionModel.description = description;
      questionModel.start = start;
      questionModel.end = end;
      questionModel.scoreQuestion = scoreQuestion;
      questionModel.attempt = attempt;
      questionModel.time = time;
      questionModel.error = error;
      questionModel.scoreQuestion = scoreQuestion;
      questionModel.isDelivered = isDelivered;
      questionModel.resetTask = resetTask;

      await firestore
          .collection(QuestionModel.collection)
          .document(questionModel.id)
          .updateData(questionModel.toMap());
    }
    return null;
  }

  // @override
  // void after() => dispatch(StreamColQuestionAsyncQuestionAction());
}

class UpdateDocSetStudentInQuestionCurrentAsyncQuestionAction
    extends ReduxAction<AppState> {
  final UserModel studentModel;
  final bool isAddOrRemove;
  UpdateDocSetStudentInQuestionCurrentAsyncQuestionAction({
    this.studentModel,
    this.isAddOrRemove,
  });
  @override
  Future<AppState> reduce() async {
    Firestore firestore = Firestore.instance;

    QuestionModel questionModel =
        QuestionModel(state.questionState.questionCurrent.id)
            .fromMap(state.questionState.questionCurrent.toMap());

    if (questionModel.studentUserRefMap == null)
      questionModel.studentUserRefMap = Map<String, UserModel>();
    if (isAddOrRemove) {
      if (!questionModel.studentUserRefMap.containsKey(studentModel.id)) {
        studentModel.status = false;
        questionModel.studentUserRefMap.addAll({studentModel.id: studentModel});
        questionModel.isDelivered = false;
      }
    }
    //  else {
    //   questionModel.studentUserRefMap.remove(studentModel.id);
    // }
    await firestore
        .collection(QuestionModel.collection)
        .document(questionModel.id)
        .updateData(questionModel.toMap());
    return state.copyWith(
      questionState: state.questionState.copyWith(
        questionCurrent: questionModel,
      ),
    );
  }

  @override
  void before() => dispatch(WaitAction.add(this));
  @override
  void after() {
    // dispatch(StreamColExameAsyncExameAction());
    dispatch(WaitAction.remove(this));
  }
}

class UpdateDocsSetStudentListInQuestionCurrentAsyncQuestionAction
    extends ReduxAction<AppState> {
  final bool isAddOrRemove;

  UpdateDocsSetStudentListInQuestionCurrentAsyncQuestionAction({
    this.isAddOrRemove,
  });
  @override
  Future<AppState> reduce() async {
    print('BatchedDocsWorkerListOnBoardAsyncWorkerAction...');
    Firestore firestore = Firestore.instance;
    QuestionModel questionModel =
        QuestionModel(state.questionState.questionCurrent.id)
            .fromMap(state.questionState.questionCurrent.toMap());

    if (questionModel.studentUserRefMap == null)
      questionModel.studentUserRefMap = Map<String, UserModel>();
    for (UserModel student in state.studentState.studentList) {
      if (isAddOrRemove) {
        if (!questionModel.studentUserRefMap.containsKey(student.id)) {
          student.status = false;
          questionModel.studentUserRefMap.addAll({student.id: student});
          questionModel.isDelivered = false;
        }
      }
      // else {
      //   if (questionModel.studentUserRefMap.containsKey(student.id)) {
      //     questionModel.studentUserRefMap.remove(student.id);
      //   }
      // }
    }
    await firestore
        .collection(QuestionModel.collection)
        .document(questionModel.id)
        .updateData(questionModel.toMap());
    return state.copyWith(
      questionState: state.questionState.copyWith(
        questionCurrent: questionModel,
      ),
    );
  }

  @override
  void before() => dispatch(WaitAction.add(this));
  @override
  void after() {
    // dispatch(StreamColExameAsyncExameAction());
    dispatch(WaitAction.remove(this));
  }
}

class DeleteStudentInQuestionCurrentAndTaskAsyncQuestionAction
    extends ReduxAction<AppState> {
  final String studentId;
  DeleteStudentInQuestionCurrentAndTaskAsyncQuestionAction(this.studentId);
  @override
  Future<AppState> reduce() async {
    Firestore firestore = Firestore.instance;

    QuestionModel questionModel =
        QuestionModel(state.questionState.questionCurrent.id)
            .fromMap(state.questionState.questionCurrent.toMap());

    questionModel.studentUserRefMap.remove(studentId);
    questionModel.isDelivered = true;
    if (questionModel.studentUserRefMap != null) {
      for (var item in questionModel.studentUserRefMap.values) {
        if (!item.status) {
          questionModel.isDelivered = false;
        }
      }
    }

    await firestore
        .collection(QuestionModel.collection)
        .document(questionModel.id)
        .updateData(questionModel.toMap());

    //+++ Deletando todas as tasks relacionadas. Pois taks para este student ja foi aplicada
    Query collRef;
    collRef = firestore
        .collection(TaskModel.collection)
        .where('questionRef.id', isEqualTo: questionModel.id);
    final docsSnap = await collRef.getDocuments();

    List<String> listDocs =
        docsSnap.documents.map((docSnap) => docSnap.documentID).toList();
    print(listDocs);
    var batch = firestore.batch();

    for (var id in listDocs) {
      batch.delete(firestore.collection(TaskModel.collection).document(id));
    }
    await batch.commit();

    //---
    return state.copyWith(
      questionState: state.questionState.copyWith(
        questionCurrent: questionModel,
      ),
    );
  }

  @override
  void before() => dispatch(WaitAction.add(this));
  @override
  void after() => dispatch(WaitAction.remove(this));
}

class UpdateOrderQuestionListAsyncQuestionAction extends ReduxAction<AppState> {
  final int oldIndex;
  final int newIndex;

  UpdateOrderQuestionListAsyncQuestionAction({
    this.oldIndex,
    this.newIndex,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateOrderQuestionListAsyncQuestionAction...');
    Firestore firestore = Firestore.instance;
    ExameModel exameModel = ExameModel(state.exameState.exameCurrent.id)
        .fromMap(state.exameState.exameCurrent.toMap());
    int _newIndex = newIndex;
    if (newIndex > oldIndex) {
      _newIndex -= 1;
    }
    dynamic exameOld = exameModel.questionId[oldIndex];
    exameModel.questionId.removeAt(oldIndex);
    exameModel.questionId.insert(_newIndex, exameOld);

    await firestore
        .collection(ExameModel.collection)
        .document(state.exameState.exameCurrent.id)
        .updateData({'questionId': exameModel.questionId});

    return null;
  }

  // @override
  // void after() {
  //   // dispatch(StreamColClassroomAsyncClassroomAction());
  //   dispatch(GetDocsUserModelAsyncLoggedAction(
  //       id: state.loggedState.userModelLogged.id));
  // }
}
