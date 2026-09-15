import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/portfolio_config.dart';

/// Exception thrown when portfolio configuration is malformed or missing required data.
class PortfolioConfigValidationException implements Exception {
  final String message;

  const PortfolioConfigValidationException(this.message);

  @override
  String toString() => 'Invalid portfolio configuration: $message';
}

/// Service responsible for loading and validating portfolio configuration from JSON.
class PortfolioConfigLoader {
  PortfolioConfigLoader._();

  /// Loads, validates, and parses portfolio configuration from a Flutter asset file.
  static Future<PortfolioConfig> loadFromAsset(String assetPath) async {
    final String jsonString;
    try {
      jsonString = await rootBundle.loadString(assetPath);
    } catch (e) {
      throw PortfolioConfigValidationException(
        'Could not find or load configuration asset at "$assetPath": $e',
      );
    }
    return loadFromString(jsonString);
  }

  /// Parses and validates a raw JSON string into a [PortfolioConfig].
  static PortfolioConfig loadFromString(String jsonString) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(jsonString);
    } on FormatException catch (e) {
      throw PortfolioConfigValidationException('Malformed JSON: ${e.message}');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const PortfolioConfigValidationException(
        'Root JSON must be an object (Map).',
      );
    }

    validate(decoded);
    return PortfolioConfig.fromJson(decoded);
  }

  /// Validates the structure and mandatory fields of the portfolio JSON map.
  static void validate(Map<String, dynamic> json) {
    // 1. Personal Info Validation
    final personalInfo = json['personalInfo'];
    if (personalInfo == null || personalInfo is! Map<String, dynamic>) {
      throw const PortfolioConfigValidationException(
        'personalInfo object is required.',
      );
    }

    final name = personalInfo['name'];
    if (name == null || name is! String || name.trim().isEmpty) {
      throw const PortfolioConfigValidationException(
        'personalInfo.name is required and cannot be empty.',
      );
    }

    final title = personalInfo['title'];
    if (title == null || title is! String || title.trim().isEmpty) {
      throw const PortfolioConfigValidationException(
        'personalInfo.title is required and cannot be empty.',
      );
    }

    final email = personalInfo['email'];
    if (email == null || email is! String || email.trim().isEmpty) {
      throw const PortfolioConfigValidationException(
        'personalInfo.email is required and cannot be empty.',
      );
    }

    // 2. Experiences Validation
    final experiences = json['experiences'];
    if (experiences != null) {
      if (experiences is! List) {
        throw const PortfolioConfigValidationException(
          'experiences must be a list of experience objects.',
        );
      }
      for (var i = 0; i < experiences.length; i++) {
        final exp = experiences[i];
        if (exp is! Map<String, dynamic>) {
          throw PortfolioConfigValidationException(
            'experiences[$i] must be an object.',
          );
        }
        final role = exp['role'] ?? exp['title'];
        if (role == null || role.toString().trim().isEmpty) {
          throw PortfolioConfigValidationException(
            'experiences[$i].role is required.',
          );
        }
        final company = exp['company'];
        if (company == null || company.toString().trim().isEmpty) {
          throw PortfolioConfigValidationException(
            'experiences[$i].company is required.',
          );
        }
      }
    }

    // 3. Projects Validation
    final projects = json['projects'];
    if (projects != null) {
      if (projects is! List) {
        throw const PortfolioConfigValidationException(
          'projects must be a list of project objects.',
        );
      }
      for (var i = 0; i < projects.length; i++) {
        final proj = projects[i];
        if (proj is! Map<String, dynamic>) {
          throw PortfolioConfigValidationException(
            'projects[$i] must be an object.',
          );
        }
        final projTitle = proj['title'] ?? proj['name'];
        if (projTitle == null || projTitle.toString().trim().isEmpty) {
          throw PortfolioConfigValidationException(
            'projects[$i].title is required.',
          );
        }
      }
    }

    // 4. Skill Groups Validation
    final skillGroups = json['skillGroups'];
    if (skillGroups != null && skillGroups is! List) {
      throw const PortfolioConfigValidationException(
        'skillGroups must be a list of skill category objects.',
      );
    }

    // 5. Section Config Validation
    final sectionConfig = json['sectionConfig'];
    if (sectionConfig != null && sectionConfig is! Map<String, dynamic>) {
      throw const PortfolioConfigValidationException(
        'sectionConfig must be a map of boolean flags.',
      );
    }
  }
}
