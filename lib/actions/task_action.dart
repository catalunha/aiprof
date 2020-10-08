import 'package:aiprof/models/task_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// +++ Actions Sync
class SetTaskCurrentSyncTaskAction extends ReduxAction<AppState> {
  final String id;

  SetTaskCurrentSyncTaskAction(this.id);

  @override
  AppState reduce() {
    TaskModel taskModel;

    TaskModel taskModelTemp =
        state.taskState.taskList.firstWhere((element) => element.id == id);
    taskModel = TaskModel(taskModelTemp.id).fromMap(taskModelTemp.toMap());

    return state.copyWith(
      taskState: state.taskState.copyWith(
        taskCurrent: taskModel,
      ),
    );
  }
}

class SetTaskFilterSyncTaskAction extends ReduxAction<AppState> {
  final TaskFilter taskFilter;

  SetTaskFilterSyncTaskAction(this.taskFilter);

  @override
  AppState reduce() {
    return state.copyWith(
      taskState: state.taskState.copyWith(
        taskFilter: taskFilter,
      ),
    );
  }

  void after() => dispatch(GetDocsTaskListAsyncTaskAction());
}

// +++ Actions Async
class GetDocsTaskListAsyncTaskAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    print('GetDocsTaskListAsyncTaskAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    collRef = firestore
        .collection(TaskModel.collection)
        .where('exameRef.id', isEqualTo: state.exameState.exameCurrent.id)
        .where('studentUserRef.id',
            isEqualTo: state.exameState.studentIdSelected);
    Stream<QuerySnapshot> streamQuerySnapshot = collRef.snapshots();

    Stream<List<TaskModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.documents
            .map((docSnapshot) =>
                TaskModel(docSnapshot.documentID).fromMap(docSnapshot.data))
            .toList());
    streamList.listen((List<TaskModel> list) {
      dispatch(Get2DocsTaskListAsyncTaskAction(list));
    });
    return null;
  }
}

class Get2DocsTaskListAsyncTaskAction extends ReduxAction<AppState> {
  final List<TaskModel> taskList;

  Get2DocsTaskListAsyncTaskAction(this.taskList);

  @override
  AppState reduce() {
    TaskModel taskModel;

    if (state.taskState.taskCurrent != null) {
      TaskModel taskModelTemp = taskList.firstWhere(
          (element) => element.id == state.taskState.taskCurrent.id);
      taskModel = TaskModel(taskModelTemp.id).fromMap(taskModelTemp.toMap());
    }

    return state.copyWith(
      taskState: state.taskState.copyWith(
        taskList: taskList,
        taskCurrent: taskModel,
      ),
    );
  }
}

class UpdateDocTaskCurrentAsyncTaskAction extends ReduxAction<AppState> {
  //dados do exame
  final dynamic start;
  final dynamic end;
  final int scoreExame;
  //dados da questao
  final int attempt;
  final int time;
  final int error;
  final int scoreQuestion;
  // gestão da tarefa
  final bool nullStarted;
  final int attempted;
  final bool open;
  final bool isDelete;
  UpdateDocTaskCurrentAsyncTaskAction({
    this.start,
    this.end,
    this.scoreExame,
    this.attempt,
    this.time,
    this.error,
    this.scoreQuestion,
    this.nullStarted,
    this.attempted,
    this.open,
    this.isDelete,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocQuestionCurrentAsyncQuestionAction...');
    Firestore firestore = Firestore.instance;
    TaskModel taskModel = TaskModel(state.taskState.taskCurrent.id)
        .fromMap(state.taskState.taskCurrent.toMap());

    if (isDelete) {
      await firestore
          .collection(TaskModel.collection)
          .document(taskModel.id)
          .delete();
    } else {
      taskModel.start = start;
      taskModel.end = end;
      taskModel.scoreExame = scoreExame;
      taskModel.attempt = attempt;
      taskModel.time = time;
      taskModel.error = error;
      taskModel.scoreQuestion = scoreQuestion;
      taskModel.attempted = attempted;
      // taskModel.open = open;
      if (nullStarted) {
        taskModel.started = null;
      }
      await firestore
          .collection(TaskModel.collection)
          .document(taskModel.id)
          .updateData(taskModel.toMap());
    }
    return null;
  }
}

class UpdateOutputAsyncTaskAction extends ReduxAction<AppState> {
  //dados do exame
  final String taskSimulationOutputId;
  final bool isTruOrFalse;

  UpdateOutputAsyncTaskAction({
    this.taskSimulationOutputId,
    this.isTruOrFalse,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocQuestionCurrentAsyncQuestionAction...');
    Firestore firestore = Firestore.instance;
    TaskModel taskModel = TaskModel(state.taskState.taskCurrent.id)
        .fromMap(state.taskState.taskCurrent.toMap());

    await firestore
        .collection(TaskModel.collection)
        .document(taskModel.id)
        .updateData(
            {'simulationOutput.$taskSimulationOutputId.right': isTruOrFalse});

    return null;
  }
}
