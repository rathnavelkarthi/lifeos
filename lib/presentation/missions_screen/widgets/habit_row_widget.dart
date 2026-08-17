import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../models/game_models.dart';

class HabitRowWidget extends StatefulWidget {
  final HabitModel habit;
  final VoidCallback onToggle;

  const HabitRowWidget({
    required this.habit,
    required this.onToggle,
    super.key,
  });

  @override
  State<HabitRowWidget> createState() => _HabitRowWidgetState();
}

class _HabitRowWidgetState extends State<HabitRowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _checkController;
  late Animation<double> _checkStroke;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _checkStroke = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeOutCubic,
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _checkController, curve: Curves.easeOut));

    if (widget.habit.completedToday) {
      _checkController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(HabitRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.habit.completedToday && !oldWidget.habit.completedToday) {
      _checkController.forward(from: 0);
    } else if (!widget.habit.completedToday && oldWidget.habit.completedToday) {
      _checkController.reverse();
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  Color _getStatColor() {
    switch (widget.habit.statName) {
      case 'Builder':
        return AppTheme.statBuilder;
      case 'Health':
        return AppTheme.statHealth;
      case 'Knowledge':
        return AppTheme.statKnowledge;
      case 'Wealth':
        return AppTheme.statWealth;
      case 'Creativity':
        return AppTheme.statCreativity;
      case 'Social':
        return AppTheme.statSocial;
      default:
        return AppTheme.primaryViolet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statColor = _getStatColor();
    final isDone = widget.habit.completedToday;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isDone
            ? AppTheme.surface.withAlpha(180)
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone
              ? AppTheme.accentMint.withAlpha(60)
              : AppTheme.border,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left accent bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 3,
                decoration: BoxDecoration(
                  color: isDone
                      ? AppTheme.accentMint.withAlpha(120)
                      : statColor.withAlpha(160),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isDone
                              ? AppTheme.border
                              : statColor.withAlpha(36),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            widget.habit.iconEmoji,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.habit.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDone ? AppTheme.muted : Colors.white,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: AppTheme.muted,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Text('🔥', style: TextStyle(fontSize: 10)),
                                const SizedBox(width: 3),
                                Text(
                                  '${widget.habit.streakDays}-day streak',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppTheme.gold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 3,
                                  height: 3,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.mutedDark,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '+${widget.habit.xpReward} XP',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppTheme.accentMint,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Animated checkmark
                      GestureDetector(
                        onTap: widget.onToggle,
                        child: AnimatedBuilder(
                          animation: _checkController,
                          builder: (context, child) {
                            return ScaleTransition(
                              scale: _scaleAnim,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDone
                                      ? AppTheme.accentMint.withAlpha(30)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isDone
                                        ? AppTheme.accentMint
                                        : AppTheme.borderBright,
                                    width: 1.5,
                                  ),
                                ),
                                child: isDone
                                    ? CustomPaint(
                                        painter: _CheckmarkPainter(
                                          progress: _checkStroke.value,
                                          color: AppTheme.accentMint,
                                        ),
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckmarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final w = size.width;
    final h = size.height;

    final p1 = Offset(w * 0.26, h * 0.50);
    final p2 = Offset(w * 0.44, h * 0.67);
    final p3 = Offset(w * 0.74, h * 0.34);

    path.moveTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p3.dx, p3.dy);

    final metrics = path.computeMetrics().first;
    final extractPath = metrics.extractPath(0, metrics.length * progress);
    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter old) => old.progress != progress;
}
