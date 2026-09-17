import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/features/portfolio/domain/entities/experience.dart';
import 'package:portfolio/shared/components/badge_pill.dart';
import 'package:portfolio/shared/components/gradient_button.dart';

/// Comprehensive modal dialog for expanded experience details, tabbed sections,
/// and pagination across roles. Matches the high-fidelity specification mockup.
class ExperienceDetailDialog extends StatefulWidget {
  final List<Experience> experiences;
  final int initialIndex;
  final void Function(String projectTitle)? onNavigateToProject;

  const ExperienceDetailDialog({
    super.key,
    required this.experiences,
    this.initialIndex = 0,
    this.onNavigateToProject,
  });

  static Future<void> show(
    BuildContext context, {
    required List<Experience> experiences,
    int initialIndex = 0,
    void Function(String projectTitle)? onNavigateToProject,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ExperienceDetailDialog(
        experiences: experiences,
        initialIndex: initialIndex,
        onNavigateToProject: onNavigateToProject,
      ),
    );
  }

  @override
  State<ExperienceDetailDialog> createState() => _ExperienceDetailDialogState();
}

class _ExperienceDetailDialogState extends State<ExperienceDetailDialog> {
  late int _currentIndex;
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Overview',
    'Responsibilities',
    'Technologies',
    'Impact',
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.experiences.length - 1);
  }

  Experience get _currentExperience => widget.experiences[_currentIndex];

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.experiences.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);
    final Experience exp = _currentExperience;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : 32,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 760),
        child: Column(
          children: [
            // 1. Top App Bar: Close, Title, Pagination (‹ 1/5 ›)
            _buildTopBar(context, isDark),

            // 2. Body Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 18 : 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card (Company, Role, Duration, Badge)
                    _buildRoleBanner(context, exp, isDark, isMobile),

                    const SizedBox(height: 24),

                    // Segmented Tabs Header
                    _buildTabsHeader(isDark, isMobile),

                    const SizedBox(height: 24),

                    // Active Tab Content with smooth transition
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: _buildTabContent(exp, isDark, isMobile),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Modal Footer CTA Bar
            _buildFooter(context, exp, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
          // Close button
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 22),
            tooltip: 'Close Details',
            onPressed: () => Navigator.of(context).pop(),
          ),

          // Title
          Text(
            'Experience Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),

          // Pagination Controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 22),
                tooltip: 'Previous Experience',
                onPressed: _currentIndex > 0 ? _goToPrevious : null,
                color: _currentIndex > 0
                    ? AppColors.primary
                    : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
              Text(
                '${_currentIndex + 1} / ${widget.experiences.length}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 22),
                tooltip: 'Next Experience',
                onPressed: _currentIndex < widget.experiences.length - 1 ? _goToNext : null,
                color: _currentIndex < widget.experiences.length - 1
                    ? AppColors.primary
                    : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBanner(BuildContext context, Experience exp, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1523) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: exp.isCurrent ? AppColors.primary.withValues(alpha: 0.4) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Monogram
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: exp.isCurrent
                  ? AppColors.primaryGradient
                  : LinearGradient(
                      colors: [
                        AppColors.secondary.withValues(alpha: 0.8),
                        AppColors.accent.withValues(alpha: 0.8),
                      ],
                    ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Center(
              child: Text(
                _getMonogram(exp.company),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Titles & Dates
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        exp.company,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    if (exp.durationText != null)
                      BadgePill(
                        label: exp.durationText!,
                        color: exp.isCurrent ? AppColors.primary.withValues(alpha: 0.15) : null,
                        textColor: exp.isCurrent ? AppColors.primary : null,
                      ),
                  ],
                ),
                const SizedBox(height: 4),

                Text(
                  exp.role,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 14,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      exp.period,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        exp.location,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF131B2C) : const Color(0xFFEDF2F7)),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? Colors.black
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent(Experience exp, bool isDark, bool isMobile) {
    switch (_selectedTabIndex) {
      case 0: // Overview
        return Column(
          key: ValueKey('overview_${exp.company}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About this role',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              exp.description ??
                  'Leading technical architecture, engineering execution, and mobile solutions delivery for production systems.',
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.65,
                fontSize: 14.5,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111726) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 20, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Domain Focus: Enterprise Mobile Solutions, High Concurrency Architecture, and Cross-Functional Mentorship.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case 1: // Responsibilities
        return Column(
          key: ValueKey('responsibilities_${exp.company}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Core Responsibilities & Delivery',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 14),
            ...exp.responsibilities.map((resp) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 11,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        resp,
                        style: context.textTheme.bodyMedium?.copyWith(
                          height: 1.55,
                          fontSize: 14,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );

      case 2: // Technologies
        return Column(
          key: ValueKey('tech_${exp.company}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Technologies & Toolchain',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exp.technologies.map((tech) {
                return BadgePill(
                  label: tech,
                  color: isDark ? const Color(0xFF192238) : const Color(0xFFE2E8F0),
                  textColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                );
              }).toList(),
            ),
          ],
        );

      case 3: // Impact
        return Column(
          key: ValueKey('impact_${exp.company}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verified Impact & Milestones',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 14),
            ...exp.impact.map((point) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F1523) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 18, color: AppColors.secondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFooter(BuildContext context, Experience exp, bool isDark) {
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
          if (exp.associatedProjectTitle != null && widget.onNavigateToProject != null)
            GradientButton(
              text: 'View Project / Case Study',
              leadingIcon: Icons.launch_rounded,
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onNavigateToProject!(exp.associatedProjectTitle!);
              },
            )
          else
            const SizedBox.shrink(),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getMonogram(String company) {
    if (company.toLowerCase().contains('cognizant')) return 'C';
    if (company.toLowerCase().contains('dlt')) return 'DLT';
    if (company.toLowerCase().contains('mobile programming')) return 'MP';
    if (company.toLowerCase().contains('code brew')) return 'CB';
    if (company.toLowerCase().contains('retisense')) return 'RT';

    final words = company.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return company.isNotEmpty ? company.substring(0, 1).toUpperCase() : 'SS';
  }
}
