import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/achievement.dart';
import '../../../domain/entities/certification.dart';
import '../../../domain/entities/education.dart';
import '../../../domain/entities/experience.dart';
import '../../../domain/entities/portfolio_config.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/skill_group.dart';
import '../../../domain/entities/social_link.dart';
import '../../bloc/portfolio_cubit.dart';
import '../../bloc/portfolio_state.dart';

/// Comprehensive Admin Dashboard allowing the owner (`suhail7.dev@gmail.com`)
/// to update any existing record and add new records across all sections.
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PortfolioConfig? _draftConfig;
  bool _isDirty = false;
  bool _isSaving = false;

  // Controllers for Personal Info
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _taglineController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _avatarController;
  late TextEditingController _totalExpController;
  late TextEditingController _summaryController;
  late TextEditingController _resumeController;

  // Controllers for Meta
  late TextEditingController _metaTitleController;
  late TextEditingController _metaDescController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _initControllers();
  }

  void _initControllers() {
    final state = context.read<PortfolioCubit>().state;
    if (state is PortfolioLoaded) {
      _draftConfig = state.config;
      final info = _draftConfig!.personalInfo;
      _nameController = TextEditingController(text: info.name);
      _titleController = TextEditingController(text: info.title);
      _taglineController = TextEditingController(text: info.tagline);
      _emailController = TextEditingController(text: info.email);
      _phoneController = TextEditingController(text: info.phone);
      _locationController = TextEditingController(text: info.location);
      _avatarController = TextEditingController(text: info.profileImageUrl ?? '');
      _totalExpController = TextEditingController(text: info.totalExperience);
      _summaryController = TextEditingController(text: info.professionalSummary);
      _resumeController = TextEditingController(text: info.resumeDownloadUrl ?? '');

      _metaTitleController = TextEditingController(text: _draftConfig!.metaTitle);
      _metaDescController = TextEditingController(text: _draftConfig!.metaDescription);
    } else {
      _nameController = TextEditingController();
      _titleController = TextEditingController();
      _taglineController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
      _locationController = TextEditingController();
      _avatarController = TextEditingController();
      _totalExpController = TextEditingController();
      _summaryController = TextEditingController();
      _resumeController = TextEditingController();
      _metaTitleController = TextEditingController();
      _metaDescController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _titleController.dispose();
    _taglineController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _avatarController.dispose();
    _totalExpController.dispose();
    _summaryController.dispose();
    _resumeController.dispose();
    _metaTitleController.dispose();
    _metaDescController.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  Future<void> _saveAndPublish() async {
    if (_draftConfig == null) return;

    setState(() => _isSaving = true);

    try {
      // Sync personal info text fields into draft
      final updatedPersonalInfo = _draftConfig!.personalInfo.copyWith(
        name: _nameController.text.trim(),
        title: _titleController.text.trim(),
        tagline: _taglineController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        profileImageUrl: _avatarController.text.trim().isEmpty ? null : _avatarController.text.trim(),
        totalExperience: _totalExpController.text.trim(),
        professionalSummary: _summaryController.text.trim(),
        resumeDownloadUrl: _resumeController.text.trim().isEmpty ? null : _resumeController.text.trim(),
      );

      final finalConfig = _draftConfig!.copyWith(
        personalInfo: updatedPersonalInfo,
        metaTitle: _metaTitleController.text.trim(),
        metaDescription: _metaDescController.text.trim(),
      );

      await context.read<PortfolioCubit>().updatePortfolio(finalConfig);

      setState(() {
        _draftConfig = finalConfig;
        _isDirty = false;
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                const Icon(Icons.cloud_done, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  'Changes published live to Cloud Firestore!',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Failed to publish changes: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PortfolioCubit, PortfolioState>(
      listener: (context, state) {
        if (state is PortfolioLoaded && _draftConfig == null) {
          setState(() {
            _draftConfig = state.config;
            _initControllers();
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: _buildAppBar(),
        body: _draftConfig == null
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : Column(
                children: [
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPersonalInfoTab(),
                        _buildExperiencesTab(),
                        _buildProjectsTab(),
                        _buildSkillsTab(),
                        _buildEducationCertificationsTab(),
                        _buildAchievementsSocialTab(),
                        _buildSectionTogglesTab(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      titleSpacing: 24,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'Admin Dashboard',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
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
                const SizedBox(width: 6),
                Text(
                  'Cloud Firestore Live',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Live Preview Button
        TextButton.icon(
          onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
          icon: const Icon(Icons.remove_red_eye_outlined, size: 16, color: AppColors.primary),
          label: Text('View Public Site', style: GoogleFonts.inter(color: AppColors.primary, fontSize: 13)),
        ),
        const SizedBox(width: 12),

        // Save and Publish Button
        ElevatedButton.icon(
          onPressed: _isSaving ? null : _saveAndPublish,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isDirty ? AppColors.success : AppColors.primary,
            foregroundColor: AppColors.darkBackground,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.darkBackground),
                )
              : Icon(_isDirty ? Icons.cloud_upload : Icons.check, size: 18),
          label: Text(
            _isSaving ? 'Publishing...' : (_isDirty ? 'Publish Live Changes' : 'Saved Live'),
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(width: 12),

        // Sign Out
        IconButton(
          tooltip: 'Sign Out',
          icon: const Icon(Icons.logout, color: AppColors.darkTextMuted, size: 20),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (mounted) Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.darkSurface,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.darkTextMuted,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
        tabs: const [
          Tab(icon: Icon(Icons.person_outline, size: 18), text: 'Personal Info'),
          Tab(icon: Icon(Icons.work_outline, size: 18), text: 'Experiences'),
          Tab(icon: Icon(Icons.rocket_launch_outlined, size: 18), text: 'Projects'),
          Tab(icon: Icon(Icons.bolt_outlined, size: 18), text: 'Skills'),
          Tab(icon: Icon(Icons.school_outlined, size: 18), text: 'Education & Certs'),
          Tab(icon: Icon(Icons.emoji_events_outlined, size: 18), text: 'Achievements & Links'),
          Tab(icon: Icon(Icons.toggle_on_outlined, size: 18), text: 'Section Toggles & SEO'),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 1: PERSONAL INFO
  // =========================================================================
  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Personal Information', 'Edit your core contact and bio details'),
              const SizedBox(height: 24),
              _buildTextField('Full Name', _nameController),
              const SizedBox(height: 16),
              _buildTextField('Professional Title (e.g. Senior Mobile Architect)', _titleController),
              const SizedBox(height: 16),
              _buildTextField('Tagline / Hero Hook', _taglineController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Email Address', _emailController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Phone Number', _phoneController)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Location (City, Country)', _locationController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Total Experience (e.g. 10+ Years)', _totalExpController)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Profile Image Asset/URL', _avatarController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Resume Download URL', _resumeController)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('Professional Summary / Bio', _summaryController, maxLines: 5),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 2: EXPERIENCES (Add, Edit, Delete)
  // =========================================================================
  Widget _buildExperiencesTab() {
    final experiences = _draftConfig!.experiences;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Work Experience', 'Manage roles, accomplishments, and career timeline'),
                  ElevatedButton.icon(
                    onPressed: () => _showExperienceDialog(),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('Add Experience', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.darkBackground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: experiences.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final exp = experiences[index];
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exp.role,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkTextPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${exp.company} • ${exp.period} (${exp.location})',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (exp.isCurrent)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text('Current', style: GoogleFonts.inter(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                              onPressed: () => _showExperienceDialog(experience: exp, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                              onPressed: () => _deleteExperience(index),
                            ),
                          ],
                        ),
                        if (exp.responsibilities.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          ...exp.responsibilities.map(
                            (r) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(color: AppColors.primary)),
                                  Expanded(
                                    child: Text(
                                      r,
                                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.darkTextSecondary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExperienceDialog({Experience? experience, int? index}) {
    final roleCtrl = TextEditingController(text: experience?.role ?? '');
    final compCtrl = TextEditingController(text: experience?.company ?? '');
    final periodCtrl = TextEditingController(text: experience?.period ?? '');
    final locCtrl = TextEditingController(text: experience?.location ?? '');
    final durCtrl = TextEditingController(text: experience?.durationText ?? '');
    final bulletsCtrl = TextEditingController(text: experience?.responsibilities.join('\n') ?? '');
    bool isCurrent = experience?.isCurrent ?? false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            experience == null ? 'Add New Experience' : 'Edit Experience',
            style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField('Role / Title', roleCtrl),
                  const SizedBox(height: 12),
                  _buildTextField('Company Name', compCtrl),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Period (e.g. 2022 - Present)', periodCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('Location (e.g. Remote, India)', locCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField('Duration Text (e.g. 2 yrs 4 mos)', durCtrl),
                  const SizedBox(height: 12),
                  _buildTextField('Accomplishments & Bullets (One per line)', bulletsCtrl, maxLines: 6),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: Text('Currently working here', style: GoogleFonts.inter(color: AppColors.darkTextPrimary, fontSize: 14)),
                    value: isCurrent,
                    activeColor: AppColors.primary,
                    checkColor: AppColors.darkBackground,
                    onChanged: (val) => setDialogState(() => isCurrent = val ?? false),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.darkTextMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.darkBackground,
              ),
              onPressed: () {
                final bullets = bulletsCtrl.text
                    .split('\n')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();

                final newExp = Experience(
                  role: roleCtrl.text.trim(),
                  company: compCtrl.text.trim(),
                  period: periodCtrl.text.trim(),
                  location: locCtrl.text.trim(),
                  durationText: durCtrl.text.trim().isEmpty ? null : durCtrl.text.trim(),
                  responsibilities: bullets,
                  isCurrent: isCurrent,
                );

                final updatedList = List<Experience>.from(_draftConfig!.experiences);
                if (index != null && index >= 0) {
                  updatedList[index] = newExp;
                } else {
                  updatedList.insert(0, newExp);
                }

                setState(() {
                  _draftConfig = _draftConfig!.copyWith(experiences: updatedList);
                  _markDirty();
                });
                Navigator.of(ctx).pop();
              },
              child: Text(experience == null ? 'Add Role' : 'Update Role'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteExperience(int index) {
    setState(() {
      final updatedList = List<Experience>.from(_draftConfig!.experiences)..removeAt(index);
      _draftConfig = _draftConfig!.copyWith(experiences: updatedList);
      _markDirty();
    });
  }

  // =========================================================================
  // TAB 3: PROJECTS (Add, Edit, Delete)
  // =========================================================================
  Widget _buildProjectsTab() {
    final projects = _draftConfig!.projects;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Projects Portfolio', 'Add, update, and showcase your mobile & web applications'),
                  ElevatedButton.icon(
                    onPressed: () => _showProjectDialog(),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('Add Project', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.darkBackground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: projects.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final proj = projects[index];
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        proj.title,
                                        style: GoogleFonts.outfit(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkTextPrimary,
                                        ),
                                      ),
                                      if (proj.isFeatured) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text('Featured', style: GoogleFonts.inter(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${proj.client ?? 'Self'} • Category: ${proj.category ?? 'Mobile'}',
                                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.darkTextMuted),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                              onPressed: () => _showProjectDialog(project: proj, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                              onPressed: () => _deleteProject(index),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          proj.overview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.darkTextSecondary),
                        ),
                        if (proj.technologies.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: proj.technologies.map(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.darkCard,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.darkBorder),
                                ),
                                child: Text(t, style: GoogleFonts.inter(fontSize: 11, color: AppColors.darkTextSecondary)),
                              ),
                            ).toList(),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProjectDialog({Project? project, int? index}) {
    final titleCtrl = TextEditingController(text: project?.title ?? '');
    final clientCtrl = TextEditingController(text: project?.client ?? '');
    final durationCtrl = TextEditingController(text: project?.duration ?? '');
    final categoryCtrl = TextEditingController(text: project?.category ?? 'Flutter');
    final overviewCtrl = TextEditingController(text: project?.overview ?? '');
    final techCtrl = TextEditingController(text: project?.technologies.join(', ') ?? '');
    final webUrlCtrl = TextEditingController(text: project?.links.web ?? '');
    final androidUrlCtrl = TextEditingController(text: project?.links.android ?? '');
    final iosUrlCtrl = TextEditingController(text: project?.links.ios ?? '');
    final githubUrlCtrl = TextEditingController(text: project?.links.github ?? '');
    final featuresCtrl = TextEditingController(text: project?.features.join('\n') ?? '');
    bool isFeatured = project?.isFeatured ?? false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            project == null ? 'Add New Project' : 'Edit Project',
            style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 650,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField('Project Title', titleCtrl),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Client / Company', clientCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('Category (e.g. Flutter, iOS, Enterprise)', categoryCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField('Duration (e.g. 6 Months)', durationCtrl),
                  const SizedBox(height: 12),
                  _buildTextField('Overview / Description', overviewCtrl, maxLines: 4),
                  const SizedBox(height: 12),
                  _buildTextField('Technologies (comma-separated: Flutter, Dart, Firebase)', techCtrl),
                  const SizedBox(height: 12),
                  _buildTextField('Features & Deliverables (One per line)', featuresCtrl, maxLines: 4),
                  const SizedBox(height: 16),
                  Text('Store & Repository Links', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.darkTextPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Live Web URL', webUrlCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('GitHub URL', githubUrlCtrl)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Google Play Store URL', androidUrlCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('iOS App Store URL', iosUrlCtrl)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: Text('Mark as Featured Project', style: GoogleFonts.inter(color: AppColors.darkTextPrimary, fontSize: 14)),
                    value: isFeatured,
                    activeColor: AppColors.primary,
                    checkColor: AppColors.darkBackground,
                    onChanged: (val) => setDialogState(() => isFeatured = val ?? false),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.darkTextMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.darkBackground,
              ),
              onPressed: () {
                final techList = techCtrl.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();

                final featList = featuresCtrl.text
                    .split('\n')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();

                final links = ProjectLinks(
                  web: webUrlCtrl.text.trim().isEmpty ? null : webUrlCtrl.text.trim(),
                  android: androidUrlCtrl.text.trim().isEmpty ? null : androidUrlCtrl.text.trim(),
                  ios: iosUrlCtrl.text.trim().isEmpty ? null : iosUrlCtrl.text.trim(),
                  github: githubUrlCtrl.text.trim().isEmpty ? null : githubUrlCtrl.text.trim(),
                );

                final newProj = Project(
                  title: titleCtrl.text.trim(),
                  client: clientCtrl.text.trim().isEmpty ? null : clientCtrl.text.trim(),
                  duration: durationCtrl.text.trim().isEmpty ? null : durationCtrl.text.trim(),
                  category: categoryCtrl.text.trim().isEmpty ? null : categoryCtrl.text.trim(),
                  overview: overviewCtrl.text.trim(),
                  technologies: techList,
                  features: featList,
                  links: links,
                  isFeatured: isFeatured,
                );

                final updatedList = List<Project>.from(_draftConfig!.projects);
                if (index != null && index >= 0) {
                  updatedList[index] = newProj;
                } else {
                  updatedList.insert(0, newProj);
                }

                setState(() {
                  _draftConfig = _draftConfig!.copyWith(projects: updatedList);
                  _markDirty();
                });
                Navigator.of(ctx).pop();
              },
              child: Text(project == null ? 'Add Project' : 'Update Project'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProject(int index) {
    setState(() {
      final updatedList = List<Project>.from(_draftConfig!.projects)..removeAt(index);
      _draftConfig = _draftConfig!.copyWith(projects: updatedList);
      _markDirty();
    });
  }

  // =========================================================================
  // TAB 4: SKILLS & CATEGORIES
  // =========================================================================
  Widget _buildSkillsTab() {
    final skillGroups = _draftConfig!.skillGroups;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Technical Skills & Matrix', 'Manage skill groups, proficiencies, and categories'),
                  ElevatedButton.icon(
                    onPressed: _showAddSkillCategoryDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('Add Category', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.darkBackground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: skillGroups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, catIndex) {
                  final group = skillGroups[catIndex];
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              group.categoryName,
                              style: GoogleFonts.outfit(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkTextPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () => _showAddSkillToCategoryDialog(catIndex),
                                  icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                                  label: Text('Add Skill', style: GoogleFonts.inter(color: AppColors.primary, fontSize: 13)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                                  onPressed: () => _deleteSkillCategory(catIndex),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(group.skills.length, (skillIndex) {
                            final skill = group.skills[skillIndex];
                            return Chip(
                              backgroundColor: AppColors.darkCard,
                              side: const BorderSide(color: AppColors.darkBorder),
                              label: Text(
                                '${skill.name} (${skill.level ?? "Expert"})',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.darkTextPrimary),
                              ),
                              deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.darkTextMuted),
                              onDeleted: () => _deleteSkillFromCategory(catIndex, skillIndex),
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSkillCategoryDialog() {
    final catCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Skill Category', style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Category Name (e.g. Cloud & DevOps)', catCtrl),
            const SizedBox(height: 12),
            _buildTextField('Category Description', descCtrl),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.darkBackground),
            onPressed: () {
              if (catCtrl.text.trim().isNotEmpty) {
                final newGroup = SkillGroup(
                  categoryName: catCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  skills: [],
                );
                setState(() {
                  final updated = List<SkillGroup>.from(_draftConfig!.skillGroups)..add(newGroup);
                  _draftConfig = _draftConfig!.copyWith(skillGroups: updated);
                  _markDirty();
                });
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Category'),
          ),
        ],
      ),
    );
  }

  void _showAddSkillToCategoryDialog(int catIndex) {
    final nameCtrl = TextEditingController();
    String level = 'Expert';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Add Skill to ${_draftConfig!.skillGroups[catIndex].categoryName}', style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Skill Name (e.g. Riverpod, Docker)', nameCtrl),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: level,
                dropdownColor: AppColors.darkCard,
                style: GoogleFonts.inter(color: AppColors.darkTextPrimary),
                decoration: InputDecoration(
                  labelText: 'Proficiency Level',
                  labelStyle: GoogleFonts.inter(color: AppColors.darkTextMuted),
                  filled: true,
                  fillColor: AppColors.darkCard,
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.darkBorder)),
                ),
                items: ['Expert', 'Advanced', 'Intermediate', 'Familiar']
                    .map((lvl) => DropdownMenuItem(value: lvl, child: Text(lvl)))
                    .toList(),
                onChanged: (val) => setDialogState(() => level = val ?? 'Expert'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.darkBackground),
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty) {
                  final group = _draftConfig!.skillGroups[catIndex];
                  final updatedSkills = List<SkillItem>.from(group.skills)
                    ..add(SkillItem(name: nameCtrl.text.trim(), level: level));
                  final updatedGroups = List<SkillGroup>.from(_draftConfig!.skillGroups);
                  updatedGroups[catIndex] = SkillGroup(
                    categoryName: group.categoryName,
                    description: group.description,
                    skills: updatedSkills,
                  );

                  setState(() {
                    _draftConfig = _draftConfig!.copyWith(skillGroups: updatedGroups);
                    _markDirty();
                  });
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('Add Skill'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteSkillCategory(int catIndex) {
    setState(() {
      final updated = List<SkillGroup>.from(_draftConfig!.skillGroups)..removeAt(catIndex);
      _draftConfig = _draftConfig!.copyWith(skillGroups: updated);
      _markDirty();
    });
  }

  void _deleteSkillFromCategory(int catIndex, int skillIndex) {
    setState(() {
      final group = _draftConfig!.skillGroups[catIndex];
      final updatedSkills = List<SkillItem>.from(group.skills)..removeAt(skillIndex);
      final updatedGroups = List<SkillGroup>.from(_draftConfig!.skillGroups);
      updatedGroups[catIndex] = SkillGroup(
        categoryName: group.categoryName,
        description: group.description,
        skills: updatedSkills,
      );
      _draftConfig = _draftConfig!.copyWith(skillGroups: updatedGroups);
      _markDirty();
    });
  }

  // =========================================================================
  // TAB 5: EDUCATION & CERTIFICATIONS
  // =========================================================================
  Widget _buildEducationCertificationsTab() {
    final educationList = _draftConfig!.education;
    final certificationsList = _draftConfig!.certifications;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Education Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Education', 'Degrees, universities, and academic history'),
                  ElevatedButton.icon(
                    onPressed: _showAddEducationDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('Add Degree', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.darkBackground),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...educationList.asMap().entries.map((entry) {
                final idx = entry.key;
                final edu = entry.value;
                return Card(
                  color: AppColors.darkSurface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.darkBorder)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(edu.degree, style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold)),
                    subtitle: Text('${edu.institution} (${edu.year}) • ${edu.details}', style: GoogleFonts.inter(color: AppColors.darkTextSecondary)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () {
                        setState(() {
                          final updated = List<Education>.from(_draftConfig!.education)..removeAt(idx);
                          _draftConfig = _draftConfig!.copyWith(education: updated);
                          _markDirty();
                        });
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),

              // Certifications Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Certifications', 'Professional credentials and badges'),
                  ElevatedButton.icon(
                    onPressed: _showAddCertificationDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('Add Certification', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.darkBackground),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...certificationsList.asMap().entries.map((entry) {
                final idx = entry.key;
                final cert = entry.value;
                return Card(
                  color: AppColors.darkSurface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.darkBorder)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(cert.title, style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold)),
                    subtitle: Text('${cert.issuer ?? ''} • ${cert.description}', style: GoogleFonts.inter(color: AppColors.darkTextSecondary)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () {
                        setState(() {
                          final updated = List<Certification>.from(_draftConfig!.certifications)..removeAt(idx);
                          _draftConfig = _draftConfig!.copyWith(certifications: updated);
                          _markDirty();
                        });
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEducationDialog() {
    final degreeCtrl = TextEditingController();
    final instCtrl = TextEditingController();
    final yearCtrl = TextEditingController();
    final detailsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Education', style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Degree / Diploma', degreeCtrl),
            const SizedBox(height: 12),
            _buildTextField('Institution / University', instCtrl),
            const SizedBox(height: 12),
            _buildTextField('Year (e.g. 2011 - 2015)', yearCtrl),
            const SizedBox(height: 12),
            _buildTextField('Details / Focus', detailsCtrl),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.darkBackground),
            onPressed: () {
              if (degreeCtrl.text.trim().isNotEmpty) {
                final newEdu = Education(
                  degree: degreeCtrl.text.trim(),
                  institution: instCtrl.text.trim(),
                  year: yearCtrl.text.trim(),
                  details: detailsCtrl.text.trim(),
                );
                setState(() {
                  final updated = List<Education>.from(_draftConfig!.education)..add(newEdu);
                  _draftConfig = _draftConfig!.copyWith(education: updated);
                  _markDirty();
                });
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Education'),
          ),
        ],
      ),
    );
  }

  void _showAddCertificationDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final issuerCtrl = TextEditingController();
    final urlCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Certification', style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Certification Title', titleCtrl),
            const SizedBox(height: 12),
            _buildTextField('Description', descCtrl),
            const SizedBox(height: 12),
            _buildTextField('Issuer / Organization (e.g. Google, Apple)', issuerCtrl),
            const SizedBox(height: 12),
            _buildTextField('Credential / Verification URL (optional)', urlCtrl),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.darkBackground),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                final newCert = Certification(
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  issuer: issuerCtrl.text.trim().isEmpty ? null : issuerCtrl.text.trim(),
                  credentialUrl: urlCtrl.text.trim().isEmpty ? null : urlCtrl.text.trim(),
                );
                setState(() {
                  final updated = List<Certification>.from(_draftConfig!.certifications)..add(newCert);
                  _draftConfig = _draftConfig!.copyWith(certifications: updated);
                  _markDirty();
                });
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Certification'),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 6: ACHIEVEMENTS & SOCIAL LINKS
  // =========================================================================
  Widget _buildAchievementsSocialTab() {
    final achievements = _draftConfig!.achievements;
    final socialLinks = _draftConfig!.socialLinks;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Achievements Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Career Achievements', 'Highlighted metrics, awards, and milestones'),
                  ElevatedButton.icon(
                    onPressed: _showAddAchievementDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('Add Achievement', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.darkBackground),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...achievements.asMap().entries.map((entry) {
                final idx = entry.key;
                final ach = entry.value;
                return Card(
                  color: AppColors.darkSurface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.darkBorder)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(ach.metricBadge ?? '★', style: GoogleFonts.outfit(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                    title: Text(ach.title, style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold)),
                    subtitle: Text(ach.description, style: GoogleFonts.inter(color: AppColors.darkTextSecondary)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () {
                        setState(() {
                          final updated = List<Achievement>.from(_draftConfig!.achievements)..removeAt(idx);
                          _draftConfig = _draftConfig!.copyWith(achievements: updated);
                          _markDirty();
                        });
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),

              // Social Links Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Social & Profile Links', 'Connect links for GitHub, LinkedIn, Twitter, etc.'),
                  ElevatedButton.icon(
                    onPressed: _showAddSocialLinkDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('Add Link', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.darkBackground),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...socialLinks.asMap().entries.map((entry) {
                final idx = entry.key;
                final link = entry.value;
                return Card(
                  color: AppColors.darkSurface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.darkBorder)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.link, color: AppColors.primary),
                    title: Text('${link.label} (${link.iconKey})', style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold)),
                    subtitle: Text(link.url, style: GoogleFonts.inter(color: AppColors.darkTextSecondary)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () {
                        setState(() {
                          final updated = List<SocialLink>.from(_draftConfig!.socialLinks)..removeAt(idx);
                          _draftConfig = _draftConfig!.copyWith(socialLinks: updated);
                          _markDirty();
                        });
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAchievementDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final badgeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Achievement', style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Metric Badge (e.g. 10+ Years, 1M+ Downloads)', badgeCtrl),
            const SizedBox(height: 12),
            _buildTextField('Title (e.g. Production Delivery)', titleCtrl),
            const SizedBox(height: 12),
            _buildTextField('Description / Detail', descCtrl, maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.darkBackground),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                final newAch = Achievement(
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  metricBadge: badgeCtrl.text.trim().isEmpty ? null : badgeCtrl.text.trim(),
                );
                setState(() {
                  final updated = List<Achievement>.from(_draftConfig!.achievements)..add(newAch);
                  _draftConfig = _draftConfig!.copyWith(achievements: updated);
                  _markDirty();
                });
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Achievement'),
          ),
        ],
      ),
    );
  }

  void _showAddSocialLinkDialog() {
    final iconKeyCtrl = TextEditingController();
    final labelCtrl = TextEditingController();
    final urlCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Social Link', style: GoogleFonts.outfit(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Icon Key (e.g. github, linkedin, email, phone, web)', iconKeyCtrl),
            const SizedBox(height: 12),
            _buildTextField('Display Label (e.g. GitHub)', labelCtrl),
            const SizedBox(height: 12),
            _buildTextField('URL (e.g. https://github.com/yourhandle)', urlCtrl),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.darkBackground),
            onPressed: () {
              if (urlCtrl.text.trim().isNotEmpty) {
                final newLink = SocialLink(
                  iconKey: iconKeyCtrl.text.trim().toLowerCase(),
                  label: labelCtrl.text.trim(),
                  url: urlCtrl.text.trim(),
                );
                setState(() {
                  final updated = List<SocialLink>.from(_draftConfig!.socialLinks)..add(newLink);
                  _draftConfig = _draftConfig!.copyWith(socialLinks: updated);
                  _markDirty();
                });
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Link'),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 7: SECTION TOGGLES & SEO
  // =========================================================================
  Widget _buildSectionTogglesTab() {
    final sec = _draftConfig!.sectionConfig;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Section Visibility Toggles', 'Show or hide specific sections on your live portfolio'),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Column(
                  children: [
                    _buildSwitch('Show Hero Section', sec.showHero, (v) {
                      setState(() {
                        _draftConfig = _draftConfig!.copyWith(
                          sectionConfig: sec.copyWith(showHero: v),
                        );
                        _markDirty();
                      });
                    }),
                    const Divider(color: AppColors.darkBorder, height: 1),
                    _buildSwitch('Show About Section', sec.showAbout, (v) {
                      setState(() {
                        _draftConfig = _draftConfig!.copyWith(
                          sectionConfig: sec.copyWith(showAbout: v),
                        );
                        _markDirty();
                      });
                    }),
                    const Divider(color: AppColors.darkBorder, height: 1),
                    _buildSwitch('Show Highlights Section', sec.showHighlights, (v) {
                      setState(() {
                        _draftConfig = _draftConfig!.copyWith(
                          sectionConfig: sec.copyWith(showHighlights: v),
                        );
                        _markDirty();
                      });
                    }),
                    const Divider(color: AppColors.darkBorder, height: 1),
                    _buildSwitch('Show Work Experience Section', sec.showExperience, (v) {
                      setState(() {
                        _draftConfig = _draftConfig!.copyWith(
                          sectionConfig: sec.copyWith(showExperience: v),
                        );
                        _markDirty();
                      });
                    }),
                    const Divider(color: AppColors.darkBorder, height: 1),
                    _buildSwitch('Show Projects Portfolio Section', sec.showProjects, (v) {
                      setState(() {
                        _draftConfig = _draftConfig!.copyWith(
                          sectionConfig: sec.copyWith(showProjects: v),
                        );
                        _markDirty();
                      });
                    }),
                    const Divider(color: AppColors.darkBorder, height: 1),
                    _buildSwitch('Show Technical Skills Section', sec.showSkills, (v) {
                      setState(() {
                        _draftConfig = _draftConfig!.copyWith(
                          sectionConfig: sec.copyWith(showSkills: v),
                        );
                        _markDirty();
                      });
                    }),
                    const Divider(color: AppColors.darkBorder, height: 1),
                    _buildSwitch('Show Impact Section', sec.showImpact, (v) {
                      setState(() {
                        _draftConfig = _draftConfig!.copyWith(
                          sectionConfig: sec.copyWith(showImpact: v),
                        );
                        _markDirty();
                      });
                    }),
                    const Divider(color: AppColors.darkBorder, height: 1),
                    _buildSwitch('Show Education Section', sec.showEducation, (v) {
                      setState(() {
                        _draftConfig = _draftConfig!.copyWith(
                          sectionConfig: sec.copyWith(showEducation: v),
                        );
                        _markDirty();
                      });
                    }),
                    const Divider(color: AppColors.darkBorder, height: 1),
                    _buildSwitch('Show Certifications Section', sec.showCertifications, (v) {
                      setState(() {
                        _draftConfig = _draftConfig!.copyWith(
                          sectionConfig: sec.copyWith(showCertifications: v),
                        );
                        _markDirty();
                      });
                    }),
                    const Divider(color: AppColors.darkBorder, height: 1),
                    _buildSwitch('Show Contact Section', sec.showContact, (v) {
                      setState(() {
                        _draftConfig = _draftConfig!.copyWith(
                          sectionConfig: sec.copyWith(showContact: v),
                        );
                        _markDirty();
                      });
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _buildSectionHeader('SEO & Web Metadata', 'Browser title and OpenGraph search snippets'),
              const SizedBox(height: 20),
              _buildTextField('Page Title (<title>)', _metaTitleController),
              const SizedBox(height: 16),
              _buildTextField('Meta Description', _metaDescController, maxLines: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: GoogleFonts.inter(color: AppColors.darkTextPrimary, fontSize: 14)),
      value: value,
      activeColor: AppColors.primary,
      onChanged: onChanged,
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.inter(color: AppColors.darkTextPrimary, fontSize: 14),
          onChanged: (_) => _markDirty(),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.darkCard,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.darkBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
