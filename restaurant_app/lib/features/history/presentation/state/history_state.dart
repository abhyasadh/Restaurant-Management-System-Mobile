import 'package:restaurant_app/features/history/domain/entity/history_entity.dart';

class HistoryState {
  final List<HistoryEntity> history;
  final bool hasReachedMax;
  final int page;
  final bool isLoading;

  HistoryState({
    required this.history,
    required this.hasReachedMax,
    required this.page,
    required this.isLoading,
  });

  factory HistoryState.initial() {
    return HistoryState(
      history: [],
      hasReachedMax: false,
      page: 0,
      isLoading: false,
    );
  }

  HistoryState copyWith({
    List<HistoryEntity>? history,
    bool? hasReachedMax,
    int? page,
    bool? isLoading,
  }) {
    return HistoryState(
      history: history ?? this.history,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
