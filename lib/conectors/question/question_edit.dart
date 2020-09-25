import 'package:aiprof/actions/question_action.dart';
import 'package:aiprof/models/simulation_model.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/routes.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/question/question_edit_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  String name;
  String description;
  dynamic start;
  dynamic end;
  int attempt;
  int time;
  int error;
  int scoreQuestion;
  SituationModel situationRef;
  SimulationModel simulationRef;
  bool isAddOrUpdate;
  Function() onSituationSelect;
  Function(String, String, dynamic, dynamic, int, int, int, int) onAdd;
  Function(String, String, dynamic, dynamic, int, int, int, int, bool) onUpdate;
  ViewModel();
  ViewModel.build({
    @required this.name,
    @required this.description,
    @required this.start,
    @required this.end,
    @required this.attempt,
    @required this.time,
    @required this.error,
    @required this.scoreQuestion,
    @required this.situationRef,
    @required this.simulationRef,
    @required this.isAddOrUpdate,
    @required this.onSituationSelect,
    @required this.onAdd,
    @required this.onUpdate,
  }) : super(equals: [
          name,
          description,
          start,
          end,
          attempt,
          time,
          error,
          scoreQuestion,
          situationRef,
          simulationRef,
          isAddOrUpdate,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
      isAddOrUpdate: state.questionState.questionCurrent.id == null,
      name: state.questionState.questionCurrent.name,
      description: state.questionState.questionCurrent.description,
      start: state.questionState.questionCurrent.start,
      end: state.questionState.questionCurrent.end,
      attempt: state.questionState.questionCurrent.attempt,
      time: state.questionState.questionCurrent.time,
      error: state.questionState.questionCurrent.error,
      scoreQuestion: state.questionState.questionCurrent.scoreQuestion,
      situationRef: state.questionState.questionCurrent.situationRef,
      simulationRef: state.questionState.questionCurrent.simulationRef,
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
        bool isDelete,
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
          isDelete: isDelete,
        ));
        dispatch(NavigateAction.pop());
      },
      onSituationSelect: () {
        dispatch(NavigateAction.pushNamed(Routes.knowSelectToQuestion));
      });
}

class QuestionEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      builder: (context, viewModel) => QuestionEditDS(
        isAddOrUpdate: viewModel.isAddOrUpdate,
        name: viewModel.name,
        description: viewModel.description,
        start: viewModel.start,
        end: viewModel.end,
        attempt: viewModel.attempt,
        time: viewModel.time,
        error: viewModel.error,
        scoreQuestion: viewModel.scoreQuestion,
        situationRef: viewModel.situationRef,
        simulationRef: viewModel.simulationRef,
        onSituationSelect: viewModel.onSituationSelect,
        onAdd: viewModel.onAdd,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
