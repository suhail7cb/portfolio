import 'file_downloader_stub.dart'
    if (dart.library.html) 'file_downloader_web.dart' as impl;

/// Helper to download files and assets across platforms (Web, Mobile, Desktop).
class FileDownloader {
  FileDownloader._();

  /// Downloads or opens a resume or document.
  /// Handles both remote URLs (https://...) and bundled assets (assets/resume/...).
  static Future<bool> downloadFile({
    required String urlOrAssetPath,
    String? fileName,
  }) async {
    return impl.downloadFile(
      urlOrAssetPath: urlOrAssetPath,
      fileName: fileName,
    );
  }
}
