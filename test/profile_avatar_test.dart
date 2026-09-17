import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/utils/profile_image_helper.dart';
import 'package:portfolio/shared/components/profile_avatar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    ProfileImageHelper.resetCache();
  });

  group('ProfileImageHelper Unit Tests', () {
    test('getInitials extracts two letters from multi-word name', () {
      expect(ProfileImageHelper.getInitials('Suhail Shabir'), 'SS');
      expect(ProfileImageHelper.getInitials('Jane Marie Doe'), 'JD');
      expect(ProfileImageHelper.getInitials('  John   Doe  '), 'JD');
    });

    test('getInitials handles single-word names and fallbacks', () {
      expect(ProfileImageHelper.getInitials('Suhail'), 'S');
      expect(ProfileImageHelper.getInitials(''), 'SS');
      expect(ProfileImageHelper.getInitials('   '), 'SS');
      expect(ProfileImageHelper.getInitials(null), 'SS');
    });

    test('getAvailableAssetImages discovers images from assets/images', () async {
      final images = await ProfileImageHelper.getAvailableAssetImages();
      expect(images, isNotEmpty);
      expect(images.contains('assets/images/profile.jpeg'), isTrue);
      // Ensure gitkeep is excluded
      expect(images.any((img) => img.endsWith('.gitkeep')), isFalse);
    });

    test('getAllCandidateImages includes explicit URLs', () async {
      final candidates = await ProfileImageHelper.getAllCandidateImages(
        explicitUrl: 'https://example.com/avatar.jpg, assets/images/custom.png',
      );
      expect(candidates.contains('https://example.com/avatar.jpg'), isTrue);
      expect(candidates.contains('assets/images/custom.png'), isTrue);
    });

    test('selectProfileImage selects an image and cycles correctly', () async {
      final selected = await ProfileImageHelper.selectProfileImage(
        explicitUrl: 'https://example.com/a.jpg, https://example.com/b.jpg',
      );
      expect(selected, isNotNull);

      final next = await ProfileImageHelper.cycleNextImage(
        explicitUrl: 'https://example.com/a.jpg, https://example.com/b.jpg',
      );
      expect(next, isNotNull);
    });
  });

  group('ProfileAvatar Widget Tests', () {
    testWidgets('renders initials when no image is available', (tester) async {
      ProfileImageHelper.resetCache();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileAvatar(
              name: 'Suhail Shabir',
              size: 100,
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(ProfileAvatar), findsOneWidget);
    });

    testWidgets('renders ProfileAvatar with explicit profile image', (tester) async {
      ProfileImageHelper.resetCache();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileAvatar(
              name: 'Suhail Shabir',
              profileImageUrl: 'assets/images/profile.jpeg',
              size: 120,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ProfileAvatar), findsOneWidget);
      expect(find.byType(ClipOval), findsOneWidget);
    });
  });
}
