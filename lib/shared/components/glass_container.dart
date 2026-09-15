import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';

/// Reusable glassmorphic container with backdrop blur, subtle gradient, and border.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? customBorderColor;
  final Color? customBackgroundColor;
  final double blur;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(AppDimensions.paddingL),
    this.margin,
    this.borderRadius = AppDimensions.radiusL,
    this.customBorderColor,
    this.customBackgroundColor,
    this.blur = 16.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    final Color bgColor = customBackgroundColor ??
        (isDark
            ? AppColors.darkCard.withValues(alpha: 0.72)
            : AppColors.lightCard.withValues(alpha: 0.85));

    final Color borderColor = customBorderColor ??
        (isDark
            ? AppColors.darkBorder.withValues(alpha: 0.8)
            : AppColors.lightBorder.withValues(alpha: 0.9));

    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: content,
        ),
      );
    }

    return content;
  }
}
