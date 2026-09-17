import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/features/portfolio/domain/entities/experience.dart';
import 'package:portfolio/shared/components/badge_pill.dart';
import 'package:portfolio/shared/components/glass_container.dart';
import 'package:portfolio/shared/components/gradient_button.dart';

/// Large focused card for the selected career experience.
/// Displays company branding, role, period, description, tech stack,
/// concise responsibilities, and measurable impact metrics.
class ExperienceFocusCard extends StatelessWidget {
  final Experience experience;
  final VoidCallback onViewDetails;

  const ExperienceFocusCard({
    super.key,
    required this.experience,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);

    return GlassContainer(
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      borderRadius: AppDimensions.radiusXL,
      customBorderColor: experience.isCurrent
          ? AppColors.primary.withValues(alpha: 0.35)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Top Header: Company Avatar + Name + Role + Period + Current Badge
          _buildHeader(context, isDark, isMobile),

          const SizedBox(height: 18),

          // 2. Short Role Description
          if (experience.description != null && experience.description!.isNotEmpty) ...[
            Text(
              experience.description!,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: isMobile ? 14 : 15,
                height: 1.6,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 18),
          ],

          // 3. Technology Chips
          if (experience.technologies.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: experience.technologies.map((tech) {
                return BadgePill(
                  label: tech,
                  color: isDark
                      ? const Color(0xFF161F33)
                      : const Color(0xFFEDF2F7),
                  textColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          const Divider(),
          const SizedBox(height: 20),

          // 4. Split: Responsibilities & Impact
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isNarrow = constraints.maxWidth < 620;

              if (isNarrow || experience.impact.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResponsibilities(context, isDark),
                    if (experience.impact.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildImpactPanel(context, isDark),
                    ],
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildResponsibilities(context, isDark),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 4,
                    child: _buildImpactPanel(context, isDark),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // 5. Actions Footer: "View Details →"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GradientButton(
                text: 'View Details',
                trailingIcon: Icons.arrow_forward_rounded,
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                onPressed: onViewDetails,
              ),
              if (experience.associatedProjectTitle != null)
                Tooltip(
                  message: 'Related project in portfolio',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.layers_outlined,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        experience.associatedProjectTitle!,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Monogram/Logo Container
        Container(
          width: isMobile ? 44 : 52,
          height: isMobile ? 44 : 52,
          decoration: BoxDecoration(
            gradient: experience.isCurrent
                ? AppColors.primaryGradient
                : LinearGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.8),
                      AppColors.accent.withValues(alpha: 0.8),
                    ],
                  ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            boxShadow: [
              BoxShadow(
                color: (experience.isCurrent ? AppColors.primary : AppColors.secondary)
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _getCompanyMonogram(experience.company),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: isMobile ? 15 : 18,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Company Name & Role Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      experience.company,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  if (experience.durationText != null)
                    BadgePill(
                      label: experience.durationText!,
                      color: experience.isCurrent
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : null,
                      textColor: experience.isCurrent ? AppColors.primary : null,
                    ),
                ],
              ),
              const SizedBox(height: 4),

              Text(
                experience.role,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 13,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    experience.period,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.location_on_outlined,
                    size: 13,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      experience.location,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildResponsibilities(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Key Responsibilities',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...experience.responsibilities.take(4).map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 13.5,
                      height: 1.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildImpactPanel(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1523) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights_rounded, size: 16, color: AppColors.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Impact & Leadership',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...experience.impact.map((point) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    size: 15,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getCompanyMonogram(String company) {
    if (company.toLowerCase().contains('cognizant')) return 'C';
    if (company.toLowerCase().contains('dlt')) return 'DLT';
    if (company.toLowerCase().contains('mobile programming')) return 'MP';
    if (company.toLowerCase().contains('code brew')) return 'CB';
    if (company.toLowerCase().contains('retisense')) return 'RT';

    final words = company.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return company.isNotEmpty ? company.substring(0, 1).toUpperCase() : 'EXP';
  }
}
