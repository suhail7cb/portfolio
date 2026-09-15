/// Domain entity representing leadership and enterprise impact achievements.
class Achievement {
  final String title;
  final String description;
  final String? metricBadge;
  final String? iconName;

  const Achievement({
    required this.title,
    required this.description,
    this.metricBadge,
    this.iconName,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      metricBadge: json['metricBadge'] as String? ?? json['badge'] as String?,
      iconName: json['iconName'] as String? ?? json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        if (metricBadge != null) 'metricBadge': metricBadge,
        if (iconName != null) 'iconName': iconName,
      };
}
