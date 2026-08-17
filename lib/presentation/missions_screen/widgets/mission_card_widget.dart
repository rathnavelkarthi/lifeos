import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../models/game_models.dart';
import '../../../widgets/status_badge_widget.dart';

class MissionCardWidget extends StatefulWidget {
  final MissionModel mission;
  final VoidCallback onClaim;

  const MissionCardWidget({
    required this.mission,
    required this.onClaim,
    super.key,
  });

  @override
  State<MissionCardWidget> createState() => _MissionCardWidgetState();
}

class _MissionCardWidgetState extends State<MissionCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  bool _isClaiming = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleClaim() async {
    if (_isClaiming || widget.mission.status == MissionStatus.claimed) return;
    setState(() => _isClaiming = true);
    await _pressController.forward();
    await _pressController.reverse();
    widget.onClaim();
    if (mounted) setState(() => _isClaiming = false);
  }

  Color _getStatColor() {
    switch (widget.mission.statName) {
      case 'Builder':
        return AppTheme.statBuilder;
      case 'Health':
        return AppTheme.statHealth;
      case 'Wealth':
        return AppTheme.statWealth;
      case 'Knowledge':
        return AppTheme.statKnowledge;
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
    final isClaimed = widget.mission.status == MissionStatus.claimed;
    final isRecovery = widget.mission.isRecovery;
    final statColor = _getStatColor();

    return ScaleTransition(
      scale: _scaleAnimation,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isClaimed
                ? AppTheme.surface.withAlpha(180)
                : AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isClaimed
                  ? AppTheme.accentMint.withAlpha(60)
                  : isRecovery
                      ? AppTheme.gold.withAlpha(100)
                      : _isHovered
                          ? AppTheme.borderBright
                          : AppTheme.border,
            ),
            boxShadow: isClaimed
                ? [
                    BoxShadow(
                      color: AppTheme.accentMint.withAlpha(18),
                      blurRadius: 16,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : _isHovered
                    ? [
                        BoxShadow(
                          color: statColor.withAlpha(20),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left accent bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 3,
                    decoration: BoxDecoration(
                      color: isClaimed
                          ? AppTheme.accentMint.withAlpha(120)
                          : statColor.withAlpha(200),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 13, 13, 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: isClaimed
                                      ? AppTheme.border
                                      : statColor.withAlpha(36),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.mission.iconEmoji,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isClaimed
                                          ? null
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isRecovery) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        margin: const EdgeInsets.only(bottom: 4),
                                        decoration: BoxDecoration(
                                          color: AppTheme.gold.withAlpha(30),
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                            color: AppTheme.gold.withAlpha(90),
                                          ),
                                        ),
                                        child: Text(
                                          'RECOVERY QUEST',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.gold,
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                    Text(
                                      widget.mission.title,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isClaimed
                                            ? AppTheme.muted
                                            : Colors.white,
                                        decoration: isClaimed
                                            ? TextDecoration.lineThrough
                                            : null,
                                        decorationColor: AppTheme.muted,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.mission.statName,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: isClaimed
                                            ? AppTheme.mutedDark
                                            : statColor.withAlpha(200),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              if (widget.mission.durationMinutes > 0) ...[
                                StatusBadgeWidget(
                                  label: '${widget.mission.durationMinutes} MIN',
                                  type: BadgeType.time,
                                ),
                                const SizedBox(width: 6),
                              ],
                              StatusBadgeWidget(
                                label: '+${widget.mission.xpReward} XP',
                                type: BadgeType.xp,
                              ),
                              if (widget.mission.goldReward > 0) ...[
                                const SizedBox(width: 6),
                                StatusBadgeWidget(
                                  label: '+${widget.mission.goldReward} Gold',
                                  type: BadgeType.gold,
                                ),
                              ],
                              const Spacer(),
                              // Claim button
                              GestureDetector(
                                onTap: _handleClaim,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  curve: Curves.easeOutCubic,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: isClaimed
                                        ? null
                                        : const LinearGradient(
                                            colors: [
                                              Color(0xFF22E6B1),
                                              Color(0xFF0CE676),
                                            ],
                                          ),
                                    color: isClaimed
                                        ? AppTheme.accentMint.withAlpha(26)
                                        : null,
                                    borderRadius: BorderRadius.circular(20),
                                    border: isClaimed
                                        ? Border.all(
                                            color: AppTheme.accentMint.withAlpha(80),
                                          )
                                        : null,
                                  ),
                                  child: isClaimed
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.check_rounded,
                                              size: 13,
                                              color: AppTheme.accentMint,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Claimed',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.accentMint,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          'Claim',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0D1117),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
