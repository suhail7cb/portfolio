import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/core/theme/theme_cubit.dart';
import 'package:portfolio/features/portfolio/domain/entities/personal_info.dart';
import 'package:portfolio/features/portfolio/presentation/sections/hero_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/portfolio_nav_bar.dart';

void main() {
  const samplePersonalInfo = PersonalInfo(
    name: 'Suhail Shabir',
    title: 'Senior Mobile Engineer',
    tagline: 'Building scalable iOS & Flutter products with a focus on clean architecture, great UX and real-world impact.',
    location: 'New Delhi, India',
    email: 'suhail7.dev@gmail.com',
    phone: '+91 7006401172',
    totalExperience: '10 Years in Mobile Development',
    professionalSummary: 'Over 10 years of experience designing, architecting, and delivering high-impact mobile solutions.',
    highlights: ['Swift', 'Flutter', 'Leadership'],
    professionalDevelopmentSummary: 'Dedicated mobile engineer.',
    profileImageUrl: 'assets/images/profile.jpeg',
    resumeDownloadUrl: 'assets/resume/Suhail_Shabir.docx',
  );

  Widget buildTestApp({
    required Widget child,
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }

  group('HeroSection Redesign Widget Tests', () {
    testWidgets('renders all visual elements matching reference screenshot', (tester) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool exploreClicked = false;

      await tester.pumpWidget(buildTestApp(
        child: HeroSection(
          personalInfo: samplePersonalInfo,
          onExploreProjects: () => exploreClicked = true,
          onContactMe: () {},
        ),
      ));
      await tester.pumpAndSettle();

      // 1. Left Content: Greeting & Name
      expect(find.text("Hello, I'm"), findsOneWidget);
      expect(find.text('Suhail '), findsOneWidget);
      expect(find.text('Shabir'), findsOneWidget);
      expect(find.text('Senior Mobile Engineer'), findsOneWidget);
      expect(
        find.text('Building scalable iOS & Flutter products with a focus on clean architecture, great UX and real-world impact.'),
        findsOneWidget,
      );

      // 2. Skill Badges
      expect(find.text('iOS'), findsNWidgets(2)); // Pill badge + floating card
      expect(find.text('Flutter'), findsNWidgets(2)); // Pill badge + floating card
      expect(find.text('Architecture'), findsNWidgets(2)); // Pill badge + floating card
      expect(find.text('Leadership'), findsNWidgets(2)); // Pill badge + floating card

      // 3. CTAs
      expect(find.text('Explore My Work →'), findsOneWidget);
      expect(find.text('Download Résumé'), findsOneWidget);

      // Tap on Explore My Work
      await tester.tap(find.text('Explore My Work →'));
      await tester.pumpAndSettle();
      expect(exploreClicked, isTrue);

      // 4. Right Visual: Handwritten Callout & Floating Card
      expect(find.text('Turning ideas\ninto products'), findsOneWidget);
      expect(find.text('Years Experience'), findsNWidgets(2)); // Floating card + bottom ribbon

      // 5. Bottom Stats Ribbon
      expect(find.text('6+'), findsOneWidget);
      expect(find.text('Enterprise Clients'), findsOneWidget);
      expect(find.text('20+'), findsOneWidget);
      expect(find.text('Apps / Products'), findsOneWidget);
      expect(find.text('4+'), findsOneWidget);
      expect(find.text('Teams Mentored'), findsOneWidget);
    });

    testWidgets('renders cleanly on mobile without overflow and keeps name, role & picture on top', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(
        child: HeroSection(
          personalInfo: samplePersonalInfo,
          onExploreProjects: () {},
          onContactMe: () {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text("Hello, I'm"), findsOneWidget);
      expect(find.text('Suhail '), findsOneWidget);
      expect(find.text('Shabir'), findsOneWidget);
      expect(find.text('Senior Mobile Engineer'), findsOneWidget);
      expect(find.text('Explore My Work →'), findsOneWidget);
      expect(find.text('Download Résumé'), findsOneWidget);
      expect(find.text('Enterprise Clients'), findsOneWidget);

      // Verify that Name & Role and Picture appear before the narrative bio & action buttons
      final nameTop = tester.getTopLeft(find.text('Suhail ')).dy;
      final bioTop = tester.getTopLeft(find.text(samplePersonalInfo.tagline)).dy;
      final ctaTop = tester.getTopLeft(find.text('Explore My Work →')).dy;

      expect(nameTop, lessThan(bioTop));
      expect(bioTop, lessThan(ctaTop));
    });

    testWidgets('dynamically resizes picture as user scrolls up and down', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final scrollController = ScrollController();
      addTearDown(() => scrollController.dispose());

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                HeroSection(
                  personalInfo: samplePersonalInfo,
                  onExploreProjects: () {},
                  onContactMe: () {},
                  scrollController: scrollController,
                ),
                Container(height: 1200, color: Colors.blue),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Find initial picture FittedBox size
      final fittedBoxFinder = find.byType(FittedBox);
      expect(fittedBoxFinder, findsOneWidget);
      final initialSize = tester.getSize(fittedBoxFinder);

      // Scroll down by 200px
      scrollController.jumpTo(200);
      await tester.pump();

      final scrolledDownSize = tester.getSize(fittedBoxFinder);
      // Picture should have resized smaller (shrunk)
      expect(scrolledDownSize.width, lessThan(initialSize.width));
      expect(scrolledDownSize.height, lessThan(initialSize.height));

      // Scroll back up to 0px
      scrollController.jumpTo(0);
      await tester.pump();

      final scrolledUpSize = tester.getSize(fittedBoxFinder);
      // Picture should expand back to original size
      expect(scrolledUpSize.width, closeTo(initialSize.width, 0.5));
      expect(scrolledUpSize.height, closeTo(initialSize.height, 0.5));
    });

    testWidgets('PortfolioNavBar keeps avatar, name and role visible at the top when scrolled to bottom', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final scrollController = ScrollController();
      addTearDown(() => scrollController.dispose());

      await tester.pumpWidget(
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        const SizedBox(height: 64),
                        HeroSection(
                          personalInfo: samplePersonalInfo,
                          onExploreProjects: () {},
                          onContactMe: () {},
                          scrollController: scrollController,
                        ),
                        Container(height: 3000, color: Colors.purple),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: PortfolioNavBar(
                      personalInfo: samplePersonalInfo,
                      navigationItems: const [],
                      activeSectionKey: 'hero',
                      onNavTap: (_) {},
                      onOpenDrawer: () {},
                      scrollController: scrollController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial state: name is visible
      expect(find.text('Suhail Shabir'), findsOneWidget);
      expect(find.text('Senior Mobile Engineer'), findsWidgets);

      // Scroll all the way down to 2500px (bottom of page)
      scrollController.jumpTo(2500);
      await tester.pump();

      // Sized-down avatar, Name and Role MUST STILL BE VISIBLE at the top!
      expect(find.text('Suhail Shabir'), findsOneWidget);
      expect(find.text('Senior Mobile Engineer'), findsWidgets);

      // Verify the navbar is at top: y < 64.0
      final navBarTop = tester.getTopLeft(find.text('Suhail Shabir')).dy;
      expect(navBarTop, lessThan(64.0));
    });
  });
}

