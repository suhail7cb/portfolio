import 'app_constants.dart';

/// Centralized UI string constants for labels, accessibility, and fallbacks.
class AppStrings {
  AppStrings._();

  // Administration & Security
  static const String adminEmail = AppConstants.adminEmail;

  // Navigation
  static const String navAbout = 'About';
  static const String navExperience = 'Experience';
  static const String navProjects = 'Projects';
  static const String navSkills = 'Skills';
  static const String navImpact = 'Impact';
  static const String navEducation = 'Education';
  static const String navContact = 'Contact';

  // Section Subtitles
  static const String sectionAboutSubtitle = 'GET TO KNOW ME';
  static const String sectionExperienceSubtitle = 'CAREER TRAJECTORY';
  static const String sectionProjectsSubtitle = 'FEATURED & PRODUCTION WORK';
  static const String sectionSkillsSubtitle = 'TECHNICAL STACK';
  static const String sectionImpactSubtitle = 'LEADERSHIP & ACHIEVEMENTS';
  static const String sectionEducationSubtitle = 'ACADEMICS & CERTIFICATIONS';
  static const String sectionContactSubtitle = 'START A CONVERSATION';

  // CTAs
  static const String ctaExploreProjects = 'Explore Work';
  static const String ctaContactMe = 'Get in Touch';
  static const String ctaDownloadResume = 'View Resume';
  static const String ctaSendMessage = 'Send Message';
  static const String ctaCopiedToClipboard = 'Copied to clipboard!';

  // Errors & States
  static const String loadingPortfolio = 'Loading portfolio experience...';
  static const String errorLoadingPortfolio = 'Failed to load portfolio content.';
  static const String retry = 'Retry';
}
