import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/portfolio/domain/entities/achievement.dart';
import 'package:portfolio/shared/components/section_title.dart';
import 'package:portfolio/shared/components/responsive_grid.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/achievement_card.dart';

/// Section showcasing enterprise milestones, leadership achievements, and client partnerships.
class AchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementsSection({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBuilder.isMobile(context);
    final bool isTablet = ResponsiveBuilder.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile
            ? AppDimensions.sectionVerticalPaddingMobile
            : AppDimensions.sectionVerticalPadding,
      ),
      child: ResponsiveContentWrapper(
        child: Column(
          children: [
            const SectionTitle(
              subtitle: 'LEADERSHIP & ACHIEVEMENTS',
              title: 'Key Achievements & Professional Impact',
              description:
                  'Demonstrated excellence in architecting secure, mission-critical systems and steering high-profile enterprise mobile deliveries.',
            ),

            // Content-adaptive responsive grid without fixed height clipping
            ResponsiveGrid<Achievement>(
              items: achievements,
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
              spacing: 20,
              runSpacing: 20,
              itemBuilder: (context, achievement) =>
                  AchievementCard(achievement: achievement),
            ),
          ],
        ),
      ),
    );
  }
}
