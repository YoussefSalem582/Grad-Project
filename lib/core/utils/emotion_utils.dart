import 'package:flutter/material.dart';

class EmotionUtils {
  static String getEmotionEmoji(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'joy':
        return '😊';
      case 'sadness':
        return '😢';
      case 'anger':
        return '😠';
      case 'fear':
        return '😨';
      case 'surprise':
        return '😲';
      case 'disgust':
        return '🤢';
      case 'neutral':
        return '😐';
      default:
        return '🤔';
    }
  }

  static Color getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
        return Colors.yellow.shade600;
      case 'sad':
      case 'sadness':
        return Colors.blue;
      case 'angry':
      case 'anger':
        return Colors.red;
      case 'fear':
        return Colors.purple;
      case 'surprise':
        return Colors.orange;
      case 'neutral':
        return Colors.grey;
      case 'disgust':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static IconData getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'joy':
        return Icons.sentiment_very_satisfied;
      case 'sadness':
        return Icons.sentiment_very_dissatisfied;
      case 'anger':
        return Icons.sentiment_dissatisfied;
      case 'fear':
        return Icons.warning;
      case 'surprise':
        return Icons.help_outline;
      case 'disgust':
        return Icons.remove_circle;
      case 'neutral':
        return Icons.sentiment_neutral;
      default:
        return Icons.help;
    }
  }

  static String formatConfidence(double confidence) {
    return '${(confidence * 100).toStringAsFixed(1)}%';
  }

  static String formatProcessingTime(double timeMs) {
    return '${timeMs.toStringAsFixed(0)}ms';
  }

  static List<MapEntry<String, double>> getSortedEmotions(
    Map<String, dynamic> allEmotions,
  ) {
    final entries = allEmotions.entries
        .map((e) => MapEntry(e.key, (e.value as num).toDouble()))
        .toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }
}
