import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';

/// Clean pill badge for tags, technologies, and metadata labels.
class BadgePill extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isSelected;

  const BadgePill({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.icon,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    final Color effectiveBgColor = isSelected
        ? AppColors.primary
        : (color ??
            (isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.8)));

    final Color effectiveTextColor = isSelected
        ? Colors.black
        : (textColor ??
            (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary));

    Widget pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: effectiveTextColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: effectiveTextColor,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: pill,
        ),
      );
    }

    return pill;
  }
}
