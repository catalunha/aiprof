import 'package:aiprof/actions/exame_action.dart';
import 'package:aiprof/models/classroom_model.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/exame/exame_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final ClassroomModel classroomRef;
  final List<ExameModel> exameList;
  final Function(String) onEditExameCurrent;
  final Function(String) onQuestionList;
  final Function(String) onStudentList;
  final Function(int, int) onChangeOrderExameList;
  ViewModel({
    @required this.classroomRef,
    @required this.exameList,
    @required this.onEditExameCurrent,
    @required this.onQuestionList,
    @required this.onStudentList,
    @required this.onChangeOrderExameList,
  }) : super(equals: [
          classroomRef,
          exameList,
        ]);
}

class Factory extends VmFactory<AppState, ExameList> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        classroomRef: state.classroomState.classroomCurrent,
        exameList: state.exameState.exameList,
        onEditExameCurrent: (String id) {
          dispatch(SetExameCurrentSyncExameAction(id));
          dispatch(NavigateAction.pushNamed(Routes.exameEdit));
        },
        onQuestionList: (String id) {
          dispatch(SetExameCurrentSyncExameAction(id));
          dispatch(NavigateAction.pushNamed(Routes.questionList));
        },
        onStudentList: (String id) {
          dispatch(SetExameCurrentSyncExameAction(id));
          dispatch(NavigateAction.pushNamed(Routes.questionStudentSelect));
        },
        onChangeOrderExameList: (int oldIndex, int newIndex) {
          dispatch(UpdateOrderExameListAsyncExameAction(
            oldIndex: oldIndex,
            newIndex: newIndex,
          ));
        },
      );
}

class ExameList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      onInit: (store) => store.dispatch(StreamColExameAsyncExameAction()),
      builder: (context, viewModel) => ExameListDS(
        classroomRef: viewModel.classroomRef,
        exameList: viewModel.exameList,
        onEditExameCurrent: viewModel.onEditExameCurrent,
        onQuestionList: viewModel.onQuestionList,
        onStudentList: viewModel.onStudentList,
        onChangeOrderExameList: viewModel.onChangeOrderExameList,
      ),
    );
  }
}
