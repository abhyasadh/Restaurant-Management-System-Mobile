import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/history/domain/usecases/history_usecase.dart';

import '../state/history_state.dart';

final historyViewModelProvider =
StateNotifierProvider.autoDispose<HistoryViewModel, HistoryState>((ref) {
  return HistoryViewModel(ref.read(historyUseCaseProvider));
});

class HistoryViewModel extends StateNotifier<HistoryState> {
  final HistoryUseCase _historyUseCase;
  HistoryViewModel(
      this._historyUseCase,
      ) : super(
    HistoryState.initial(),
  ) {
    getHistory();
  }

  Future resetState() async {
    state = HistoryState.initial();
    getHistory();
  }

  Future getHistory() async {
    state = state.copyWith(isLoading: true);
    final currentState = state;
    final page = currentState.page + 1;
    final history = currentState.history;
    final hasReachedMax = currentState.hasReachedMax;
    if (!hasReachedMax) {
      final result = await _historyUseCase.getHistory(page);
      result.fold(
            (failure) =>
        state = state.copyWith(hasReachedMax: true, isLoading: false),
            (data) {
          if (data.isEmpty) {
            state = state.copyWith(hasReachedMax: true, isLoading: false);
          } else {
            state = state.copyWith(
              history: [...history, ...data],
              page: page,
              isLoading: false,
            );
          }
        },
      );
    }
  }
}
