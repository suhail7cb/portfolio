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

/// Contact section providing direct touchpoints (email, phone, location) and quick message sender.
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
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
            const SectionTitle(
              subtitle: 'START A CONVERSATION',
              title: 'Get In Touch',
              description:
                  'Whether you have an enterprise mobile project, leadership opportunity, or technical inquiry, my inbox is open.',
            ),

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

  Widget _buildInfoCards(BuildContext context, bool isDark) {
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
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        _ContactTouchpoint(
          icon: Icons.location_on_outlined,
          title: 'Current Location',
          value: widget.personalInfo.location,
        ),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context, bool isDark) {
    return GlassContainer(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a Direct Message',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Fill in the details below to initiate direct communication.',
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
  final VoidCallback? onTapValue;
  final VoidCallback? onCopy;

  const _ContactTouchpoint({
    required this.icon,
    required this.title,
    required this.value,
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
