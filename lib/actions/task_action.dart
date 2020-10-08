// +++ Actions Sync
import 'package:aiprof/models/task_model.dart';
import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetTaskCurrentSyncTaskAction extends ReduxAction<AppState> {
  final String id;

  SetTaskCurrentSyncTaskAction(this.id);

  @override
  AppState reduce() {
    TaskModel taskModel;
    if (id == null) {
      return null;
    } else {
      TaskModel taskModelTemp =
          state.taskState.taskList.firstWhere((element) => element.id == id);
      taskModel = TaskModel(taskModelTemp.id).fromMap(taskModelTemp.toMap());
    }
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
  Future<AppState> reduce() async {
    print('GetDocsTaskListAsyncTaskAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    collRef = firestore
        .collection(TaskModel.collection)
        .where('exameRef.id', isEqualTo: state.exameState.exameCurrent.id)
        .where('studentUserRef.id',
            isEqualTo: state.exameState.studentIdSelected);
    final docsSnap = await collRef.getDocuments();

    final listDocs = docsSnap.documents
        .map((docSnap) => TaskModel(docSnap.documentID).fromMap(docSnap.data))
        .toList();
    // listDocs.sort((a, b) => a.name.compareTo(b.name));
    return state.copyWith(
      taskState: state.taskState.copyWith(
        taskList: listDocs,
      ),
    );
  }
}
