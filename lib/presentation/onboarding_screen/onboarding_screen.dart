import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import './widgets/onboarding_step1_widget.dart';
import './widgets/onboarding_step2_widget.dart';
import './widgets/onboarding_step3_widget.dart';
import './widgets/onboarding_step4_widget.dart';
import './widgets/onboarding_step5_widget.dart';
import './widgets/onboarding_step_indicator_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with [Riverpod/Bloc] for production

  int _currentStep = 0; // 0 = welcome, steps 1-4 for the rest
  final PageController _pageController = PageController();
  late AnimationController _transitionController;
  late Animation<double> _fadeAnim;

  // Onboarding data
  String _playerName = '';
  int _selectedAvatarIndex = 0;
  int _selectedClassIndex = 0;
  final Set<int> _selectedCompanions = {};
  final Set<int> _selectedThemes = {};

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    _fadeAnim = CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return true;
      case 1:
        return _playerName.trim().isNotEmpty;
      case 2:
        return true;
      case 3:
        return _selectedCompanions.isNotEmpty;
      case 4:
        return _selectedThemes.isNotEmpty;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (!_canProceed()) return;

    if (_currentStep == 4) {
      // Complete onboarding
      context.go(AppRoutes.homeScreen);
      return;
    }

    setState(() => _currentStep++);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _prevStep() {
    if (_currentStep == 0) return;
    setState(() => _currentStep--);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  String _getNextLabel() {
    switch (_currentStep) {
      case 0:
        return 'Start';
      case 4:
        return 'Enter the Game';
      default:
        return 'Continue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Step indicator (hidden on welcome)
            if (_currentStep > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      GestureDetector(
                        onTap: _prevStep,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppTheme.muted,
                            size: 16,
                          ),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OnboardingStepIndicatorWidget(
                        totalSteps: 4,
                        currentStep: _currentStep - 1,
                      ),
                    ),
                  ],
                ),
              ),
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  OnboardingStep1Widget(),
                  OnboardingStep2Widget(
                    name: _playerName,
                    onNameChanged: (v) => setState(() => _playerName = v),
                  ),
                  OnboardingStep3Widget(
                    selectedAvatarIndex: _selectedAvatarIndex,
                    selectedClassIndex: _selectedClassIndex,
                    onAvatarSelected: (i) =>
                        setState(() => _selectedAvatarIndex = i),
                    onClassSelected: (i) =>
                        setState(() => _selectedClassIndex = i),
                  ),
                  OnboardingStep4Widget(
                    selectedCompanions: _selectedCompanions,
                    onToggle: (i) {
                      setState(() {
                        if (_selectedCompanions.contains(i)) {
                          _selectedCompanions.remove(i);
                        } else {
                          _selectedCompanions.add(i);
                        }
                      });
                    },
                  ),
                  OnboardingStep5Widget(
                    selectedThemes: _selectedThemes,
                    onToggle: (i) {
                      setState(() {
                        if (_selectedThemes.contains(i)) {
                          _selectedThemes.remove(i);
                        } else {
                          _selectedThemes.add(i);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            // Bottom CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  if (_currentStep == 1 && !_canProceed())
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Enter your hero name to continue',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.muted,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: _canProceed() ? _nextStep : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: _canProceed()
                            ? AppTheme.auroraGradient
                            : null,
                        color: _canProceed() ? null : AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: _canProceed()
                            ? null
                            : Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getNextLabel(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _canProceed()
                                  ? Colors.white
                                  : AppTheme.mutedDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: _canProceed()
                                ? Colors.white
                                : AppTheme.mutedDark,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
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
