import 'package:meta/meta.dart';
import 'package:aiprof/models/exame_model.dart';
import 'package:aiprof/states/types_states.dart';

@immutable
class ExameState {
  final ExameFilter exameFilter;
  final List<ExameModel> exameList;
  final ExameModel exameCurrent;
  ExameState({
    this.exameFilter,
    this.exameList,
    this.exameCurrent,
  });
  factory ExameState.initialState() => ExameState(
        exameFilter: ExameFilter.isactive,
        exameList: <ExameModel>[],
        exameCurrent: null,
      );
  ExameState copyWith({
    ExameFilter exameFilter,
    List<ExameModel> exameList,
    ExameModel exameCurrent,
  }) =>
      ExameState(
        exameFilter: exameFilter ?? this.exameFilter,
        exameList: exameList ?? this.exameList,
        exameCurrent: exameCurrent ?? this.exameCurrent,
      );
  @override
  int get hashCode =>
      exameFilter.hashCode ^ exameList.hashCode ^ exameCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExameState &&
          exameFilter == other.exameFilter &&
          exameList == other.exameList &&
          exameCurrent == other.exameCurrent &&
          runtimeType == other.runtimeType;
}
