import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/url_launcher_helper.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/shared/components/badge_pill.dart';
import 'project_case_study_dialog.dart';

/// Visual project card with image/product banner, hover zoom micro-interactions,
/// category tags, tech chips, store links, and "View Case Study →" trigger.
class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final Project p = widget.project;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => ProjectCaseStudyDialog.show(context, p),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -4.0, 0.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.8)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: isDark ? 0.22 : 0.12,
                  ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Visual Product Preview Banner with Hover Zoom
              _buildProductBanner(p, isDark),

              // 2. Card Content Body
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Category & Duration Row
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (p.category != null)
                          BadgePill(
                            label: p.category!,
                            color: AppColors.primary.withValues(alpha: 0.12),
                            textColor: AppColors.primary,
                          ),
                        if (p.duration != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 13,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                p.duration!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Project Title
                    Text(
                      p.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: isDark
                            ? Colors.white
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Client Tag
                    if (p.client != null) ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.business_rounded,
                            size: 14,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              p.client!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Overview Snippet
                    Text(
                      p.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium?.copyWith(
                        height: 1.55,
                        fontSize: 13.5,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tech Chips
                    if (p.technologies.isNotEmpty) ...[
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: p.technologies.take(4).map((tech) {
                          return BadgePill(
                            label: tech,
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE2E8F0),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),
                    ],

                    const Divider(),
                    const SizedBox(height: 14),

                    // Action Link ("View Case Study →") + Platform Store Icons
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Primary Case Study Action
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View Case Study',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: _isHovered
                                    ? AppColors.primary
                                    : (isDark
                                        ? Colors.white
                                        : AppColors.lightTextPrimary),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ],
                        ),

                        // Store Icons
                        if (p.links.hasAny)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (p.links.ios != null)
                                _PlatformIcon(
                                  icon: Icons.apple,
                                  tooltip: 'Apple App Store',
                                  url: p.links.ios!,
                                  isDark: isDark,
                                ),
                              if (p.links.android != null)
                                _PlatformIcon(
                                  icon: Icons.shop_rounded,
                                  tooltip: 'Google Play Store',
                                  url: p.links.android!,
                                  isDark: isDark,
                                ),
                              if (p.links.web != null)
                                _PlatformIcon(
                                  icon: Icons.language,
                                  tooltip: 'Web Portal',
                                  url: p.links.web!,
                                  isDark: isDark,
                                ),
                              if (p.links.github != null)
                                _PlatformIcon(
                                  icon: Icons.code,
                                  tooltip: 'GitHub',
                                  url: p.links.github!,
                                  isDark: isDark,
                                ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductBanner(Project p, bool isDark) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppDimensions.radiusL - 1),
        topRight: Radius.circular(AppDimensions.radiusL - 1),
      ),
      child: Stack(
        children: [
          // Banner Background with slight zoom on hover
          AnimatedScale(
            scale: _isHovered ? 1.04 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getCategoryAccentColor(p.category).withValues(alpha: 0.25),
                    AppColors.darkSurface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _getCategoryAccentColor(p.category),
                        AppColors.secondary,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getCategoryAccentColor(p.category).withValues(
                          alpha: 0.4,
                        ),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Icon(
                    _getCategoryIcon(p.category),
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Subtle Overlay on hover
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _isHovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.65),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: const [
                    Icon(
                      Icons.visibility_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Explore Full Case Study',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryAccentColor(String? category) {
    if (category == null) return AppColors.primary;
    if (category.contains('Retail') || category.contains('E-Commerce')) {
      return AppColors.primary;
    }
    if (category.contains('Logistics')) return const Color(0xFF38BDF8);
    if (category.contains('Blockchain') || category.contains('Fintech')) {
      return AppColors.accent;
    }
    if (category.contains('Health')) return AppColors.success;
    return AppColors.secondary;
  }

  IconData _getCategoryIcon(String? category) {
    if (category == null) return Icons.devices_rounded;
    if (category.contains('Retail') || category.contains('E-Commerce')) {
      return Icons.shopping_bag_outlined;
    }
    if (category.contains('Logistics')) return Icons.local_shipping_outlined;
    if (category.contains('Blockchain') || category.contains('Fintech')) {
      return Icons.account_balance_wallet_outlined;
    }
    if (category.contains('Health')) return Icons.favorite_outline_rounded;
    if (category.contains('Real-time')) return Icons.translate_rounded;
    return Icons.smartphone_rounded;
  }
}

class _PlatformIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final String url;
  final bool isDark;

  const _PlatformIcon({
    required this.icon,
    required this.tooltip,
    required this.url,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () => UrlLauncherHelper.launchURL(url),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEDF2F7),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Icon(
              icon,
              size: 15,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
