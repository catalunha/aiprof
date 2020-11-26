import 'package:aiprof/app_state.dart';
import 'package:aiprof/situation/situation_action.dart';
import 'package:aiprof/situation/situation_edit_ui.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final String area;
  final String name;
  final String description;
  final String url;
  final bool isActive;
  final bool isAddOrUpdate;
  final Function(String, String, String, String) onAdd;
  final Function(String, String, String, String, bool, bool) onUpdate;
  ViewModel({
    @required this.area,
    @required this.name,
    @required this.description,
    @required this.url,
    @required this.isActive,
    @required this.isAddOrUpdate,
    @required this.onAdd,
    @required this.onUpdate,
  }) : super(equals: [
          area,
          name,
          description,
          url,
          isActive,
          isAddOrUpdate,
        ]);
}

class Factory extends VmFactory<AppState, SituationEdit> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        isAddOrUpdate: state.situationState.situationCurrent.id == null,
        area: state.situationState.situationCurrent.area,
        name: state.situationState.situationCurrent.name,
        description: state.situationState.situationCurrent.description,
        url: state.situationState.situationCurrent.url,
        isActive: state.situationState.situationCurrent?.isActive ?? false,
        onAdd: (
          String area,
          String name,
          String description,
          String url,
        ) {
          dispatch(AddDocSituationCurrentAsyncSituationAction(
            area: area,
            name: name,
            description: description,
            url: url,
          ));
          dispatch(NavigateAction.pop());
        },
        onUpdate: (
          String area,
          String name,
          String description,
          String url,
          bool isActive,
          bool isDelete,
        ) {
          dispatch(UpdateDocSituationCurrentAsyncSituationAction(
            area: area,
            name: name,
            description: description,
            url: url,
            isActive: isActive,
            isDelete: isDelete,
          ));
          dispatch(NavigateAction.pop());
        },
      );
}

class SituationEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (context, viewModel) => SituationEditUI(
        isAddOrUpdate: viewModel.isAddOrUpdate,
        area: viewModel.area,
        name: viewModel.name,
        description: viewModel.description,
        url: viewModel.url,
        isActive: viewModel.isActive,
        onAdd: viewModel.onAdd,
        onUpdate: viewModel.onUpdate,
      ),
    );
  }
}
