import 'package:aiprof/states/types_states.dart';
import 'package:meta/meta.dart';
import 'package:aiprof/models/know_model.dart';

@immutable
class KnowState {
  final KnowFilter knowFilter;
  final List<KnowModel> knowList;
  final KnowModel knowCurrent;

  KnowState({
    this.knowFilter,
    this.knowList,
    this.knowCurrent,
  });
  factory KnowState.initialState() => KnowState(
        knowFilter: KnowFilter.isactive,
        knowList: <KnowModel>[],
        knowCurrent: null,
      );
  KnowState copyWith({
    KnowFilter knowFilter,
    List<KnowModel> knowList,
    KnowModel knowCurrent,
  }) =>
      KnowState(
        knowFilter: knowFilter ?? this.knowFilter,
        knowList: knowList ?? this.knowList,
        knowCurrent: knowCurrent ?? this.knowCurrent,
      );
  @override
  int get hashCode =>
      knowFilter.hashCode ^ knowList.hashCode ^ knowCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KnowState &&
          knowFilter == other.knowFilter &&
          knowList == other.knowList &&
          knowCurrent == other.knowCurrent &&
          runtimeType == other.runtimeType;
}
