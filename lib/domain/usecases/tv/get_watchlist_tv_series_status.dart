import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetWatchListTVSeriesStatus {
  final TVSeriesRepository repository;

  GetWatchListTVSeriesStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}