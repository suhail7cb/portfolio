import '../entities/portfolio_config.dart';

/// Abstract repository contract for fetching portfolio configuration.
abstract class PortfolioRepository {
  Future<PortfolioConfig> getPortfolioConfig();
}
