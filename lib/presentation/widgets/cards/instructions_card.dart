import 'package:flutter/material.dart';

import '../../../core/core.dart';

class InstructionsCard extends StatelessWidget {
  const InstructionsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildInstructionSteps(),
            const SizedBox(height: 20),
            _buildExamples(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: const Icon(Icons.lightbulb, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        const Text(
          AppStrings.howToUseTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionSteps() {
    return Column(
      children: [
        _buildInstructionStep(
          '1',
          AppStrings.step1Title,
          AppStrings.step1Description,
          Icons.wifi,
          AppColors.success,
        ),
        _buildInstructionStep(
          '2',
          AppStrings.step2Title,
          AppStrings.step2Description,
          Icons.edit,
          AppColors.info,
        ),
        _buildInstructionStep(
          '3',
          AppStrings.step3Title,
          AppStrings.step3Description,
          Icons.psychology,
          AppColors.primary,
        ),
        _buildInstructionStep(
          '4',
          AppStrings.step4Title,
          AppStrings.step4Description,
          Icons.analytics,
          AppColors.primaryLight,
        ),
      ],
    );
  }

  Widget _buildInstructionStep(
    String number,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: color.withValues(alpha: 0.7), size: 20),
        ],
      ),
    );
  }

  Widget _buildExamples() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primaryLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                AppStrings.tryExamplesTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...AppStrings.exampleTexts.map((text) => _buildExampleText(text)),
        ],
      ),
    );
  }

  Widget _buildExampleText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
    );
  }
}

