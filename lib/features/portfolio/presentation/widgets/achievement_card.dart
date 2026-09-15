import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/portfolio/domain/entities/achievement.dart';
import 'package:portfolio/shared/components/animated_hover_card.dart';
import 'package:portfolio/shared/components/badge_pill.dart';

/// Card presenting an enterprise achievement or leadership impact milestone.
class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    final IconData iconData = _mapIcon(achievement.iconName);

    return AnimatedHoverCard(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      hoverBorderColor: AppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon & Badge Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(
                  iconData,
                  size: 22,
                  color: AppColors.secondary,
                ),
              ),
              if (achievement.metricBadge != null)
                BadgePill(
                  label: achievement.metricBadge!,
                  color: AppColors.primary.withValues(alpha: 0.12),
                  textColor: AppColors.primary,
                ),
            ],
          ),
          const SizedBox(height: 18),

          // Title
          Text(
            achievement.title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 10),

          // Description
          Text(
            achievement.description,
            style: context.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _mapIcon(String? iconName) {
    switch (iconName) {
      case 'corporate_fare':
        return Icons.corporate_fare_rounded;
      case 'groups':
        return Icons.groups_rounded;
      case 'design_services':
        return Icons.auto_awesome_rounded;
      case 'shield':
        return Icons.shield_outlined;
      case 'hub':
        return Icons.hub_rounded;
      case 'verified':
        return Icons.verified_user_outlined;
      default:
        return Icons.star_border_rounded;
    }
  }
}
