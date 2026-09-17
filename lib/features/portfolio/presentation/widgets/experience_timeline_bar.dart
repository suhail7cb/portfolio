import 'package:flutter/material.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/features/portfolio/domain/entities/experience.dart';

/// Interactive horizontal timeline node bar for career trajectory navigation.
class ExperienceTimelineBar extends StatefulWidget {
  final List<Experience> experiences;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoPrevious;
  final bool canGoNext;

  const ExperienceTimelineBar({
    super.key,
    required this.experiences,
    required this.selectedIndex,
    required this.onSelect,
    required this.onPrevious,
    required this.onNext,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  @override
  State<ExperienceTimelineBar> createState() => _ExperienceTimelineBarState();
}

class _ExperienceTimelineBarState extends State<ExperienceTimelineBar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant ExperienceTimelineBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _scrollToActiveNode();
    }
  }

  void _scrollToActiveNode() {
    if (!_scrollController.hasClients) return;
    // Estimated node width ~170px
    const double itemWidth = 170.0;
    final double targetOffset = (widget.selectedIndex * itemWidth) -
        (_scrollController.position.viewportDimension / 2) +
        (itemWidth / 2);

    final double clampedOffset = targetOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Previous Arrow Button
          _ArrowNavButton(
            icon: Icons.chevron_left_rounded,
            tooltip: 'Previous Experience (Arrow Left)',
            isEnabled: widget.canGoPrevious,
            onTap: widget.onPrevious,
          ),
          const SizedBox(width: 8),

          // Horizontal Timeline Track
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(widget.experiences.length, (index) {
                    final experience = widget.experiences[index];
                    final bool isSelected = index == widget.selectedIndex;
                    final bool isFirst = index == 0;
                    final bool isLast = index == widget.experiences.length - 1;

                    return _TimelineNodeItem(
                      experience: experience,
                      isSelected: isSelected,
                      isFirst: isFirst,
                      isLast: isLast,
                      isDark: isDark,
                      onTap: () => widget.onSelect(index),
                    );
                  }),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),
          // Next Arrow Button
          _ArrowNavButton(
            icon: Icons.chevron_right_rounded,
            tooltip: 'Next Experience (Arrow Right)',
            isEnabled: widget.canGoNext,
            onTap: widget.onNext,
          ),
        ],
      ),
    );
  }
}

class _ArrowNavButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool isEnabled;
  final VoidCallback onTap;

  const _ArrowNavButton({
    required this.icon,
    required this.tooltip,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  State<_ArrowNavButton> createState() => _ArrowNavButtonState();
}

class _ArrowNavButtonState extends State<_ArrowNavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: widget.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.isEnabled ? widget.onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isEnabled && _isHovered
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : (isDark ? AppColors.darkCard : AppColors.lightCard),
              border: Border.all(
                color: widget.isEnabled && _isHovered
                    ? AppColors.primary
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: 1.2,
              ),
              boxShadow: [
                if (widget.isEnabled && _isHovered)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                  ),
              ],
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: widget.isEnabled
                  ? (_isHovered
                      ? AppColors.primary
                      : (isDark ? Colors.white : AppColors.lightTextPrimary))
                  : (isDark ? AppColors.darkTextMuted.withValues(alpha: 0.3) : AppColors.lightTextMuted.withValues(alpha: 0.3)),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineNodeItem extends StatefulWidget {
  final Experience experience;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final bool isDark;
  final VoidCallback onTap;

  const _TimelineNodeItem({
    required this.experience,
    required this.isSelected,
    required this.isFirst,
    required this.isLast,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_TimelineNodeItem> createState() => _TimelineNodeItemState();
}

class _TimelineNodeItemState extends State<_TimelineNodeItem> {
  bool _isHovered = false;

  String _formatShortPeriod(String period) {
    // e.g. "June 2025 – Present" -> "2025 — Present"
    // "Feb 2019 – June 2025" -> "2019 — 2025"
    final regex = RegExp(r'(\b\d{4}\b).*?([–\-—].*?(\b\d{4}\b|Present))', caseSensitive: false);
    final match = regex.firstMatch(period);
    if (match != null) {
      final startYear = match.group(1);
      final rawEnd = match.group(2) ?? '';
      if (rawEnd.toLowerCase().contains('present')) {
        return '$startYear — Present';
      }
      final endYearMatch = RegExp(r'\b\d{4}\b').allMatches(rawEnd);
      if (endYearMatch.isNotEmpty) {
        return '$startYear — ${endYearMatch.last.group(0)}';
      }
    }
    return period;
  }

  @override
  Widget build(BuildContext context) {
    final String shortPeriod = _formatShortPeriod(widget.experience.period);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 170,
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Period Text above node
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isSelected
                      ? AppColors.primary
                      : (_isHovered
                          ? (widget.isDark ? Colors.white : AppColors.lightTextPrimary)
                          : (widget.isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  letterSpacing: 0.2,
                ),
                child: Text(
                  shortPeriod,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),

              // 2. Track & Node Circle
              SizedBox(
                height: 24,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Connecting horizontal line
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: widget.isFirst
                                ? Colors.transparent
                                : (widget.isSelected
                                    ? AppColors.primary.withValues(alpha: 0.7)
                                    : (widget.isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: widget.isLast
                                ? Colors.transparent
                                : (widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                        ),
                      ],
                    ),

                    // Illuminated Center Circle
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: widget.isSelected ? 18 : 12,
                      height: widget.isSelected ? 18 : 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isSelected
                            ? AppColors.primary
                            : (_isHovered
                                ? AppColors.primary.withValues(alpha: 0.7)
                                : (widget.isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1))),
                        border: Border.all(
                          color: widget.isSelected
                              ? Colors.white
                              : (widget.isDark ? AppColors.darkBackground : Colors.white),
                          width: widget.isSelected ? 3 : 2,
                        ),
                        boxShadow: [
                          if (widget.isSelected || _isHovered)
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: widget.isSelected ? 0.65 : 0.35),
                              blurRadius: widget.isSelected ? 12 : 8,
                              spreadRadius: widget.isSelected ? 2 : 1,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 3. Company Name below node
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isSelected
                      ? (widget.isDark ? Colors.white : AppColors.lightTextPrimary)
                      : (_isHovered
                          ? AppColors.primary
                          : (widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                ),
                child: Text(
                  widget.experience.company,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
