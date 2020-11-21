import 'package:meta/meta.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/states/types_states.dart';

@immutable
class SituationState {
  final SituationFilter situationFilter;
  final List<SituationModel> situationList;
  final SituationModel situationCurrent;
  SituationState({
    this.situationFilter,
    this.situationList,
    this.situationCurrent,
  });
  factory SituationState.initialState() => SituationState(
        situationFilter: SituationFilter.isActive,
        situationList: <SituationModel>[],
        situationCurrent: null,
      );
  SituationState copyWith({
    SituationFilter situationFilter,
    List<SituationModel> situationList,
    SituationModel situationCurrent,
  }) =>
      SituationState(
        situationFilter: situationFilter ?? this.situationFilter,
        situationList: situationList ?? this.situationList,
        situationCurrent: situationCurrent ?? this.situationCurrent,
      );
  @override
  int get hashCode =>
      situationFilter.hashCode ^
      situationList.hashCode ^
      situationCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SituationState &&
          situationFilter == other.situationFilter &&
          situationList == other.situationList &&
          situationCurrent == other.situationCurrent &&
          runtimeType == other.runtimeType;
}
