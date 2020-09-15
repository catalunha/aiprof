import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:meta/meta.dart';

@immutable
class UserState {
  final List<UserModel> userList;
  final UserOrder userOrder;

  UserState({
    this.userList,
    this.userOrder,
  });

  factory UserState.initialState() {
    return UserState(
      userList: [],
      userOrder: UserOrder.name,
    );
  }
  UserState copyWith({
    List<UserModel> userList,
    UserOrder userOrder,
  }) {
    return UserState(
      userList: userList ?? this.userList,
      userOrder: userOrder ?? this.userOrder,
    );
  }

  @override
  int get hashCode => userOrder.hashCode ^ userList.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserState &&
          userOrder == other.userOrder &&
          userList == other.userList &&
          runtimeType == other.runtimeType;
}
