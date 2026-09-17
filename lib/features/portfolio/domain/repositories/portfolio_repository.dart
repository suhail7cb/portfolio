import '../entities/portfolio_config.dart';

/// Abstract repository contract for fetching and persisting portfolio configuration.
abstract class PortfolioRepository {
  Future<PortfolioConfig> getPortfolioConfig();
  Future<PortfolioConfig> getLocalConfig();
  Future<PortfolioConfig?> getRemoteConfig();
  Future<void> savePortfolioConfig(PortfolioConfig config);
}
