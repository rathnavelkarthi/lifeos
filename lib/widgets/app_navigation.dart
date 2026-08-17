import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class _TabSpec {
  final String label;
  final IconData icon;
  final int? branchIndex;

  const _TabSpec({
    required this.label,
    required this.icon,
    required this.branchIndex,
  });
}

// V3 Liquid Glass BottomNav — BackdropFilter blur + frosted + animated pill — LOCKED
class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigation({required this.navigationShell, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation>
    with SingleTickerProviderStateMixin {
  int _selectedVisualIndex = 0;

  late AnimationController _pillController;
  late Animation<double> _pillAnimation;
  int _previousIndex = 0;

  static const List<_TabSpec> _tabs = [
    _TabSpec(label: 'Today', icon: Icons.home_rounded, branchIndex: 0),
    _TabSpec(
      label: 'Missions',
      icon: Icons.auto_awesome_rounded,
      branchIndex: 1,
    ),
    _TabSpec(label: 'Life', icon: Icons.timeline_rounded, branchIndex: null),
    _TabSpec(
      label: 'Growth',
      icon: Icons.trending_up_rounded,
      branchIndex: null,
    ),
    _TabSpec(label: 'You', icon: Icons.person_rounded, branchIndex: null),
  ];

  @override
  void initState() {
    super.initState();
    _pillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pillAnimation = CurvedAnimation(
      parent: _pillController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pillController.dispose();
    super.dispose();
  }

  void _onTabTap(int visualIndex) {
    final tab = _tabs[visualIndex];
    if (tab.branchIndex == null) return; // stub tab — silent ignore

    if (_selectedVisualIndex != visualIndex) {
      setState(() {
        _previousIndex = _selectedVisualIndex;
        _selectedVisualIndex = visualIndex;
      });
      _pillController.forward(from: 0);
      widget.navigationShell.goBranch(
        tab.branchIndex!,
        initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.surface.withAlpha(217),
              border: const Border(
                top: BorderSide(color: AppTheme.border, width: 1),
              ),
            ),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final isActive = i == _selectedVisualIndex;
                final isStub = tab.branchIndex == null;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Opacity(
                      opacity: isStub ? 0.4 : 1.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isActive
                                    ? AppTheme.primaryViolet.withAlpha(51)
                                    : Colors.transparent,
                              ),
                              child: ShaderMask(
                                shaderCallback: (bounds) => isActive
                                    ? AppTheme.auroraGradient.createShader(
                                        bounds,
                                      )
                                    : const LinearGradient(
                                        colors: [
                                          AppTheme.muted,
                                          AppTheme.muted,
                                        ],
                                      ).createShader(bounds),
                                child: Icon(
                                  tab.icon,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? AppTheme.accentMint
                                    : AppTheme.mutedDark,
                              ),
                              child: Text(tab.label),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
