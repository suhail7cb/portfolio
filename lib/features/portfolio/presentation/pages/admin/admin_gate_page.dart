import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import 'admin_dashboard_page.dart';
import 'admin_login_page.dart';

/// Secure Gate checking authentication state and email identity
/// before granting access to the [AdminDashboardPage].
class AdminGatePage extends StatelessWidget {
  const AdminGatePage({super.key});

  static const String authorizedAdminEmail = AppConstants.adminEmail;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0A0D14),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null && user.email?.toLowerCase() == authorizedAdminEmail) {
          return const AdminDashboardPage();
        }

        return const AdminLoginPage();
      },
    );
  }
}
