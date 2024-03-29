import 'package:aiprof/app_state.dart';
import 'package:aiprof/task/task_enum.dart';
import 'package:aiprof/task/task_model.dart';
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

  // void after() => dispatch(StreamColTaskAsyncTaskAction());
}

// +++ Actions Async
class StreamColTaskAsyncTaskAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    print('StreamColTaskAsyncTaskAction...');
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query collRef;
    if (state.taskState.taskFilter == TaskFilter.whereClassroomAndStudent) {
      collRef = firestore
          .collection(TaskModel.collection)
          .where('classroomRef.id',
              isEqualTo: state.classroomState.classroomCurrent.id)
          .where('studentUserRef.id',
              isEqualTo: state.studentState.studentCurrent.id);
    } else if (state.taskState.taskFilter ==
        TaskFilter.whereQuestionAndStudent) {
      collRef = firestore
          .collection(TaskModel.collection)
          .where('questionRef.id',
              isEqualTo: state.questionState.questionCurrent.id)
          .where('studentUserRef.id',
              isEqualTo: state.studentState.studentCurrent.id);
    }

    Stream<QuerySnapshot> streamQuerySnapshot = collRef.snapshots();

    Stream<List<TaskModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.docs
            .map((docSnapshot) =>
                TaskModel(docSnapshot.id).fromMap(docSnapshot.data()))
            .toList());
    streamList.listen((List<TaskModel> list) {
      dispatch(GetDocsTaskListAsyncTaskAction(list));
    });
    return null;
  }
}

class GetDocsTaskListAsyncTaskAction extends ReduxAction<AppState> {
  final List<TaskModel> taskList;

  GetDocsTaskListAsyncTaskAction(this.taskList);

  @override
  AppState reduce() {
    TaskModel taskModel;
    print('Get2DocsTaskListAsyncTaskAction... ${taskList.length}');
    taskList.sort((a, b) => a.exameRef.name.compareTo(b.exameRef.name));

    if (state.taskState.taskCurrent != null) {
      int index = taskList.indexWhere(
          (element) => element.id == state.taskState.taskCurrent.id);
      print(index);
      if (index >= 0) {
        TaskModel taskModelTemp = taskList.firstWhere(
            (element) => element.id == state.taskState.taskCurrent.id);
        taskModel = TaskModel(taskModelTemp.id).fromMap(taskModelTemp.toMap());
      }
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
  final bool isOpen;
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
    this.isOpen,
    this.isDelete,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocQuestionCurrentAsyncQuestionAction...');
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    TaskModel taskModel = TaskModel(state.taskState.taskCurrent.id)
        .fromMap(state.taskState.taskCurrent.toMap());

    if (isDelete) {
      await firestore
          .collection(TaskModel.collection)
          .doc(taskModel.id)
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
      taskModel.isOpen = isOpen;
      if (nullStarted) {
        taskModel.started = null;
        taskModel.lastSendAnswer = null;
      }
      await firestore
          .collection(TaskModel.collection)
          .doc(taskModel.id)
          .update(taskModel.toMap());
    }
    return null;
  }
}

class UpdateOutputAsyncTaskAction extends ReduxAction<AppState> {
  //dados do exame
  final String taskId;
  final String taskSimulationOutputId;
  final bool isTruOrFalse;

  UpdateOutputAsyncTaskAction({
    this.taskId,
    this.taskSimulationOutputId,
    this.isTruOrFalse,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocQuestionCurrentAsyncQuestionAction...');
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection(TaskModel.collection).doc(taskId).update(
        {'simulationOutput.$taskSimulationOutputId.right': isTruOrFalse});

    return null;
  }
}
