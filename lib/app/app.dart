import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_cubit.dart';
import '../features/portfolio/presentation/bloc/portfolio_cubit.dart';
import '../features/portfolio/presentation/pages/admin/admin_gate_page.dart';
import '../features/portfolio/presentation/pages/portfolio_page.dart';
import 'service_locator.dart';

/// Root application widget configuring Theme, BLoC providers, and routing.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(
          value: ServiceLocator.themeCubit,
        ),
        BlocProvider<PortfolioCubit>(
          create: (_) => ServiceLocator.createPortfolioCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Suhail Shabir | Mobile Application Developer (iOS & Flutter)',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const PortfolioPage(),
              '/admin': (context) => const AdminGatePage(),
            },
          );
        },
      ),
    );
  }
}
