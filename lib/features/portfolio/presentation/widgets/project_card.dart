import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/utils/url_launcher_helper.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/shared/components/animated_hover_card.dart';
import 'package:portfolio/shared/components/badge_pill.dart';
import 'project_detail_dialog.dart';

/// Interactive project card showing client, duration, overview snippet, tech tags,
/// and dynamic platform store icons (iOS, Android, Web, GitHub).
class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return AnimatedHoverCard(
      onTap: () => ProjectDetailDialog.show(context, project),
      borderRadius: AppDimensions.radiusL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Content Group
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Badges (Category & Duration)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (project.category != null)
                    BadgePill(
                      label: project.category!,
                      color: AppColors.primary.withValues(alpha: 0.12),
                      textColor: AppColors.primary,
                    )
                  else
                    const SizedBox.shrink(),
                  if (project.duration != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 13,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          project.duration!,
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
              const SizedBox(height: 16),

              // Project Title
              Text(
                project.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 6),

              // Client Tag
              if (project.client != null) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.business,
                      size: 14,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        project.client!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // Overview Snippet
              Text(
                project.overview,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Bottom Content Group (Tech Chips + Actions)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tech Chips
              if (project.technologies.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: project.technologies.take(4).map((tech) {
                    return BadgePill(
                      label: tech,
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Action Link + Dynamic Platform Store Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              // Explore Details button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Explore Details',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),

              // Dynamic Platform Store Icons
              if (project.links.hasAny)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (project.links.ios != null)
                      _PlatformIconBtn(
                        icon: Icons.apple,
                        tooltip: 'Open on Apple App Store',
                        url: project.links.ios!,
                      ),
                    if (project.links.android != null)
                      _PlatformIconBtn(
                        icon: Icons.shop_rounded,
                        tooltip: 'Open on Google Play Store',
                        url: project.links.android!,
                      ),
                    if (project.links.web != null)
                      _PlatformIconBtn(
                        icon: Icons.language,
                        tooltip: 'Open Web Application',
                        url: project.links.web!,
                      ),
                    if (project.links.github != null)
                      _PlatformIconBtn(
                        icon: Icons.code,
                        tooltip: 'Open GitHub Repository',
                        url: project.links.github!,
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    ],
  ),
);
  }
}

class _PlatformIconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final String url;

  const _PlatformIconBtn({
    required this.icon,
    required this.tooltip,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(left: 4),
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
              size: 16,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
