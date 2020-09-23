import 'package:aiprof/models/simulation_model.dart';
import 'package:meta/meta.dart';
import 'package:aiprof/states/types_states.dart';

@immutable
class SimulationState {
  final SimulationFilter situationFilter;
  final List<SimulationModel> situationList;
  final SimulationModel situationCurrent;
  final Input inputCurrent;
  final Output outputCurrent;
  SimulationState({
    this.situationFilter,
    this.situationList,
    this.situationCurrent,
    this.inputCurrent,
    this.outputCurrent,
  });
  factory SimulationState.initialState() => SimulationState(
        situationFilter: SimulationFilter.isactive,
        situationList: <SimulationModel>[],
        situationCurrent: null,
      );
  SimulationState copyWith({
    SimulationFilter situationFilter,
    List<SimulationModel> situationList,
    SimulationModel situationCurrent,
  }) =>
      SimulationState(
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
      other is SimulationState &&
          situationFilter == other.situationFilter &&
          situationList == other.situationList &&
          situationCurrent == other.situationCurrent &&
          runtimeType == other.runtimeType;
}
