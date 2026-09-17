import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> downloadFile({
  required String urlOrAssetPath,
  String? fileName,
}) async {
  final cleanUrl = urlOrAssetPath.trim();
  if (cleanUrl.isEmpty) return false;

  // 1. Remote web URL (e.g. Google Drive, Firebase Storage, AWS, etc.)
  if (cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://')) {
    final uri = Uri.tryParse(cleanUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  // 2. Bundled local asset (e.g. assets/resume/Suhail_Shabir.docx)
  try {
    await rootBundle.load(cleanUrl);
    debugPrint('Successfully verified local asset: $cleanUrl');
    return true;
  } catch (e) {
    debugPrint('Could not load local asset ($cleanUrl): $e');
    return false;
  }
}
