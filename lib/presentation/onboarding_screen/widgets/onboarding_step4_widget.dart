import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingStep4Widget extends StatelessWidget {
  final Set<int> selectedCompanions;
  final ValueChanged<int> onToggle;

  const OnboardingStep4Widget({
    required this.selectedCompanions,
    required this.onToggle,
    super.key,
  });

  static const List<Map<String, String>> _companions = [
    {'name': 'Gym Freak', 'emoji': '🏋️', 'stat': 'Health'},
    {'name': 'Grinder', 'emoji': '⚡', 'stat': 'Builder'},
    {'name': 'Dieter', 'emoji': '🥗', 'stat': 'Health'},
    {'name': 'Programmer', 'emoji': '💻', 'stat': 'Builder'},
    {'name': 'Hustler', 'emoji': '💼', 'stat': 'Wealth'},
    {'name': 'Bookworm', 'emoji': '📚', 'stat': 'Knowledge'},
    {'name': 'Dreamer', 'emoji': '🌟', 'stat': 'Creativity'},
    {'name': 'Chill Friend', 'emoji': '😎', 'stat': 'Social'},
  ];

  Color _getStatColor(String stat) {
    switch (stat) {
      case 'Health':
        return AppTheme.statHealth;
      case 'Builder':
        return AppTheme.statBuilder;
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your\ncompanions',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Select the archetypes that resonate with you.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 28),
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: _companions.length,
              itemBuilder: (context, i) {
                final companion = _companions[i];
                final isSelected = selectedCompanions.contains(i);
                final statColor = _getStatColor(companion['stat']!);

                return GestureDetector(
                  onTap: () => onToggle(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? statColor.withAlpha(31)
                          : AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? statColor : AppTheme.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: statColor.withAlpha(51),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              companion['emoji']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? statColor
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? statColor
                                      : AppTheme.border,
                                  width: 1.5,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 12,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companion['name']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? statColor : Colors.white,
                              ),
                            ),
                            Text(
                              companion['stat']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (selectedCompanions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '${selectedCompanions.length} companion${selectedCompanions.length > 1 ? 's' : ''} selected',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.accentMint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
