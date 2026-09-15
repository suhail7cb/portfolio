import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/portfolio/domain/entities/education.dart';
import 'package:portfolio/features/portfolio/domain/entities/certification.dart';
import 'package:portfolio/shared/components/section_title.dart';
import 'package:portfolio/shared/components/glass_container.dart';
import 'package:portfolio/shared/components/badge_pill.dart';
import 'package:portfolio/shared/components/animated_hover_card.dart';

/// Section rendering academic degrees and modern AI certifications side-by-side.
class EducationCertificationsSection extends StatelessWidget {
  final List<Education> educationList;
  final List<Certification> certifications;

  const EducationCertificationsSection({
    super.key,
    required this.educationList,
    required this.certifications,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
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
              subtitle: 'ACADEMICS & CERTIFICATIONS',
              title: 'Education & Continuous Learning',
              description:
                  'Groundwork in computer science coupled with continuous mastery of modern AI workflows and tools.',
            ),

            isMobile
                ? Column(
                    children: [
                      _buildEducationColumn(context, isDark),
                      const SizedBox(height: 36),
                      _buildCertificationsColumn(context, isDark),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildEducationColumn(context, isDark)),
                      const SizedBox(width: 32),
                      Expanded(child: _buildCertificationsColumn(context, isDark)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationColumn(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.school_outlined, color: AppColors.primary, size: 22),
            const SizedBox(width: 10),
            Text(
              'Educational Timeline',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...educationList.map((edu) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassContainer(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          edu.degree,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      BadgePill(
                        label: edu.year,
                        color: AppColors.primary.withValues(alpha: 0.12),
                        textColor: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    edu.institution,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    edu.details,
                    style: context.textTheme.bodyMedium?.copyWith(
                      height: 1.55,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCertificationsColumn(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.psychology_outlined, color: AppColors.secondary, size: 22),
            const SizedBox(width: 10),
            Text(
              'Certifications & Continuous Learning',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...certifications.map((cert) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AnimatedHoverCard(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              hoverBorderColor: AppColors.primary,
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
                        child: const Icon(Icons.bookmark_added_outlined,
                            color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          cert.title,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cert.description,
                    style: context.textTheme.bodyMedium?.copyWith(
                      height: 1.55,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
