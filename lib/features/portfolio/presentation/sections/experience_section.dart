import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/portfolio/domain/entities/experience.dart';
import 'package:portfolio/shared/components/section_title.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/experience_timeline_tile.dart';

/// Section presenting the full timeline of professional work experience.
class ExperienceSection extends StatelessWidget {
  final List<Experience> experiences;

  const ExperienceSection({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBuilder.isMobile(context);

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
              subtitle: 'CAREER TRAJECTORY',
              title: 'Professional Experience',
              description:
                  'A track record of technical leadership, architecting enterprise systems, and delivering production mobile solutions.',
            ),
            const SizedBox(height: 20),

            // Timeline ListView
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final experience = experiences[index];
                final bool isFirst = index == 0;
                final bool isLast = index == experiences.length - 1;

                return ExperienceTimelineTile(
                  experience: experience,
                  isFirst: isFirst,
                  isLast: isLast,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
