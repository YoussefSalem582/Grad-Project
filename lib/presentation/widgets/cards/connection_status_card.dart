import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/emotion/emotion_cubit.dart';
import '../../../core/core.dart';

class ConnectionStatusCard extends StatelessWidget {
  const ConnectionStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmotionCubit, EmotionState>(
      builder: (context, state) {
        final isConnected = _isConnected(state);
        final isChecking = _isConnectionChecking(state);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isConnected
                ? AppColors.successGradient
                : AppColors.errorGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (isConnected ? AppColors.success : AppColors.error)
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                isConnected ? Icons.check_circle : Icons.error,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isConnected ? AppStrings.connected : AppStrings.disconnected,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: isChecking
                    ? null
                    : () => context.read<EmotionCubit>().checkConnection(),
                icon: isChecking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.refresh, color: Colors.white, size: 18),
                label: Text(
                  AppStrings.refresh,
                  style: const TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isConnected(EmotionState state) {
    if (state is EmotionConnectionResult) {
      return state.isConnected;
    }
    return false;
  }

  bool _isConnectionChecking(EmotionState state) {
    return state is EmotionConnectionChecking;
  }
}
