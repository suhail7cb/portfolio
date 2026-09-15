import 'package:portfolio/features/portfolio/domain/entities/portfolio_config.dart';
import 'portfolio_config_loader.dart';

/// Data source interface for portfolio configuration.
/// Loads the configuration from the external JSON file.
abstract class PortfolioLocalDataSource {
  Future<PortfolioConfig> getPortfolioConfig();
}

class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  final String assetPath;

  const PortfolioLocalDataSourceImpl({
    this.assetPath = 'assets/config/portfolio.json',
  });

  @override
  Future<PortfolioConfig> getPortfolioConfig() async {
    return await PortfolioConfigLoader.loadFromAsset(assetPath);
  }
}
