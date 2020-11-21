import 'package:aiprof/models/user_model.dart';
import 'package:aiprof/states/types_states.dart';
import 'package:meta/meta.dart';

@immutable
class StudentState {
  final StudentFilter studentFilter;
  final List<UserModel> studentList;
  final UserModel studentCurrent;
  StudentState({
    this.studentFilter,
    this.studentList,
    this.studentCurrent,
  });
  factory StudentState.initialState() => StudentState(
        studentFilter: StudentFilter.isActive,
        studentList: <UserModel>[],
        studentCurrent: null,
      );
  StudentState copyWith({
    StudentFilter studentFilter,
    List<UserModel> studentList,
    UserModel studentCurrent,
  }) =>
      StudentState(
        studentFilter: studentFilter ?? this.studentFilter,
        studentList: studentList ?? this.studentList,
        studentCurrent: studentCurrent ?? this.studentCurrent,
      );
  @override
  int get hashCode =>
      studentFilter.hashCode ^ studentList.hashCode ^ studentCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentState &&
          studentFilter == other.studentFilter &&
          studentList == other.studentList &&
          studentCurrent == other.studentCurrent &&
          runtimeType == other.runtimeType;
}
