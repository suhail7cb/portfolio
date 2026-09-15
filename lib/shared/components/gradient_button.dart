import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';

/// Interactive button with smooth gradient, hover elevation, and optional leading/trailing icon.
class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isOutlined;
  final Gradient? customGradient;
  final double height;
  final EdgeInsetsGeometry padding;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isOutlined = false,
    this.customGradient,
    this.height = 48.0,
    this.padding = const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Gradient gradient = widget.customGradient ?? AppColors.primaryGradient;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: widget.height,
        curve: Curves.easeOut,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0.0, -2.0, 0.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          gradient: widget.isOutlined ? null : gradient,
          color: widget.isOutlined ? Colors.transparent : null,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: widget.isOutlined
              ? Border.all(
                  color: _isHovered ? AppColors.primary : AppColors.secondary,
                  width: 1.5,
                )
              : null,
          boxShadow: [
            if (!widget.isOutlined && _isHovered)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            onTap: widget.onPressed,
            child: Padding(
              padding: widget.padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.leadingIcon != null) ...[
                    Icon(
                      widget.leadingIcon,
                      size: 18,
                      color: widget.isOutlined
                          ? (context.isDarkMode ? Colors.white : AppColors.lightTextPrimary)
                          : Colors.black,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      color: widget.isOutlined
                          ? (context.isDarkMode ? Colors.white : AppColors.lightTextPrimary)
                          : Colors.black,
                    ),
                  ),
                  if (widget.trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      widget.trailingIcon,
                      size: 18,
                      color: widget.isOutlined
                          ? (context.isDarkMode ? Colors.white : AppColors.lightTextPrimary)
                          : Colors.black,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
