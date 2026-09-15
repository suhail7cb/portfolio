import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper to safely launch external URLs, mailto, and tel links.
class UrlLauncherHelper {
  UrlLauncherHelper._();

  static Future<bool> launchURL(String urlString) async {
    final Uri? uri = Uri.tryParse(urlString.trim());
    if (uri == null) {
      debugPrint('Could not parse url: $urlString');
      return false;
    }

    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      } else {
        debugPrint('Cannot launch URL: $urlString');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching URL ($urlString): $e');
      return false;
    }
  }

  static Future<bool> openEmail(String email, {String subject = '', String body = ''}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email.trim(),
      query: _encodeQueryParameters(<String, String>{
        if (subject.isNotEmpty) 'subject': subject,
        if (body.isNotEmpty) 'body': body,
      }),
    );
    return launchURL(emailLaunchUri.toString());
  }

  static Future<bool> openPhone(String phone) async {
    final String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanPhone);
    return launchURL(phoneUri.toString());
  }

  static String? _encodeQueryParameters(Map<String, String> params) {
    if (params.isEmpty) return null;
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
