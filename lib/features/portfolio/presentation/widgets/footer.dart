import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/utils/url_launcher_helper.dart';
import 'package:portfolio/features/portfolio/domain/entities/personal_info.dart';
import 'package:portfolio/features/portfolio/domain/entities/social_link.dart';
import 'package:portfolio/features/portfolio/domain/entities/navigation_item.dart';

/// Clean footer with quick links, social channels, and configuration branding.
class PortfolioFooter extends StatelessWidget {
  final PersonalInfo personalInfo;
  final List<NavigationItem> navigationItems;
  final List<SocialLink> socialLinks;
  final void Function(String sectionKey) onNavTap;

  const PortfolioFooter({
    super.key,
    required this.personalInfo,
    required this.navigationItems,
    required this.socialLinks,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF070A0F) : const Color(0xFFF1F5F9),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppDimensions.paddingL
            : AppDimensions.paddingXXL,
        vertical: AppDimensions.paddingXXL,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.desktopMaxWidth,
          ),
          child: Column(
            children: [
              // Top Row (Brand + Nav Links + Social Links)
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildBrand(context, isDark),
                        const SizedBox(height: 20),
                        _buildSocials(isDark),
                        const SizedBox(height: 20),
                        _buildNav(isDark),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildBrand(context, isDark),
                        _buildNav(isDark),
                        _buildSocials(isDark),
                      ],
                    ),

              const SizedBox(height: 32),
              Divider(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              const SizedBox(height: 24),

              // Bottom Row (Copyright & Architecture notice)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '© ${DateTime.now().year} ${personalInfo.name}. All rights reserved.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        // 'Built with Flutter Clean Architecture',
                        '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.lock_outline_rounded, size: 14),
                        tooltip: 'Admin Portal',
                        color: isDark
                            ? AppColors.darkTextMuted.withValues(alpha: 0.5)
                            : AppColors.lightTextMuted.withValues(alpha: 0.5),
                        hoverColor: AppColors.primary.withValues(alpha: 0.15),
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/admin'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrand(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'SS ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              personalInfo.name,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          personalInfo.title,
          style: TextStyle(
            fontSize: 12.5,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildNav(bool isDark) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: navigationItems.map((item) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onNavTap(item.sectionKey),
            child: Text(
              item.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSocials(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: socialLinks.map((link) {
        final icon = _mapSocialIcon(link.iconKey);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: IconButton(
            icon: Icon(icon, size: 20),
            tooltip: link.label,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            hoverColor: AppColors.primary.withValues(alpha: 0.15),
            onPressed: () => UrlLauncherHelper.launchURL(link.url),
          ),
        );
      }).toList(),
    );
  }

  IconData _mapSocialIcon(String key) {
    switch (key.toLowerCase()) {
      case 'github':
        return Icons.code_rounded;
      case 'linkedin':
        return Icons.link_rounded;
      case 'email':
        return Icons.email_outlined;
      case 'phone':
        return Icons.phone_outlined;
      default:
        return Icons.open_in_new_rounded;
    }
  }
}
