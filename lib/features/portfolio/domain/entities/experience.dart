/// Domain entity representing a professional work role / company.
class Experience {
  final String role;
  final String company;
  final String location;
  final String period;
  final String? durationText;
  final bool isCurrent;
  final List<String> responsibilities;

  const Experience({
    required this.role,
    required this.company,
    required this.location,
    required this.period,
    this.durationText,
    this.isCurrent = false,
    required this.responsibilities,
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
    final rawResponsibilities = json['responsibilities'] ?? json['description'];
    final List<String> respList = [];
    if (rawResponsibilities is List) {
      respList.addAll(rawResponsibilities.map((e) => e.toString()));
    } else if (rawResponsibilities is String && rawResponsibilities.isNotEmpty) {
      respList.add(rawResponsibilities);
    }

    return Experience(
      role: json['role'] as String? ?? json['title'] as String? ?? '',
      company: json['company'] as String? ?? '',
      location: json['location'] as String? ?? '',
      period: periodStr,
      durationText: json['durationText'] as String?,
      isCurrent: json['isCurrent'] as bool? ?? false,
      responsibilities: respList,
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
      };
}
