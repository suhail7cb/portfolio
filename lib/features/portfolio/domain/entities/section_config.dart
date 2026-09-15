/// Configuration for dynamically toggling visibility of portfolio sections.
class SectionConfig {
  final bool showHero;
  final bool showAbout;
  final bool showHighlights;
  final bool showExperience;
  final bool showProjects;
  final bool showSkills;
  final bool showImpact;
  final bool showEducation;
  final bool showCertifications;
  final bool showContact;

  const SectionConfig({
    this.showHero = true,
    this.showAbout = true,
    this.showHighlights = true,
    this.showExperience = true,
    this.showProjects = true,
    this.showSkills = true,
    this.showImpact = true,
    this.showEducation = true,
    this.showCertifications = true,
    this.showContact = true,
  });

  factory SectionConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SectionConfig();
    return SectionConfig(
      showHero: json['showHero'] as bool? ?? true,
      showAbout: json['showAbout'] as bool? ?? true,
      showHighlights: json['showHighlights'] as bool? ?? true,
      showExperience: json['showExperience'] as bool? ?? true,
      showProjects: json['showProjects'] as bool? ?? true,
      showSkills: json['showSkills'] as bool? ?? true,
      showImpact: json['showImpact'] as bool? ?? true,
      showEducation: json['showEducation'] as bool? ?? true,
      showCertifications: json['showCertifications'] as bool? ?? true,
      showContact: json['showContact'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'showHero': showHero,
        'showAbout': showAbout,
        'showHighlights': showHighlights,
        'showExperience': showExperience,
        'showProjects': showProjects,
        'showSkills': showSkills,
        'showImpact': showImpact,
        'showEducation': showEducation,
        'showCertifications': showCertifications,
        'showContact': showContact,
      };
}
