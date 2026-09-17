import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/portfolio_config.dart';

/// Remote data source responsible for persisting and fetching portfolio configuration
/// from Cloud Firestore with strict timeouts.
class PortfolioRemoteDataSource {
  final FirebaseFirestore? _customFirestore;

  PortfolioRemoteDataSource({FirebaseFirestore? firestore})
    : _customFirestore = firestore;

  FirebaseFirestore? get _firestore {
    if (_customFirestore != null) return _customFirestore;
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      // Firebase not initialized (e.g., in unit test environment)
      return null;
    }
  }

  DocumentReference<Map<String, dynamic>>? get _portfolioDoc {
    final fs = _firestore;
    if (fs == null) return null;
    return fs.collection('portfolio').doc('content');
  }

  /// Fetches portfolio configuration from Cloud Firestore with a 2.5-second timeout.
  /// Returns `null` if the document does not exist, Firebase is uninitialized, or Firestore is unreachable.
  Future<PortfolioConfig?> getPortfolioConfig() async {
    try {
      final doc = _portfolioDoc;
      if (doc == null) return null;

      final snapshot = await doc.get().timeout(
        const Duration(milliseconds: 2500),
      );
      if (snapshot.exists && snapshot.data() != null) {
        return PortfolioConfig.fromJson(snapshot.data()!);
      }
      return null;
    } catch (e) {
      debugPrint(
        'PortfolioRemoteDataSource: Remote fetch skipped (offline/timeout): $e',
      );
      return null;
    }
  }

  /// Saves the complete portfolio configuration to Cloud Firestore with a 5-second timeout.
  Future<void> savePortfolioConfig(PortfolioConfig config) async {
    final doc = _portfolioDoc;
    if (doc == null) {
      throw StateError('Firebase Firestore is not initialized.');
    }
    await doc
        .set(config.toJson(), SetOptions(merge: true))
        .timeout(const Duration(seconds: 5));
  }

  /// Seeds initial portfolio configuration to Cloud Firestore if no document exists yet.
  /// Only executes if authenticated as the portfolio owner (suhail7.dev@gmail.com).
  Future<void> seedInitialData(PortfolioConfig config) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email?.toLowerCase() != 'suhail7.dev@gmail.com') {
        return; // Public visitors do not write to Firestore
      }

      final doc = _portfolioDoc;
      if (doc == null) return;

      final snapshot = await doc.get().timeout(
        const Duration(milliseconds: 2500),
      );
      if (!snapshot.exists) {
        await doc.set(config.toJson()).timeout(const Duration(seconds: 4));
        debugPrint('PortfolioRemoteDataSource: Seeded initial Firestore data.');
      }
    } catch (e) {
      debugPrint(
        'PortfolioRemoteDataSource: Seeding skipped (offline/timeout): $e',
      );
    }
  }
}
