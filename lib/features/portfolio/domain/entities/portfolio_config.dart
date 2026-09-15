import 'personal_info.dart';
import 'experience.dart';
import 'project.dart';
import 'skill_group.dart';
import 'education.dart';
import 'certification.dart';
import 'achievement.dart';
import 'social_link.dart';
import 'section_config.dart';
import 'navigation_item.dart';

/// Central domain entity aggregating all portfolio configuration and content.
/// Changing this instance changes the entire portfolio without touching UI widgets.
class PortfolioConfig {
  final PersonalInfo personalInfo;
  final List<Experience> experiences;
  final List<Project> projects;
  final List<SkillGroup> skillGroups;
  final List<Education> education;
  final List<Certification> certifications;
  final List<Achievement> achievements;
  final List<SocialLink> socialLinks;
  final List<NavigationItem> navigationItems;
  final SectionConfig sectionConfig;
  final String metaTitle;
  final String metaDescription;

  const PortfolioConfig({
    required this.personalInfo,
    required this.experiences,
    required this.projects,
    required this.skillGroups,
    required this.education,
    required this.certifications,
    required this.achievements,
    required this.socialLinks,
    required this.navigationItems,
    this.sectionConfig = const SectionConfig(),
    required this.metaTitle,
    required this.metaDescription,
  });

  factory PortfolioConfig.fromJson(Map<String, dynamic> json) {
    final personalInfoJson = json['personalInfo'] as Map<String, dynamic>? ?? {};
    final experiencesJson = json['experiences'] as List<dynamic>? ?? const [];
    final projectsJson = json['projects'] as List<dynamic>? ?? const [];
    final skillGroupsJson = json['skillGroups'] as List<dynamic>? ?? const [];
    final educationJson = json['education'] as List<dynamic>? ?? const [];
    final certificationsJson = json['certifications'] as List<dynamic>? ?? const [];
    final achievementsJson = json['achievements'] as List<dynamic>? ?? const [];
    final socialLinksJson = json['socialLinks'] as List<dynamic>? ?? const [];
    final navigationItemsJson = json['navigationItems'] as List<dynamic>? ?? const [];
    final sectionConfigJson = json['sectionConfig'] as Map<String, dynamic>?;

    return PortfolioConfig(
      personalInfo: PersonalInfo.fromJson(personalInfoJson),
      experiences: experiencesJson
          .map((e) => Experience.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: projectsJson
          .map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
      skillGroups: skillGroupsJson
          .map((e) => SkillGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: educationJson
          .map((e) => Education.fromJson(e as Map<String, dynamic>))
          .toList(),
      certifications: certificationsJson
          .map((e) => Certification.fromJson(e as Map<String, dynamic>))
          .toList(),
      achievements: achievementsJson
          .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
      socialLinks: socialLinksJson
          .map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      navigationItems: navigationItemsJson
          .map((e) => NavigationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      sectionConfig: SectionConfig.fromJson(sectionConfigJson),
      metaTitle: json['metaTitle'] as String? ?? 'Portfolio',
      metaDescription: json['metaDescription'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'metaTitle': metaTitle,
        'metaDescription': metaDescription,
        'sectionConfig': sectionConfig.toJson(),
        'personalInfo': personalInfo.toJson(),
        'navigationItems': navigationItems.map((e) => e.toJson()).toList(),
        'socialLinks': socialLinks.map((e) => e.toJson()).toList(),
        'experiences': experiences.map((e) => e.toJson()).toList(),
        'projects': projects.map((e) => e.toJson()).toList(),
        'skillGroups': skillGroups.map((e) => e.toJson()).toList(),
        'achievements': achievements.map((e) => e.toJson()).toList(),
        'education': education.map((e) => e.toJson()).toList(),
        'certifications': certifications.map((e) => e.toJson()).toList(),
      };
}
