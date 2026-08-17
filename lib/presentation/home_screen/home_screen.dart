import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/game_models.dart';
import '../../theme/app_theme.dart';
import './widgets/home_ai_director_widget.dart';
import './widgets/home_header_widget.dart';
import './widgets/home_progress_ring_widget.dart';
import './widgets/home_stat_grid_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with [Riverpod/Bloc] for production

  late PlayerModel _player;
  late List<StatModel> _stats;
  bool _isLoading = true;

  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    _initData();
  }

  void _initData() {
    _player = PlayerModel(
      name: 'Rathnavel',
      playerClass: 'Builder',
      totalXp: 8420,
      gold: 340,
      streakDays: 12,
      avatarUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&h=200&fit=crop&crop=face',
    );

    final statMaps = [
      {
        'name': 'Builder',
        'icon': '🏗️',
        'color': AppTheme.statBuilder,
        'xp': 9300,
        'lastActivity': DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
      },
      {
        'name': 'Health',
        'icon': '💚',
        'color': AppTheme.statHealth,
        'xp': 6600,
        'lastActivity': DateTime.now()
            .subtract(const Duration(hours: 18))
            .toIso8601String(),
      },
      {
        'name': 'Wealth',
        'icon': '💰',
        'color': AppTheme.statWealth,
        'xp': 5400,
        'lastActivity': DateTime.now()
            .subtract(const Duration(hours: 80))
            .toIso8601String(),
      },
      {
        'name': 'Knowledge',
        'icon': '📚',
        'color': AppTheme.statKnowledge,
        'xp': 7200,
        'lastActivity': DateTime.now()
            .subtract(const Duration(hours: 5))
            .toIso8601String(),
      },
      {
        'name': 'Creativity',
        'icon': '🎨',
        'color': AppTheme.statCreativity,
        'xp': 8700,
        'lastActivity': DateTime.now()
            .subtract(const Duration(hours: 10))
            .toIso8601String(),
      },
      {
        'name': 'Social',
        'icon': '🤝',
        'color': AppTheme.statSocial,
        'xp': 5100,
        'lastActivity': DateTime.now()
            .subtract(const Duration(hours: 90))
            .toIso8601String(),
      },
    ];

    _stats = statMaps.map(StatModel.fromMap).toList();

    setState(() => _isLoading = false);
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  double get _todayProgress {
    // 3 missions claimed out of 5 + 2 habits done = 68%
    return 0.68;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryViolet),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: HomeHeaderWidget(
                    player: _player,
                    greeting: _getGreeting(),
                  ),
                ),
                SliverToBoxAdapter(child: _buildLevelBar()),
                SliverToBoxAdapter(
                  child: HomeProgressRingWidget(
                    progress: _todayProgress,
                    streakDays: _player.streakDays,
                  ),
                ),
                SliverToBoxAdapter(child: HomeStatGridWidget(stats: _stats)),
                SliverToBoxAdapter(
                  child: HomeAiDirectorWidget(playerName: _player.name),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: AppTheme.auroraGradient,
                  ),
                  child: Text(
                    'LEVEL ${_player.level}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                Text(
                  '${_player.xpForCurrentLevel.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} / ${_player.xpNeededForNextLevel} XP',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.muted,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(height: 6, color: AppTheme.border),
                  FractionallySizedBox(
                    widthFactor: _player.levelProgress,
                    child: Container(
                      height: 6,
                      decoration: const BoxDecoration(
                        gradient: AppTheme.auroraGradient,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
