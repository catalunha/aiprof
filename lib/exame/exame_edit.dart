import 'package:aiprof/app_state.dart';
import 'package:aiprof/exame/exame_action.dart';
import 'package:aiprof/exame/exame_edit_ui.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final String name;
  final String description;
  final dynamic start;
  final dynamic end;
  final int scoreExame;
  final int attempt;
  final int time;
  final int error;
  final int scoreQuestion;
  final bool isAddOrUpdate;
  final Function(String, String, dynamic, dynamic, int, int, int, int, int)
      onAdd;
  final Function(
      String, String, dynamic, dynamic, int, int, int, int, int, bool) onUpdate;
  ViewModel({
    @required this.name,
    @required this.description,
    @required this.start,
    @required this.end,
    @required this.scoreExame,
    @required this.attempt,
    @required this.time,
    @required this.error,
    @required this.scoreQuestion,
    @required this.isAddOrUpdate,
    @required this.onAdd,
    @required this.onUpdate,
  }) : super(equals: [
          name,
          description,
          start,
          end,
          scoreExame,
          attempt,
          time,
          error,
          scoreQuestion,
          isAddOrUpdate,
        ]);
}

class Factory extends VmFactory<AppState, ExameEdit> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        isAddOrUpdate: state.exameState.exameCurrent.id == null,
        name: state.exameState.exameCurrent.name,
        description: state.exameState.exameCurrent.description,
        start: state.exameState.exameCurrent.start,
        end: state.exameState.exameCurrent.end,
        scoreExame: state.exameState.exameCurrent.scoreExame,
        attempt: state.exameState.exameCurrent.attempt,
        time: state.exameState.exameCurrent.time,
        error: state.exameState.exameCurrent.error,
        scoreQuestion: state.exameState.exameCurrent.scoreQuestion,
        onAdd: (
          String name,
          String description,
          dynamic start,
          dynamic end,
          int scoreExame,
          int attempt,
          int time,
          int error,
          int scoreQuestion,
        ) {
          dispatch(AddDocExameCurrentAsyncExameAction(
            name: name,
            description: description,
            start: start,
            end: end,
            scoreExame: scoreExame,
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
          int scoreExame,
          int attempt,
          int time,
          int error,
          int scoreQuestion,
          bool isDelete,
        ) {
          dispatch(UpdateDocExameCurrentAsyncExameAction(
            name: name,
            description: description,
            start: start,
            end: end,
            scoreExame: scoreExame,
            attempt: attempt,
            time: time,
            error: error,
            scoreQuestion: scoreQuestion,
            isDelete: isDelete,
          ));
          dispatch(NavigateAction.pop());
        },
      );
}

class ExameEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (context, viewModel) => ExameEditUI(
        isAddOrUpdate: viewModel.isAddOrUpdate,
        name: viewModel.name,
        description: viewModel.description,
        start: viewModel.start,
        end: viewModel.end,
        scoreExame: viewModel.scoreExame,
        attempt: viewModel.attempt,
        time: viewModel.time,
        error: viewModel.error,
        scoreQuestion: viewModel.scoreQuestion,
        onAdd: viewModel.onAdd,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
