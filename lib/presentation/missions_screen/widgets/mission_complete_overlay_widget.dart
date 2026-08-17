import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../models/game_models.dart';
import '../../../widgets/status_badge_widget.dart';

class MissionCompleteOverlayWidget extends StatefulWidget {
  final MissionModel mission;
  final VoidCallback onDismiss;

  const MissionCompleteOverlayWidget({
    required this.mission,
    required this.onDismiss,
    super.key,
  });

  @override
  State<MissionCompleteOverlayWidget> createState() =>
      _MissionCompleteOverlayWidgetState();
}

class _MissionCompleteOverlayWidgetState
    extends State<MissionCompleteOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _medalController;
  late AnimationController _confettiController;
  late AnimationController _bgController;

  late Animation<double> _medalScale;
  late Animation<double> _medalOpacity;
  late Animation<double> _bgOpacity;
  late Animation<double> _contentSlide;

  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    HapticFeedback.heavyImpact();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bgOpacity = CurvedAnimation(parent: _bgController, curve: Curves.easeOut);

    _medalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _medalScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _medalController, curve: Curves.elasticOut),
    );
    _medalOpacity = CurvedAnimation(
      parent: _medalController,
      curve: const Interval(0, 0.3),
    );

    _contentSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _medalController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Generate confetti particles
    for (int i = 0; i < 30; i++) {
      _particles.add(
        _ConfettiParticle(
          x: _random.nextDouble(),
          delay: _random.nextDouble() * 0.5,
          color: [
            AppTheme.primaryViolet,
            AppTheme.accentMint,
            AppTheme.gold,
            AppTheme.error,
            AppTheme.oceanBlue,
          ][_random.nextInt(5)],
          size: 4 + _random.nextDouble() * 6,
          speed: 0.3 + _random.nextDouble() * 0.7,
        ),
      );
    }

    _bgController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _medalController.forward();
      _confettiController.forward();
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _medalController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _bgOpacity,
      child: GestureDetector(
        onTap: widget.onDismiss,
        child: Container(
          color: Colors.black.withAlpha(204),
          child: Stack(
            children: [
              // Confetti
              AnimatedBuilder(
                animation: _confettiController,
                builder: (context, child) {
                  return CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: _ConfettiPainter(
                      particles: _particles,
                      progress: _confettiController.value,
                    ),
                  );
                },
              ),
              // Content card
              Center(
                child: AnimatedBuilder(
                  animation: _medalController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _contentSlide.value),
                      child: Opacity(
                        opacity: _medalOpacity.value.clamp(0, 1),
                        child: child,
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {}, // prevent dismiss on card tap
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.primaryViolet.withAlpha(128),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryViolet.withAlpha(77),
                            blurRadius: 40,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Medal
                          ScaleTransition(
                            scale: _medalScale,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6040),
                                    Color(0xFFFFA640),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.gold.withAlpha(128),
                                    blurRadius: 24,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  '⭐',
                                  style: TextStyle(fontSize: 36),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Mission Complete!',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.mission.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppTheme.muted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StatusBadgeWidget(
                                label: '+${widget.mission.xpReward} XP',
                                type: BadgeType.xp,
                                fontSize: 13,
                              ),
                              if (widget.mission.goldReward > 0) ...[
                                const SizedBox(width: 8),
                                StatusBadgeWidget(
                                  label: '+${widget.mission.goldReward} Gold',
                                  type: BadgeType.gold,
                                  fontSize: 13,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Stat bump
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryViolet.withAlpha(26),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppTheme.primaryViolet.withAlpha(77),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${widget.mission.statName} Lv. 31',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryVioletLight,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 14,
                                  color: AppTheme.accentMint,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '32 ↑',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.accentMint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Awesome button
                          GestureDetector(
                            onTap: widget.onDismiss,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: AppTheme.auroraGradient,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                'Awesome!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _ConfettiParticle {
  final double x;
  final double delay;
  final Color color;
  final double size;
  final double speed;

  _ConfettiParticle({
    required this.x,
    required this.delay,
    required this.color,
    required this.size,
    required this.speed,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final x = p.x * size.width + sin(t * pi * 3) * 30;
      final y = -20 + t * (size.height + 40) * p.speed;

      final paint = Paint()
        ..color = p.color.withOpacity((1 - t * 0.5).clamp(0, 1));

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * pi * 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.5,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
