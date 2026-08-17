import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class OnboardingStep3Widget extends StatelessWidget {
  final int selectedAvatarIndex;
  final int selectedClassIndex;
  final ValueChanged<int> onAvatarSelected;
  final ValueChanged<int> onClassSelected;

  const OnboardingStep3Widget({
    required this.selectedAvatarIndex,
    required this.selectedClassIndex,
    required this.onAvatarSelected,
    required this.onClassSelected,
    super.key,
  });

  static const List<Map<String, String>> _avatarOptions = [
    {
      'url':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1db145533-1772629983865.png',
      'label': 'Aurora',
      'semanticLabel':
          'Abstract purple and blue aurora nebula swirling in space',
    },
    {
      'url':
          'https://img.rocket.new/generatedImages/rocket_gen_img_106d32243-1780326097130.png',
      'label': 'Nebula',
      'semanticLabel':
          'Swirling purple and pink nebula with star field in deep space',
    },
    {
      'url':
          'https://img.rocket.new/generatedImages/rocket_gen_img_17dbc6f09-1766809631569.png',
      'label': 'Planet',
      'semanticLabel':
          'Blue and green alien planet with rings floating in dark space',
    },
    {
      'url':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1eabb97ec-1772792842315.png',
      'label': 'Cosmos',
      'semanticLabel':
          'Deep space cosmic view with orange and red star formation',
    },
    {
      'url':
          'https://img.rocket.new/generatedImages/rocket_gen_img_16aa7e555-1784391783677.png',
      'label': 'Galaxy',
      'semanticLabel':
          'Spiral galaxy with bright core and blue outer arms in black space',
    },
  ];

  static const List<Map<String, dynamic>> _classOptions = [
    {
      'name': 'Builder',
      'emoji': '🏗️',
      'description': 'Create systems, products & solutions',
      'color': AppTheme.statBuilder,
    },
    {
      'name': 'Grinder',
      'emoji': '⚡',
      'description': 'Relentless execution & consistency',
      'color': AppTheme.gold,
    },
    {
      'name': 'Explorer',
      'emoji': '🧭',
      'description': 'Learn, discover & expand horizons',
      'color': AppTheme.statKnowledge,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your avatar\n& class',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This defines your hero identity.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 28),
          // Avatar picker
          Text(
            'AVATAR',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.muted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _avatarOptions.length,
              itemBuilder: (context, i) {
                final isSelected = i == selectedAvatarIndex;
                return GestureDetector(
                  onTap: () => onAvatarSelected(i),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isSelected ? AppTheme.auroraGradient : null,
                        color: isSelected ? null : AppTheme.surface,
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppTheme.border,
                          width: isSelected ? 0 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryViolet.withAlpha(128),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      padding: isSelected
                          ? const EdgeInsets.all(3)
                          : EdgeInsets.zero,
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: _avatarOptions[i]['url']!,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          semanticLabel: _avatarOptions[i]['semanticLabel']!,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          // Class selection
          Text(
            'CLASS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.muted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_classOptions.length, (i) {
            final cls = _classOptions[i];
            final isSelected = i == selectedClassIndex;
            final color = cls['color'] as Color;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => onClassSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withAlpha(31) : AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? color : AppTheme.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withAlpha(51),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color.withAlpha(38),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            cls['emoji'] as String,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cls['name'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? color : Colors.white,
                              ),
                            ),
                            Text(
                              cls['description'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? color : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? color : AppTheme.border,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                size: 13,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
