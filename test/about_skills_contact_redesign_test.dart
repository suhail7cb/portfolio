import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/features/portfolio/domain/entities/personal_info.dart';
import 'package:portfolio/features/portfolio/domain/entities/social_link.dart';
import 'package:portfolio/features/portfolio/domain/entities/skill_group.dart';
import 'package:portfolio/features/portfolio/presentation/sections/summary_highlights_section.dart';
import 'package:portfolio/features/portfolio/presentation/sections/skills_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/skill_chip_group.dart';
import 'package:portfolio/features/portfolio/presentation/sections/contact_section.dart';
import 'package:portfolio/shared/components/badge_pill.dart';

void main() {
  const samplePersonalInfo = PersonalInfo(
    name: 'Suhail Shabir',
    title: 'Mobile Application Developer (iOS & Flutter)',
    tagline: 'Architecting High-Impact, Scalable Mobile Solutions for 10+ Years',
    location: 'New Delhi, India',
    email: 'suhail7.dev@gmail.com',
    phone: '+91 7006401172',
    totalExperience: '10 Years in Mobile Development',
    professionalSummary:
        'Innovative, visionary, and results-driven iOS & Mobile Application Developer with over 10 years of experience.',
    highlights: [
      'Expert-level proficiency in Swift, SwiftUI, Flutter, Dart and mobile architecture',
      'Strong eye for UI/UX design, performance optimisation, and accessibility',
      'Proven leadership in cross-functional teams and client-facing roles',
    ],
    professionalDevelopmentSummary: 'A decade of dedication to mobile engineering.',
  );

  final sampleSocialLinks = [
    const SocialLink(
      label: 'LinkedIn',
      url: 'https://www.linkedin.com/in/suhail-s-4b9613a8/',
      iconKey: 'linkedin',
    ),
    const SocialLink(
      label: 'GitHub',
      url: 'https://github.com/suhail7cb',
      iconKey: 'github',
    ),
    const SocialLink(
      label: 'Email',
      url: 'mailto:suhail7.dev@gmail.com',
      iconKey: 'email',
    ),
  ];

  final sampleSkillGroups = [
    const SkillGroup(
      categoryName: 'Core Mobile Engineering',
      description: 'Native iOS & Flutter ecosystems',
      skills: [
        SkillItem(name: 'Flutter', level: 'Expert'),
        SkillItem(name: 'Dart', level: 'Expert'),
        SkillItem(name: 'iOS Native (Swift)', level: 'Expert'),
      ],
    ),
    const SkillGroup(
      categoryName: 'Architecture & Practices',
      description: 'Scalable patterns & systems',
      skills: [
        SkillItem(name: 'Clean Architecture', level: 'Expert'),
        SkillItem(name: 'BLoC Pattern', level: 'Expert'),
        SkillItem(name: 'SOLID Principles', level: 'Expert'),
      ],
    ),
  ];

  Widget buildTestApp(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }

  group('About & Engineering DNA Section Tests', () {
    testWidgets('renders About Me narrative, capability tags, and Engineering DNA pillars', (tester) async {
      tester.view.physicalSize = const Size(1440, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(
        const SummaryHighlightsSection(personalInfo: samplePersonalInfo),
      ));
      await tester.pumpAndSettle();

      // Section Titles
      expect(find.text('ABOUT ME & ENGINEERING DNA'), findsOneWidget);
      expect(find.text('Architectural Mindset, Product Thinking'), findsOneWidget);

      // About Me Card
      expect(find.text('About Me'), findsOneWidget);
      expect(find.text('Problem Solver'), findsOneWidget);
      expect(find.text('Team Player'), findsOneWidget);
      expect(find.text('Continuous Learner'), findsOneWidget);

      // Engineering DNA Visual Flow
      expect(find.text('ENGINEERING DNA'), findsOneWidget);
      expect(find.text('How I Approach Engineering'), findsOneWidget);
      expect(find.text('Product Thinking'), findsOneWidget);
      expect(find.text('User-Centric Architecture • Business Value Alignment'), findsOneWidget);

      // 3 DNA Pillars
      expect(find.text('Architecture'), findsOneWidget);
      expect(find.text('Quality'), findsOneWidget);
      expect(find.text('Delivery'), findsOneWidget);

      // Pillar sub-points
      expect(find.text('Clean'), findsOneWidget);
      expect(find.text('Modular'), findsOneWidget);
      expect(find.text('Scalable'), findsOneWidget);
      expect(find.text('Testing'), findsOneWidget);
      expect(find.text('Code Reviews'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('CI/CD'), findsOneWidget);
      expect(find.text('Release'), findsOneWidget);
      expect(find.text('Monitoring'), findsOneWidget);

      // What I Bring to the Table Highlights
      expect(find.text('What I Bring to the Table'), findsOneWidget);
      expect(find.textContaining('Expert-level proficiency in Swift'), findsOneWidget);
    });
  });

  group('SkillsSection Tests', () {
    testWidgets('renders category filter and allows switching category', (tester) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(
        SkillsSection(skillGroups: sampleSkillGroups),
      ));
      await tester.pumpAndSettle();

      // Category filters
      expect(find.byType(BadgePill), findsAtLeastNWidgets(3));
      expect(find.byType(SkillChipGroup), findsNWidgets(2));
      expect(find.text('Flutter'), findsOneWidget);
      expect(find.text('Clean Architecture'), findsOneWidget);

      // Tap on Architecture & Practices filter pill
      final archFilter = find.widgetWithText(BadgePill, 'Architecture & Practices').first;
      await tester.tap(archFilter);
      await tester.pumpAndSettle();

      // Only Architecture skill group should be shown
      expect(find.byType(SkillChipGroup), findsOneWidget);
      expect(find.text('Clean Architecture'), findsOneWidget);
      expect(find.text('Flutter'), findsNothing);
    });
  });

  group('ContactSection ("Get in Touch") Tests', () {
    testWidgets('renders Section 18 headline, Let\'s Talk CTA banner, touchpoints, and form', (tester) async {
      tester.view.physicalSize = const Size(1440, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(
        ContactSection(
          personalInfo: samplePersonalInfo,
          socialLinks: sampleSocialLinks,
        ),
      ));
      await tester.pumpAndSettle();

      // Section 18 Headline & Copy
      expect(find.text('GET IN TOUCH'), findsOneWidget);
      expect(find.text('Ready to build something great?'), findsOneWidget);
      expect(
        find.text("I'm open to interesting engineering problems, product collaborations and senior mobile opportunities."),
        findsOneWidget,
      );

      // Primary CTA
      expect(find.text("Let's Talk →"), findsOneWidget);
      expect(find.text('Have a mobile project or technical challenge?'), findsOneWidget);

      // Verified Touchpoints
      expect(find.text('Direct Email'), findsOneWidget);
      expect(find.text('suhail7.dev@gmail.com'), findsOneWidget);
      expect(find.text('LinkedIn'), findsOneWidget);
      expect(find.text('GitHub'), findsOneWidget);
      expect(find.text('Direct Phone'), findsOneWidget);
      expect(find.text('+91 7006401172'), findsOneWidget);
      expect(find.text('Current Location'), findsOneWidget);
      expect(find.text('New Delhi, India'), findsOneWidget);

      // Direct Message Form
      expect(find.text('Send a Direct Message'), findsOneWidget);
      expect(find.text('Your Name'), findsOneWidget);
      expect(find.text('Your Email'), findsOneWidget);
      expect(find.text('Subject'), findsOneWidget);
      expect(find.text('Message'), findsOneWidget);
      expect(find.text('Send Message'), findsOneWidget);
    });
  });
}
