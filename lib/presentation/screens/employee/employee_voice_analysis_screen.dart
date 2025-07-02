import 'package:flutter/material.dart';
import '../../../core/core.dart';

class EmployeeVoiceAnalysisScreen extends StatefulWidget {
  const EmployeeVoiceAnalysisScreen({super.key});

  @override
  State<EmployeeVoiceAnalysisScreen> createState() =>
      _EmployeeVoiceAnalysisScreenState();
}

class _EmployeeVoiceAnalysisScreenState
    extends State<EmployeeVoiceAnalysisScreen>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _isAnalyzing = false;
  bool _hasRecording = false;
  String _recordingDuration = '00:00';
  double _recordingLevel = 0.0;
  Map<String, dynamic>? _analysisResult;
  late AnimationController _waveController;
  late AnimationController _levelController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _levelController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildRecordingSection(),
            const SizedBox(height: 24),
            if (_analysisResult != null) _buildAnalysisResult(),
            if (_analysisResult != null) const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildRecentRecordings(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mic, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Voice Analysis',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Analyze voice calls, voicemails, and audio feedback for emotion, sentiment, and quality',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatChip('Analyzed Today', '12', AppColors.primary),
                const SizedBox(width: 12),
                _buildStatChip('Avg Quality', '8.7/10', AppColors.success),
                const SizedBox(width: 12),
                _buildStatChip('Processing', '2.1s', AppColors.secondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRecordingSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Voice Recording & Analysis',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            // Recording visualization
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isRecording
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : AppColors.divider,
                ),
              ),
              child: _isRecording
                  ? _buildWaveform()
                  : _buildRecordingPlaceholder(),
            ),

            const SizedBox(height: 20),

            // Recording duration
            Text(
              _recordingDuration,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _isRecording
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // Recording controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Upload button
                _buildControlButton(
                  icon: Icons.upload_file,
                  label: 'Upload',
                  onPressed: _uploadAudio,
                  color: AppColors.secondary,
                ),

                // Record button
                GestureDetector(
                  onTap: _toggleRecording,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording ? AppColors.error : AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (_isRecording
                                      ? AppColors.error
                                      : AppColors.primary)
                                  .withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),

                // Analyze button
                _buildControlButton(
                  icon: Icons.analytics,
                  label: 'Analyze',
                  onPressed: _hasRecording ? _analyzeAudio : null,
                  color: AppColors.success,
                ),
              ],
            ),

            if (_hasRecording) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: _playRecording,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                  ),
                  TextButton.icon(
                    onPressed: _deleteRecording,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: onPressed != null ? color : AppColors.divider,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: onPressed != null ? color : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildWaveform() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          painter: WaveformPainter(
            animationValue: _waveController.value,
            level: _recordingLevel,
            color: AppColors.primary,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }

  Widget _buildRecordingPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mic_none, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 8),
          Text(
            'Tap the microphone to start recording',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResult() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: AppColors.success),
                const SizedBox(width: 8),
                Text(
                  'Voice Analysis Results',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Emotional analysis
            _buildResultCard(
              'Emotional Tone',
              _analysisResult!['emotion'],
              Icons.sentiment_satisfied,
              AppColors.primary,
            ),
            const SizedBox(height: 12),

            // Voice quality
            _buildResultCard(
              'Voice Quality',
              _analysisResult!['quality'],
              Icons.high_quality,
              AppColors.success,
            ),
            const SizedBox(height: 12),

            // Speech clarity
            _buildResultCard(
              'Speech Clarity',
              _analysisResult!['clarity'],
              Icons.record_voice_over,
              AppColors.secondary,
            ),
            const SizedBox(height: 12),

            // Customer satisfaction
            _buildResultCard(
              'Customer Satisfaction',
              _analysisResult!['satisfaction'],
              Icons.thumb_up,
              AppColors.warning,
            ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generateTranscript,
                    icon: const Icon(Icons.text_fields),
                    label: const Text('Generate Transcript'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _saveAnalysis,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            _buildActionCard(
              'Call Analysis',
              Icons.phone,
              () => _analyzeCall(),
            ),
            _buildActionCard(
              'Batch Process',
              Icons.folder,
              () => _batchProcess(),
            ),
            _buildActionCard(
              'Voice Training',
              Icons.school,
              () => _voiceTraining(),
            ),
            _buildActionCard(
              'Settings',
              Icons.settings,
              () => _voiceSettings(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentRecordings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Recordings',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) => _buildRecordingCard(index),
        ),
      ],
    );
  }

  Widget _buildRecordingCard(int index) {
    final durations = ['2:34', '1:45', '3:21', '0:58'];
    final types = ['Customer Call', 'Voicemail', 'Team Meeting', 'Training'];
    final emotions = ['Positive', 'Neutral', 'Satisfied', 'Concerned'];
    final times = ['1 hour ago', '3 hours ago', '1 day ago', '2 days ago'];

    final emotionColors = {
      'Positive': AppColors.success,
      'Neutral': AppColors.textSecondary,
      'Satisfied': AppColors.primary,
      'Concerned': AppColors.warning,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(Icons.record_voice_over, color: AppColors.primary),
        ),
        title: Row(
          children: [
            Text(types[index]),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: emotionColors[emotions[index]]!.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                emotions[index],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: emotionColors[emotions[index]],
                ),
              ),
            ),
          ],
        ),
        subtitle: Text('Duration: ${durations[index]} • ${times[index]}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, size: 20),
              onPressed: () => _playRecordingFromHistory(index),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, size: 20),
              onPressed: () => _showRecordingOptions(index),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _startRecording();
      } else {
        _stopRecording();
      }
    });
  }

  void _startRecording() {
    _waveController.repeat();
    // Simulate recording with timer updates
    _updateRecordingDuration();
  }

  void _stopRecording() {
    _waveController.stop();
    setState(() {
      _hasRecording = true;
    });
  }

  void _updateRecordingDuration() {
    if (_isRecording) {
      // This would be replaced with actual recording duration logic
      Future.delayed(const Duration(seconds: 1), () {
        if (_isRecording) {
          setState(() {
            final currentSeconds =
                int.parse(_recordingDuration.split(':')[1]) + 1;
            final minutes = currentSeconds ~/ 60;
            final seconds = currentSeconds % 60;
            _recordingDuration =
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
            _recordingLevel =
                (DateTime.now().millisecondsSinceEpoch % 100) / 100.0;
          });
          _updateRecordingDuration();
        }
      });
    }
  }

  void _uploadAudio() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Audio file upload would be implemented here'),
      ),
    );
  }

  void _analyzeAudio() {
    setState(() => _isAnalyzing = true);

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isAnalyzing = false;
        _analysisResult = {
          'emotion': 'Calm & Professional (89%)',
          'quality': 'Excellent (9.2/10)',
          'clarity': 'Very Clear (94%)',
          'satisfaction': 'High (8.7/10)',
        };
      });
    });
  }

  void _playRecording() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Playing recording...')));
  }

  void _deleteRecording() {
    setState(() {
      _hasRecording = false;
      _recordingDuration = '00:00';
      _analysisResult = null;
    });
  }

  void _generateTranscript() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Transcript'),
        content: const SingleChildScrollView(
          child: Text(
            'Customer: Hello, I\'m calling about my recent order.\n\nAgent: Hi there! I\'d be happy to help you with your order. Can you please provide me with your order number?\n\nCustomer: Sure, it\'s ORDER-12345.\n\nAgent: Thank you. I can see your order here. It was shipped yesterday and should arrive within 2-3 business days. Is there anything specific you needed to know about it?\n\nCustomer: Perfect, that\'s exactly what I needed to know. Thank you so much for your help!\n\nAgent: You\'re very welcome! Is there anything else I can assist you with today?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save Transcript'),
          ),
        ],
      ),
    );
  }

  void _saveAnalysis() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice analysis saved successfully')),
    );
  }

  void _analyzeCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Call analysis feature would be implemented here'),
      ),
    );
  }

  void _batchProcess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Batch processing feature would be implemented here'),
      ),
    );
  }

  void _voiceTraining() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice training module would be implemented here'),
      ),
    );
  }

  void _voiceSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice settings would be implemented here')),
    );
  }

  void _playRecordingFromHistory(int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Playing recording ${index + 1}')));
  }

  void _showRecordingOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Re-analyze'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _levelController.dispose();
    super.dispose();
  }
}

class WaveformPainter extends CustomPainter {
  final double animationValue;
  final double level;
  final Color color;

  WaveformPainter({
    required this.animationValue,
    required this.level,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = size.height / 2;
    final barWidth = size.width / 20;

    for (int i = 0; i < 20; i++) {
      final x = i * barWidth + barWidth / 2;
      final height =
          (20 + (level * 40) + (i % 3) * 10) *
          (0.5 + 0.5 * (animationValue + i * 0.1) % 1.0);

      canvas.drawLine(
        Offset(x, center - height),
        Offset(x, center + height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
