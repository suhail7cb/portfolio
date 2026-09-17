/// Domain entity representing personal identity and professional overview.
class PersonalInfo {
  final String name;
  final String title;
  final String tagline;
  final String location;
  final String email;
  final String phone;
  final String totalExperience;
  final String professionalSummary;
  final List<String> highlights;
  final String professionalDevelopmentSummary;
  final String? profileImageUrl;
  final String? resumeDownloadUrl;

  const PersonalInfo({
    required this.name,
    required this.title,
    required this.tagline,
    required this.location,
    required this.email,
    required this.phone,
    required this.totalExperience,
    required this.professionalSummary,
    required this.highlights,
    required this.professionalDevelopmentSummary,
    this.profileImageUrl,
    this.resumeDownloadUrl,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      location: json['location'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      totalExperience: json['totalExperience'] as String? ?? '',
      professionalSummary: json['professionalSummary'] as String? ?? '',
      highlights: (json['highlights'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      professionalDevelopmentSummary:
          json['professionalDevelopmentSummary'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String? ??
          json['profileImage'] as String?,
      resumeDownloadUrl: json['resumeDownloadUrl'] as String? ??
          json['resumeUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'tagline': tagline,
        'location': location,
        'email': email,
        'phone': phone,
        'totalExperience': totalExperience,
        'professionalSummary': professionalSummary,
        'highlights': highlights,
        'professionalDevelopmentSummary': professionalDevelopmentSummary,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        if (resumeDownloadUrl != null) 'resumeDownloadUrl': resumeDownloadUrl,
      };

  PersonalInfo copyWith({
    String? name,
    String? title,
    String? tagline,
    String? location,
    String? email,
    String? phone,
    String? totalExperience,
    String? professionalSummary,
    List<String>? highlights,
    String? professionalDevelopmentSummary,
    String? profileImageUrl,
    String? resumeDownloadUrl,
  }) {
    return PersonalInfo(
      name: name ?? this.name,
      title: title ?? this.title,
      tagline: tagline ?? this.tagline,
      location: location ?? this.location,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      totalExperience: totalExperience ?? this.totalExperience,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      highlights: highlights ?? this.highlights,
      professionalDevelopmentSummary: professionalDevelopmentSummary ?? this.professionalDevelopmentSummary,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      resumeDownloadUrl: resumeDownloadUrl ?? this.resumeDownloadUrl,
    );
  }
}
