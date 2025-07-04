import 'package:flutter/material.dart';
import 'video_analysis_screen.dart';

/// Legacy wrapper for VideoAnalyzerScreen - redirects to new VideoAnalysisScreen
class VideoAnalyzerScreen extends StatelessWidget {
  const VideoAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect to the new enhanced VideoAnalysisScreen
    return const VideoAnalysisScreen();
  }
}
