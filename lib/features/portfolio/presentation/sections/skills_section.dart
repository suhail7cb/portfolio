import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/portfolio/domain/entities/skill_group.dart';
import 'package:portfolio/shared/components/section_title.dart';
import 'package:portfolio/shared/components/responsive_grid.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/skill_chip_group.dart';

/// Section displaying technical skills grouped into categories with proficiency tags.
class SkillsSection extends StatelessWidget {
  final List<SkillGroup> skillGroups;

  const SkillsSection({super.key, required this.skillGroups});

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
              subtitle: 'TECHNICAL STACK',
              title: 'Technical Expertise Matrix',
              description:
                  'Comprehensive technical foundations across native iOS, cross-platform Flutter, architecture, security, and team mentorship.',
            ),

            // Content-adaptive responsive grid without height constraints
            ResponsiveGrid<SkillGroup>(
              items: skillGroups,
              crossAxisCount: isMobile ? 1 : 2,
              spacing: 20,
              runSpacing: 20,
              itemBuilder: (context, group) => SkillChipGroup(skillGroup: group),
            ),
          ],
        ),
      ),
    );
  }
}
