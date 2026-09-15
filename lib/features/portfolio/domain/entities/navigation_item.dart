/// Domain entity representing a navigation bar / menu item.
class NavigationItem {
  final String label;
  final String sectionKey; // e.g. 'about', 'experience', 'projects', etc.

  const NavigationItem({
    required this.label,
    required this.sectionKey,
  });

  factory NavigationItem.fromJson(Map<String, dynamic> json) {
    return NavigationItem(
      label: json['label'] as String? ?? json['name'] as String? ?? '',
      sectionKey: json['sectionKey'] as String? ?? json['key'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'sectionKey': sectionKey,
      };
}
