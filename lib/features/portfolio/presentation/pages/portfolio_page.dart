import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/portfolio/presentation/bloc/portfolio_cubit.dart';
import 'package:portfolio/features/portfolio/presentation/bloc/portfolio_state.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/portfolio_nav_bar.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/portfolio_drawer.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/footer.dart';
import 'package:portfolio/features/portfolio/presentation/sections/hero_section.dart';
import 'package:portfolio/features/portfolio/presentation/sections/summary_highlights_section.dart';
import 'package:portfolio/features/portfolio/presentation/sections/experience_section.dart';
import 'package:portfolio/features/portfolio/presentation/sections/projects_section.dart';
import 'package:portfolio/features/portfolio/presentation/sections/skills_section.dart';
import 'package:portfolio/features/portfolio/presentation/sections/achievements_section.dart';
import 'package:portfolio/features/portfolio/presentation/sections/education_certifications_section.dart';
import 'package:portfolio/features/portfolio/presentation/sections/contact_section.dart';
import 'package:portfolio/shared/widgets/scroll_to_top_fab.dart';

/// Main single-page scroll view orchestrating all portfolio sections.
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // GlobalKeys for sections to enable smooth scrolling
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _impactKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<PortfolioCubit>().loadPortfolio();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String sectionKey) {
    GlobalKey? targetKey;
    switch (sectionKey.toLowerCase()) {
      case 'hero':
        targetKey = _heroKey;
        break;
      case 'about':
        targetKey = _aboutKey;
        break;
      case 'experience':
        targetKey = _experienceKey;
        break;
      case 'projects':
        targetKey = _projectsKey;
        break;
      case 'skills':
        targetKey = _skillsKey;
        break;
      case 'impact':
        targetKey = _impactKey;
        break;
      case 'education':
        targetKey = _educationKey;
        break;
      case 'contact':
        targetKey = _contactKey;
        break;
    }

    if (targetKey != null && targetKey.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey.currentContext!,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
        alignment: 0.05,
      );
      context.read<PortfolioCubit>().setActiveSection(sectionKey);
    } else if (sectionKey == 'hero') {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
      context.read<PortfolioCubit>().setActiveSection('about');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return BlocBuilder<PortfolioCubit, PortfolioState>(
      builder: (context, state) {
        if (state is PortfolioLoading || state is PortfolioInitial) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loading Portfolio Experience...',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is PortfolioError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text('Failed to load portfolio: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<PortfolioCubit>().loadPortfolio(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final config = (state as PortfolioLoaded).config;
        final activeSection = state.activeSectionKey;

        return Scaffold(
          key: _scaffoldKey,
          endDrawer: PortfolioDrawer(
            personalInfo: config.personalInfo,
            navigationItems: config.navigationItems,
            activeSectionKey: activeSection,
            onNavTap: _scrollToSection,
          ),
          floatingActionButton: ScrollToTopFab(
            scrollController: _scrollController,
          ),
          body: Stack(
            children: [
              // Scrollable Content
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Space for sticky navbar
                    const SizedBox(height: AppDimensions.navBarHeight),

                    // Section 1: Hero
                    if (config.sectionConfig.showHero)
                      Container(
                        key: _heroKey,
                        child: HeroSection(
                          personalInfo: config.personalInfo,
                          onExploreProjects: () => _scrollToSection('projects'),
                          onContactMe: () => _scrollToSection('contact'),
                          scrollController: _scrollController,
                        ),
                      ),

                    // Section 2: Summary & Highlights
                    if (config.sectionConfig.showAbout ||
                        config.sectionConfig.showHighlights)
                      Container(
                        key: _aboutKey,
                        child: SummaryHighlightsSection(
                          personalInfo: config.personalInfo,
                        ),
                      ),

                    // Section 3: Experience
                    if (config.sectionConfig.showExperience &&
                        config.experiences.isNotEmpty)
                      Container(
                        key: _experienceKey,
                        child: ExperienceSection(
                          experiences: config.experiences,
                          onNavigateToProject: (projectTitle) =>
                              _scrollToSection('projects'),
                        ),
                      ),

                    // Section 4: Projects
                    if (config.sectionConfig.showProjects &&
                        config.projects.isNotEmpty)
                      Container(
                        key: _projectsKey,
                        child: ProjectsSection(projects: config.projects),
                      ),

                    // Section 5: Skills
                    if (config.sectionConfig.showSkills &&
                        config.skillGroups.isNotEmpty)
                      Container(
                        key: _skillsKey,
                        child: SkillsSection(skillGroups: config.skillGroups),
                      ),

                    // Section 6: Key Achievements & Impact
                    if (config.sectionConfig.showImpact &&
                        config.achievements.isNotEmpty)
                      Container(
                        key: _impactKey,
                        child: AchievementsSection(
                          achievements: config.achievements,
                        ),
                      ),

                    // Section 7: Education & Certifications
                    if ((config.sectionConfig.showEducation &&
                            config.education.isNotEmpty) ||
                        (config.sectionConfig.showCertifications &&
                            config.certifications.isNotEmpty))
                      Container(
                        key: _educationKey,
                        child: EducationCertificationsSection(
                          educationList: config.education,
                          certifications: config.certifications,
                        ),
                      ),

                    // Section 8: Contact
                    if (config.sectionConfig.showContact)
                      Container(
                        key: _contactKey,
                        child: ContactSection(
                          personalInfo: config.personalInfo,
                          socialLinks: config.socialLinks,
                        ),
                      ),

                    // Footer
                    PortfolioFooter(
                      personalInfo: config.personalInfo,
                      navigationItems: config.navigationItems,
                      socialLinks: config.socialLinks,
                      onNavTap: _scrollToSection,
                    ),
                  ],
                ),
              ),

              // Sticky Top Navigation Bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: PortfolioNavBar(
                  personalInfo: config.personalInfo,
                  navigationItems: config.navigationItems,
                  activeSectionKey: activeSection,
                  onNavTap: _scrollToSection,
                  onOpenDrawer: () =>
                      _scaffoldKey.currentState?.openEndDrawer(),
                  scrollController: _scrollController,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
