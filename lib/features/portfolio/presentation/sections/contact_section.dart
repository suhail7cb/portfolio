import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/core/utils/url_launcher_helper.dart';
import 'package:portfolio/features/portfolio/domain/entities/personal_info.dart';
import 'package:portfolio/features/portfolio/domain/entities/social_link.dart';
import 'package:portfolio/shared/components/section_title.dart';
import 'package:portfolio/shared/components/glass_container.dart';
import 'package:portfolio/shared/components/gradient_button.dart';

/// Contact section redesigned as the high-impact final CTA of the portfolio.
/// Features the "Ready to build something great?" headline, "Let's Talk →" CTA,
/// verified touchpoints (Email, LinkedIn, GitHub, Phone), and an interactive direct message form.
class ContactSection extends StatefulWidget {
  final PersonalInfo personalInfo;
  final List<SocialLink> socialLinks;

  const ContactSection({
    super.key,
    required this.personalInfo,
    required this.socialLinks,
  });

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _messageFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _onLetsTalkPressed() {
    // Open email client directly with collaboration intent
    UrlLauncherHelper.openEmail(
      widget.personalInfo.email,
      subject: "Let's Talk — Engineering Collaboration",
      body: "Hi Suhail,\n\nI came across your portfolio and would love to discuss...",
    );
    // Also focus message form for users on platforms without native mail handlers
    _messageFocusNode.requestFocus();
  }

  void _sendMessage() {
    if (_formKey.currentState?.validate() ?? false) {
      final subject = _subjectController.text.trim().isEmpty
          ? 'Inquiry from Portfolio Website'
          : _subjectController.text.trim();
      final body =
          'Name: ${_nameController.text.trim()}\nEmail: ${_emailController.text.trim()}\n\n${_messageController.text.trim()}';

      UrlLauncherHelper.openEmail(
        widget.personalInfo.email,
        subject: subject,
        body: body,
      );

      context.showSnackBar('Opening your mail client...');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile
            ? AppDimensions.sectionVerticalPaddingMobile
            : AppDimensions.sectionVerticalPadding,
      ),
      child: ResponsiveContentWrapper(
        child: Column(
          children: [
            // Section Header matching Specification Section 18
            const SectionTitle(
              subtitle: 'GET IN TOUCH',
              title: 'Ready to build something great?',
              description:
                  "I'm open to interesting engineering problems, product collaborations and senior mobile opportunities.",
            ),

            // High-Impact Primary CTA Banner
            _buildPrimaryCtaBanner(context, isDark, isMobile),
            const SizedBox(height: 36),

            // Responsive Layout: Touchpoints + Direct Message Form
            isMobile
                ? Column(
                    children: [
                      _buildInfoCards(context, isDark),
                      const SizedBox(height: 32),
                      _buildContactForm(context, isDark),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildInfoCards(context, isDark),
                      ),
                      const SizedBox(width: 36),
                      Expanded(
                        flex: 6,
                        child: _buildContactForm(context, isDark),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  /// Primary CTA Card with "Let's Talk →"
  Widget _buildPrimaryCtaBanner(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 22 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.18),
            AppColors.secondary.withValues(alpha: 0.18),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCtaText(context, isDark, isMobile),
                const SizedBox(height: 20),
                _buildCtaButton(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildCtaText(context, isDark, isMobile)),
                const SizedBox(width: 24),
                _buildCtaButton(),
              ],
            ),
    );
  }

  Widget _buildCtaText(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'AVAILABLE FOR SENIOR MOBILE ROLES & CONSULTING',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Have a mobile project or technical challenge?',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: isMobile ? 18 : 22,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Let’s discuss architecture, product delivery, and engineering execution.',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: 13.5,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCtaButton() {
    return GradientButton(
      text: "Let's Talk →",
      leadingIcon: Icons.forum_rounded,
      onPressed: _onLetsTalkPressed,
    );
  }

  /// Verified Contact Touchpoints (Email, LinkedIn, GitHub, Phone, Location)
  Widget _buildInfoCards(BuildContext context, bool isDark) {
    // Locate LinkedIn and GitHub links from socialLinks
    final linkedInLink = widget.socialLinks
        .cast<SocialLink?>()
        .firstWhere((l) => l?.label.toLowerCase() == 'linkedin', orElse: () => null);
    final gitHubLink = widget.socialLinks
        .cast<SocialLink?>()
        .firstWhere((l) => l?.label.toLowerCase() == 'github', orElse: () => null);

    return Column(
      children: [
        _ContactTouchpoint(
          icon: Icons.email_outlined,
          title: 'Direct Email',
          value: widget.personalInfo.email,
          onTapValue: () => UrlLauncherHelper.openEmail(widget.personalInfo.email),
          onCopy: () {
            Clipboard.setData(ClipboardData(text: widget.personalInfo.email));
            context.showSnackBar('Email copied to clipboard!');
          },
        ),
        const SizedBox(height: 14),

        if (linkedInLink != null) ...[
          _ContactTouchpoint(
            icon: Icons.link_rounded,
            title: 'LinkedIn',
            value: 'suhail-s-4b9613a8',
            subtitle: 'Connect professionally',
            onTapValue: () => UrlLauncherHelper.launchURL(linkedInLink.url),
            onCopy: () {
              Clipboard.setData(ClipboardData(text: linkedInLink.url));
              context.showSnackBar('LinkedIn link copied!');
            },
          ),
          const SizedBox(height: 14),
        ],

        if (gitHubLink != null) ...[
          _ContactTouchpoint(
            icon: Icons.code_rounded,
            title: 'GitHub',
            value: 'suhail7cb',
            subtitle: 'Open source & repositories',
            onTapValue: () => UrlLauncherHelper.launchURL(gitHubLink.url),
            onCopy: () {
              Clipboard.setData(ClipboardData(text: gitHubLink.url));
              context.showSnackBar('GitHub link copied!');
            },
          ),
          const SizedBox(height: 14),
        ],

        _ContactTouchpoint(
          icon: Icons.phone_outlined,
          title: 'Direct Phone',
          value: widget.personalInfo.phone,
          onTapValue: () => UrlLauncherHelper.openPhone(widget.personalInfo.phone),
          onCopy: () {
            Clipboard.setData(ClipboardData(text: widget.personalInfo.phone));
            context.showSnackBar('Phone number copied to clipboard!');
          },
        ),
        const SizedBox(height: 14),

        _ContactTouchpoint(
          icon: Icons.location_on_outlined,
          title: 'Current Location',
          value: widget.personalInfo.location,
        ),
      ],
    );
  }

  /// Interactive Direct Message Form
  Widget _buildContactForm(BuildContext context, bool isDark) {
    return GlassContainer(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Send a Direct Message',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Fill in the details below to initiate direct email communication.',
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 20),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
              validator: (val) =>
                  (val == null || val.trim().isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),

            // Email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Your Email',
                prefixIcon: Icon(Icons.mail_outline, size: 20),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!val.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Subject
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                prefixIcon: Icon(Icons.subject_outlined, size: 20),
              ),
            ),
            const SizedBox(height: 16),

            // Message
            TextFormField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Message',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Icon(Icons.chat_bubble_outline, size: 20),
                ),
              ),
              validator: (val) =>
                  (val == null || val.trim().isEmpty) ? 'Please enter your message' : null,
            ),
            const SizedBox(height: 24),

            // Submit CTA
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                text: 'Send Message',
                leadingIcon: Icons.send_rounded,
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTouchpoint extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final VoidCallback? onTapValue;
  final VoidCallback? onCopy;

  const _ContactTouchpoint({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.onTapValue,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return GlassContainer(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: onTapValue,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: onTapValue != null
                          ? AppColors.primary
                          : (isDark ? Colors.white : AppColors.lightTextPrimary),
                    ),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 18),
              tooltip: 'Copy',
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              onPressed: onCopy,
            ),
        ],
      ),
    );
  }
}
