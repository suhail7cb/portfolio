import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/theme/theme_cubit.dart';
import 'package:portfolio/features/portfolio/domain/entities/navigation_item.dart';
import 'package:portfolio/features/portfolio/domain/entities/personal_info.dart';
import 'package:portfolio/shared/components/gradient_button.dart';

/// Sticky glassmorphic top navigation bar.
class PortfolioNavBar extends StatelessWidget {
  final PersonalInfo personalInfo;
  final List<NavigationItem> navigationItems;
  final String activeSectionKey;
  final void Function(String sectionKey) onNavTap;
  final VoidCallback onOpenDrawer;
  final ScrollController? scrollController;

  const PortfolioNavBar({
    super.key,
    required this.personalInfo,
    required this.navigationItems,
    required this.activeSectionKey,
    required this.onNavTap,
    required this.onOpenDrawer,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (scrollController != null) {
      return ListenableBuilder(
        listenable: scrollController!,
        builder: (context, _) {
          final double scrollOffset = scrollController!.hasClients
              ? scrollController!.offset
              : 0.0;
          return _buildNavBarContent(context, scrollOffset);
        },
      );
    }
    return _buildNavBarContent(context, 0.0);
  }

  Widget _buildNavBarContent(BuildContext context, double scrollOffset) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);
    final themeCubit = context.watch<ThemeCubit>();

    // Scroll progress as user scrolls down (0.0 at top to 2.0 as user scrolls past 180px)
    final double scrollProgress = (scrollOffset / 180.0).clamp(0.0, 2.0);
    final double avatarSize = isMobile
        ? (36.0 + scrollProgress * 4.0)
        : (38.0 + scrollProgress * 8.0);
    final double borderAlpha = 0.7 + (scrollProgress * 0.3);
    final double shadowAlpha = 0.25 + (scrollProgress * 0.35);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: AppDimensions.navBarHeight,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? AppDimensions.paddingL
                : AppDimensions.paddingXXL,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkBackground.withValues(alpha: 0.85)
                : AppColors.lightBackground.withValues(alpha: 0.90),
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            children: [
              // Brand: Picture, Name & Role (Always on top across the entire page)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => onNavTap('hero'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Resized Profile Picture: Remains permanently at top even when at bottom of page
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(
                              alpha: borderAlpha,
                            ),
                            width: 1.5 + (scrollProgress * 0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                alpha: shadowAlpha,
                              ),
                              blurRadius: 8.0 + (scrollProgress * 6.0),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            personalInfo.profileImageUrl ??
                                'assets/images/profile.jpeg',
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (_, __, ___) => Container(
                              decoration: const BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  _getInitials(personalInfo.name),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            personalInfo.name,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: isMobile ? 14 : 15.5,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            personalInfo.title,
                            style: TextStyle(
                              fontSize: isMobile ? 10.5 : 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Desktop Navigation Links
              if (!isMobile) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: navigationItems.map((item) {
                    final bool isActive = activeSectionKey == item.sectionKey;
                    return _NavBarItem(
                      label: item.label,
                      isActive: isActive,
                      onTap: () => onNavTap(item.sectionKey),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 16),
              ],

              // Theme Switch Toggle
              IconButton(
                icon: Icon(
                  themeCubit.isDark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  color: isDark ? AppColors.primary : AppColors.secondary,
                  size: 20,
                ),
                tooltip: themeCubit.isDark
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
                onPressed: () => themeCubit.toggleTheme(),
              ),

              // Resume CTA or Contact CTA
              if (!isMobile) ...[
                const SizedBox(width: 12),
                GradientButton(
                  text: 'Get in Touch',
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  onPressed: () => onNavTap('contact'),
                ),
              ],

              // Mobile Menu Button
              if (isMobile) ...[
                const SizedBox(width: 6),
                IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    size: 26,
                  ),
                  onPressed: onOpenDrawer,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      // return '<${parts.first[0]}${parts.last[0]} />';
      return '${parts.first[0]}${parts.last[0]}';
    } else if (parts.isNotEmpty && parts.first.isNotEmpty) {
      // return '<${parts.first[0]} />';
      return parts.first[0];
    }
    return 'SS';
  }
}

class _NavBarItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    final Color textColor = widget.isActive
        ? AppColors.primary
        : (_isHovered
              ? (isDark ? Colors.white : Colors.black)
              : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: widget.isActive
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive || _isHovered ? 20 : 0,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
