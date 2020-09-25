import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/models/question_model.dart';
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

  void after() => dispatch(GetDocsQuestionListAsyncQuestionAction());
}

// +++ Actions Async
class GetDocsQuestionListAsyncQuestionAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    print('GetDocsQuestionListAsyncQuestionAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    collRef = firestore
        .collection(QuestionModel.collection)
        .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id)
        .where('classroomRef.id',
            isEqualTo: state.classroomState.classroomCurrent.id)
        .where('exameRef.id', isEqualTo: state.exameState.exameCurrent.id);
    final docsSnap = await collRef.getDocuments();

    List<QuestionModel> listDocs = docsSnap.documents
        .map((docSnap) =>
            QuestionModel(docSnap.documentID).fromMap(docSnap.data))
        .toList();

    return state.copyWith(
      questionState: state.questionState.copyWith(
        questionList: listDocs,
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
    await firestore
        .collection(QuestionModel.collection)
        .add(questionModel.toMap());

    return null;
  }

  @override
  void after() => dispatch(GetDocsQuestionListAsyncQuestionAction());
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
  final bool isDelete;
  UpdateDocQuestionCurrentAsyncQuestionAction({
    this.name,
    this.description,
    this.start,
    this.end,
    this.scoreQuestion,
    this.attempt,
    this.time,
    this.error,
    this.isDelete,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocQuestionCurrentAsyncQuestionAction...');
    Firestore firestore = Firestore.instance;
    QuestionModel questionModel =
        QuestionModel(state.questionState.questionCurrent.id)
            .fromMap(state.questionState.questionCurrent.toMap());
    questionModel.name = name;
    questionModel.description = description;
    questionModel.start = start;
    questionModel.end = end;
    questionModel.scoreQuestion = scoreQuestion;
    questionModel.attempt = attempt;
    questionModel.time = time;
    questionModel.error = error;
    questionModel.scoreQuestion = scoreQuestion;

    if (isDelete) {
      await firestore
          .collection(QuestionModel.collection)
          .document(questionModel.id)
          .delete();
    } else {
      await firestore
          .collection(QuestionModel.collection)
          .document(questionModel.id)
          .updateData(questionModel.toMap());
    }
    return null;
  }

  @override
  void after() => dispatch(GetDocsQuestionListAsyncQuestionAction());
}
