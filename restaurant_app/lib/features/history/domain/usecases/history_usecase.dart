import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/history/domain/entity/history_entity.dart';
import 'package:restaurant_app/features/history/domain/repository/history_repository.dart';

import '../../../../core/failure/failure.dart';

final historyUseCaseProvider = Provider<HistoryUseCase>(
      (ref) => HistoryUseCase(historyRepository: ref.read(historyRepositoryProvider)),
);

class HistoryUseCase {
  final IHistoryRepository historyRepository;

  HistoryUseCase({required this.historyRepository});

  Future<Either<Failure, List<HistoryEntity>>> getHistory(int page) async {
    return await historyRepository.getHistory(page);
  }
}