import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/portfolio/domain/entities/personal_info.dart';
import 'package:portfolio/shared/components/section_title.dart';
import 'package:portfolio/shared/components/glass_container.dart';
import 'package:portfolio/shared/components/animated_hover_card.dart';
import 'package:portfolio/shared/components/badge_pill.dart';

/// Section showcasing About Me, Engineering DNA, and What I Bring to the Table highlights.
class SummaryHighlightsSection extends StatelessWidget {
  final PersonalInfo personalInfo;

  const SummaryHighlightsSection({super.key, required this.personalInfo});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            const Center(
              child: SectionTitle(
                subtitle: 'ABOUT ME & ENGINEERING DNA',
                title: 'Architectural Mindset, Product Thinking',
                description:
                    'A decade of delivering scalable, elegant, and business-critical mobile applications across global enterprise domains.',
              ),
            ),

            // 1. About Me Narrative Card (Eliminates wall of text)
            _buildAboutCard(context, isDark, isMobile),
            const SizedBox(height: 48),

            // 2. Engineering DNA Visual Pipeline
            _buildEngineeringDna(context, isDark, isMobile, isTablet),
            const SizedBox(height: 52),

            // 3. What I Bring to the Table (Verified Highlights)
            _buildHighlightsSection(context, isDark, isMobile, isTablet),
          ],
        ),
      ),
    );
  }

  /// 1. About Me Card with Executive Intro and Capability Tags
  Widget _buildAboutCard(BuildContext context, bool isDark, bool isMobile) {
    const capabilityTags = [
      {'label': 'Problem Solver', 'icon': Icons.lightbulb_outline_rounded},
      {'label': 'Team Player', 'icon': Icons.groups_outlined},
      {'label': 'Continuous Learner', 'icon': Icons.auto_stories_outlined},
    ];

    return GlassContainer(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.25),
                      AppColors.secondary.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ),
                child: const Icon(
                  Icons.person_pin_circle_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Me',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: isMobile ? 18 : 20,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Senior Mobile Engineer & Solutions Architect',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Short Professional Introduction
          Text(
            personalInfo.professionalSummary,
            style: context.textTheme.bodyLarge?.copyWith(
              height: 1.7,
              fontSize: isMobile ? 14.5 : 16,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 22),

          const Divider(),
          const SizedBox(height: 18),

          // Capability Tags Row
          Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Core Mindset:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              ...capabilityTags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF131D33)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tag['icon'] as IconData,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tag['label'] as String,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Engineering DNA Visual Flow (Product Thinking -> Architecture + Quality + Delivery)
  Widget _buildEngineeringDna(
    BuildContext context,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    return Column(
      children: [
        // DNA Header
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.hub_outlined, size: 14, color: AppColors.secondary),
                    SizedBox(width: 6),
                    Text(
                      'ENGINEERING DNA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'How I Approach Engineering',
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: isMobile ? 22 : 26,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Text(
                  'Bridging product goals into resilient, scalable mobile architectures with relentless commitment to code quality and delivery velocity.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Visual Anchor: Product Thinking
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.22),
                  AppColors.secondary.withValues(alpha: 0.22),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.5),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Product Thinking',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'User-Centric Architecture • Business Value Alignment',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Visual Connector Arrow (Product Thinking ↓ Architecture + Quality + Delivery)
        Center(
          child: Column(
            children: [
              Container(
                width: 2,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.6),
                      AppColors.secondary.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_downward_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              Container(
                width: 2,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.6),
                      AppColors.primary.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 3 Pillars: Architecture, Quality, Delivery
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = isMobile
                ? constraints.maxWidth
                : (constraints.maxWidth - (isTablet ? 16 : 32)) / 3;

            final pillars = [
              _DnaPillar(
                title: 'Architecture',
                icon: Icons.architecture_rounded,
                accentColor: AppColors.primary,
                subPoints: ['Clean', 'Modular', 'Scalable'],
                description:
                    'Clean Architecture, MVVM & BLoC state isolation ensuring maintainable codebases that scale effortlessly.',
                isDark: isDark,
              ),
              _DnaPillar(
                title: 'Quality',
                icon: Icons.verified_user_outlined,
                accentColor: AppColors.secondary,
                subPoints: ['Testing', 'Code Reviews', 'Security'],
                description:
                    'Comprehensive unit testing, zero-trust security practices, and peer review rigor to prevent production defects.',
                isDark: isDark,
              ),
              _DnaPillar(
                title: 'Delivery',
                icon: Icons.rocket_launch_outlined,
                accentColor: AppColors.success,
                subPoints: ['CI/CD', 'Release', 'Monitoring'],
                description:
                    'Automated build pipelines, phased store rollouts, and real-time crash telemetry for continuous reliability.',
                isDark: isDark,
              ),
            ];

            return Wrap(
              spacing: isTablet ? 16 : 16,
              runSpacing: 16,
              children: pillars.map((pillar) {
                return SizedBox(
                  width: cardWidth,
                  child: pillar,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  /// 3. What I Bring to the Table (Verified Highlights)
  Widget _buildHighlightsSection(
    BuildContext context,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.stars_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'What I Bring to the Table',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 18 : 20,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        LayoutBuilder(
          builder: (context, constraints) {
            final count = isMobile ? 1 : (isTablet ? 2 : 3);
            final double spacing = 16;
            final itemWidth = (constraints.maxWidth - (spacing * (count - 1))) / count;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: personalInfo.highlights.asMap().entries.map((entry) {
                final int index = entry.key;
                final String highlight = entry.value;
                final IconData icon = _getHighlightIcon(index);

                return SizedBox(
                  width: itemWidth,
                  child: AnimatedHoverCard(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                          child: Icon(icon, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            highlight,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.45,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  IconData _getHighlightIcon(int index) {
    switch (index) {
      case 0:
        return Icons.code_rounded;
      case 1:
        return Icons.palette_outlined;
      case 2:
        return Icons.group_work_outlined;
      case 3:
        return Icons.cloud_sync_outlined;
      case 4:
        return Icons.speed_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }
}

/// DNA Pillar Card with interactive hover, accent icon, sub-points, and description
class _DnaPillar extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<String> subPoints;
  final String description;
  final bool isDark;

  const _DnaPillar({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.subPoints,
    required this.description,
    required this.isDark,
  });

  @override
  State<_DnaPillar> createState() => _DnaPillarState();
}

class _DnaPillarState extends State<_DnaPillar> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: widget.isDark
              ? (_isHovered ? const Color(0xFF131D33) : const Color(0xFF0F172A))
              : (_isHovered ? const Color(0xFFF1F5F9) : Colors.white),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.6)
                : (widget.isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder),
            width: _isHovered ? 1.4 : 1.0,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: widget.accentColor.withValues(alpha: 0.15),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon & Title Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(
                      color: widget.accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 22,
                    color: widget.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: widget.isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sub-points Chips
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.subPoints.map((point) {
                return BadgePill(
                  label: point,
                  color: widget.accentColor.withValues(alpha: 0.12),
                  textColor: widget.accentColor,
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Description
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: widget.isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
