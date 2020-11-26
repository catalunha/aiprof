import 'package:aiprof/know/know_enum.dart';
import 'package:aiprof/know/know_model.dart';
import 'package:meta/meta.dart';

@immutable
class KnowState {
  final KnowFilter knowFilter;
  final List<KnowModel> knowList;
  final KnowModel knowCurrent;
  final Folder folderCurrent;

  KnowState({
    this.knowFilter,
    this.knowList,
    this.knowCurrent,
    this.folderCurrent,
  });
  factory KnowState.initialState() => KnowState(
        knowFilter: KnowFilter.isActive,
        knowList: <KnowModel>[],
        knowCurrent: null,
        folderCurrent: null,
      );
  KnowState copyWith({
    KnowFilter knowFilter,
    List<KnowModel> knowList,
    KnowModel knowCurrent,
    Folder folderCurrent,
  }) =>
      KnowState(
        knowFilter: knowFilter ?? this.knowFilter,
        knowList: knowList ?? this.knowList,
        knowCurrent: knowCurrent ?? this.knowCurrent,
        folderCurrent: folderCurrent ?? this.folderCurrent,
      );
  @override
  int get hashCode =>
      folderCurrent.hashCode ^
      knowFilter.hashCode ^
      knowList.hashCode ^
      knowCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KnowState &&
          folderCurrent == other.folderCurrent &&
          knowFilter == other.knowFilter &&
          knowList == other.knowList &&
          knowCurrent == other.knowCurrent &&
          runtimeType == other.runtimeType;
}
