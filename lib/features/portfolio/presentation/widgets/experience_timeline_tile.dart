import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/features/portfolio/domain/entities/experience.dart';
import 'package:portfolio/shared/components/glass_container.dart';
import 'package:portfolio/shared/components/badge_pill.dart';

/// Vertical timeline tile for professional work experience.
class ExperienceTimelineTile extends StatelessWidget {
  final Experience experience;
  final bool isFirst;
  final bool isLast;

  const ExperienceTimelineTile({
    super.key,
    required this.experience,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Node & Line
          SizedBox(
            width: isMobile ? 32 : 48,
            child: Column(
              children: [
                // Top line
                Container(
                  width: 2,
                  height: isFirst ? 16 : 24,
                  color: isFirst
                      ? Colors.transparent
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                // Illuminated Node
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: experience.isCurrent ? AppColors.primary : AppColors.secondary,
                    border: Border.all(
                      color: isDark ? AppColors.darkBackground : Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      if (experience.isCurrent)
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.6),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                ),
                // Bottom connecting line
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
              ],
            ),
          ),

          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: GlassContainer(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                customBorderColor: experience.isCurrent
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Period & Status row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            experience.period,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: experience.isCurrent
                                  ? AppColors.primary
                                  : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
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
                    const SizedBox(height: 10),

                    // Role & Company
                    Text(
                      experience.role,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(
                          Icons.apartment,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          experience.company,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          experience.location,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Key Responsibilities List
                    ...experience.responsibilities.map((resp) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? AppColors.primary.withValues(alpha: 0.8)
                                    : AppColors.secondary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                resp,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
