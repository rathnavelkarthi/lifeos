import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../models/game_models.dart';

class HomeStatGridWidget extends StatefulWidget {
  final List<StatModel> stats;

  const HomeStatGridWidget({required this.stats, super.key});

  @override
  State<HomeStatGridWidget> createState() => _HomeStatGridWidgetState();
}

class _HomeStatGridWidgetState extends State<HomeStatGridWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _barAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _barAnimations = List.generate(widget.stats.length, (i) {
      return Tween<double>(
        begin: 0,
        end: widget.stats[i].levelProgress,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i * 0.08,
            (i * 0.08 + 0.6).clamp(0, 1),
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'STATS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.muted,
                letterSpacing: 1.2,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemCount: widget.stats.length,
            itemBuilder: (context, i) {
              return AnimatedBuilder(
                animation: _barAnimations[i],
                builder: (context, child) {
                  return _StatTile(
                    stat: widget.stats[i],
                    barProgress: _barAnimations[i].value,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final StatModel stat;
  final double barProgress;

  const _StatTile({required this.stat, required this.barProgress});

  @override
  Widget build(BuildContext context) {
    final isDecaying = stat.isDecaying;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDecaying ? AppTheme.error.withAlpha(128) : AppTheme.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stat.icon, style: const TextStyle(fontSize: 16)),
              if (isDecaying)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withAlpha(38),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '⚠',
                    style: TextStyle(fontSize: 9, color: AppTheme.error),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            stat.name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Lv. ${stat.level}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              children: [
                Container(height: 3, color: AppTheme.border),
                FractionallySizedBox(
                  widthFactor: barProgress,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: isDecaying ? AppTheme.error : stat.color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
