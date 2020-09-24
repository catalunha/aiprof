import 'package:aiprof/actions/exame_action.dart';
import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/exame/exame_edit_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  String name;
  String description;
  dynamic start;
  dynamic end;
  int scoreExame;
  int attempt;
  int time;
  int error;
  int scoreQuestion;
  bool isDelivery;
  bool isAddOrUpdate;
  Function(String, String, dynamic, dynamic, int, int, int, int, int) onAdd;
  Function(
          String, String, dynamic, dynamic, int, int, int, int, int, bool, bool)
      onUpdate;
  ViewModel();
  ViewModel.build({
    @required this.name,
    @required this.description,
    @required this.start,
    @required this.end,
    @required this.scoreExame,
    @required this.attempt,
    @required this.time,
    @required this.error,
    @required this.scoreQuestion,
    @required this.isDelivery,
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
          isDelivery,
          isAddOrUpdate,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
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
        isDelivery: state.exameState.exameCurrent.isDelivery,
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
          bool isDelivery,
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
            isDelivery: isDelivery,
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
      model: ViewModel(),
      builder: (context, viewModel) => ExameEditDS(
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
        isDelivery: viewModel.isDelivery,
        onAdd: viewModel.onAdd,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
