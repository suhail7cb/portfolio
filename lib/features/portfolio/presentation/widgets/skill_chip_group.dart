import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/portfolio/domain/entities/skill_group.dart';
import 'package:portfolio/shared/components/glass_container.dart';

/// Interactive skill group container displaying skills and their proficiency levels.
class SkillChipGroup extends StatelessWidget {
  final SkillGroup skillGroup;

  const SkillChipGroup({super.key, required this.skillGroup});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return GlassContainer(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Title
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  skillGroup.categoryName,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            skillGroup.description,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 18),

          // Skills Wrap
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
              : (isDark ? const Color(0xFF161E33) : const Color(0xFFF1F5F9)),
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
                color: levelColor.withValues(alpha: 0.2),
                blurRadius: 10,
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
                  color: levelColor.withValues(alpha: 0.2),
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
