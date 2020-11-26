import 'package:aiprof/app_state.dart';
import 'package:aiprof/question/question_action.dart';
import 'package:aiprof/question/question_edit_ui.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/situation/situation_model.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final String id;
  final String name;
  final String description;
  final dynamic start;
  final dynamic end;
  final int attempt;
  final int time;
  final int error;
  final int scoreQuestion;
  final SituationModel situationModel;
  final bool isDelivered;
  final bool withStudent;
  final bool withTask;
  final bool isAddOrUpdate;
  final Function() onSituationSelect;
  final Function(String, String, dynamic, dynamic, int, int, int, int) onAdd;
  final Function(String, String, dynamic, dynamic, int, int, int, int, bool,
      bool, bool) onUpdate;
  ViewModel({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.start,
    @required this.end,
    @required this.attempt,
    @required this.time,
    @required this.error,
    @required this.scoreQuestion,
    @required this.situationModel,
    @required this.isDelivered,
    @required this.withStudent,
    @required this.withTask,
    @required this.isAddOrUpdate,
    @required this.onSituationSelect,
    @required this.onAdd,
    @required this.onUpdate,
  }) : super(equals: [
          id,
          name,
          description,
          start,
          end,
          attempt,
          time,
          error,
          scoreQuestion,
          situationModel,
          isDelivered,
          withStudent,
          withTask,
          isAddOrUpdate,
        ]);
}

class Factory extends VmFactory<AppState, QuestionEdit> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
      isAddOrUpdate: state.questionState.questionCurrent.id == null,
      id: state.questionState.questionCurrent.id,
      name: state.questionState.questionCurrent.name,
      description: state.questionState.questionCurrent.description,
      start: state.questionState.questionCurrent.start,
      end: state.questionState.questionCurrent.end,
      attempt: state.questionState.questionCurrent.attempt,
      time: state.questionState.questionCurrent.time,
      error: state.questionState.questionCurrent.error,
      scoreQuestion: state.questionState.questionCurrent.scoreQuestion,
      situationModel: state.questionState.questionCurrent.situationModel,
      withStudent: _withStudentWithoutTask(),
      withTask: _withTask(),
      isDelivered: state.questionState.questionCurrent.isDelivered,
      onAdd: (
        String name,
        String description,
        dynamic start,
        dynamic end,
        int attempt,
        int time,
        int error,
        int scoreQuestion,
      ) {
        dispatch(AddDocQuestionCurrentAsyncQuestionAction(
          name: name,
          description: description,
          start: start,
          end: end,
          attempt: attempt,
          time: time,
          error: error,
          scoreQuestion: scoreQuestion,
        ));
        dispatch(NavigateAction.pop());
      },
      onUpdate: (
        String name,
        String description,
        dynamic start,
        dynamic end,
        int attempt,
        int time,
        int error,
        int scoreQuestion,
        bool isDelivered,
        bool isDelete,
        bool resetTask,
      ) {
        dispatch(UpdateDocQuestionCurrentAsyncQuestionAction(
          name: name,
          description: description,
          start: start,
          end: end,
          attempt: attempt,
          time: time,
          error: error,
          scoreQuestion: scoreQuestion,
          isDelivered: isDelivered,
          isDelete: isDelete,
          resetTask: resetTask,
        ));
        dispatch(NavigateAction.pop());
      },
      onSituationSelect: () {
        dispatch(NavigateAction.pushNamed(Routes.knowSelectToQuestion));
      });
  bool _withStudentWithoutTask() {
    bool _return = false;
    if (state.questionState.questionCurrent.studentUserRefMap != null) {
      for (var item
          in state.questionState.questionCurrent.studentUserRefMap.values) {
        if (!item.status) {
          _return = true;
        }
      }
    }
    return _return;
  }

  bool _withTask() {
    bool _return = false;
    if (state.questionState.questionCurrent.studentUserRefMap != null) {
      for (var item
          in state.questionState.questionCurrent.studentUserRefMap.values) {
        if (item.status) {
          _return = true;
        }
      }
    }
    return _return;
  }
}

class QuestionEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (context, viewModel) => QuestionEditUI(
        isAddOrUpdate: viewModel.isAddOrUpdate,
        id: viewModel.id,
        name: viewModel.name,
        description: viewModel.description,
        start: viewModel.start,
        end: viewModel.end,
        attempt: viewModel.attempt,
        time: viewModel.time,
        error: viewModel.error,
        scoreQuestion: viewModel.scoreQuestion,
        situationModel: viewModel.situationModel,
        withStudent: viewModel.withStudent,
        withTask: viewModel.withTask,
        isDelivered: viewModel.isDelivered,
        onSituationSelect: viewModel.onSituationSelect,
        onAdd: viewModel.onAdd,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
