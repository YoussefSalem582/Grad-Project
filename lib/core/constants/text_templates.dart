import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Text templates for analysis screens
class TextTemplate {
  final String id;
  final String title;
  final String content;
  final TextTemplateCategory category;
  final List<String> tags;

  const TextTemplate({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.tags = const [],
  });
}

/// Categories for text templates
enum TextTemplateCategory {
  customerService('Customer Service', Icons.headset_mic, AppColors.primary),
  business('Business', Icons.business, AppColors.secondary),
  social('Social Media', Icons.share, AppColors.info),
  feedback('Feedback', Icons.feedback, AppColors.warning),
  marketing('Marketing', Icons.campaign, AppColors.success),
  support('Support', Icons.support_agent, AppColors.accent);

  const TextTemplateCategory(this.name, this.icon, this.color);
  final String name;
  final IconData icon;
  final Color color;
}

/// Default text templates for analysis
class DefaultTextTemplates {
  static const List<TextTemplate> customerService = [
    TextTemplate(
      id: 'cs_1',
      title: 'Customer Appreciation',
      content:
          "Thank you for contacting us. We appreciate your feedback and value your business relationship with us.",
      category: TextTemplateCategory.customerService,
      tags: ['appreciation', 'feedback', 'positive'],
    ),
    TextTemplate(
      id: 'cs_2',
      title: 'Apology Response',
      content:
          "I sincerely apologize for the inconvenience. Let me resolve this issue immediately and ensure it doesn't happen again.",
      category: TextTemplateCategory.customerService,
      tags: ['apology', 'resolution', 'service'],
    ),
    TextTemplate(
      id: 'cs_3',
      title: 'Follow-up Question',
      content:
          "Is there anything else I can help you with today? We're here to ensure you have the best experience possible.",
      category: TextTemplateCategory.customerService,
      tags: ['follow-up', 'assistance', 'service'],
    ),
  ];

  static const List<TextTemplate> business = [
    TextTemplate(
      id: 'biz_1',
      title: 'Order Confirmation',
      content:
          "Your order has been processed successfully. Thank you for your business. You'll receive a confirmation email shortly.",
      category: TextTemplateCategory.business,
      tags: ['order', 'confirmation', 'business'],
    ),
    TextTemplate(
      id: 'biz_2',
      title: 'Meeting Follow-up',
      content:
          "Thank you for the productive meeting today. I've attached the action items we discussed for your review.",
      category: TextTemplateCategory.business,
      tags: ['meeting', 'follow-up', 'professional'],
    ),
    TextTemplate(
      id: 'biz_3',
      title: 'Project Update',
      content:
          "I'm pleased to update you on our project progress. We're ahead of schedule and within budget parameters.",
      category: TextTemplateCategory.business,
      tags: ['project', 'update', 'progress'],
    ),
  ];

  static const List<TextTemplate> social = [
    TextTemplate(
      id: 'social_1',
      title: 'Social Media Post',
      content:
          "Excited to share this amazing experience! The team's dedication and innovation continue to inspire me every day. #teamwork #innovation",
      category: TextTemplateCategory.social,
      tags: ['social', 'excitement', 'team'],
    ),
    TextTemplate(
      id: 'social_2',
      title: 'Product Review',
      content:
          "This product exceeded my expectations! The quality is outstanding and the customer service was exceptional. Highly recommended!",
      category: TextTemplateCategory.social,
      tags: ['review', 'positive', 'recommendation'],
    ),
    TextTemplate(
      id: 'social_3',
      title: 'Achievement Post',
      content:
          "Thrilled to announce that we've reached a major milestone! Thank you to everyone who supported us on this journey.",
      category: TextTemplateCategory.social,
      tags: ['achievement', 'milestone', 'gratitude'],
    ),
  ];

  static List<TextTemplate> get all => [
    ...customerService,
    ...business,
    ...social,
  ];

  static List<TextTemplate> getByCategory(TextTemplateCategory category) {
    return all.where((template) => template.category == category).toList();
  }
}
