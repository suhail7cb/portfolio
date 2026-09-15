import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/shared/components/section_title.dart';
import 'package:portfolio/shared/components/badge_pill.dart';
import 'package:portfolio/shared/components/responsive_grid.dart';
import '../widgets/project_card.dart';

/// Section showcasing featured and additional projects with category filtering.
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
    'Blockchain & Enterprise',
    'Fintech & Blockchain',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBuilder.isMobile(context);
    final bool isTablet = ResponsiveBuilder.isTablet(context);

    // Filter projects
    final List<Project> filteredProjects = widget.projects.where((p) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Featured') return p.isFeatured;
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
            const SectionTitle(
              subtitle: 'FEATURED & PRODUCTION WORK',
              title: 'Projects Portfolio',
              description:
                  'Production-tested mobile applications delivered for high-profile clients including Liverpool (Mexico), Walmart, DLT Labs, and enterprise stakeholders.',
            ),

            // Filter Pills Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
            const SizedBox(height: 36),

            // Responsive Projects Grid without fixed height clipping
            ResponsiveGrid<Project>(
              items: filteredProjects,
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
              spacing: 20,
              runSpacing: 20,
              itemBuilder: (context, project) => ProjectCard(project: project),
            ),
          ],
        ),
      ),
    );
  }
}
