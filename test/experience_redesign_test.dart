import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/features/portfolio/domain/entities/experience.dart';
import 'package:portfolio/features/portfolio/presentation/sections/experience_section.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/experience_timeline_bar.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/experience_focus_card.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/experience_previous_list.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/experience_detail_dialog.dart';

void main() {
  final List<Experience> sampleExperiences = [
    const Experience(
      role: 'Technology Specialist',
      company: 'Cognizant',
      location: 'Noida, India',
      period: 'June 2025 – Present',
      durationText: 'Current',
      isCurrent: true,
      description: 'Leading mobile architecture and enterprise delivery.',
      technologies: ['Flutter', 'iOS', 'SwiftUI', 'Architecture'],
      impact: ['5+ Engineers Mentored', 'Enterprise Mobile Systems'],
      associatedProjectTitle: 'Click & Collect',
      responsibilities: [
        'Mobile application development for enterprise clients',
        'Managed and mentored development teams',
      ],
    ),
    const Experience(
      role: 'Lead Engineer',
      company: 'DLT Labs',
      location: 'Noida, India',
      period: 'Feb 2019 – June 2025',
      durationText: '6 years 5 months',
      isCurrent: false,
      description: 'Led full-cycle mobile development and blockchain solutions.',
      technologies: ['Flutter', 'Dart', 'Blockchain'],
      impact: ['6+ Years of Enterprise Delivery'],
      associatedProjectTitle: 'Asset Track™',
      responsibilities: [
        'Led full-cycle Mobile app development.',
        'Delivered complex projects on time',
      ],
    ),
  ];

  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    );
  }

  group('Experience Entity Unit Tests', () {
    test('fromJson parses all enriched fields properly', () {
      final json = {
        'role': 'Technology Specialist',
        'company': 'Cognizant',
        'location': 'Noida, India',
        'period': 'June 2025 – Present',
        'durationText': 'Current',
        'isCurrent': true,
        'description': 'Role description test',
        'technologies': ['Flutter', 'iOS'],
        'impact': ['Mentored engineers'],
        'associatedProjectTitle': 'Click & Collect',
        'responsibilities': ['Resp 1', 'Resp 2'],
      };

      final exp = Experience.fromJson(json);
      expect(exp.role, 'Technology Specialist');
      expect(exp.company, 'Cognizant');
      expect(exp.description, 'Role description test');
      expect(exp.technologies, ['Flutter', 'iOS']);
      expect(exp.impact, ['Mentored engineers']);
      expect(exp.associatedProjectTitle, 'Click & Collect');
      expect(exp.responsibilities.length, 2);
    });

    test('toJson includes new fields when present', () {
      final exp = sampleExperiences.first;
      final json = exp.toJson();
      expect(json['description'], 'Leading mobile architecture and enterprise delivery.');
      expect(json['technologies'], ['Flutter', 'iOS', 'SwiftUI', 'Architecture']);
      expect(json['impact'], ['5+ Engineers Mentored', 'Enterprise Mobile Systems']);
      expect(json['associatedProjectTitle'], 'Click & Collect');
    });
  });

  group('ExperienceSection Widget Tests', () {
    testWidgets('renders Timeline mode by default with timeline bar and focus card', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget(
        ExperienceSection(experiences: sampleExperiences),
      ));
      await tester.pumpAndSettle();

      // Check for Section Header
      expect(find.text('Professional Experience'), findsOneWidget);
      expect(find.text('CAREER TRAJECTORY'), findsOneWidget);

      // Check for Timeline Bar and Focus Card
      expect(find.byType(ExperienceTimelineBar), findsOneWidget);
      expect(find.byType(ExperienceFocusCard), findsOneWidget);
      expect(find.byType(ExperiencePreviousList), findsOneWidget);

      // Verify active experience details
      expect(find.text('Cognizant'), findsWidgets);
      expect(find.text('Technology Specialist'), findsWidgets);
      expect(find.text('Leading mobile architecture and enterprise delivery.'), findsOneWidget);
    });

    testWidgets('selecting a different node updates the focused card', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget(
        ExperienceSection(experiences: sampleExperiences),
      ));
      await tester.pumpAndSettle();

      // Tap on DLT Labs node in the timeline bar
      final dltTimelineNode = find.descendant(
        of: find.byType(ExperienceTimelineBar),
        matching: find.text('DLT Labs'),
      );
      expect(dltTimelineNode, findsOneWidget);
      await tester.tap(dltTimelineNode);
      await tester.pumpAndSettle();

      // Focused card should now show DLT Labs
      final focusedRole = find.descendant(
        of: find.byType(ExperienceFocusCard),
        matching: find.text('Lead Engineer'),
      );
      expect(focusedRole, findsOneWidget);
    });

    testWidgets('toggling Cards mode shows the vertical list view', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget(
        ExperienceSection(experiences: sampleExperiences),
      ));
      await tester.pumpAndSettle();

      // Find Cards toggle button and tap
      final cardsBtn = find.text('Cards');
      expect(cardsBtn, findsOneWidget);
      await tester.ensureVisible(cardsBtn);
      await tester.tap(cardsBtn);
      await tester.pumpAndSettle();

      // Timeline bar should not be present in Cards mode
      expect(find.byType(ExperienceTimelineBar), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('tapping View Details opens ExperienceDetailDialog with tabs', (tester) async {
      tester.view.physicalSize = const Size(1440, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget(
        ExperienceSection(experiences: sampleExperiences),
      ));
      await tester.pumpAndSettle();

      // Find "View Details" button in ExperienceFocusCard and tap
      final viewDetailsBtn = find.text('View Details');
      expect(viewDetailsBtn, findsOneWidget);
      await tester.ensureVisible(viewDetailsBtn);
      await tester.tap(viewDetailsBtn);
      await tester.pumpAndSettle();

      // ExperienceDetailDialog should be displayed
      expect(find.byType(ExperienceDetailDialog), findsOneWidget);
      expect(find.text('Experience Details'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Responsibilities'), findsOneWidget);
      expect(find.text('Technologies'), findsOneWidget);
      expect(find.text('Impact'), findsOneWidget);

      // Close modal
      final closeBtn = find.text('Close');
      expect(closeBtn, findsOneWidget);
      await tester.ensureVisible(closeBtn);
      await tester.tap(closeBtn);
      await tester.pumpAndSettle();

      expect(find.byType(ExperienceDetailDialog), findsNothing);
    });
  });
}
