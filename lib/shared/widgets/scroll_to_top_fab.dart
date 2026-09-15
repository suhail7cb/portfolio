import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';

/// Floating Action Button that smoothly scrolls the page back to the top.
class ScrollToTopFab extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollToTopFab({super.key, required this.scrollController});

  @override
  State<ScrollToTopFab> createState() => _ScrollToTopFabState();
}

class _ScrollToTopFabState extends State<ScrollToTopFab> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (widget.scrollController.offset > 400 && !_isVisible) {
      setState(() => _isVisible = true);
    } else if (widget.scrollController.offset <= 400 && _isVisible) {
      setState(() => _isVisible = false);
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: IgnorePointer(
        ignoring: !_isVisible,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton.small(
            onPressed: _scrollToTop,
            backgroundColor: isDark ? AppColors.darkCard : Colors.white,
            foregroundColor: AppColors.primary,
            elevation: 4,
            tooltip: 'Scroll to Top',
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            child: const Icon(Icons.arrow_upward, size: 20),
          ),
        ),
      ),
    );
  }
}
