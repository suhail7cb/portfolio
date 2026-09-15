import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/utils/url_launcher_helper.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/shared/components/badge_pill.dart';
import 'package:portfolio/shared/components/gradient_button.dart';

/// Comprehensive modal dialog for in-depth project details, user personas, and feature lists.
class ProjectDetailDialog extends StatelessWidget {
  final Project project;

  const ProjectDetailDialog({super.key, required this.project});

  static Future<void> show(BuildContext context, Project project) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ProjectDetailDialog(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780, maxHeight: 720),
        child: Column(
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (project.category != null) ...[
                          BadgePill(
                            label: project.category!,
                            color: AppColors.primary.withValues(alpha: 0.15),
                            textColor: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          project.title,
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Modal Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Metadata Row (Client, Duration, Platforms)
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        if (project.client != null)
                          _DetailMetaChip(
                            icon: Icons.business_outlined,
                            label: 'Client',
                            value: project.client!,
                          ),
                        if (project.duration != null)
                          _DetailMetaChip(
                            icon: Icons.timer_outlined,
                            label: 'Duration',
                            value: project.duration!,
                          ),
                        if (project.platforms.isNotEmpty)
                          _DetailMetaChip(
                            icon: Icons.devices_outlined,
                            label: 'Platforms',
                            value: project.platforms.join(' • '),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Overview
                    _SectionHeading(title: 'Overview'),
                    const SizedBox(height: 8),
                    Text(
                      project.overview,
                      style: context.textTheme.bodyMedium?.copyWith(
                        height: 1.65,
                        fontSize: 15,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // User Personas
                    if (project.userPersonas.isNotEmpty) ...[
                      _SectionHeading(title: 'User Personas'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: project.userPersonas.map((persona) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEDF2F7),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                              border: Border.all(
                                color: AppColors.secondary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.person_outline, size: 16, color: AppColors.secondary),
                                const SizedBox(width: 8),
                                Text(
                                  persona,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Key Features
                    if (project.features.isNotEmpty) ...[
                      _SectionHeading(title: 'Key Features & Capabilities'),
                      const SizedBox(height: 12),
                      ...project.features.map((feature) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    height: 1.55,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],

                    // Technologies
                    if (project.technologies.isNotEmpty) ...[
                      _SectionHeading(title: 'Technologies & Architecture'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: project.technologies.map((tech) {
                          return BadgePill(
                            label: tech,
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),

            // Modal Footer
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 10,
                children: [
                  if (project.links.ios != null)
                    GradientButton(
                      text: 'App Store',
                      height: 38,
                      leadingIcon: Icons.apple,
                      onPressed: () => UrlLauncherHelper.launchURL(project.links.ios!),
                    ),
                  if (project.links.android != null)
                    GradientButton(
                      text: 'Google Play',
                      height: 38,
                      leadingIcon: Icons.shop_rounded,
                      onPressed: () => UrlLauncherHelper.launchURL(project.links.android!),
                    ),
                  if (project.links.web != null)
                    GradientButton(
                      text: 'Open Web',
                      height: 38,
                      leadingIcon: Icons.language,
                      onPressed: () => UrlLauncherHelper.launchURL(project.links.web!),
                    ),
                  if (project.links.github != null)
                    GradientButton(
                      text: 'Source Code',
                      height: 38,
                      leadingIcon: Icons.code,
                      isOutlined: true,
                      onPressed: () => UrlLauncherHelper.launchURL(project.links.github!),
                    ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailMetaChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;

  const _SectionHeading({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
    );
  }
}
