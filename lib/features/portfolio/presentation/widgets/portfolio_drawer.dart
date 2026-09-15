import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/theme/theme_cubit.dart';
import 'package:portfolio/features/portfolio/domain/entities/navigation_item.dart';
import 'package:portfolio/features/portfolio/domain/entities/personal_info.dart';
import 'package:portfolio/shared/components/gradient_button.dart';

/// Mobile slide-in drawer for smooth on-the-go navigation.
class PortfolioDrawer extends StatelessWidget {
  final PersonalInfo personalInfo;
  final List<NavigationItem> navigationItems;
  final String activeSectionKey;
  final void Function(String sectionKey) onNavTap;

  const PortfolioDrawer({
    super.key,
    required this.personalInfo,
    required this.navigationItems,
    required this.activeSectionKey,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final themeCubit = context.watch<ThemeCubit>();

    return Drawer(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        personalInfo.name,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'iOS & Flutter Specialist',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),

              // Navigation List
              Expanded(
                child: ListView.builder(
                  itemCount: navigationItems.length,
                  itemBuilder: (context, index) {
                    final item = navigationItems[index];
                    final bool isActive = activeSectionKey == item.sectionKey;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                      selected: isActive,
                      selectedTileColor: AppColors.primary.withValues(alpha: 0.12),
                      title: Text(
                        item.label,
                        style: TextStyle(
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive
                              ? AppColors.primary
                              : (isDark ? Colors.white : AppColors.lightTextPrimary),
                        ),
                      ),
                      trailing: isActive
                          ? const Icon(Icons.chevron_right, color: AppColors.primary)
                          : null,
                      onTap: () {
                        Navigator.of(context).pop();
                        onNavTap(item.sectionKey);
                      },
                    );
                  },
                ),
              ),

              const Divider(),
              const SizedBox(height: 12),

              // Theme Switcher & CTA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    themeCubit.isDark ? 'Dark Theme' : 'Light Theme',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch.adaptive(
                    value: themeCubit.isDark,
                    activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                    activeColor: AppColors.primary,
                    onChanged: (_) => themeCubit.toggleTheme(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              GradientButton(
                text: 'Contact Suhail',
                leadingIcon: Icons.mail_outline,
                onPressed: () {
                  Navigator.of(context).pop();
                  onNavTap('contact');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
