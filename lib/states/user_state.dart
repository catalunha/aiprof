import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:meta/meta.dart';

@immutable
class UserState {
  final List<UserModel> userList;
  final UserModel userCurrent;
  final UserOrder userOrder;

  UserState({
    this.userList,
    this.userCurrent,
    this.userOrder,
  });

  factory UserState.initialState() {
    return UserState(
      userList: [],
      userOrder: UserOrder.name,
      userCurrent: null,
    );
  }
  UserState copyWith({
    List<UserModel> userList,
    UserModel userCurrent,
    UserOrder userOrder,
  }) {
    return UserState(
      userList: userList ?? this.userList,
      userCurrent: userCurrent ?? this.userCurrent,
      userOrder: userOrder ?? this.userOrder,
    );
  }

  @override
  int get hashCode =>
      userCurrent.hashCode ^ userOrder.hashCode ^ userList.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserState &&
          userCurrent == other.userCurrent &&
          userOrder == other.userOrder &&
          userList == other.userList &&
          runtimeType == other.runtimeType;
}
