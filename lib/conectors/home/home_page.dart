import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/app_state.dart';
import 'package:aiprof/uis/home/home_page_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final UserModel userModel;

  ViewModel({
    @required this.userModel,
  }) : super(equals: [
          userModel,
        ]);
}

class Factory extends VmFactory<AppState, HomePage> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        userModel: state.loggedState.userModelLogged,
      );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      builder: (BuildContext context, ViewModel viewModel) => HomePageDS(
        userModel: viewModel.userModel,
      ),
    );
  }
}
