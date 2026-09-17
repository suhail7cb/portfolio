import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/utils/url_launcher_helper.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/shared/components/badge_pill.dart';
import 'package:portfolio/shared/components/gradient_button.dart';

/// Detailed Case Study modal view matching the UX/UI specification and Mockup Image 2.
/// Features structured tabs: Overview, My Role, Architecture, Challenges, and Outcome.
class ProjectCaseStudyDialog extends StatefulWidget {
  final Project project;

  const ProjectCaseStudyDialog({super.key, required this.project});

  static Future<void> show(BuildContext context, Project project) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ProjectCaseStudyDialog(project: project),
    );
  }

  @override
  State<ProjectCaseStudyDialog> createState() => _ProjectCaseStudyDialogState();
}

class _ProjectCaseStudyDialogState extends State<ProjectCaseStudyDialog> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Overview',
    'My Role',
    'Architecture',
    'Challenges',
    'Outcome',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);
    final Project p = widget.project;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 36,
        vertical: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840, maxHeight: 820),
        child: Column(
          children: [
            // 1. Modal Top Bar (Back to Projects + Actions)
            _buildTopBar(context, p, isDark),

            // 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 18 : 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Visual Product Showcase Banner
                    _buildProductShowcase(p, isDark, isMobile),

                    const SizedBox(height: 24),

                    // Segmented Tabs Header
                    _buildTabsHeader(isDark, isMobile),

                    const SizedBox(height: 24),

                    // Active Tab Content
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: _buildTabContent(p, isDark, isMobile),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Modal Footer
            _buildFooter(context, p, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Project p, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_back_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Back to Projects',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // External Store Links
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (p.links.ios != null)
                _IconActionBtn(
                  icon: Icons.apple,
                  tooltip: 'Apple App Store',
                  url: p.links.ios!,
                  isDark: isDark,
                ),
              if (p.links.android != null)
                _IconActionBtn(
                  icon: Icons.shop_rounded,
                  tooltip: 'Google Play Store',
                  url: p.links.android!,
                  isDark: isDark,
                ),
              if (p.links.web != null)
                _IconActionBtn(
                  icon: Icons.language,
                  tooltip: 'Web Portal',
                  url: p.links.web!,
                  isDark: isDark,
                ),
              if (p.links.github != null)
                _IconActionBtn(
                  icon: Icons.code,
                  tooltip: 'GitHub Repository',
                  url: p.links.github!,
                  isDark: isDark,
                ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductShowcase(Project p, bool isDark, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C111E) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (p.category != null)
                BadgePill(
                  label: p.category!,
                  color: AppColors.primary.withValues(alpha: 0.15),
                  textColor: AppColors.primary,
                ),
              if (p.duration != null)
                BadgePill(
                  label: p.duration!,
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              if (p.client != null)
                BadgePill(
                  label: p.client!,
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  textColor: AppColors.secondary,
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Project Title
          Text(
            p.title,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Short summary
          Text(
            p.overview,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: isMobile ? 13.5 : 14.5,
              height: 1.6,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Mockup Preview Visual Strip
          _buildDeviceMockupVisual(p, isDark),
        ],
      ),
    );
  }

  Widget _buildDeviceMockupVisual(Project p, bool isDark) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.18),
            AppColors.secondary.withValues(alpha: 0.18),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDevicePill(Icons.phone_iphone_rounded, 'Mobile App', isDark),
              const SizedBox(width: 16),
              _buildDevicePill(
                Icons.cloud_sync_outlined,
                'Enterprise REST API',
                isDark,
              ),
              const SizedBox(width: 16),
              _buildDevicePill(
                Icons.layers_outlined,
                'Clean Architecture',
                isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDevicePill(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101728) : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsHeader(bool isDark, bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final String title = _tabs[index];
          final bool isSelected = index == _selectedTabIndex;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              onTap: () => setState(() => _selectedTabIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                          ? const Color(0xFF131B2C)
                          : const Color(0xFFEDF2F7)),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                  ),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? Colors.black
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent(Project p, bool isDark, bool isMobile) {
    switch (_selectedTabIndex) {
      case 0: // Overview
        return Column(
          key: ValueKey('overview_${p.title}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The Problem
            _buildSectionHeader('The Problem', Icons.report_problem_outlined),
            const SizedBox(height: 8),
            Text(
              p.effectiveProblem,
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.65,
                fontSize: 14.5,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // The Solution
            _buildSectionHeader('The Solution', Icons.lightbulb_outline_rounded),
            const SizedBox(height: 8),
            Text(
              p.effectiveSolution,
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.65,
                fontSize: 14.5,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // Tech Stack
            _buildSectionHeader('Tech Stack', Icons.terminal_rounded),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: p.technologies.map((tech) {
                return BadgePill(
                  label: tech,
                  color: isDark
                      ? const Color(0xFF151D2F)
                      : const Color(0xFFEDF2F7),
                  textColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Measurable Impact Strip
            _buildSectionHeader(
              'Measurable Impact',
              Icons.signal_cellular_alt_rounded,
            ),
            const SizedBox(height: 14),
            Row(
              children: p.effectiveImpactMetrics.map((metric) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F1523)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metric['value'] ?? '',
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          metric['label'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );

      case 1: // My Role
        return Column(
          key: ValueKey('role_${p.title}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Personal Contribution & Leadership',
              Icons.person_outline,
            ),
            const SizedBox(height: 10),
            Text(
              p.effectiveRoleDescription,
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.65,
                fontSize: 14.5,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 24),

            if (p.userPersonas.isNotEmpty) ...[
              _buildSectionHeader('Target User Personas', Icons.groups_outlined),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: p.userPersonas.map((persona) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF151D2F)
                          : const Color(0xFFEDF2F7),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.badge_outlined,
                          size: 15,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          persona,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Key Features Delivered
            if (p.features.isNotEmpty) ...[
              _buildSectionHeader(
                'Key Features Delivered',
                Icons.check_circle_outline_rounded,
              ),
              const SizedBox(height: 12),
              ...p.features.map((feat) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 10,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feat,
                          style: context.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            fontSize: 13.5,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        );

      case 2: // Architecture
        return Column(
          key: ValueKey('arch_${p.title}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'End-to-End System Architecture',
              Icons.hub_outlined,
            ),
            const SizedBox(height: 8),
            Text(
              'Layered Clean Architecture enforcing strict separation of concerns, single responsibility, and mockable unit/widget testability.',
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Flow Diagram
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0B101D)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: List.generate(
                  p.effectiveArchitectureSteps.length,
                  (index) {
                    final String step = p.effectiveArchitectureSteps[index];
                    final bool isLast =
                        index == p.effectiveArchitectureSteps.length - 1;

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: index == 0
                                ? AppColors.primaryGradient
                                : null,
                            color: index != 0
                                ? (isDark
                                    ? const Color(0xFF161E33)
                                    : Colors.white)
                                : null,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusM,
                            ),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == 0
                                      ? Colors.black.withValues(alpha: 0.2)
                                      : AppColors.primary.withValues(
                                          alpha: 0.15,
                                        ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: index == 0
                                          ? Colors.black
                                          : AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  step,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: index == 0
                                        ? Colors.black
                                        : (isDark
                                            ? Colors.white
                                            : AppColors.lightTextPrimary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Icon(
                              Icons.arrow_downward_rounded,
                              size: 18,
                              color: AppColors.primary.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 3: // Challenges
        return Column(
          key: ValueKey('challenges_${p.title}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Key Engineering Challenges Overcome',
              Icons.flag_outlined,
            ),
            const SizedBox(height: 14),
            ...p.effectiveChallenges.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F1523)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.bolt_rounded,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item['title'] ?? '',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item['description'] ?? '',
                        style: context.textTheme.bodyMedium?.copyWith(
                          height: 1.55,
                          fontSize: 13.5,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );

      case 4: // Outcome
        return Column(
          key: ValueKey('outcome_${p.title}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Production Outcomes & Business Impact',
              Icons.insights_rounded,
            ),
            const SizedBox(height: 10),
            Text(
              'Successfully deployed to production, ensuring rock-solid stability, positive user satisfaction, and business ROI across enterprise touchpoints.',
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Verified Delivery Milestones',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...p.effectiveImpactMetrics.map((metric) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${metric['label']}: ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          Text(
                            metric['value'] ?? '',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, Project p, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (p.links.hasAny)
            GradientButton(
              text: 'Open Live App',
              leadingIcon: Icons.open_in_new_rounded,
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              onPressed: () {
                final url = p.links.web ??
                    p.links.ios ??
                    p.links.android ??
                    p.links.github;
                if (url != null) UrlLauncherHelper.launchURL(url);
              },
            )
          else
            const SizedBox.shrink(),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close Case Study'),
          ),
        ],
      ),
    );
  }
}

class _IconActionBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final String url;
  final bool isDark;

  const _IconActionBtn({
    required this.icon,
    required this.tooltip,
    required this.url,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () => UrlLauncherHelper.launchURL(url),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEDF2F7),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
