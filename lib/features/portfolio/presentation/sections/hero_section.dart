import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/core/utils/url_launcher_helper.dart';
import 'package:portfolio/features/portfolio/domain/entities/personal_info.dart';
import 'package:portfolio/shared/components/profile_avatar.dart';

/// Redesigned Hero Section matching the reference design:
/// - Outer illuminated navy card with integrated bottom stats ribbon
/// - Left: "Hello, I'm", "Suhail Shabir" (with gradient text), role, description,
///   interactive skill badges (iOS, Flutter, Architecture, Leadership), and CTAs
/// - Right: Portrait with glowing ambient clouds, handwritten callout "Turning ideas into products",
///   and floating "10+ Years Experience" stack card
/// - Bottom ribbon: 10+ Years Experience, 6+ Enterprise Clients, 20+ Apps/Products, 4+ Teams Mentored
class HeroSection extends StatefulWidget {
  final PersonalInfo personalInfo;
  final VoidCallback onExploreProjects;
  final VoidCallback onContactMe;
  final ScrollController? scrollController;

  const HeroSection({
    super.key,
    required this.personalInfo,
    required this.onExploreProjects,
    required this.onContactMe,
    this.scrollController,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  void _downloadResume(BuildContext context) {
    final url =
        widget.personalInfo.resumeDownloadUrl ??
        'assets/resume/Suhail_Shabir.docx';
    UrlLauncherHelper.launchURL(url);
    context.showSnackBar('Opening résumé...');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scrollController != null) {
      return ListenableBuilder(
        listenable: widget.scrollController!,
        builder: (context, _) {
          final double scrollOffset = widget.scrollController!.hasClients
              ? widget.scrollController!.offset
              : 0.0;
          return _buildHeroContent(context, scrollOffset);
        },
      );
    }
    return _buildHeroContent(context, 0.0);
  }

  Widget _buildHeroContent(BuildContext context, double scrollOffset) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);
    final bool isTablet = ResponsiveBuilder.isTablet(context);

    // Shrink progress as user scrolls down through the hero section (0.0 to 1.0 over 260px)
    final double shrinkProgress = (scrollOffset / 260.0).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 24 : 40),
      child: ResponsiveContentWrapper(
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF080D1A) : Colors.white,
            borderRadius: BorderRadius.circular(isMobile ? 20 : 28),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: isDark ? 0.08 : 0.04,
                ),
                blurRadius: 36,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              // Upper Hero Container: Name, Role, and Picture always on top
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 20 : (isTablet ? 28 : 44),
                  isMobile ? 8 : (isTablet ? 6 : 8),
                  isMobile ? 20 : (isTablet ? 28 : 44),
                  isMobile ? 4 : (isTablet ? 2 : 4),
                ),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Name & Role at the top of Hero section
                          _buildNameAndRole(context, isDark, isMobile),
                          const SizedBox(height: 20),

                          // 2. Picture at the top of Hero section (resizes dynamically as user scrolls up/down)
                          Center(
                            child: _buildRightVisual(
                              context,
                              isDark,
                              isMobile,
                              shrinkProgress,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // 3. Bio Description, Skill Badges & Action Buttons
                          _buildBioAndActions(context, isDark, isMobile),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 11,
                            child: _buildLeftContent(context, isDark, isMobile),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 9,
                            child: Center(
                              child: _buildRightVisual(
                                context,
                                isDark,
                                isMobile,
                                shrinkProgress,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),

              // Integrated Bottom Quick Stats Ribbon
              Divider(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
                height: 1,
                thickness: 1,
              ),
              _buildStatsRibbon(context, isDark, isMobile, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  /// Left Side Container: Combines Name, Role, Bio, Badges, and Action Buttons
  Widget _buildLeftContent(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameAndRole(context, isDark, isMobile),
        const SizedBox(height: 14),
        _buildBioAndActions(context, isDark, isMobile),
      ],
    );
  }

  /// Name & Role: "Hello, I'm", "Suhail Shabir" (with gradient), and "Senior Mobile Engineer"
  Widget _buildNameAndRole(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Hello, I'm"
        Text(
          "Hello, I'm",
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),

        // "Suhail Shabir" (with Shabir gradient)
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Suhail ',
              style: TextStyle(
                fontSize: isMobile ? 32 : 46,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF38BDF8), // Vibrant cyan
                  Color(0xFF818CF8), // Indigo
                  Color(0xFFC084FC), // Magenta / Purple
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'Shabir',
                style: TextStyle(
                  fontSize: isMobile ? 32 : 46,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // "Senior Mobile Engineer"
        Text(
          'Senior Mobile Engineer',
          style: TextStyle(
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.w700,
            color: isDark
                ? const Color(0xFFF1F5F9)
                : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  /// Narrative Bio, Skill Badges & Action Buttons
  Widget _buildBioAndActions(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Narrative Description
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            'Building scalable iOS & Flutter products with a focus on clean architecture, great UX and real-world impact.',
            style: TextStyle(
              fontSize: isMobile ? 14 : 15.5,
              height: 1.6,
              color: isDark
                  ? const Color(0xFF94A3B8)
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        const SizedBox(height: 22),

        // Skill Badges Row (iOS, Flutter, Architecture, Leadership)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _SkillPillBadge(icon: Icons.apple, label: 'iOS'),
            _SkillPillBadge(icon: Icons.flutter_dash, label: 'Flutter'),
            _SkillPillBadge(icon: Icons.layers_outlined, label: 'Architecture'),
            _SkillPillBadge(icon: Icons.groups_outlined, label: 'Leadership'),
          ],
        ),
        const SizedBox(height: 32),

        // Action Buttons Row
        Wrap(
          spacing: 14,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Primary Button: "Explore My Work →"
            _HeroPrimaryButton(
              text: 'Explore My Work →',
              onPressed: widget.onExploreProjects,
            ),

            // Secondary Button: "Download Résumé"
            _HeroSecondaryButton(
              text: 'Download Résumé',
              icon: Icons.download_rounded,
              onPressed: () => _downloadResume(context),
            ),
          ],
        ),
      ],
    );
  }

  /// Right Side: Portrait + Ambient Glow + "Turning ideas into products" + Floating Stack Card
  /// Dynamically resizes (shrinks/expands) as user scrolls up/down.
  Widget _buildRightVisual(
    BuildContext context,
    bool isDark,
    bool isMobile,
    double shrinkProgress,
  ) {
    final double baseVisualWidth = isMobile ? 310.0 : 420.0;
    final double baseVisualHeight = isMobile ? 320.0 : 380.0;

    // As user scrolls down, scale shrinks smoothly towards the sized-down state
    // Desktop: smoothly shrinks by up to 42%
    // Mobile: smoothly shrinks by up to 45%
    final double scale = 1.0 - (shrinkProgress * (isMobile ? 0.60 : 0.55));
    final double currentWidth = baseVisualWidth * scale;
    final double currentHeight = baseVisualHeight * scale;
    final double translateY = shrinkProgress * (isMobile ? 20.0 : 32.0);

    return Transform.translate(
      offset: Offset(0, -translateY),
      child: SizedBox(
        width: currentWidth,
        height: currentHeight,
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: SizedBox(
            width: baseVisualWidth,
            height: baseVisualHeight,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // 1. Ambient Background Glow Blobs
                Positioned(
                  left: 20,
                  top: 40,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF0284C7).withValues(alpha: 0.38),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 40,
                  top: 60,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF7C3AED).withValues(alpha: 0.35),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. Main Portrait Image
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: isMobile ? 220 : 270,
                    height: isMobile ? 270 : 330,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        widget.personalInfo.profileImageUrl ??
                            'assets/images/profile.jpeg',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) =>
                            ProfileAvatar(
                              name: widget.personalInfo.name,
                              profileImageUrl:
                                  widget.personalInfo.profileImageUrl,
                              size: 200,
                            ),
                      ),
                    ),
                  ),
                ),

                // 3. Floating Handwritten Annotation: "Turning ideas into products"
                Positioned(
                  right: isMobile ? 4 : 20,
                  top: isMobile ? 6 : 14,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Turning ideas\ninto products',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.caveat(
                            fontSize: isMobile ? 15 : 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7DD3FC),
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.subdirectory_arrow_left,
                            size: 22,
                            color: Color(0xFF7DD3FC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 4. Floating Experience Card (Right-aligned over photo edge)
                Positioned(
                  right: isMobile ? -0 : -0,
                  bottom: isMobile ? 10 : 18,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xE60A1022),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF1E293B),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '10+',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Years Experience',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const _FloatingStackItem(
                          icon: Icons.apple,
                          label: 'iOS',
                        ),
                        const SizedBox(height: 5),
                        const _FloatingStackItem(
                          icon: Icons.flutter_dash,
                          label: 'Flutter',
                        ),
                        const SizedBox(height: 5),
                        const _FloatingStackItem(
                          icon: Icons.layers_outlined,
                          label: 'Architecture',
                        ),
                        const SizedBox(height: 5),
                        const _FloatingStackItem(
                          icon: Icons.shield_outlined,
                          label: 'Leadership',
                        ),
                      ],
                    ),
                  ),
                ),

                // 5. Glowing Ambient Indicator Node near bottom-left of photo
                Positioned(
                  left: isMobile ? 18 : 34,
                  bottom: isMobile ? 50 : 70,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Integrated Quick Stats Ribbon at bottom of hero card
  Widget _buildStatsRibbon(
    BuildContext context,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    const stats = [
      {'icon': Icons.code_rounded, 'value': '10+', 'label': 'Years Experience'},
      {
        'icon': Icons.business_center_outlined,
        'value': '6+',
        'label': 'Enterprise Clients',
      },
      {
        'icon': Icons.phone_iphone_rounded,
        'value': '20+',
        'label': 'Apps / Products',
      },
      {'icon': Icons.groups_outlined, 'value': '4+', 'label': 'Teams Mentored'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: isMobile ? 16 : 20,
      ),
      child: isMobile
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: stats.map((stat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 28),
                    child: _HeroStatItem(
                      icon: stat['icon'] as IconData,
                      value: stat['value'] as String,
                      label: stat['label'] as String,
                      isDark: isDark,
                    ),
                  );
                }).toList(),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: stats.map((stat) {
                return _HeroStatItem(
                  icon: stat['icon'] as IconData,
                  value: stat['value'] as String,
                  label: stat['label'] as String,
                  isDark: isDark,
                );
              }).toList(),
            ),
    );
  }
}

/// Pill Badge (iOS, Flutter, Architecture, Leadership)
class _SkillPillBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SkillPillBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE2E8F0),
            ),
          ),
        ],
      ),
    );
  }
}

/// Primary CTA Button ("Explore My Work →") with vibrant gradient & glowing shadow
class _HeroPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _HeroPrimaryButton({required this.text, required this.onPressed});

  @override
  State<_HeroPrimaryButton> createState() => _HeroPrimaryButtonState();
}

class _HeroPrimaryButtonState extends State<_HeroPrimaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 180),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isHovered
                    ? [
                        const Color(0xFF0284C7),
                        const Color(0xFF6366F1),
                        const Color(0xFFA855F7),
                      ]
                    : [
                        const Color(0xFF0284C7),
                        const Color(0xFF4F46E5),
                        const Color(0xFF7C3AED),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF0284C7,
                  ).withValues(alpha: _isHovered ? 0.5 : 0.35),
                  blurRadius: _isHovered ? 20 : 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary CTA Button ("Download Résumé") with outlined glass design
class _HeroSecondaryButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const _HeroSecondaryButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_HeroSecondaryButton> createState() => _HeroSecondaryButtonState();
}

class _HeroSecondaryButtonState extends State<_HeroSecondaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF1E293B).withValues(alpha: 0.8)
                : const Color(0xFF0F172A).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : const Color(0xFF334155),
              width: 1.1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: _isHovered ? AppColors.primary : const Color(0xFFE2E8F0),
              ),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _isHovered ? Colors.white : const Color(0xFFE2E8F0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vertical Item in Floating Stack Card
class _FloatingStackItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FloatingStackItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCBD5E1),
          ),
        ),
      ],
    );
  }
}

/// Stat Item in Bottom Ribbon
class _HeroStatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isDark;

  const _HeroStatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Icon(icon, size: 19, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
