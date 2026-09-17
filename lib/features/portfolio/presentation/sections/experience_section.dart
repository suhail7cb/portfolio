import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/constants/app_colors.dart';
import 'package:portfolio/core/constants/app_dimensions.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/responsive/responsive_builder.dart';
import 'package:portfolio/core/responsive/responsive_layout.dart';
import 'package:portfolio/features/portfolio/domain/entities/experience.dart';
import 'package:portfolio/shared/components/section_title.dart';
import '../widgets/experience_timeline_bar.dart';
import '../widgets/experience_focus_card.dart';
import '../widgets/experience_previous_list.dart';
import '../widgets/experience_detail_dialog.dart';
import '../widgets/experience_timeline_tile.dart';

/// Interactive career journey section featuring horizontal timeline navigation,
/// focused role card with impact metrics, career milestones sidebar, and expanded detail view.
class ExperienceSection extends StatefulWidget {
  final List<Experience> experiences;
  final void Function(String projectTitle)? onNavigateToProject;

  const ExperienceSection({
    super.key,
    required this.experiences,
    this.onNavigateToProject,
  });

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  int _selectedIndex = 0;
  bool _isTimelineMode = true; // true = Timeline journey, false = Cards list
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _selectExperience(int index) {
    if (index >= 0 && index < widget.experiences.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _previousExperience() {
    if (_selectedIndex > 0) {
      _selectExperience(_selectedIndex - 1);
    }
  }

  void _nextExperience() {
    if (_selectedIndex < widget.experiences.length - 1) {
      _selectExperience(_selectedIndex + 1);
    }
  }

  void _openDetailModal() {
    ExperienceDetailDialog.show(
      context,
      experiences: widget.experiences,
      initialIndex: _selectedIndex,
      onNavigateToProject: widget.onNavigateToProject,
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _previousExperience();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _nextExperience();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    final bool isMobile = ResponsiveBuilder.isMobile(context);
    final Experience currentExperience = widget.experiences.isNotEmpty
        ? widget.experiences[_selectedIndex.clamp(0, widget.experiences.length - 1)]
        : const Experience(
            role: '',
            company: '',
            location: '',
            period: '',
            responsibilities: [],
          );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile
            ? AppDimensions.sectionVerticalPaddingMobile
            : AppDimensions.sectionVerticalPadding,
      ),
      child: ResponsiveContentWrapper(
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Header with View Mode Switcher [ Timeline | Cards ]
              _buildHeaderWithSwitcher(isDark, isMobile),

              const SizedBox(height: 24),

              // 2. Main Content: Timeline View vs Cards List View
              if (_isTimelineMode && widget.experiences.isNotEmpty) ...[
                // Horizontal Interactive Timeline Bar
                ExperienceTimelineBar(
                  experiences: widget.experiences,
                  selectedIndex: _selectedIndex,
                  onSelect: _selectExperience,
                  onPrevious: _previousExperience,
                  onNext: _nextExperience,
                  canGoPrevious: _selectedIndex > 0,
                  canGoNext: _selectedIndex < widget.experiences.length - 1,
                ),

                const SizedBox(height: 28),

                // Focused Experience Card & Sidebar with Smooth Animated Switcher
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.03),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<int>(_selectedIndex),
                    child: isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExperienceFocusCard(
                                experience: currentExperience,
                                onViewDetails: _openDetailModal,
                              ),
                              const SizedBox(height: 20),
                              ExperiencePreviousList(
                                experiences: widget.experiences,
                                selectedIndex: _selectedIndex,
                                onSelect: _selectExperience,
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Large Focused Experience Card (Left)
                              Expanded(
                                flex: 7,
                                child: ExperienceFocusCard(
                                  experience: currentExperience,
                                  onViewDetails: _openDetailModal,
                                ),
                              ),
                              const SizedBox(width: 24),

                              // Career Milestones Sidebar (Right)
                              Expanded(
                                flex: 5,
                                child: ExperiencePreviousList(
                                  experiences: widget.experiences,
                                  selectedIndex: _selectedIndex,
                                  onSelect: _selectExperience,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ] else ...[
                // Alternate Cards / Vertical Timeline Mode
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.experiences.length,
                  itemBuilder: (context, index) {
                    final experience = widget.experiences[index];
                    final bool isFirst = index == 0;
                    final bool isLast = index == widget.experiences.length - 1;

                    return ExperienceTimelineTile(
                      experience: experience,
                      isFirst: isFirst,
                      isLast: isLast,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderWithSwitcher(bool isDark, bool isMobile) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SectionTitle(
                subtitle: 'CAREER TRAJECTORY',
                title: 'Professional Experience',
                description:
                    'A track record of technical leadership, architecting enterprise systems, and delivering production mobile solutions.',
              ),
              const SizedBox(height: 12),
              _buildViewModeToggle(isDark),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: SectionTitle(
                  subtitle: 'CAREER TRAJECTORY',
                  title: 'Professional Experience',
                  description:
                      'A track record of technical leadership, architecting enterprise systems, and delivering production mobile solutions.',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildViewModeToggle(isDark),
              ),
            ],
          );
  }

  Widget _buildViewModeToggle(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1523) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            label: 'Timeline',
            icon: Icons.timeline_rounded,
            isSelected: _isTimelineMode,
            isDark: isDark,
            onTap: () {
              if (!_isTimelineMode) {
                setState(() => _isTimelineMode = true);
              }
            },
          ),
          const SizedBox(width: 4),
          _ToggleButton(
            label: 'Cards',
            icon: Icons.view_agenda_outlined,
            isSelected: !_isTimelineMode,
            isDark: isDark,
            onTap: () {
              if (_isTimelineMode) {
                setState(() => _isTimelineMode = false);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.radiusM - 2),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM - 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.black
                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                  ? Colors.black
                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
