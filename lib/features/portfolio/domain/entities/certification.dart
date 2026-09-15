/// Domain entity representing professional certifications and continuous learning programs.
class Certification {
  final String title;
  final String description;
  final String? issuer;
  final String? credentialUrl;

  const Certification({
    required this.title,
    required this.description,
    this.issuer,
    this.credentialUrl,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      title: json['title'] as String? ?? json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      issuer: json['issuer'] as String?,
      credentialUrl: json['credentialUrl'] as String? ?? json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        if (issuer != null) 'issuer': issuer,
        if (credentialUrl != null) 'credentialUrl': credentialUrl,
      };
}
