import '../features/portfolio/data/datasources/portfolio_local_data_source.dart';
import '../features/portfolio/data/datasources/portfolio_remote_data_source.dart';
import '../features/portfolio/data/repositories/portfolio_repository_impl.dart';
import '../features/portfolio/domain/repositories/portfolio_repository.dart';
import '../features/portfolio/domain/usecases/get_portfolio_config.dart';
import '../features/portfolio/domain/usecases/save_portfolio_config.dart';
import '../features/portfolio/presentation/bloc/portfolio_cubit.dart';
import '../core/theme/theme_cubit.dart';

/// Composition root and service locator for clean dependency injection.
class ServiceLocator {
  ServiceLocator._();

  static PortfolioLocalDataSource? _portfolioLocalDataSource;
  static PortfolioRemoteDataSource? _portfolioRemoteDataSource;
  static PortfolioRepository? _portfolioRepository;
  static GetPortfolioConfig? _getPortfolioConfig;
  static SavePortfolioConfig? _savePortfolioConfig;
  static ThemeCubit? _themeCubit;

  static PortfolioLocalDataSource get portfolioLocalDataSource =>
      _portfolioLocalDataSource ??= const PortfolioLocalDataSourceImpl();

  static PortfolioRemoteDataSource get portfolioRemoteDataSource =>
      _portfolioRemoteDataSource ??= PortfolioRemoteDataSource();

  static PortfolioRepository get portfolioRepository =>
      _portfolioRepository ??= PortfolioRepositoryImpl(
        localDataSource: portfolioLocalDataSource,
        remoteDataSource: portfolioRemoteDataSource,
      );

  static GetPortfolioConfig get getPortfolioConfig =>
      _getPortfolioConfig ??= GetPortfolioConfig(portfolioRepository);

  static SavePortfolioConfig get savePortfolioConfig =>
      _savePortfolioConfig ??= SavePortfolioConfig(portfolioRepository);

  static ThemeCubit get themeCubit => _themeCubit ??= ThemeCubit();

  static void init({
    PortfolioLocalDataSource? localDataSource,
    PortfolioRemoteDataSource? remoteDataSource,
    bool force = false,
  }) {
    if (force) {
      _portfolioLocalDataSource = null;
      _portfolioRemoteDataSource = null;
      _portfolioRepository = null;
      _getPortfolioConfig = null;
      _savePortfolioConfig = null;
      _themeCubit = null;
    }
    // Eagerly initialize
    _portfolioLocalDataSource = localDataSource ?? const PortfolioLocalDataSourceImpl();
    _portfolioRemoteDataSource = remoteDataSource ?? PortfolioRemoteDataSource();
    _portfolioRepository = PortfolioRepositoryImpl(
      localDataSource: _portfolioLocalDataSource!,
      remoteDataSource: _portfolioRemoteDataSource!,
    );
    _getPortfolioConfig = GetPortfolioConfig(_portfolioRepository!);
    _savePortfolioConfig = SavePortfolioConfig(_portfolioRepository!);
    _themeCubit ??= ThemeCubit();
  }

  static PortfolioCubit createPortfolioCubit() {
    return PortfolioCubit(
      getPortfolioConfig: getPortfolioConfig,
      savePortfolioConfig: savePortfolioConfig,
    );
  }
}
