import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../models/game_models.dart';

class HomeHeaderWidget extends StatelessWidget {
  final PlayerModel player;
  final String greeting;

  const HomeHeaderWidget({
    required this.player,
    required this.greeting,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.auroraGradient,
            ),
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: player.avatarUrl,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                semanticLabel:
                    'Player avatar for ${player.name}, circular profile photo',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.muted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  player.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Gold counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 4),
                Text(
                  '${player.gold}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gold,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Settings
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: AppTheme.muted,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
