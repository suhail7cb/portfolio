import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/utils/profile_image_helper.dart';

/// Interactive glowing profile avatar with automatic image discovery,
/// multi-image session rotation, and a stylized initials fallback ("SS").
class ProfileAvatar extends StatefulWidget {
  final String name;
  final String? profileImageUrl;
  final double size;
  final bool showHoverEffect;
  final bool allowCycleOnClick;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    required this.name,
    this.profileImageUrl,
    this.size = 110,
    this.showHoverEffect = true,
    this.allowCycleOnClick = true,
    this.onTap,
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  String? _currentImage;
  bool _isLoading = true;
  bool _isHovered = false;
  int _candidateCount = 0;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant ProfileAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profileImageUrl != widget.profileImageUrl ||
        oldWidget.name != widget.name) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    final candidates = await ProfileImageHelper.getAllCandidateImages(
      explicitUrl: widget.profileImageUrl,
    );

    final selected = await ProfileImageHelper.selectProfileImage(
      explicitUrl: widget.profileImageUrl,
    );

    if (mounted) {
      setState(() {
        _candidateCount = candidates.length;
        _currentImage = selected;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleCycle() async {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    if (!widget.allowCycleOnClick || _candidateCount <= 1) return;

    final next = await ProfileImageHelper.cycleNextImage(
      explicitUrl: widget.profileImageUrl,
    );

    if (mounted) {
      setState(() {
        _currentImage = next;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double borderPadding = (widget.size * 0.035).clamp(2.5, 4.5);
    final bool canCycle = widget.allowCycleOnClick && _candidateCount > 1;

    Widget avatarContent = AnimatedScale(
      scale: (_isHovered && widget.showHoverEffect) ? 1.04 : 1.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.heroGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(
                alpha: _isHovered ? 0.55 : 0.35,
              ),
              blurRadius: _isHovered ? 32 : 28,
              spreadRadius: _isHovered ? 6 : 4,
            ),
          ],
        ),
        padding: EdgeInsets.all(borderPadding),
        child: ClipOval(
          child: _buildInnerContent(),
        ),
      ),
    );

    if (canCycle) {
      avatarContent = Tooltip(
        message: 'Click to switch photo ($_candidateCount available)',
        waitDuration: const Duration(milliseconds: 500),
        child: avatarContent,
      );
    }

    return MouseRegion(
      cursor: canCycle ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (mounted && widget.showHoverEffect) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (mounted && widget.showHoverEffect) {
          setState(() => _isHovered = false);
        }
      },
      child: GestureDetector(
        onTap: _handleCycle,
        child: avatarContent,
      ),
    );
  }

  Widget _buildInnerContent() {
    if (_isLoading) {
      return _buildInitials();
    }

    if (_currentImage == null || _currentImage!.trim().isEmpty) {
      return _buildInitials();
    }

    final imagePath = _currentImage!.trim();

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildInitials(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildInitials();
        },
      );
    }

    return Image.asset(
      imagePath,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildInitials(),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return _buildInitials();
      },
    );
  }

  Widget _buildInitials() {
    final initials = ProfileImageHelper.getInitials(widget.name);
    final fontSize = widget.size * 0.36;

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.heroGradient,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}
