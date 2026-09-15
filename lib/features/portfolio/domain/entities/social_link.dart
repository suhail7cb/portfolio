/// Domain entity representing external social or professional links.
class SocialLink {
  final String label;
  final String url;
  final String iconKey; // 'github', 'linkedin', 'email', 'phone', 'portfolio'

  const SocialLink({
    required this.label,
    required this.url,
    required this.iconKey,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      label: json['label'] as String? ?? json['name'] as String? ?? '',
      url: json['url'] as String? ?? json['link'] as String? ?? '',
      iconKey: json['iconKey'] as String? ?? json['icon'] as String? ?? 'link',
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'url': url,
        'iconKey': iconKey,
      };
}
