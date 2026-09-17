import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/shared/components/section_title.dart';
import 'package:portfolio/shared/components/badge_pill.dart';
import 'package:portfolio/shared/components/responsive_grid.dart';
import '../widgets/project_card.dart';

/// Section showcasing featured and production mobile projects with category filtering,
/// visual mockup previews, and in-depth Case Study modals.
class ProjectsSection extends StatefulWidget {
  final List<Project> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Featured',
    'Retail & Logistics',
    'E-Commerce',
    'Enterprise Logistics',
    'Fintech & Blockchain',
    'Health & IoT',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBuilder.isMobile(context);
    final bool isTablet = ResponsiveBuilder.isTablet(context);

    // Filter projects
    final List<Project> filteredProjects = widget.projects.where((p) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Featured') return p.isFeatured;
      if (_selectedFilter == 'Health & IoT') {
        return p.category == 'Health & IoT' ||
            (p.category != null && p.category!.contains('Health'));
      }
      return p.category == _selectedFilter;
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
            // Section Header matching specification and mockup
            const SectionTitle(
              subtitle: 'FEATURED WORK',
              title: 'Featured Projects',
              description:
                  'Production-tested mobile applications engineered for global enterprise clients including Liverpool, Walmart, and DLT Labs.',
            ),

            // Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _filters.map((filter) {
                    final bool isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: BadgePill(
                        label: filter,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedFilter = filter),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 36),

            // Projects Grid with smooth transition
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: filteredProjects.isNotEmpty
                  ? ResponsiveGrid<Project>(
                      key: ValueKey<String>(_selectedFilter),
                      items: filteredProjects,
                      crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                      spacing: 20,
                      runSpacing: 20,
                      itemBuilder: (context, project) =>
                          ProjectCard(project: project),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No projects found in this category.',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
