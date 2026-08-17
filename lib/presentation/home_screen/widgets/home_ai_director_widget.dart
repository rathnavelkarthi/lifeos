import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class HomeAiDirectorWidget extends StatelessWidget {
  final String playerName;

  const HomeAiDirectorWidget({required this.playerName, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryViolet.withAlpha(102)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryViolet.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppTheme.auroraGradient,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'AI DIRECTOR',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.more_horiz,
                  color: AppTheme.mutedDark,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'You completed 4 missions yesterday.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your biggest unfinished objective:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Finish Meenamma pricing section',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // Recommended mission row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primaryViolet.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryViolet.withAlpha(51)),
              ),
              child: Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommended mission',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.muted,
                          ),
                        ),
                        Text(
                          '+250 XP · Builder',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentMint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.muted,
                    size: 14,
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
