import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Audio sample for voice analysis
class AudioSample {
  final String id;
  final String title;
  final String description;
  final String filePath;
  final String duration;
  final AudioCategory category;

  const AudioSample({
    required this.id,
    required this.title,
    required this.description,
    required this.filePath,
    required this.duration,
    required this.category,
  });
}

/// Categories for audio samples
enum AudioCategory {
  customerService('Customer Service', Icons.headset_mic, AppColors.primary),
  presentation('Presentation', Icons.present_to_all, AppColors.secondary),
  interview('Interview', Icons.person, AppColors.info),
  meeting('Meeting', Icons.groups, AppColors.warning),
  training('Training', Icons.school, AppColors.success),
  call('Phone Call', Icons.phone, AppColors.accent);

  const AudioCategory(this.name, this.icon, this.color);
  final String name;
  final IconData icon;
  final Color color;
}

/// Default audio samples for voice analysis
class DefaultAudioSamples {
  static const List<AudioSample> all = [
    AudioSample(
      id: '1',
      title: 'Customer Service Call',
      description: 'Professional customer interaction recording',
      filePath: '/audio/customer-service-call.mp3',
      duration: '4:32',
      category: AudioCategory.customerService,
    ),
    AudioSample(
      id: '2',
      title: 'Sales Presentation',
      description: 'Sales team presentation recording',
      filePath: '/audio/sales-presentation.wav',
      duration: '8:15',
      category: AudioCategory.presentation,
    ),
    AudioSample(
      id: '3',
      title: 'Job Interview',
      description: 'Mock interview for communication analysis',
      filePath: '/audio/job-interview.mp3',
      duration: '12:45',
      category: AudioCategory.interview,
    ),
    AudioSample(
      id: '4',
      title: 'Team Meeting',
      description: 'Weekly team sync meeting recording',
      filePath: '/audio/team-meeting.wav',
      duration: '25:18',
      category: AudioCategory.meeting,
    ),
    AudioSample(
      id: '5',
      title: 'Training Session',
      description: 'Employee training and development session',
      filePath: '/audio/training-session.mp3',
      duration: '18:42',
      category: AudioCategory.training,
    ),
    AudioSample(
      id: '6',
      title: 'Client Phone Call',
      description: 'Important client consultation call',
      filePath: '/audio/client-call.wav',
      duration: '6:28',
      category: AudioCategory.call,
    ),
  ];
}
