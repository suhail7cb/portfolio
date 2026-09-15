import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/portfolio/domain/entities/personal_info.dart';
import 'package:portfolio/shared/components/gradient_button.dart';
import 'package:portfolio/shared/components/glass_container.dart';

/// Hero Section introducing Suhail Shabir with headline, experience badges, and primary CTAs.
class HeroSection extends StatelessWidget {
  final PersonalInfo personalInfo;
  final VoidCallback onExploreProjects;
  final VoidCallback onContactMe;

  const HeroSection({
    super.key,
    required this.personalInfo,
    required this.onExploreProjects,
    required this.onContactMe,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);

    return Container(
      padding: EdgeInsets.only(
        top: isMobile ? 32 : 64,
        bottom: isMobile ? 48 : 80,
      ),
      child: ResponsiveContentWrapper(
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContent(context, isDark, isMobile),
                  const SizedBox(height: 36),
                  Center(child: _buildHeroCard(context, isDark, isMobile)),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildContent(context, isDark, isMobile),
                  ),
                  const SizedBox(width: 48),
                  Expanded(
                    flex: 4,
                    child: Center(child: _buildHeroCard(context, isDark, isMobile)),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Available for High-Impact Projects',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Name / Greeting
        Text(
          "Hi, I'm ${personalInfo.name}",
          style: (isMobile
                  ? context.textTheme.headlineMedium
                  : context.textTheme.displayMedium)
              ?.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 10),

        // Role & Gradient Title
        ShaderMask(
          shaderCallback: (bounds) => AppColors.heroGradient.createShader(bounds),
          child: Text(
            personalInfo.title,
            style: (isMobile
                    ? context.textTheme.titleLarge
                    : context.textTheme.headlineMedium)
                ?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Tagline / Subtitle
        Text(
          personalInfo.tagline,
          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: isMobile ? 15 : 17,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 20),

        // Quick Info Badges (Location, Experience)
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _InfoChip(
              icon: Icons.location_on_outlined,
              label: personalInfo.location,
            ),
            _InfoChip(
              icon: Icons.verified_outlined,
              label: personalInfo.totalExperience,
            ),
          ],
        ),
        const SizedBox(height: 32),

        // CTAs
        Wrap(
          spacing: 16,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GradientButton(
              text: 'Explore Projects',
              leadingIcon: Icons.rocket_launch_outlined,
              onPressed: onExploreProjects,
            ),
            GradientButton(
              text: 'Get in Touch',
              isOutlined: true,
              leadingIcon: Icons.mail_outline,
              onPressed: onContactMe,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      child: GlassContainer(
        padding: const EdgeInsets.all(28),
        borderRadius: AppDimensions.radiusXL,
        customBorderColor: AppColors.primary.withValues(alpha: 0.35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar badge
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.heroGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 28,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'SS',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              personalInfo.name,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              'iOS (Swift/SwiftUI) • Flutter/Dart',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),

            // Metrics Summary Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatColumn(label: 'Experience', value: '10+ Yrs'),
                Container(
                  width: 1,
                  height: 32,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                _StatColumn(label: 'Clients', value: 'Walmart • DHL'),
                Container(
                  width: 1,
                  height: 32,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                _StatColumn(label: 'Focus', value: 'Enterprise'),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Email Copy Tile
            InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              onTap: () {
                Clipboard.setData(ClipboardData(text: personalInfo.email));
                context.showSnackBar('Email copied to clipboard!');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F1626) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.email_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      personalInfo.email,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.copy_rounded, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161E33) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}
