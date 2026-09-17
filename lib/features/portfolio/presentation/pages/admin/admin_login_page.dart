import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';

/// Secure Login Page for the Portfolio Owner (`suhail7.dev@gmail.com`).
/// Supports one-click Google Sign-In and Email/Password credentials.
class AdminLoginPage extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const AdminLoginPage({super.key, this.onLoginSuccess});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'suhail7.dev@gmail.com');
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  String? _infoMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles 1-click Google Sign-in via browser popup
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    try {
      final googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.setCustomParameters({'prompt': 'select_account'});

      final credential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
      final user = credential.user;

      if (user == null ||
          user.email?.toLowerCase() != 'suhail7.dev@gmail.com') {
        await FirebaseAuth.instance.signOut();
        setState(() {
          _errorMessage =
              'Access denied. Signed in as "${user?.email ?? 'Unknown'}", but only suhail7.dev@gmail.com is authorized to access this admin panel.';
          _isGoogleLoading = false;
        });
        return;
      }

      if (widget.onLoginSuccess != null) {
        widget.onLoginSuccess!();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'popup-closed-by-user':
            _errorMessage =
                'Sign-in was cancelled. The Google popup was closed before completion.';
            break;
          case 'popup-blocked':
            _errorMessage =
                'Popup was blocked by your browser. Please allow popups for this site to sign in with Google.';
            break;
          case 'cancelled-popup-request':
            _errorMessage =
                'Multiple popup requests initiated. Please try again.';
            break;
          case 'operation-not-allowed':
            _errorMessage =
                'Google sign-in is not yet enabled in Firebase Console. Go to Firebase Console > Authentication > Sign-in method and enable Google provider.';
            break;
          case 'unauthorized-domain':
            _errorMessage =
                'Domain not authorized. Add localhost or your hosting domain in Firebase Console > Authentication > Settings > Authorized domains.';
            break;
          default:
            _errorMessage = e.message ?? 'Google Sign-in failed (${e.code}).';
        }
        _isGoogleLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred during Google sign-in: $e';
        _isGoogleLoading = false;
      });
    }
  }

  /// Handles Email/Password Login
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final user = credential.user;
      if (user == null ||
          user.email?.toLowerCase() != 'suhail7.dev@gmail.com') {
        await FirebaseAuth.instance.signOut();
        setState(() {
          _errorMessage =
              'Access denied. Only the portfolio owner (suhail7.dev@gmail.com) is authorized.';
          _isLoading = false;
        });
        return;
      }

      if (widget.onLoginSuccess != null) {
        widget.onLoginSuccess!();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            _errorMessage =
                'No password account found for this email in Firebase yet. Click "Sign in with Google" above or add this user in Firebase Console.';
            break;
          case 'wrong-password':
          case 'invalid-credential':
            _errorMessage =
                'Incorrect password. If you haven\'t set a password yet, use "Sign in with Google" above or click "Forgot password?".';
            break;
          case 'user-disabled':
            _errorMessage = 'This user account has been disabled.';
            break;
          case 'too-many-requests':
            _errorMessage =
                'Too many failed login attempts. Please try again later or use Google Sign-in.';
            break;
          default:
            _errorMessage =
                e.message ?? 'Authentication failed. Please try again.';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage =
          'Please enter your email to receive a password reset link.');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _infoMessage =
            'Password reset email sent to $email. Check your inbox to set a password!';
        _errorMessage = null;
      });
    } catch (e) {
      setState(() => _errorMessage = 'Failed to send reset email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool anyLoading = _isLoading || _isGoogleLoading;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.darkBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 40,
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon and Header
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.admin_panel_settings_rounded,
                          color: AppColors.darkBackground,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Admin Portal',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkTextPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to manage projects, experiences, and live portfolio data.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.darkTextSecondary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // Error Banner
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.error,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Info Banner
                    if (_infoMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: AppColors.success,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _infoMessage!,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ==========================================
                    // 1-CLICK GOOGLE SIGN-IN BUTTON (RECOMMENDED)
                    // ==========================================
                    OutlinedButton(
                      onPressed: anyLoading ? null : _handleGoogleSignIn,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1F2937),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isGoogleLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF1F2937),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CustomPaint(
                                    painter: _GoogleLogoPainter(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Sign in with Google',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1F2937),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Divider: OR SIGN IN WITH EMAIL
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: AppColors.darkBorder),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'OR SIGN IN WITH EMAIL',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkTextMuted,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: AppColors.darkBorder),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Email Field
                    Text(
                      'Email Address',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      style: GoogleFonts.inter(color: AppColors.darkTextPrimary),
                      decoration: InputDecoration(
                        hintText: 'admin@example.com',
                        hintStyle:
                            GoogleFonts.inter(color: AppColors.darkTextMuted),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.darkTextMuted,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: AppColors.darkCard,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.darkBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Email is required'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Password',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkTextPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: anyLoading ? null : _handleForgotPassword,
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: GoogleFonts.inter(color: AppColors.darkTextPrimary),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle:
                            GoogleFonts.inter(color: AppColors.darkTextMuted),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.darkTextMuted,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.darkTextMuted,
                            size: 20,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.darkCard,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.darkBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Password is required'
                          : null,
                    ),
                    const SizedBox(height: 28),

                    // Email Sign In Button
                    ElevatedButton(
                      onPressed: anyLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.darkBackground,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.darkBackground,
                                ),
                              ),
                            )
                          : Text(
                              'Sign In with Email',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 24),

                    // Back to Public Site
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            size: 16,
                            color: AppColors.darkTextMuted,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Back to Public Portfolio',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.darkTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Vector Painter for the authentic 4-color Google "G" logo
class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / 48.0;
    canvas.scale(scale, scale);

    // Blue
    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final bluePath = Path()
      ..moveTo(46.98, 24.55)
      ..cubicTo(46.98, 22.84, 46.83, 21.19, 46.54, 19.60)
      ..lineTo(24, 19.60)
      ..lineTo(24, 28.98)
      ..lineTo(36.94, 28.98)
      ..cubicTo(36.38, 31.97, 34.69, 34.50, 32.14, 36.21)
      ..lineTo(32.14, 42.22)
      ..lineTo(39.92, 42.22)
      ..cubicTo(44.47, 38.03, 46.98, 31.87, 46.98, 24.55)
      ..close();
    canvas.drawPath(bluePath, bluePaint);

    // Green
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill;
    final greenPath = Path()
      ..moveTo(24, 48)
      ..cubicTo(30.48, 48, 35.91, 45.85, 39.92, 42.22)
      ..lineTo(32.14, 36.21)
      ..cubicTo(30.01, 37.64, 27.24, 38.51, 24, 38.51)
      ..cubicTo(17.75, 38.51, 12.46, 34.27, 10.57, 28.59)
      ..lineTo(2.55, 28.59)
      ..lineTo(2.55, 34.80)
      ..cubicTo(6.52, 42.68, 14.62, 48, 24, 48)
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // Yellow
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill;
    final yellowPath = Path()
      ..moveTo(10.57, 28.59)
      ..cubicTo(10.09, 27.15, 9.82, 25.60, 9.82, 24)
      ..cubicTo(9.82, 22.40, 10.09, 20.85, 10.57, 19.41)
      ..lineTo(10.57, 13.20)
      ..lineTo(2.55, 13.20)
      ..cubicTo(0.92, 16.44, 0, 20.11, 0, 24)
      ..cubicTo(0, 27.89, 0.92, 31.56, 2.55, 34.80)
      ..lineTo(10.57, 28.59)
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Red
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill;
    final redPath = Path()
      ..moveTo(24, 9.49)
      ..cubicTo(27.52, 9.49, 30.68, 10.71, 33.17, 13.08)
      ..lineTo(40.09, 6.16)
      ..cubicTo(35.90, 2.34, 30.48, 0, 24, 0)
      ..cubicTo(14.62, 0, 6.52, 5.32, 2.55, 13.20)
      ..lineTo(10.57, 19.41)
      ..cubicTo(12.46, 13.73, 17.75, 9.49, 24, 9.49)
      ..close();
    canvas.drawPath(redPath, redPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
