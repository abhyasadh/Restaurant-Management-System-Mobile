import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/history/data/repository/history_remote_repo_impl.dart';
import 'package:restaurant_app/features/history/domain/entity/history_entity.dart';

import '../../../../core/failure/failure.dart';

final historyRepositoryProvider = Provider.autoDispose<IHistoryRepository>(
      (ref) {
    return ref.read(historyRemoteRepositoryProvider);
  },
);

abstract class IHistoryRepository {
  Future<Either<Failure, List<HistoryEntity>>> getHistory(int page);
}
