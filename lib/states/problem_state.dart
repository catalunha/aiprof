import 'package:meta/meta.dart';
import 'package:aiprof/models/problem_model.dart';
import 'package:aiprof/states/types_states.dart';

@immutable
class ProblemState {
  final ProblemFilter problemFilter;
  final List<ProblemModel> problemList;
  final ProblemModel problemCurrent;
  ProblemState({
    this.problemFilter,
    this.problemList,
    this.problemCurrent,
  });
  factory ProblemState.initialState() => ProblemState(
        problemFilter: ProblemFilter.isactive,
        problemList: <ProblemModel>[],
        problemCurrent: null,
      );
  ProblemState copyWith({
    ProblemFilter problemFilter,
    List<ProblemModel> problemList,
    ProblemModel problemCurrent,
  }) =>
      ProblemState(
        problemFilter: problemFilter ?? this.problemFilter,
        problemList: problemList ?? this.problemList,
        problemCurrent: problemCurrent ?? this.problemCurrent,
      );
  @override
  int get hashCode =>
      problemFilter.hashCode ^ problemList.hashCode ^ problemCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProblemState &&
          problemFilter == other.problemFilter &&
          problemList == other.problemList &&
          problemCurrent == other.problemCurrent &&
          runtimeType == other.runtimeType;
}
