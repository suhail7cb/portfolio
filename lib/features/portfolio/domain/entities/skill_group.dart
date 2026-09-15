/// Domain entity representing a skill category and its technical skills.
class SkillItem {
  final String name;
  final String? level; // e.g. 'Expert', 'Advanced'
  final String? iconName;

  const SkillItem({
    required this.name,
    this.level,
    this.iconName,
  });

  factory SkillItem.fromJson(dynamic json) {
    if (json is String) {
      return SkillItem(name: json);
    }
    if (json is Map<String, dynamic>) {
      return SkillItem(
        name: json['name'] as String? ?? '',
        level: json['level'] as String?,
        iconName: json['iconName'] as String?,
      );
    }
    return const SkillItem(name: '');
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (level != null) 'level': level,
        if (iconName != null) 'iconName': iconName,
      };
}

class SkillGroup {
  final String categoryName;
  final String description;
  final List<SkillItem> skills;

  const SkillGroup({
    required this.categoryName,
    required this.description,
    required this.skills,
  });

  factory SkillGroup.fromJson(Map<String, dynamic> json) {
    final rawSkills = json['skills'] as List<dynamic>? ?? const [];
    return SkillGroup(
      categoryName: json['categoryName'] as String? ??
          json['category'] as String? ??
          'Skills',
      description: json['description'] as String? ?? '',
      skills: rawSkills.map((e) => SkillItem.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'categoryName': categoryName,
        'description': description,
        'skills': skills.map((s) => s.toJson()).toList(),
      };
}
