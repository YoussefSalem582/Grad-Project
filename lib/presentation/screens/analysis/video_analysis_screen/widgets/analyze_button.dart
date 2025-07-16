import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import '../../../../cubit/video_analysis/video_analysis_cubit.dart';
import '../../../../widgets/common/animated_loading_indicator.dart';

/// Analyze button widget with dynamic states and animations
class AnalyzeButton extends StatelessWidget {
  final Animation<double> animation;
  final bool canAnalyze;
  final VoidCallback onPressed;

  const AnalyzeButton({
    super.key,
    required this.animation,
    required this.canAnalyze,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: BlocBuilder<VideoAnalysisCubit, VideoAnalysisState>(
        builder: (context, state) {
          final isLoading = state is VideoAnalysisLoading;

          return Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient:
                  canAnalyze && !isLoading
                      ? const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      )
                      : null,
              color: canAnalyze && !isLoading ? null : AppColors.border,
              borderRadius: BorderRadius.circular(14),
              boxShadow:
                  canAnalyze && !isLoading
                      ? [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                      : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: canAnalyze && !isLoading ? onPressed : null,
                child: Center(
                  child:
                      isLoading
                          ? _buildLoadingContent()
                          : _buildDefaultContent(canAnalyze),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmoLoader.mini(size: 24, color: Colors.white),
        const SizedBox(width: 12),
        const Text(
          'Analyzing Customer Video...',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultContent(bool enabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.analytics_rounded,
          color: enabled ? Colors.white : AppColors.textSecondary,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          'Analyze Customer Video',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: enabled ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
