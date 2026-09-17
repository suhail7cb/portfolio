import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/portfolio/domain/entities/achievement.dart';
import 'package:portfolio/shared/components/animated_hover_card.dart';
import 'package:portfolio/shared/components/badge_pill.dart';

/// Card presenting an enterprise achievement, architecture milestone, or leadership impact.
class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final Color accentColor = _getAccentColor(achievement.iconName);
    final IconData iconData = _mapIcon(achievement.iconName);

    return AnimatedHoverCard(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      hoverBorderColor: accentColor,
      borderRadius: AppDimensions.radiusXL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon & Badge Row
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.22),
                      accentColor.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.35),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  iconData,
                  size: 22,
                  color: accentColor,
                ),
              ),
              if (achievement.metricBadge != null)
                BadgePill(
                  label: achievement.metricBadge!,
                  color: accentColor.withValues(alpha: 0.12),
                  textColor: accentColor,
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Milestone Title
          Text(
            achievement.title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              letterSpacing: -0.2,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 10),

          // Milestone Narrative Description
          Text(
            achievement.description,
            style: context.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAccentColor(String? iconName) {
    switch (iconName) {
      case 'corporate_fare':
        return AppColors.primary; // Cyan
      case 'groups':
        return AppColors.secondary; // Indigo
      case 'design_services':
        return AppColors.accent; // Violet
      case 'shield':
        return AppColors.success; // Emerald
      case 'hub':
        return const Color(0xFF38BDF8); // Sky Blue
      case 'verified':
        return const Color(0xFFF59E0B); // Amber
      default:
        return AppColors.primary;
    }
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
