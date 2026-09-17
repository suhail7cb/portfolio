import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/features/portfolio/domain/entities/skill_group.dart';
import 'package:portfolio/features/portfolio/domain/entities/achievement.dart';
import 'package:portfolio/features/portfolio/presentation/sections/projects_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/project_card.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/project_case_study_dialog.dart';
import 'package:portfolio/features/portfolio/presentation/sections/skills_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/skill_chip_group.dart';
import 'package:portfolio/shared/components/badge_pill.dart';
import 'package:portfolio/features/portfolio/presentation/sections/achievements_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/achievement_card.dart';

void main() {
  final sampleProjects = [
    const Project(
      title: 'Click & Collect',
      client: 'Liverpool (Mexico)',
      duration: '6 Months',
      category: 'Retail & Logistics',
      isFeatured: true,
      overview: 'Enterprise platform enabling customers to order and pick up in-store.',
      features: ['Appointment scheduling', 'Curbside pickup', 'Express delivery'],
      userPersonas: ['Sales Associate', 'Warehouse Staff'],
      technologies: ['Flutter', 'Dart', 'iOS', 'REST APIs'],
      platforms: ['Mobile'],
      links: ProjectLinks(ios: 'https://apps.apple.com'),
    ),
    const Project(
      title: 'Asset Track™',
      client: 'DLT Labs',
      duration: '45 Months',
      category: 'Fintech & Blockchain',
      isFeatured: true,
      overview: 'Real-time supply chain asset tracking on blockchain.',
      features: ['Tamper-proof tracking', 'Real-time alerts'],
      userPersonas: ['Auditor', 'Supply Manager'],
      technologies: ['Flutter', 'Dart', 'Blockchain'],
      platforms: ['Mobile', 'Web'],
    ),
  ];

  final sampleSkillGroups = [
    const SkillGroup(
      categoryName: 'Core Technologies',
      description: 'Mobile languages and frameworks',
      skills: [
        SkillItem(name: 'Flutter', level: 'Expert'),
        SkillItem(name: 'Swift', level: 'Expert'),
        SkillItem(name: 'Dart', level: 'Expert'),
      ],
    ),
    const SkillGroup(
      categoryName: 'Architecture',
      description: 'System design patterns',
      skills: [
        SkillItem(name: 'Clean Architecture', level: 'Expert'),
        SkillItem(name: 'BLoC', level: 'Expert'),
      ],
    ),
  ];

  final sampleAchievements = [
    const Achievement(
      title: 'Enterprise Leadership',
      description: 'Led end-to-end mobile engineering for Walmart and DHL.',
      metricBadge: 'Walmart • DHL • BSE',
      iconName: 'corporate_fare',
    ),
    const Achievement(
      title: 'Security Pioneer',
      description: 'Engineered secure blockchain ledgers for enterprise workflows.',
      metricBadge: 'Blockchain & Integrity',
      iconName: 'shield',
    ),
  ];

  Widget buildTestApp(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    );
  }

  group('Project Entity & Case Study Tests', () {
    test('derives effective case study values when not explicitly provided', () {
      final p = sampleProjects.first;
      expect(p.effectiveProblem, contains('Liverpool (Mexico)'));
      expect(p.effectiveSolution, contains('Enterprise platform'));
      expect(p.effectiveRoleDescription, contains('Architected'));
      expect(p.effectiveArchitectureSteps.length, 5);
      expect(p.effectiveImpactMetrics.isNotEmpty, true);
      expect(p.effectiveChallenges.length, 3);
    });

    test('parses custom case study fields from json', () {
      final json = {
        'title': 'Test Project',
        'overview': 'Test Overview',
        'problem': 'Custom Problem Statement',
        'solution': 'Custom Solution Statement',
        'roleDescription': 'Custom Role',
        'architectureSteps': ['Step 1', 'Step 2'],
        'challenges': [
          {'title': 'Challenge 1', 'description': 'Desc 1'}
        ],
        'impactMetrics': [
          {'value': '10M+', 'label': 'Users'}
        ],
      };

      final p = Project.fromJson(json);
      expect(p.problem, 'Custom Problem Statement');
      expect(p.solution, 'Custom Solution Statement');
      expect(p.roleDescription, 'Custom Role');
      expect(p.architectureSteps, ['Step 1', 'Step 2']);
      expect(p.challenges.first['title'], 'Challenge 1');
      expect(p.impactMetrics.first['value'], '10M+');
    });
  });

  group('ProjectsSection & ProjectCaseStudyDialog Widget Tests', () {
    testWidgets('renders project cards and filters correctly', (tester) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(
        ProjectsSection(projects: sampleProjects),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Featured Projects'), findsOneWidget);
      expect(find.byType(ProjectCard), findsNWidgets(2));
      expect(find.text('Click & Collect'), findsOneWidget);
      expect(find.text('Asset Track™'), findsOneWidget);

      // Tap on Retail & Logistics filter
      final retailFilter =
          find.widgetWithText(BadgePill, 'Retail & Logistics').first;
      expect(retailFilter, findsOneWidget);
      await tester.ensureVisible(retailFilter);
      await tester.tap(retailFilter);
      await tester.pumpAndSettle();

      // Only Click & Collect should remain
      expect(find.text('Click & Collect'), findsOneWidget);
      expect(find.text('Asset Track™'), findsNothing);
    });

    testWidgets('tapping project card opens ProjectCaseStudyDialog with all 5 tabs', (tester) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(
        ProjectsSection(projects: sampleProjects),
      ));
      await tester.pumpAndSettle();

      // Tap first ProjectCard
      final firstCard = find.byType(ProjectCard).first;
      await tester.ensureVisible(firstCard);
      await tester.tap(firstCard);
      await tester.pumpAndSettle();

      // Verify ProjectCaseStudyDialog is displayed
      expect(find.byType(ProjectCaseStudyDialog), findsOneWidget);
      expect(find.text('Back to Projects'), findsOneWidget);
      expect(find.text('The Problem'), findsOneWidget);
      expect(find.text('The Solution'), findsOneWidget);

      // Verify tabs exist
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('My Role'), findsOneWidget);
      expect(find.text('Architecture'), findsOneWidget);
      expect(find.text('Challenges'), findsOneWidget);
      expect(find.text('Outcome'), findsOneWidget);

      // Switch to Architecture tab
      final archTab = find.text('Architecture');
      await tester.tap(archTab);
      await tester.pumpAndSettle();

      expect(find.text('End-to-End System Architecture'), findsOneWidget);

      // Close dialog
      final closeBtn = find.text('Close Case Study');
      await tester.tap(closeBtn);
      await tester.pumpAndSettle();

      expect(find.byType(ProjectCaseStudyDialog), findsNothing);
    });
  });

  group('SkillsSection Widget Tests', () {
    testWidgets('renders skill groups with category icons and no percentage bars', (tester) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(
        SkillsSection(skillGroups: sampleSkillGroups),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Technical Expertise Matrix'), findsOneWidget);
      expect(find.byType(SkillChipGroup), findsNWidgets(2));
      expect(find.text('Flutter'), findsOneWidget);
      expect(find.text('Clean Architecture'), findsOneWidget);

      // Percentage bars should not be present
      expect(find.textContaining('%'), findsNothing);
    });
  });

  group('AchievementsSection Widget Tests', () {
    testWidgets('renders achievements with custom icons and metric badges', (tester) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestApp(
        AchievementsSection(achievements: sampleAchievements),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Key Achievements & Professional Impact'), findsOneWidget);
      expect(find.byType(AchievementCard), findsNWidgets(2));
      expect(find.text('Walmart • DHL • BSE'), findsOneWidget);
      expect(find.text('Enterprise Leadership'), findsOneWidget);
      expect(find.text('Blockchain & Integrity'), findsOneWidget);
    });
  });
}
