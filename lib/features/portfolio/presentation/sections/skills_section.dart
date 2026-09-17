import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/portfolio/domain/entities/skill_group.dart';
import 'package:portfolio/shared/components/section_title.dart';
import 'package:portfolio/shared/components/badge_pill.dart';
import 'package:portfolio/shared/components/responsive_grid.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/skill_chip_group.dart';

/// Section displaying technical skills grouped into clean capability categories without percentage bars.
class SkillsSection extends StatefulWidget {
  final List<SkillGroup> skillGroups;

  const SkillsSection({super.key, required this.skillGroups});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBuilder.isMobile(context);

    final List<String> categories = [
      'All',
      ...widget.skillGroups.map((g) => g.categoryName),
    ];

    final List<SkillGroup> filteredGroups = widget.skillGroups.where((g) {
      if (_selectedCategory == 'All') return true;
      return g.categoryName == _selectedCategory;
    }).toList();

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

            // Category Filter Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: categories.map((cat) {
                    final bool isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: BadgePill(
                        label: cat,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedCategory = cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Responsive Skills Grid
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: ResponsiveGrid<SkillGroup>(
                key: ValueKey<String>(_selectedCategory),
                items: filteredGroups,
                crossAxisCount: isMobile ? 1 : 2,
                spacing: 20,
                runSpacing: 20,
                itemBuilder: (context, group) =>
                    SkillChipGroup(skillGroup: group),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
