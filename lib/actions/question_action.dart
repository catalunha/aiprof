import 'package:aiprof/actions/exame_action.dart';
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
    questionList.sort((a, b) => a.name.compareTo(b.name));

    return state.copyWith(
      questionState: state.questionState.copyWith(
        questionList: questionList,
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
        .add(questionModel.toMap())
        .then((value) =>
            dispatch(UpdateDocSetQuestionInExameCurrentAsyncExameAction(
              questionId: value.documentID,
              isAddOrRemove: true,
            )));
    // dispatch(UpdateDocSetQuestionInExameCurrentAsyncExameAction(
    //   questionId: questionModel.id,
    //   isAddOrRemove: true,
    // ));
    return null;
  }

  // @override
  // void after() => dispatch(StreamColQuestionAsyncQuestionAction());
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
    questionModel.name = name;
    questionModel.description = description;
    questionModel.start = start;
    questionModel.end = end;
    questionModel.scoreQuestion = scoreQuestion;
    questionModel.attempt = attempt;
    questionModel.time = time;
    questionModel.error = error;
    questionModel.scoreQuestion = scoreQuestion;
    questionModel.resetTask = resetTask;

    if (isDelete) {
      await firestore
          .collection(QuestionModel.collection)
          .document(questionModel.id)
          .delete();
      dispatch(UpdateDocSetQuestionInExameCurrentAsyncExameAction(
        questionId: questionModel.id,
        isAddOrRemove: false,
      ));
    } else {
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
