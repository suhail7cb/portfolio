import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/portfolio/domain/entities/skill_group.dart';
import 'package:portfolio/shared/components/glass_container.dart';

/// Interactive skill group container displaying capability category,
/// contextual icon, description, and interactive skill chips without percentage bars.
class SkillChipGroup extends StatelessWidget {
  final SkillGroup skillGroup;

  const SkillChipGroup({super.key, required this.skillGroup});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final IconData categoryIcon = _getCategoryIcon(skillGroup.categoryName);

    return GlassContainer(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      borderRadius: AppDimensions.radiusXL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header with Icon & Name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  categoryIcon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skillGroup.categoryName,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isDark
                            ? Colors.white
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    if (skillGroup.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        skillGroup.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF161E33)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  '${skillGroup.skills.length}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Skills Chips Wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skillGroup.skills.map((skill) {
              return _SkillPill(skill: skill);
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('core') || lower.contains('mobile')) {
      return Icons.smartphone_rounded;
    }
    if (lower.contains('architecture') || lower.contains('system')) {
      return Icons.account_tree_outlined;
    }
    if (lower.contains('tool') || lower.contains('devops')) {
      return Icons.terminal_rounded;
    }
    if (lower.contains('leadership') || lower.contains('management')) {
      return Icons.groups_rounded;
    }
    if (lower.contains('advanced') || lower.contains('security')) {
      return Icons.shield_outlined;
    }
    return Icons.code_rounded;
  }
}

class _SkillPill extends StatefulWidget {
  final SkillItem skill;

  const _SkillPill({required this.skill});

  @override
  State<_SkillPill> createState() => _SkillPillState();
}

class _SkillPillState extends State<_SkillPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    Color levelColor;
    switch (widget.skill.level) {
      case 'Expert':
        levelColor = AppColors.primary;
        break;
      case 'Advanced':
        levelColor = AppColors.secondary;
        break;
      default:
        levelColor = AppColors.success;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovered
              ? levelColor.withValues(alpha: 0.15)
              : (isDark ? const Color(0xFF141C2E) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: _isHovered
                ? levelColor
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: 1,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: levelColor.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.skill.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            if (widget.skill.level != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: levelColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.skill.level!,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: levelColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
