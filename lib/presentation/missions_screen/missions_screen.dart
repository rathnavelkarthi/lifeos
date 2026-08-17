import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/game_models.dart';
import '../../theme/app_theme.dart';
import './widgets/habit_row_widget.dart';
import './widgets/mission_card_widget.dart';
import './widgets/mission_complete_overlay_widget.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen>
    with TickerProviderStateMixin {
  int _selectedTab = 0;
  late List<MissionModel> _missions;
  late List<HabitModel> _habits;
  bool _showCompleteOverlay = false;
  MissionModel? _completedMission;

  late AnimationController _headerController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late AnimationController _tabIndicatorController;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();
    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic));

    _tabIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _initData();
  }

  void _initData() {
    final missionMaps = [
      {
        'id': 'm1',
        'title': 'Build pricing page',
        'statName': 'Builder',
        'xpReward': 250,
        'goldReward': 10,
        'durationMinutes': 90,
        'iconEmoji': '🏗️',
        'status': 'pending',
        'isRecovery': false,
      },
      {
        'id': 'm2',
        'title': 'Read 20 pages',
        'statName': 'Knowledge',
        'xpReward': 60,
        'goldReward': 5,
        'durationMinutes': 30,
        'iconEmoji': '📚',
        'status': 'pending',
        'isRecovery': false,
      },
      {
        'id': 'm3',
        'title': 'Workout session',
        'statName': 'Health',
        'xpReward': 75,
        'goldReward': 5,
        'durationMinutes': 45,
        'iconEmoji': '💪',
        'status': 'claimed',
        'isRecovery': false,
      },
      {
        'id': 'm4',
        'title': 'Meditate 15 minutes',
        'statName': 'Health',
        'xpReward': 40,
        'goldReward': 2,
        'durationMinutes': 15,
        'iconEmoji': '🧘',
        'status': 'pending',
        'isRecovery': false,
      },
      {
        'id': 'm5',
        'title': 'Sleep 8 hours',
        'statName': 'Health',
        'xpReward': 30,
        'goldReward': 0,
        'durationMinutes': 0,
        'iconEmoji': '😴',
        'status': 'pending',
        'isRecovery': true,
      },
    ];

    final habitMaps = [
      {
        'id': 'h1',
        'title': 'Code 1 hour',
        'iconEmoji': '💻',
        'statName': 'Builder',
        'xpReward': 50,
        'streakDays': 12,
        'completedToday': true,
      },
      {
        'id': 'h2',
        'title': 'No sugar',
        'iconEmoji': '🚫',
        'statName': 'Health',
        'xpReward': 30,
        'streakDays': 8,
        'completedToday': true,
      },
      {
        'id': 'h3',
        'title': 'Sleep before 12 AM',
        'iconEmoji': '🌙',
        'statName': 'Health',
        'xpReward': 40,
        'streakDays': 5,
        'completedToday': false,
      },
      {
        'id': 'h4',
        'title': 'Read daily',
        'iconEmoji': '📖',
        'statName': 'Knowledge',
        'xpReward': 35,
        'streakDays': 3,
        'completedToday': false,
      },
    ];

    _missions = missionMaps.map(MissionModel.fromMap).toList();
    _habits = habitMaps.map(HabitModel.fromMap).toList();
  }

  int get _totalPotentialXp {
    return _missions
        .where((m) => m.status == MissionStatus.pending)
        .fold(0, (sum, m) => sum + m.xpReward);
  }

  int get _claimedCount =>
      _missions.where((m) => m.status == MissionStatus.claimed).length;

  int get _completedHabits =>
      _habits.where((h) => h.completedToday).length;

  void _claimMission(MissionModel mission) {
    HapticFeedback.mediumImpact();
    setState(() {
      mission.status = MissionStatus.claimed;
      _completedMission = mission;
      _showCompleteOverlay = true;
    });
  }

  void _dismissOverlay() {
    setState(() => _showCompleteOverlay = false);
  }

  void _toggleHabit(HabitModel habit) {
    HapticFeedback.lightImpact();
    setState(() {
      habit.completedToday = !habit.completedToday;
      if (habit.completedToday) {
        habit.streakDays++;
      }
    });
  }

  void _switchTab(int index) {
    if (_selectedTab == index) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedTab = index);
  }

  @override
  void dispose() {
    _headerController.dispose();
    _tabIndicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideTransition(
                  position: _headerSlide,
                  child: FadeTransition(
                    opacity: _headerFade,
                    child: _buildHeader(),
                  ),
                ),
                FadeTransition(
                  opacity: _headerFade,
                  child: _buildProgressSummary(),
                ),
                _buildSegmentedTabs(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.04, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _selectedTab == 0
                        ? _buildMissionsList()
                        : _buildHabitsList(),
                  ),
                ),
              ],
            ),
          ),
          if (_showCompleteOverlay && _completedMission != null)
            MissionCompleteOverlayWidget(
              mission: _completedMission!,
              onDismiss: _dismissOverlay,
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Missions',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 5),
                    Text(
                      "Today's potential: ",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppTheme.forestGradient.createShader(bounds),
                      child: Text(
                        '+$_totalPotentialXp XP',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Date chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.border),
            ),
            child: Text(
              _getTodayLabel(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.muted,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTodayLabel() {
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[now.month - 1]} ${now.day}';
  }

  Widget _buildProgressSummary() {
    final total = _missions.length;
    final claimed = _claimedCount;
    final progress = total > 0 ? claimed / total : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            // Progress fraction
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$claimed',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  TextSpan(
                    text: '/$total',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'done',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    Container(height: 5, color: AppTheme.border),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => FractionallySizedBox(
                        widthFactor: value,
                        child: Container(
                          height: 5,
                          decoration: const BoxDecoration(
                            gradient: AppTheme.auroraGradient,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${(progress * 100).round()}%',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentMint,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            _buildTabPill('Today', 0, '${_missions.length}'),
            _buildTabPill('Habits', 1, '${_habits.length}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPill(String label, int index, String count) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: isActive ? AppTheme.auroraGradient : null,
            color: isActive ? null : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : AppTheme.muted,
                ),
              ),
              const SizedBox(width: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white.withAlpha(51)
                      : AppTheme.border,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : AppTheme.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissionsList() {
    final pending = _missions.where((m) => m.status == MissionStatus.pending).toList();
    final claimed = _missions.where((m) => m.status == MissionStatus.claimed).toList();

    return ListView(
      key: const ValueKey('missions'),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
      physics: const BouncingScrollPhysics(),
      children: [
        if (pending.isNotEmpty) ...[
          _buildSectionLabel('ACTIVE', pending.length),
          const SizedBox(height: 8),
          ...pending.asMap().entries.map((e) {
            final i = e.key;
            final mission = e.value;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 320 + i * 70),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 18),
                  child: child,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MissionCardWidget(
                  mission: mission,
                  onClaim: () => _claimMission(mission),
                ),
              ),
            );
          }),
        ],
        if (claimed.isNotEmpty) ...[
          const SizedBox(height: 6),
          _buildSectionLabel('COMPLETED', claimed.length),
          const SizedBox(height: 8),
          ...claimed.asMap().entries.map((e) {
            final i = e.key;
            final mission = e.value;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + i * 60),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: child,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MissionCardWidget(
                  mission: mission,
                  onClaim: () {},
                ),
              ),
            );
          }),
        ],
        if (_missions.isEmpty)
          _buildEmptyState(
            icon: '⚔️',
            title: 'No missions today',
            subtitle: 'Check back tomorrow for new quests.',
          ),
      ],
    );
  }

  Widget _buildHabitsList() {
    final incomplete = _habits.where((h) => !h.completedToday).toList();
    final complete = _habits.where((h) => h.completedToday).toList();

    return ListView(
      key: const ValueKey('habits'),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
      physics: const BouncingScrollPhysics(),
      children: [
        if (incomplete.isNotEmpty) ...[
          _buildSectionLabel('PENDING', incomplete.length),
          const SizedBox(height: 8),
          ...incomplete.asMap().entries.map((e) {
            final i = e.key;
            final habit = e.value;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 280 + i * 60),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 14),
                  child: child,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HabitRowWidget(
                  habit: habit,
                  onToggle: () => _toggleHabit(habit),
                ),
              ),
            );
          }),
        ],
        if (complete.isNotEmpty) ...[
          const SizedBox(height: 6),
          _buildSectionLabel('DONE TODAY', complete.length),
          const SizedBox(height: 8),
          ...complete.asMap().entries.map((e) {
            final habit = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HabitRowWidget(
                habit: habit,
                onToggle: () => _toggleHabit(habit),
              ),
            );
          }),
        ],
        if (_habits.isEmpty)
          _buildEmptyState(
            icon: '🔄',
            title: 'No habits yet',
            subtitle: 'Add habits to build daily momentum.',
          ),
        // Habits summary footer
        if (_habits.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildHabitsSummary(),
        ],
      ],
    );
  }

  Widget _buildSectionLabel(String label, int count) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppTheme.mutedDark,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: AppTheme.border,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.muted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHabitsSummary() {
    final done = _completedHabits;
    final total = _habits.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$done of $total habits completed today',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.muted,
              ),
            ),
          ),
          if (done == total && total > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.accentMint.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accentMint.withAlpha(77)),
              ),
              child: Text(
                'Perfect day!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentMint,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}
