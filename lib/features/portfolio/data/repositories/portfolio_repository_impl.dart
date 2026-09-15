import 'package:portfolio/features/portfolio/domain/entities/portfolio_config.dart';
import 'package:portfolio/features/portfolio/domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_local_data_source.dart';

/// Concrete implementation of [PortfolioRepository].
class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource localDataSource;

  const PortfolioRepositoryImpl({required this.localDataSource});

  @override
  Future<PortfolioConfig> getPortfolioConfig() async {
    return await localDataSource.getPortfolioConfig();
  }
}
