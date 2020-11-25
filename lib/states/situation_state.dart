import 'package:meta/meta.dart';
import 'package:aiprof/models/situation_model.dart';
import 'package:aiprof/states/types_states.dart';

@immutable
class SituationState {
  final SituationFilter situationFilter;
  final List<SituationModel> situationListFilter;
  final List<SituationModel> situationList;
  final SituationModel situationCurrent;
  SituationState({
    this.situationFilter,
    this.situationListFilter,
    this.situationList,
    this.situationCurrent,
  });
  factory SituationState.initialState() => SituationState(
        situationFilter: SituationFilter.isActive,
        situationListFilter: <SituationModel>[],
        situationList: <SituationModel>[],
        situationCurrent: null,
      );
  SituationState copyWith({
    SituationFilter situationFilter,
    List<SituationModel> situationList,
    List<SituationModel> situationListFilter,
    SituationModel situationCurrent,
  }) =>
      SituationState(
        situationFilter: situationFilter ?? this.situationFilter,
        situationListFilter: situationListFilter ?? this.situationListFilter,
        situationList: situationList ?? this.situationList,
        situationCurrent: situationCurrent ?? this.situationCurrent,
      );
  @override
  int get hashCode =>
      situationFilter.hashCode ^
      situationListFilter.hashCode ^
      situationList.hashCode ^
      situationCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SituationState &&
          situationFilter == other.situationFilter &&
          situationListFilter == other.situationListFilter &&
          situationList == other.situationList &&
          situationCurrent == other.situationCurrent &&
          runtimeType == other.runtimeType;
}
