import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_config.dart';
import 'package:portfolio/features/portfolio/domain/usecases/get_portfolio_config.dart';
import 'package:portfolio/features/portfolio/domain/usecases/save_portfolio_config.dart';
import 'portfolio_state.dart';

/// Cubit managing portfolio data loading, persistence, project filtering, and active section tracking.
/// Implements instant local loading (sub-10ms) followed by silent background Firestore sync.
class PortfolioCubit extends Cubit<PortfolioState> {
  final GetPortfolioConfig getPortfolioConfig;
  final SavePortfolioConfig? savePortfolioConfig;

  PortfolioCubit({
    required this.getPortfolioConfig,
    this.savePortfolioConfig,
  }) : super(const PortfolioInitial());

  Future<void> loadPortfolio() async {
    // 1. Instant local render: Display complete portfolio immediately (0ms wait)
    try {
      final localConfig = await getPortfolioConfig.getLocal();
      emit(PortfolioLoaded(config: localConfig));
    } catch (_) {
      emit(const PortfolioLoading());
    }

    // 2. Background sync: Check Firestore for published updates without blocking UI
    try {
      final remoteConfig = await getPortfolioConfig.getRemote();
      if (remoteConfig != null) {
        final currentState = state;
        if (currentState is PortfolioLoaded) {
          emit(currentState.copyWith(config: remoteConfig));
        } else {
          emit(PortfolioLoaded(config: remoteConfig));
        }
      }
    } catch (e) {
      // If Firestore is offline or timing out, the user already has the instant local config
      if (state is! PortfolioLoaded) {
        try {
          final fallback = await getPortfolioConfig.getLocal();
          emit(PortfolioLoaded(config: fallback));
        } catch (err) {
          emit(PortfolioError(err.toString()));
        }
      }
    }
  }

  Future<void> updatePortfolio(PortfolioConfig newConfig) async {
    final currentState = state;
    if (currentState is PortfolioLoaded) {
      emit(currentState.copyWith(config: newConfig));
    } else {
      emit(PortfolioLoaded(config: newConfig));
    }

    if (savePortfolioConfig != null) {
      await savePortfolioConfig!(newConfig);
    }
  }

  void setProjectFilter(String filter) {
    if (state is PortfolioLoaded) {
      final loadedState = state as PortfolioLoaded;
      emit(loadedState.copyWith(activeFilter: filter));
    }
  }

  void setActiveSection(String sectionKey) {
    if (state is PortfolioLoaded) {
      final loadedState = state as PortfolioLoaded;
      if (loadedState.activeSectionKey != sectionKey) {
        emit(loadedState.copyWith(activeSectionKey: sectionKey));
      }
    }
  }
}
