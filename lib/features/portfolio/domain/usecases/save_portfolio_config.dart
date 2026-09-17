import '../entities/portfolio_config.dart';
import '../repositories/portfolio_repository.dart';

/// Use case to persist updated portfolio configuration to remote storage.
class SavePortfolioConfig {
  final PortfolioRepository repository;

  SavePortfolioConfig(this.repository);

  Future<void> call(PortfolioConfig config) async {
    await repository.savePortfolioConfig(config);
  }
}
