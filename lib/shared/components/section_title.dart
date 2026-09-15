import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';

/// Standardized section title header with category tag and description.
class SectionTitle extends StatelessWidget {
  final String subtitle;
  final String title;
  final String? description;
  final bool isCentered;

  const SectionTitle({
    super.key,
    required this.subtitle,
    required this.title,
    this.description,
    this.isCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);

    final crossAxisAlignment =
        isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = isCentered ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        // Category Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            subtitle.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Main Title
        Text(
          title,
          textAlign: textAlign,
          style: (isMobile
                  ? context.textTheme.headlineMedium
                  : context.textTheme.displaySmall)
              ?.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            letterSpacing: -0.5,
          ),
        ),

        // Optional Description
        if (description != null) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              description!,
              textAlign: textAlign,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: isMobile ? 14 : 15.5,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
        const SizedBox(height: AppDimensions.paddingXL),
      ],
    );
  }
}
