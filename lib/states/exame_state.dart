import 'package:meta/meta.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/states/types_states.dart';

@immutable
class ExameState {
  final ExameFilter exameFilter;
  final List<ExameModel> exameList;
  final ExameModel exameCurrent;
  final String questionIdSelected;
  final String studentIdSelected;
  ExameState({
    this.exameFilter,
    this.exameList,
    this.exameCurrent,
    this.questionIdSelected,
    this.studentIdSelected,
  });
  factory ExameState.initialState() => ExameState(
        exameFilter: ExameFilter.isActive,
        exameList: <ExameModel>[],
        exameCurrent: null,
        questionIdSelected: null,
        studentIdSelected: null,
      );
  ExameState copyWith({
    ExameFilter exameFilter,
    List<ExameModel> exameList,
    ExameModel exameCurrent,
    String questionIdSelected,
    String studentIdSelected,
  }) =>
      ExameState(
        exameFilter: exameFilter ?? this.exameFilter,
        exameList: exameList ?? this.exameList,
        exameCurrent: exameCurrent ?? this.exameCurrent,
        questionIdSelected: questionIdSelected ?? this.questionIdSelected,
        studentIdSelected: studentIdSelected ?? this.studentIdSelected,
      );
  @override
  int get hashCode =>
      questionIdSelected.hashCode ^
      studentIdSelected.hashCode ^
      exameFilter.hashCode ^
      exameList.hashCode ^
      exameCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExameState &&
          studentIdSelected == other.studentIdSelected &&
          questionIdSelected == other.questionIdSelected &&
          exameFilter == other.exameFilter &&
          exameList == other.exameList &&
          exameCurrent == other.exameCurrent &&
          runtimeType == other.runtimeType;
}
