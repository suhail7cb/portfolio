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
  final String? problem;
  final String? solution;
  final String? roleDescription;
  final List<String> architectureSteps;
  final List<Map<String, String>> challenges;
  final List<Map<String, String>> impactMetrics;
  final String? imageUrl;

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
    this.problem,
    this.solution,
    this.roleDescription,
    this.architectureSteps = const [],
    this.challenges = const [],
    this.impactMetrics = const [],
    this.imageUrl,
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

  String get effectiveProblem {
    if (problem != null && problem!.isNotEmpty) return problem!;
    if (client != null) {
      return 'The client ($client) required a reliable, enterprise-grade mobile solution to optimize user workflows, reduce operational friction, and scale across multi-region production environments.';
    }
    return 'Required an intuitive, high-performance mobile platform addressing complex user workflows and robust real-time data handling.';
  }

  String get effectiveSolution {
    if (solution != null && solution!.isNotEmpty) return solution!;
    return overview;
  }

  String get effectiveRoleDescription {
    if (roleDescription != null && roleDescription!.isNotEmpty) {
      return roleDescription!;
    }
    return 'Architected mobile application layer, implemented clean architecture patterns, spearheaded API integration, and ensured rigorous quality standards.';
  }

  List<String> get effectiveArchitectureSteps {
    if (architectureSteps.isNotEmpty) return architectureSteps;
    return const [
      'Mobile Client (iOS & Flutter)',
      'Presentation Layer (BLoC / UI)',
      'Domain Layer (Use Cases & Entities)',
      'Data Layer (Repositories & Cache)',
      'REST APIs & Backend Services',
    ];
  }

  List<Map<String, String>> get effectiveImpactMetrics {
    if (impactMetrics.isNotEmpty) return impactMetrics;
    if (title.contains('Click & Collect')) {
      return const [
        {'value': '50K+', 'label': 'Monthly Active Users'},
        {'value': '30%', 'label': 'Faster Store Pickup'},
        {'value': '99.9%', 'label': 'System Availability'},
      ];
    } else if (title.contains('Liverpool')) {
      return const [
        {'value': '4.7★', 'label': 'App Store Rating'},
        {'value': 'Millions', 'label': 'Store Customers'},
        {'value': 'Top Retail', 'label': 'Mexico E-Commerce'},
      ];
    } else if (title.contains('Walmart') || title.contains('SDS')) {
      return const [
        {'value': 'Enterprise', 'label': 'Walmart Systems'},
        {'value': 'Zero', 'label': 'Dock Congestion'},
        {'value': '14 Months', 'label': 'System Delivery'},
      ];
    } else if (title.contains('Asset Track')) {
      return const [
        {'value': 'Blockchain', 'label': 'Tamper-proof Ledger'},
        {'value': 'Enterprise', 'label': 'Supply Chain Live'},
        {'value': '45 Months', 'label': 'Lead Architecture'},
      ];
    }
    return const [
      {'value': 'Production', 'label': 'Delivered Solution'},
      {'value': '60 FPS', 'label': 'Fluid UX Performance'},
      {'value': 'Clean Code', 'label': 'Modular Architecture'},
    ];
  }

  List<Map<String, String>> get effectiveChallenges {
    if (challenges.isNotEmpty) return challenges;
    return const [
      {
        'title': 'High-Throughput Concurrency',
        'description':
            'Engineered optimized rendering and state pipelines to handle real-time updates and heavy data synchronization without frame drops.',
      },
      {
        'title': 'Offline Resilience',
        'description':
            'Implemented local persistence, optimistic UI updates, and intelligent background retry logic for unstable networks.',
      },
      {
        'title': 'Multi-Persona Workflow',
        'description':
            'Designed modular screen layouts adapted to distinct internal personas and customer roles, preserving strict role-based data isolation.',
      },
    ];
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    final rawLinks = json['links'] as Map<String, dynamic>?;
    final parsedLinks = ProjectLinks.fromJson(rawLinks);

    // Parse challenges if present
    final rawChallenges = json['challenges'] as List<dynamic>?;
    final List<Map<String, String>> parsedChallenges = [];
    if (rawChallenges != null) {
      for (final item in rawChallenges) {
        if (item is Map) {
          parsedChallenges.add({
            'title': item['title']?.toString() ?? '',
            'description': item['description']?.toString() ?? '',
          });
        }
      }
    }

    // Parse impact metrics if present
    final rawMetrics = json['impactMetrics'] as List<dynamic>?;
    final List<Map<String, String>> parsedMetrics = [];
    if (rawMetrics != null) {
      for (final item in rawMetrics) {
        if (item is Map) {
          parsedMetrics.add({
            'value': item['value']?.toString() ?? '',
            'label': item['label']?.toString() ?? '',
          });
        }
      }
    }

    // Parse architecture steps
    final rawSteps = json['architectureSteps'] as List<dynamic>?;
    final List<String> parsedSteps =
        rawSteps?.map((e) => e.toString()).toList() ?? const [];

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
      problem: json['problem'] as String?,
      solution: json['solution'] as String?,
      roleDescription: json['roleDescription'] as String?,
      architectureSteps: parsedSteps,
      challenges: parsedChallenges,
      impactMetrics: parsedMetrics,
      imageUrl: json['imageUrl'] as String?,
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
        if (problem != null) 'problem': problem,
        if (solution != null) 'solution': solution,
        if (roleDescription != null) 'roleDescription': roleDescription,
        if (architectureSteps.isNotEmpty)
          'architectureSteps': architectureSteps,
        if (challenges.isNotEmpty) 'challenges': challenges,
        if (impactMetrics.isNotEmpty) 'impactMetrics': impactMetrics,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };
}

