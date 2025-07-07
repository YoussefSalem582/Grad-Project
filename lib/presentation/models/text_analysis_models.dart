/// Data models for the text analysis screen
///
/// This file contains all data models and structures used by the
/// text analysis functionality, ensuring type safety and consistency.

import 'package:flutter/material.dart';

/// Represents a quick action item in the text analysis screen
class AnalysisQuickAction {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const AnalysisQuickAction({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

/// Represents a statistics item shown in the analysis header
class AnalysisHeaderStat {
  final String value;
  final String label;
  final IconData icon;
  final Color? color;

  const AnalysisHeaderStat({
    required this.value,
    required this.label,
    required this.icon,
    this.color,
  });
}

/// Represents a single item in the analysis history
class AnalysisHistoryItem {
  final String id;
  final String title;
  final String type;
  final DateTime timestamp;
  final double confidence;
  final Map<String, dynamic> result;

  const AnalysisHistoryItem({
    required this.id,
    required this.title,
    required this.type,
    required this.timestamp,
    required this.confidence,
    required this.result,
  });

  /// Get a formatted confidence percentage
  String get confidencePercentage => '${(confidence * 100).toInt()}%';

  /// Get a human-readable time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Represents a text template that users can quickly apply
class TextTemplate {
  final String title;
  final String description;
  final String content;
  final String category;
  final IconData icon;

  const TextTemplate({
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    required this.icon,
  });
}

/// Default text templates for common use cases
class DefaultTextTemplates {
  static const List<TextTemplate> all = [
    TextTemplate(
      title: 'Customer Review',
      description: 'Positive customer feedback',
      content:
          'I absolutely love this product! The quality is amazing and customer service was incredibly helpful. Would definitely recommend to others.',
      category: 'Reviews',
      icon: Icons.star,
    ),
    TextTemplate(
      title: 'Support Request',
      description: 'Technical support inquiry',
      content:
          'Hi, I\'m having trouble with my account login. Could you please help me reset my password? This is quite urgent as I need access for work.',
      category: 'Support',
      icon: Icons.help,
    ),
    TextTemplate(
      title: 'Complaint',
      description: 'Customer complaint example',
      content:
          'I am very disappointed with my recent purchase. The item arrived damaged and the delivery was delayed by 3 days without any notification.',
      category: 'Feedback',
      icon: Icons.report_problem,
    ),
    TextTemplate(
      title: 'Business Email',
      description: 'Professional communication',
      content:
          'Thank you for your proposal. We have reviewed the terms and are pleased to move forward with the partnership. Let\'s schedule a meeting next week.',
      category: 'Business',
      icon: Icons.business,
    ),
    TextTemplate(
      title: 'Social Media',
      description: 'Social media post example',
      content:
          'Just tried the new coffee shop downtown! Amazing atmosphere and the barista was so friendly. Perfect place to work remotely! ☕️ #coffee #remote',
      category: 'Social',
      icon: Icons.share,
    ),
  ];
}
