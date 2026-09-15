/// Platform-specific links for a project (web, android, ios, github).
class ProjectLinks {
  final String? web;
  final String? android;
  final String? ios;
  final String? github;

  const ProjectLinks({
    this.web,
    this.android,
    this.ios,
    this.github,
  });

  bool get hasAny =>
      (web != null && web!.isNotEmpty) ||
      (android != null && android!.isNotEmpty) ||
      (ios != null && ios!.isNotEmpty) ||
      (github != null && github!.isNotEmpty);

  factory ProjectLinks.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProjectLinks();
    return ProjectLinks(
      web: _parseUrl(json['web']),
      android: _parseUrl(json['android']),
      ios: _parseUrl(json['ios']),
      github: _parseUrl(json['github']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (web != null) 'web': web,
        if (android != null) 'android': android,
        if (ios != null) 'ios': ios,
        if (github != null) 'github': github,
      };

  static String? _parseUrl(dynamic value) {
    if (value == null || value is! String) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final uri = Uri.tryParse(trimmed);
    if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
      return trimmed;
    }
    return null;
  }
}

/// Domain entity representing a featured or production project.
class Project {
  final String title;
  final String? client;
  final String? duration;
  final String overview;
  final List<String> features;
  final List<String> userPersonas;
  final List<String> technologies;
  final List<String> platforms;
  final ProjectLinks links;
  final bool isFeatured;
  final String? category; // e.g. 'Enterprise', 'E-Commerce', 'Fintech', 'Health'

  const Project({
    required this.title,
    this.client,
    this.duration,
    required this.overview,
    this.features = const [],
    this.userPersonas = const [],
    this.technologies = const [],
    this.platforms = const [],
    this.links = const ProjectLinks(),
    String? appStoreUrl,
    String? playStoreUrl,
    String? liveUrl,
    String? githubUrl,
    this.isFeatured = false,
    this.category,
  }) : _appStoreUrl = appStoreUrl,
       _playStoreUrl = playStoreUrl,
       _liveUrl = liveUrl,
       _githubUrl = githubUrl;

  final String? _appStoreUrl;
  final String? _playStoreUrl;
  final String? _liveUrl;
  final String? _githubUrl;

  // Backward-compatible getters
  String? get appStoreUrl => links.ios ?? _appStoreUrl;
  String? get playStoreUrl => links.android ?? _playStoreUrl;
  String? get liveUrl => links.web ?? _liveUrl;
  String? get githubUrl => links.github ?? _githubUrl;

  factory Project.fromJson(Map<String, dynamic> json) {
    final rawLinks = json['links'] as Map<String, dynamic>?;
    final parsedLinks = ProjectLinks.fromJson(rawLinks);

    return Project(
      title: json['title'] as String? ?? 'Untitled Project',
      client: json['client'] as String?,
      duration: json['duration'] as String?,
      overview: json['overview'] as String? ?? '',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      userPersonas: (json['userPersonas'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      technologies: (json['technologies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      platforms: (json['platforms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      links: parsedLinks,
      appStoreUrl: parsedLinks.ios ?? json['appStoreUrl'] as String?,
      playStoreUrl: parsedLinks.android ?? json['playStoreUrl'] as String?,
      liveUrl: parsedLinks.web ?? json['liveUrl'] as String?,
      githubUrl: parsedLinks.github ?? json['githubUrl'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        if (client != null) 'client': client,
        if (duration != null) 'duration': duration,
        'overview': overview,
        'features': features,
        'userPersonas': userPersonas,
        'technologies': technologies,
        'platforms': platforms,
        'links': links.toJson(),
        'isFeatured': isFeatured,
        if (category != null) 'category': category,
      };
}
