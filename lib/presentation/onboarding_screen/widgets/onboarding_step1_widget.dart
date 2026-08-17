import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class OnboardingStep1Widget extends StatefulWidget {
  const OnboardingStep1Widget({super.key});

  @override
  State<OnboardingStep1Widget> createState() => _OnboardingStep1WidgetState();
}

class _OnboardingStep1WidgetState extends State<OnboardingStep1Widget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _barWidth;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    _taglineSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
          ),
        );
    _barWidth = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero image
        Expanded(
          flex: 5,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: CustomImageWidget(
                  imageUrl:
                      'https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?w=800&h=600&fit=crop',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  semanticLabel:
                      'Cosmic purple and orange mountain landscape at dusk with large planet in sky',
                ),
              ),
              // Dark gradient overlay
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0x880D1117),
                      Color(0xFF0D1117),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 0.7, 1.0],
                  ),
                ),
              ),
              // Logo overlay
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppTheme.auroraGradient.createShader(bounds),
                          child: Text(
                            'LifeOS',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: _taglineSlide,
                          child: FadeTransition(
                            opacity: _logoFade,
                            child: Text(
                              'Your life. Upgraded.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: AppTheme.muted,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom content
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Turn your life into a game.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Complete missions. Build habits. Level up your real-life stats. All local. All yours.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: AppTheme.muted,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                // Animated loading bar
                AnimatedBuilder(
                  animation: _barWidth,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: [
                          Container(height: 3, color: AppTheme.border),
                          FractionallySizedBox(
                            widthFactor: _barWidth.value,
                            child: Container(
                              height: 3,
                              decoration: const BoxDecoration(
                                gradient: AppTheme.auroraGradient,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
