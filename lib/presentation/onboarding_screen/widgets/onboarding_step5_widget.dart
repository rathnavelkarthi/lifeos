import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingStep5Widget extends StatelessWidget {
  final Set<int> selectedThemes;
  final ValueChanged<int> onToggle;

  const OnboardingStep5Widget({
    required this.selectedThemes,
    required this.onToggle,
    super.key,
  });

  static const List<Map<String, dynamic>> _themes = [
    {'name': 'Coding', 'emoji': '💻', 'gradient': AppTheme.oceanGradient},
    {'name': 'Fitness', 'emoji': '🏃', 'gradient': AppTheme.forestGradient},
    {'name': 'Learning', 'emoji': '🧠', 'gradient': AppTheme.auroraGradient},
    {'name': 'Money', 'emoji': '💰', 'gradient': AppTheme.sunsetGradient},
    {'name': 'Writing', 'emoji': '✍️', 'gradient': AppTheme.auroraGradient},
    {'name': 'Career', 'emoji': '🚀', 'gradient': AppTheme.oceanGradient},
    {'name': 'Health', 'emoji': '💚', 'gradient': AppTheme.forestGradient},
    {'name': 'Social', 'emoji': '🤝', 'gradient': AppTheme.sunsetGradient},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are your\nfocus themes?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Missions will be generated from these themes daily.',
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
                childAspectRatio: 2.0,
              ),
              itemCount: _themes.length,
              itemBuilder: (context, i) {
                final theme = _themes[i];
                final isSelected = selectedThemes.contains(i);
                final gradient = theme['gradient'] as LinearGradient;

                return GestureDetector(
                  onTap: () => onToggle(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected ? gradient : null,
                      color: isSelected ? null : AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppTheme.border,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: gradient.colors.first.withAlpha(77),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          theme['emoji'] as String,
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          theme['name'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (selectedThemes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '${selectedThemes.length} theme${selectedThemes.length > 1 ? 's' : ''} selected',
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
