import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/utils/file_downloader.dart';
import 'package:portfolio/core/utils/url_launcher_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FileDownloader Tests', () {
    test('downloadFile returns false for empty input', () async {
      final result = await FileDownloader.downloadFile(urlOrAssetPath: '');
      expect(result, isFalse);
    });

    test('downloadFile handles local asset path', () async {
      // In flutter test environment, rootBundle loads project assets
      final result = await FileDownloader.downloadFile(
        urlOrAssetPath: 'assets/resume/Suhail_Shabir.docx',
        fileName: 'Suhail_Shabir_Resume.docx',
      );
      expect(result, isTrue);
    });

    test('UrlLauncherHelper routes asset paths to FileDownloader', () async {
      final result = await UrlLauncherHelper.launchURL(
        'assets/resume/Suhail_Shabir.docx',
      );
      expect(result, isTrue);
    });
  });
}
