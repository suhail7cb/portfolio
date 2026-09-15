/// Domain entity representing academic degrees and schooling.
class Education {
  final String degree;
  final String institution;
  final String year;
  final String details;

  const Education({
    required this.degree,
    required this.institution,
    required this.year,
    required this.details,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'] as String? ?? '',
      institution: json['institution'] as String? ?? json['school'] as String? ?? '',
      year: json['year'] as String? ?? '',
      details: json['details'] as String? ?? json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'degree': degree,
        'institution': institution,
        'year': year,
        'details': details,
      };
}
