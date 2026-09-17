// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Web implementation for downloading files or opening documents.
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
    // Fallback: browser anchor element
    try {
      final anchor = html.AnchorElement(href: cleanUrl)
        ..target = '_blank'
        ..download = fileName ?? cleanUrl.split('/').last;
      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      return true;
    } catch (e) {
      debugPrint('Error triggering web download for $cleanUrl: $e');
      return false;
    }
  }

  // 2. Bundled local asset (e.g. assets/resume/Suhail_Shabir.docx)
  try {
    final ByteData byteData = await rootBundle.load(cleanUrl);
    final Uint8List bytes = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );

    final mimeType = _getMimeType(cleanUrl);
    final blob = html.Blob([bytes], mimeType);
    final objectUrl = html.Url.createObjectUrlFromBlob(blob);

    final resolvedFileName = fileName ?? cleanUrl.split('/').last;
    final anchor = html.AnchorElement(href: objectUrl)
      ..download = resolvedFileName
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);

    // Revoke object URL after a short delay to allow the browser to initiate the download
    Future.delayed(const Duration(seconds: 1), () {
      html.Url.revokeObjectUrl(objectUrl);
    });

    debugPrint(
      'Successfully triggered download for asset: $cleanUrl as $resolvedFileName',
    );
    return true;
  } catch (e) {
    debugPrint('Could not download local asset ($cleanUrl): $e');
    return false;
  }
}

String _getMimeType(String path) {
  final lower = path.toLowerCase();
  if (lower.endsWith('.docx')) {
    return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
  } else if (lower.endsWith('.doc')) {
    return 'application/msword';
  } else if (lower.endsWith('.pdf')) {
    return 'application/pdf';
  } else if (lower.endsWith('.zip')) {
    return 'application/zip';
  } else if (lower.endsWith('.png')) {
    return 'image/png';
  } else if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
    return 'image/jpeg';
  }
  return 'application/octet-stream';
}
