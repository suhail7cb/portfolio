import 'package:portfolio/features/portfolio/domain/entities/portfolio_config.dart';

abstract class PortfolioState {
  const PortfolioState();
}

class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

class PortfolioLoaded extends PortfolioState {
  final PortfolioConfig config;
  final String activeFilter; // For filtering projects (e.g. 'All', 'Enterprise', etc.)
  final String activeSectionKey; // For navbar highlighting

  const PortfolioLoaded({
    required this.config,
    this.activeFilter = 'All',
    this.activeSectionKey = 'about',
  });

  PortfolioLoaded copyWith({
    PortfolioConfig? config,
    String? activeFilter,
    String? activeSectionKey,
  }) {
    return PortfolioLoaded(
      config: config ?? this.config,
      activeFilter: activeFilter ?? this.activeFilter,
      activeSectionKey: activeSectionKey ?? this.activeSectionKey,
    );
  }
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);
}
