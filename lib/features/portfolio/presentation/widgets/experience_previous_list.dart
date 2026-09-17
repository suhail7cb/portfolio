import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/portfolio/domain/entities/experience.dart';
import 'package:portfolio/shared/components/glass_container.dart';

/// Sidebar listing all career roles with quick-jump selection.
class ExperiencePreviousList extends StatelessWidget {
  final List<Experience> experiences;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ExperiencePreviousList({
    super.key,
    required this.experiences,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: AppDimensions.radiusXL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  size: 16,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Career Journey',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List of experiences
          ...List.generate(experiences.length, (index) {
            final experience = experiences[index];
            final bool isSelected = index == selectedIndex;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ExperienceItemTile(
                experience: experience,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () => onSelect(index),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ExperienceItemTile extends StatefulWidget {
  final Experience experience;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ExperienceItemTile({
    required this.experience,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_ExperienceItemTile> createState() => _ExperienceItemTileState();
}

class _ExperienceItemTileState extends State<_ExperienceItemTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isHighlighted = widget.isSelected || _isHovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primary.withValues(alpha: 0.12)
                : (_isHovered
                    ? (widget.isDark ? const Color(0xFF161E33) : const Color(0xFFEDF2F7))
                    : (widget.isDark ? const Color(0xFF0F1523) : const Color(0xFFF8FAFC))),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary
                  : (_isHovered
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : (widget.isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              width: widget.isSelected ? 1.4 : 1.0,
            ),
            boxShadow: [
              if (isHighlighted)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: widget.isSelected ? 0.18 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              // Small indicator icon / monogram
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? AppColors.primary
                      : (widget.isDark ? const Color(0xFF1B243B) : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Center(
                  child: Icon(
                    widget.experience.isCurrent
                        ? Icons.work_rounded
                        : Icons.apartment_rounded,
                    size: 16,
                    color: widget.isSelected
                        ? Colors.black
                        : (widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title and Role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.experience.company,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: widget.isSelected
                            ? AppColors.primary
                            : (widget.isDark ? Colors.white : AppColors.lightTextPrimary),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.experience.role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.experience.period,
                      style: TextStyle(
                        fontSize: 11,
                        color: widget.isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: widget.isSelected
                    ? AppColors.primary
                    : (widget.isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
