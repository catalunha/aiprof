import 'package:aiprof/situation/simulation/simulation_enum.dart';
import 'package:aiprof/situation/simulation/simulation_model.dart';
import 'package:meta/meta.dart';

@immutable
class SimulationState {
  final SimulationFilter simulationFilter;
  final List<SimulationModel> simulationList;
  final SimulationModel simulationCurrent;
  final Input inputCurrent;
  final Output outputCurrent;
  SimulationState({
    this.simulationFilter,
    this.simulationList,
    this.simulationCurrent,
    this.inputCurrent,
    this.outputCurrent,
  });
  factory SimulationState.initialState() => SimulationState(
        simulationFilter: SimulationFilter.isActive,
        simulationList: <SimulationModel>[],
        simulationCurrent: null,
        inputCurrent: null,
        outputCurrent: null,
      );
  SimulationState copyWith({
    SimulationFilter simulationFilter,
    List<SimulationModel> simulationList,
    SimulationModel simulationCurrent,
    Input inputCurrent,
    Output outputCurrent,
  }) =>
      SimulationState(
        simulationFilter: simulationFilter ?? this.simulationFilter,
        simulationList: simulationList ?? this.simulationList,
        simulationCurrent: simulationCurrent ?? this.simulationCurrent,
        inputCurrent: inputCurrent ?? this.inputCurrent,
        outputCurrent: outputCurrent ?? this.outputCurrent,
      );
  @override
  int get hashCode =>
      inputCurrent.hashCode ^
      outputCurrent.hashCode ^
      simulationFilter.hashCode ^
      simulationList.hashCode ^
      simulationCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimulationState &&
          inputCurrent == other.inputCurrent &&
          outputCurrent == other.outputCurrent &&
          simulationFilter == other.simulationFilter &&
          simulationList == other.simulationList &&
          simulationCurrent == other.simulationCurrent &&
          runtimeType == other.runtimeType;
}
