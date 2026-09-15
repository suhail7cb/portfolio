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
import 'package:portfolio/shared/components/responsive_grid.dart';

/// Section showcasing the professional summary and "What I Bring to the Table" highlights.
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
          children: [
            const SectionTitle(
              subtitle: 'GET TO KNOW ME',
              title: 'Professional Summary & Value Proposition',
              description:
                  'A decade of delivering scalable, elegant, and business-critical mobile applications across enterprise domains.',
            ),

            // Summary narrative card
            GlassContainer(
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.format_quote_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Executive Overview',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    personalInfo.professionalSummary,
                    style: context.textTheme.bodyLarge?.copyWith(
                      height: 1.7,
                      fontSize: isMobile ? 14.5 : 16,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    personalInfo.professionalDevelopmentSummary,
                    style: context.textTheme.bodyMedium?.copyWith(
                      height: 1.65,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // "What I Bring to the Table" Grid
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Icon(Icons.rocket_launch_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'What I Bring to the Table',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Responsive grid without height clipping
            ResponsiveGrid<MapEntry<int, String>>(
              items: personalInfo.highlights.asMap().entries.toList(),
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
              spacing: 16,
              runSpacing: 16,
              itemBuilder: (context, entry) {
                final int index = entry.key;
                final String highlight = entry.value;
                final IconData icon = _getHighlightIcon(index);

                return AnimatedHoverCard(
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
                );
              },
            ),
          ],
        ),
      ),
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
