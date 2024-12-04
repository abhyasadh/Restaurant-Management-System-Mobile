import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:restaurant_app/features/history/domain/usecases/history_usecase.dart';
import 'package:restaurant_app/features/history/presentation/viewmodel/history_view_model.dart';
import 'package:restaurant_app/features/history/domain/entity/history_entity.dart';

import 'history_test.mocks.dart';

@GenerateMocks([HistoryUseCase])
void main() {
  group('HistoryViewModel Tests', () {
    late HistoryViewModel historyViewModel;
    late MockHistoryUseCase mockHistoryUseCase;

    setUp(() {
      mockHistoryUseCase = MockHistoryUseCase();
      historyViewModel = HistoryViewModel(mockHistoryUseCase);
    });

    test('getHistory - Success', () async {
      when(mockHistoryUseCase.getHistory(1))
          .thenAnswer((_) async => const Right([]));

      await mockHistoryUseCase.getHistory(1);

      expect(historyViewModel.state.isLoading, false);
      expect(historyViewModel.state.history, []);
    });

    test('getHistory - Failure', () async {
      when(mockHistoryUseCase.getHistory(1))
          .thenAnswer((_) async => Left(Failure(error: 'Failed to retrieve History')));

      await historyViewModel.getHistory();

      expect(historyViewModel.state.isLoading, false);
      expect(historyViewModel.state.history.isEmpty, true);
    });

    test('resetState', () async {
      final history = <HistoryEntity>[];
      when(mockHistoryUseCase.getHistory(1))
          .thenAnswer((_) async => Right(history));

      historyViewModel.resetState();

      expect(historyViewModel.state.isLoading, true);
      expect(historyViewModel.state.history, history);
      verify(mockHistoryUseCase.getHistory(1)).called(1);
    });
  });
}