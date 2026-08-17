import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class OnboardingStepIndicatorWidget extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const OnboardingStepIndicatorWidget({
    required this.totalSteps,
    required this.currentStep,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final isActive = i == currentStep;
        final isCompleted = i < currentStep;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < totalSteps - 1 ? 6 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: isActive || isCompleted
                    ? AppTheme.auroraGradient
                    : null,
                color: isActive || isCompleted ? null : AppTheme.border,
              ),
            ),
          ),
        );
      }),
    );
  }
}
