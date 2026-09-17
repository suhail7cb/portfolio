/// Domain entity representing a professional work role / company.
class Experience {
  final String role;
  final String company;
  final String location;
  final String period;
  final String? durationText;
  final bool isCurrent;
  final List<String> responsibilities;
  final String? description;
  final List<String> technologies;
  final List<String> impact;
  final String? associatedProjectTitle;

  const Experience({
    required this.role,
    required this.company,
    required this.location,
    required this.period,
    this.durationText,
    this.isCurrent = false,
    required this.responsibilities,
    this.description,
    this.technologies = const [],
    this.impact = const [],
    this.associatedProjectTitle,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    // Support either 'period' or 'startDate' + 'endDate'
    String periodStr = json['period'] as String? ?? '';
    if (periodStr.isEmpty) {
      final start = json['startDate'] as String? ?? '';
      final end = json['endDate'] as String? ?? '';
      if (start.isNotEmpty || end.isNotEmpty) {
        periodStr = '$start – $end'.trim();
      }
    }

    // Support either 'responsibilities' or 'description'
    final rawResponsibilities = json['responsibilities'];
    final List<String> respList = [];
    if (rawResponsibilities is List) {
      respList.addAll(rawResponsibilities.map((e) => e.toString()));
    } else if (rawResponsibilities is String && rawResponsibilities.isNotEmpty) {
      respList.add(rawResponsibilities);
    }

    // Technologies tags
    final rawTech = json['technologies'];
    final List<String> techList = [];
    if (rawTech is List) {
      techList.addAll(rawTech.map((e) => e.toString()));
    }

    // Measurable impact points
    final rawImpact = json['impact'];
    final List<String> impactList = [];
    if (rawImpact is List) {
      impactList.addAll(rawImpact.map((e) => e.toString()));
    }

    return Experience(
      role: json['role'] as String? ?? json['title'] as String? ?? '',
      company: json['company'] as String? ?? '',
      location: json['location'] as String? ?? '',
      period: periodStr,
      durationText: json['durationText'] as String?,
      isCurrent: json['isCurrent'] as bool? ?? false,
      responsibilities: respList,
      description: json['description'] as String?,
      technologies: techList,
      impact: impactList,
      associatedProjectTitle: json['associatedProjectTitle'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'company': company,
        'location': location,
        'period': period,
        if (durationText != null) 'durationText': durationText,
        'isCurrent': isCurrent,
        'responsibilities': responsibilities,
        if (description != null) 'description': description,
        if (technologies.isNotEmpty) 'technologies': technologies,
        if (impact.isNotEmpty) 'impact': impact,
        if (associatedProjectTitle != null)
          'associatedProjectTitle': associatedProjectTitle,
      };
}
