import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/features/portfolio/domain/usecases/get_portfolio_config.dart';
import 'portfolio_state.dart';

/// Cubit managing portfolio data loading, project filtering, and active section tracking.
class PortfolioCubit extends Cubit<PortfolioState> {
  final GetPortfolioConfig getPortfolioConfig;

  PortfolioCubit({required this.getPortfolioConfig}) : super(const PortfolioInitial());

  Future<void> loadPortfolio() async {
    emit(const PortfolioLoading());
    try {
      final config = await getPortfolioConfig();
      emit(PortfolioLoaded(config: config));
    } catch (e) {
      emit(PortfolioError(e.toString()));
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
