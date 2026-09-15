import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';

/// Card wrapper that elevates on hover with dynamic border glow.
class AnimatedHoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? hoverBorderColor;

  const AnimatedHoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = AppDimensions.radiusL,
    this.padding = const EdgeInsets.all(AppDimensions.paddingL),
    this.hoverBorderColor,
  });

  @override
  State<AnimatedHoverCard> createState() => _AnimatedHoverCardState();
}

class _AnimatedHoverCardState extends State<AnimatedHoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final Color glowColor = widget.hoverBorderColor ?? AppColors.primary;

    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -4.0, 0.0))
              : Matrix4.identity(),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isHovered
                  ? glowColor.withValues(alpha: 0.8)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: glowColor.withValues(alpha: isDark ? 0.22 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
