import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import 'admin_dashboard_page.dart';
import 'admin_login_page.dart';

/// Secure Gate checking authentication state and email identity
/// before granting access to the [AdminDashboardPage].
/// Includes safety timeout and synchronous initial state to prevent loading hangs.
class AdminGatePage extends StatefulWidget {
  const AdminGatePage({super.key});

  static const String authorizedAdminEmail = AppConstants.adminEmail;

  @override
  State<AdminGatePage> createState() => _AdminGatePageState();
}

class _AdminGatePageState extends State<AdminGatePage> {
  bool _timedOut = false;

  @override
  void initState() {
    super.initState();
    // Safety timeout: if auth stream doesn't emit within 1.5 seconds, show login page
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && !_timedOut) {
        setState(() => _timedOut = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      return StreamBuilder<User?>(
        initialData: FirebaseAuth.instance.currentUser,
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !_timedOut &&
              snapshot.data == null) {
            return const Scaffold(
              backgroundColor: Color(0xFF0A0D14),
              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00E5FF),
                ),
              ),
            );
          }

          final user = snapshot.data ?? FirebaseAuth.instance.currentUser;
          if (user != null &&
              user.email?.toLowerCase() ==
                  AdminGatePage.authorizedAdminEmail.toLowerCase()) {
            return const AdminDashboardPage();
          }

          return const AdminLoginPage();
        },
      );
    } catch (_) {
      // If Firebase Auth instance throws an initialization error, show login page
      return const AdminLoginPage();
    }
  }
}
