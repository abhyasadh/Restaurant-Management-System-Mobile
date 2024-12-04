import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:restaurant_app/features/history/data/data_source/history_remote_data_source.dart';
import 'package:restaurant_app/features/history/domain/entity/history_entity.dart';

import '../../domain/repository/history_repository.dart';

final historyRemoteRepositoryProvider = Provider.autoDispose<IHistoryRepository>(
      (ref) => HistoryRemoteRepository(
    historyDataSource: ref.read(historyDataSourceProvider),
  ),
);

class HistoryRemoteRepository implements IHistoryRepository {
  final HistoryDataSource historyDataSource;

  const HistoryRemoteRepository({required this.historyDataSource});

  @override
  Future<Either<Failure, List<HistoryEntity>>> getHistory(int page) {
    return historyDataSource.getPosts(page);
  }
}
