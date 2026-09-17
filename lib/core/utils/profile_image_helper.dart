import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Helper utility to discover, rotate, and manage profile photos
/// bundled in `assets/images/` or configured in [PersonalInfo].
class ProfileImageHelper {
  static List<String>? _cachedAssetImages;
  static String? _sessionSelectedImage;
  static int _currentIndex = 0;

  /// Resets cached state (useful for tests or hot reloads).
  @visibleForTesting
  static void resetCache() {
    _cachedAssetImages = null;
    _sessionSelectedImage = null;
    _currentIndex = 0;
  }

  /// Discovers all candidate image assets inside `assets/images/`.
  static Future<List<String>> getAvailableAssetImages({
    AssetBundle? bundle,
  }) async {
    if (_cachedAssetImages != null) {
      return _cachedAssetImages!;
    }

    try {
      final manifest = await AssetManifest.loadFromAssetBundle(
        bundle ?? rootBundle,
      );
      final assets = manifest.listAssets();

      final images = assets.where((path) {
        if (!path.startsWith('assets/images/')) return false;
        final lower = path.toLowerCase();
        if (lower.endsWith('.gitkeep') ||
            lower.endsWith('.ds_store') ||
            lower.contains('/.')) {
          return false;
        }
        return lower.endsWith('.jpg') ||
            lower.endsWith('.jpeg') ||
            lower.endsWith('.png') ||
            lower.endsWith('.webp') ||
            lower.endsWith('.gif');
      }).toList();

      _cachedAssetImages = images;
      return images;
    } catch (e) {
      debugPrint('ProfileImageHelper: Could not load AssetManifest: $e');
      return const [];
    }
  }

  /// Collects all candidate images from both bundled assets and any explicit URL/path.
  static Future<List<String>> getAllCandidateImages({
    String? explicitUrl,
    AssetBundle? bundle,
  }) async {
    final assetImages = await getAvailableAssetImages(bundle: bundle);
    final candidates = <String>[...assetImages];

    if (explicitUrl != null && explicitUrl.trim().isNotEmpty) {
      // Support comma-separated URLs or paths
      final customUrls = explicitUrl
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty);

      for (final url in customUrls) {
        if (!candidates.contains(url)) {
          candidates.add(url);
        }
      }
    }

    return candidates;
  }

  /// Selects a profile image for the current app session.
  /// On each new session/page load, if multiple images exist,
  /// one is randomly selected.
  static Future<String?> selectProfileImage({
    String? explicitUrl,
    AssetBundle? bundle,
    bool forceNewSelection = false,
  }) async {
    if (_sessionSelectedImage != null && !forceNewSelection) {
      return _sessionSelectedImage;
    }

    final candidates = await getAllCandidateImages(
      explicitUrl: explicitUrl,
      bundle: bundle,
    );

    if (candidates.isEmpty) {
      _sessionSelectedImage = null;
      return null;
    }

    final random = Random();
    _currentIndex = random.nextInt(candidates.length);
    _sessionSelectedImage = candidates[_currentIndex];
    return _sessionSelectedImage;
  }

  /// Cycles to the next available image (for interactive avatar clicks).
  static Future<String?> cycleNextImage({
    String? explicitUrl,
    AssetBundle? bundle,
  }) async {
    final candidates = await getAllCandidateImages(
      explicitUrl: explicitUrl,
      bundle: bundle,
    );

    if (candidates.isEmpty) {
      return null;
    }

    _currentIndex = (_currentIndex + 1) % candidates.length;
    _sessionSelectedImage = candidates[_currentIndex];
    return _sessionSelectedImage;
  }

  /// Extracts uppercase initials from a full name.
  /// Falls back to "SS" if empty.
  static String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'SS';

    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts.first.isNotEmpty) {
      return parts.first[0].toUpperCase();
    }

    return 'SS';
  }
}
