import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/emotion/emotion_cubit.dart';
import '../../blocs/emotion/emotion_state.dart';
import '../../../core/core.dart';
import '../../../core/utils/api_connection_helper.dart';

/// Connection Status Card Widget
///
/// This widget displays the current connection status to the backend API server.
/// It provides visual feedback about connectivity and includes a test button
/// for manual connection verification.
///
/// Features:
/// - Real-time connection status display
/// - Color-coded status (green=connected, red=disconnected)
/// - Manual connection test button
/// - Loading state during connection tests
/// - Gradient background with shadows for modern UI
///
/// The widget automatically reflects the current EmotionCubit state:
/// - Connected: When not in error state
/// - Disconnected: When in error state
/// - Loading: When performing operations
class ConnectionStatusCard extends StatelessWidget {
  const ConnectionStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmotionCubit, EmotionState>(
      builder: (context, state) {
        // Determine connection status based on EmotionCubit state
        // Connected: Any state except EmotionError
        // Disconnected: EmotionError state (indicates API communication failure)
        final isConnected = state is! EmotionError;
        final isLoading = state is EmotionLoading;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // Dynamic gradient based on connection status
            // Green gradient for connected, red gradient for disconnected
            gradient: isConnected
                ? AppColors.successGradient
                : AppColors.errorGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                // Color-matched shadow for depth effect
                color: (isConnected ? AppColors.success : AppColors.error)
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Status icon: check mark for connected, error icon for disconnected
              Icon(
                isConnected ? Icons.check_circle : Icons.error,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  // Display connection status text from app strings
                  isConnected ? AppStrings.connected : AppStrings.disconnected,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              // Connection test button
              TextButton.icon(
                onPressed: isLoading
                    ? null
                    : () async {
                        // Test connection using comprehensive diagnostic
                        // This triggers the EmotionCubit to perform an operation,
                        // which will update the connection status automatically
                        try {
                          // Use API helper for detailed connection testing
                          final helper = ApiConnectionHelper();
                          final result = await helper.quickConnectionTest();

                          // Also trigger EmotionCubit operation to update state
                          context.read<EmotionCubit>().loadAnalysisHistory();

                          // Show result in debug console
                          print(
                            '[Connection Test] Result: ${result ? 'SUCCESS' : 'FAILED'}',
                          );
                        } catch (e) {
                          print('[Connection Test] Error: $e');
                          // Still trigger cubit operation for UI state update
                          context.read<EmotionCubit>().loadAnalysisHistory();
                        }
                      },
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.refresh, color: Colors.white, size: 18),
                label: Text(
                  // Dynamic button text based on loading state
                  isLoading ? 'Testing...' : 'Test',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  // Semi-transparent white background for button
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
