import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_config.dart';
import 'package:portfolio/features/portfolio/domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_local_data_source.dart';
import '../datasources/portfolio_remote_data_source.dart';

/// Concrete implementation of [PortfolioRepository] managing remote Firestore
/// synchronization with instant local asset fallback and background seeding.
class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource localDataSource;
  final PortfolioRemoteDataSource? remoteDataSource;

  const PortfolioRepositoryImpl({
    required this.localDataSource,
    this.remoteDataSource,
  });

  @override
  Future<PortfolioConfig> getLocalConfig() async {
    return await localDataSource.getPortfolioConfig();
  }

  @override
  Future<PortfolioConfig?> getRemoteConfig() async {
    if (remoteDataSource == null) return null;
    try {
      final remoteConfig = await remoteDataSource!.getPortfolioConfig();
      if (remoteConfig != null) {
        return remoteConfig;
      }
      // If remote document doesn't exist yet, seed in background only if authenticated as owner
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email?.toLowerCase() == 'suhail7.dev@gmail.com') {
        final localConfig = await localDataSource.getPortfolioConfig();
        unawaited(remoteDataSource!.seedInitialData(localConfig));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<PortfolioConfig> getPortfolioConfig() async {
    final localConfig = await getLocalConfig();
    try {
      final remoteConfig = await getRemoteConfig();
      return remoteConfig ?? localConfig;
    } catch (_) {
      return localConfig;
    }
  }

  @override
  Future<void> savePortfolioConfig(PortfolioConfig config) async {
    if (remoteDataSource != null) {
      await remoteDataSource!.savePortfolioConfig(config);
    }
  }
}
