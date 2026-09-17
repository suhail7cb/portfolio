import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/app/service_locator.dart';
import 'package:portfolio/core/theme/theme_cubit.dart';
import 'package:portfolio/features/portfolio/data/datasources/portfolio_config_loader.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio_config.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/features/portfolio/presentation/bloc/portfolio_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late String portfolioJsonContent;

  setUpAll(() {
    final file = File('assets/config/portfolio.json');
    portfolioJsonContent = file.readAsStringSync();
  });

  setUp(() {
    ServiceLocator.init();
  });

  group('PortfolioConfigLoader & JSON Tests', () {
    test('loads and validates authentic portfolio.json successfully', () {
      final PortfolioConfig config =
          PortfolioConfigLoader.loadFromString(portfolioJsonContent);

      expect(config.personalInfo.name, 'Suhail Shabir');
      expect(config.personalInfo.title,
          'Mobile Application Developer (iOS & Flutter)');
      expect(config.personalInfo.email, 'suhail7.dev@gmail.com');
      expect(config.personalInfo.phone, '+91 7006401172');
      expect(config.personalInfo.location, 'New Delhi, India');

      // Verify all 5 work experiences
      expect(config.experiences.length, 5);
      expect(config.experiences.first.company, 'Cognizant');
      expect(config.experiences.first.isCurrent, true);
      expect(config.experiences[1].company, 'DLT Labs');

      // Verify featured projects
      expect(config.projects.isNotEmpty, true);
      final clickAndCollect =
          config.projects.firstWhere((p) => p.title == 'Click & Collect');
      expect(clickAndCollect.client, contains('Liverpool'));
      expect(clickAndCollect.userPersonas.length, 3);

      final sdsApp =
          config.projects.firstWhere((p) => p.title.contains('SDS'));
      expect(sdsApp.client, contains('Walmart'));

      // Verify ProjectLinks
      final liverpoolIos = config.projects
          .firstWhere((p) => p.title.contains('Liverpool: Shop'));
      expect(liverpoolIos.links.hasAny, true);
      expect(liverpoolIos.links.ios, contains('apple.com'));
      expect(liverpoolIos.appStoreUrl, contains('apple.com'));

      final assetTrack =
          config.projects.firstWhere((p) => p.title.contains('Asset Track'));
      expect(assetTrack.links.android, contains('play.google.com'));
      expect(assetTrack.playStoreUrl, contains('play.google.com'));

      // Verify skills, achievements, education, certifications
      expect(config.skillGroups.length, 4);
      expect(config.achievements.length, 6);
      expect(config.education.length, 2);
      expect(config.certifications.length, 3);
    });

    test('throws PortfolioConfigValidationException when name is missing', () {
      const invalidJson = '''
      {
        "personalInfo": {
          "title": "Flutter Dev",
          "email": "test@example.com"
        }
      }
      ''';

      expect(
        () => PortfolioConfigLoader.loadFromString(invalidJson),
        throwsA(isA<PortfolioConfigValidationException>()),
      );
    });

    test('throws PortfolioConfigValidationException on malformed JSON', () {
      const brokenJson = '{ "personalInfo": { broken ';

      expect(
        () => PortfolioConfigLoader.loadFromString(brokenJson),
        throwsA(isA<PortfolioConfigValidationException>()),
      );
    });

    test('ProjectLinks parses valid URLs and filters invalid strings safely', () {
      final links = ProjectLinks.fromJson({
        'web': 'https://example.com',
        'android': 'https://play.google.com/store/apps/details?id=app',
        'ios': 'https://apps.apple.com/app/id123',
        'github': 'javascript:alert(1)', // invalid scheme, should be filtered
      });

      expect(links.web, 'https://example.com');
      expect(links.android, contains('play.google.com'));
      expect(links.ios, contains('apps.apple.com'));
      expect(links.github, isNull);
      expect(links.hasAny, true);
    });
  });

  group('ThemeCubit Tests', () {
    test('initial state is dark theme and toggles correctly', () {
      final themeCubit = ThemeCubit();
      expect(themeCubit.state, ThemeMode.dark);
      expect(themeCubit.isDark, true);

      themeCubit.toggleTheme();
      expect(themeCubit.state, ThemeMode.light);
      expect(themeCubit.isDark, false);

      themeCubit.toggleTheme();
      expect(themeCubit.state, ThemeMode.dark);
      expect(themeCubit.isDark, true);
    });
  });

  group('PortfolioCubit Tests', () {
    test('loads portfolio and transitions to PortfolioLoaded state', () async {
      final cubit = ServiceLocator.createPortfolioCubit();
      expect(cubit.state, isA<PortfolioInitial>());

      await cubit.loadPortfolio();
      expect(cubit.state, isA<PortfolioLoaded>());

      final loadedState = cubit.state as PortfolioLoaded;
      expect(loadedState.config.personalInfo.name, 'Suhail Shabir');
      expect(loadedState.activeFilter, 'All');

      // Test filter update
      cubit.setProjectFilter('Retail & Logistics');
      final updatedState = cubit.state as PortfolioLoaded;
      expect(updatedState.activeFilter, 'Retail & Logistics');

      // Test section update
      cubit.setActiveSection('experience');
      final sectionState = cubit.state as PortfolioLoaded;
      expect(sectionState.activeSectionKey, 'experience');
    });

    test('PortfolioConfig copyWith updates fields immutably', () {
      final config = PortfolioConfigLoader.loadFromString(portfolioJsonContent);
      final updated = config.copyWith(metaTitle: 'New Title');
      expect(updated.metaTitle, 'New Title');
      expect(updated.personalInfo.name, config.personalInfo.name);
    });

    test('PortfolioRepositoryImpl falls back to local data source when remote is unavailable', () async {
      final repo = ServiceLocator.portfolioRepository;
      final config = await repo.getPortfolioConfig();
      expect(config.personalInfo.name, 'Suhail Shabir');
    });
  });
}
