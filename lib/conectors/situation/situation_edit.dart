import 'package:aiprof/actions/situation_action.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/situation/situation_edit_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  String area;
  String name;
  String description;
  String url;
  bool isActive;
  bool isAddOrUpdate;
  Function(String, String, String, String) onAdd;
  Function(String, String, String, String, bool, bool) onUpdate;
  ViewModel();
  ViewModel.build({
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
  @override
  ViewModel fromStore() => ViewModel.build(
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
      model: ViewModel(),
      builder: (context, viewModel) => SituationEditDS(
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
