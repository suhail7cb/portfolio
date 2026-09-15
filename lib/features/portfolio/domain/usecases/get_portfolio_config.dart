import '../entities/portfolio_config.dart';
import '../repositories/portfolio_repository.dart';

/// Use case to retrieve the active portfolio configuration.
class GetPortfolioConfig {
  final PortfolioRepository repository;

  GetPortfolioConfig(this.repository);

  Future<PortfolioConfig> call() async {
    return await repository.getPortfolioConfig();
  }
}
