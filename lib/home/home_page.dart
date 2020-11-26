import 'package:aiprof/app_state.dart';
import 'package:aiprof/home/home_page_ui.dart';
import 'package:aiprof/user/user_model.dart';
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
      builder: (BuildContext context, ViewModel viewModel) => HomePageUI(
        userModel: viewModel.userModel,
      ),
    );
  }
}
