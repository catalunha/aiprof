import 'package:meta/meta.dart';
import 'package:aiprof/models/question_model.dart';
import 'package:aiprof/states/types_states.dart';

@immutable
class QuestionState {
  final QuestionFilter questionFilter;
  final List<QuestionModel> questionList;
  final QuestionModel questionCurrent;
  QuestionState({
    this.questionFilter,
    this.questionList,
    this.questionCurrent,
  });
  factory QuestionState.initialState() => QuestionState(
        questionFilter: QuestionFilter.isActive,
        questionList: <QuestionModel>[],
        questionCurrent: null,
      );
  QuestionState copyWith({
    QuestionFilter questionFilter,
    List<QuestionModel> questionList,
    QuestionModel questionCurrent,
  }) =>
      QuestionState(
        questionFilter: questionFilter ?? this.questionFilter,
        questionList: questionList ?? this.questionList,
        questionCurrent: questionCurrent ?? this.questionCurrent,
      );
  @override
  int get hashCode =>
      questionFilter.hashCode ^
      questionList.hashCode ^
      questionCurrent.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionState &&
          questionFilter == other.questionFilter &&
          questionList == other.questionList &&
          questionCurrent == other.questionCurrent &&
          runtimeType == other.runtimeType;
}
