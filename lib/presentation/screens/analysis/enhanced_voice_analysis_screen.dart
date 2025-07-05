import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../widgets/analysis/analysis.dart';
import '../../cubit/voice_analysis/voice_analysis_cubit.dart';

class EnhancedVoiceAnalysisScreen extends StatelessWidget {
  const EnhancedVoiceAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VoiceAnalysisCubit(),
      child: const _EnhancedVoiceAnalysisScreenView(),
    );
  }
}

class _EnhancedVoiceAnalysisScreenView extends StatefulWidget {
  const _EnhancedVoiceAnalysisScreenView();

  @override
  State<_EnhancedVoiceAnalysisScreenView> createState() =>
      _EnhancedVoiceAnalysisScreenViewState();
}

class _EnhancedVoiceAnalysisScreenViewState
    extends State<_EnhancedVoiceAnalysisScreenView> {
  final TextEditingController _filePathController = TextEditingController();
  final FocusNode _filePathFocusNode = FocusNode();

  String _selectedAnalysisType = 'Emotion Analysis';
  bool _isValidFile = false;

  final List<String> _analysisTypes = [
    'Emotion Analysis',
    'Communication Style',
    'Confidence Level',
    'Speech Patterns',
    'Sentiment Analysis',
  ];

  final List<AudioSample> _sampleAudioFiles = DefaultAudioSamples.all;

  @override
  void initState() {
    super.initState();
    _filePathController.addListener(_validateFile);
  }

  @override
  void dispose() {
    _filePathController.dispose();
    _filePathFocusNode.dispose();
    super.dispose();
  }

  void _validateFile() {
    final path = _filePathController.text.trim();
    setState(() {
      _isValidFile =
          path.isNotEmpty &&
          (path.endsWith('.mp3') ||
              path.endsWith('.wav') ||
              path.endsWith('.m4a') ||
              path.startsWith('/audio/'));
    });
  }

  void _onAnalysisTypeChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedAnalysisType = value;
      });
    }
  }

  void _useSampleAudio(String filePath) {
    _filePathController.text = filePath;
    _validateFile();
    _filePathFocusNode.unfocus();
  }

  void _selectAudioFile() {
    // In a real implementation, this would open a file picker
    // For now, show a dialog with file selection options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Audio File'),
        content: const Text(
          'In a production app, this would open a file picker to select:\n\n'
          '• Audio files from device storage\n'
          '• Recent call recordings\n'
          '• Cloud storage files\n'
          '• Voice memos\n\n'
          'For now, please use the sample files below or enter a file path manually.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _analyzeAudio() async {
    if (!_isValidFile) return;

    context.read<VoiceAnalysisCubit>().analyzeAudio(
      filePath: _filePathController.text.trim(),
      analysisType: _selectedAnalysisType,
    );
  }

  void _clearAnalysis() {
    setState(() {
      _filePathController.clear();
      _isValidFile = false;
    });
    context.read<VoiceAnalysisCubit>().clearAnalysis();
  }

  void _showAudioLibrary() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Audio Library feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportResults() {
    final cubit = context.read<VoiceAnalysisCubit>();
    final state = cubit.state;

    if (state is! VoiceAnalysisSuccess && state is! VoiceAnalysisDemo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No analysis results to export'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export Results feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Voice Analysis'),
        content: const Text(
          'This tool analyzes pre-recorded audio files and phone calls to provide insights into:\n\n'
          '• Emotional tone and sentiment\n'
          '• Communication effectiveness\n'
          '• Confidence levels\n'
          '• Speech patterns and clarity\n\n'
          'Supported formats: MP3, WAV, M4A\n'
          'Maximum file size: 50MB\n'
          'Analysis typically takes 30-60 seconds.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = CustomSpacing();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Voice Analysis'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            onPressed: _showAudioLibrary,
            icon: const Icon(Icons.library_music),
            tooltip: 'Audio Library',
          ),
          IconButton(
            onPressed: _exportResults,
            icon: const Icon(Icons.download),
            tooltip: 'Export Results',
          ),
          IconButton(
            onPressed: _showAboutDialog,
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
          ),
        ],
      ),
      body: BlocConsumer<VoiceAnalysisCubit, VoiceAnalysisState>(
        listener: (context, state) {
          if (state is VoiceAnalysisSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Audio analysis completed successfully!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is VoiceAnalysisError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                AnalysisHeaderWidget(
                  title: 'Voice & Audio Analysis',
                  description:
                      'Import and analyze pre-recorded audio files or phone calls',
                  icon: Icons.mic,
                  gradientColors: const [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                  stats: [
                    AnalysisHeaderStat(
                      value: '12',
                      label: 'Files',
                      icon: Icons.audio_file,
                    ),
                    AnalysisHeaderStat(
                      value: '8.7',
                      label: 'Avg Score',
                      icon: Icons.star,
                    ),
                    AnalysisHeaderStat(
                      value: '2.1s',
                      label: 'Speed',
                      icon: Icons.speed,
                    ),
                  ],
                ),
                SizedBox(height: spacing.xl),

                // Audio Input Section
                _buildAudioInputSection(theme, spacing, state),
                SizedBox(height: spacing.xl),

                // Sample Audio Files Section
                _buildAudioSamplesSection(theme, spacing),
                SizedBox(height: spacing.xl),

                // Analysis Results Section
                if (state is VoiceAnalysisSuccess ||
                    state is VoiceAnalysisDemo) ...[
                  AnalysisResultWidget(
                    result: state is VoiceAnalysisSuccess
                        ? state.result.toMap()
                        : (state as VoiceAnalysisDemo).demoResult.toMap(),
                    isLoading: false,
                    analysisType: 'voice',
                  ),
                  SizedBox(height: spacing.xl),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selectAudioFile,
        icon: Icon(Icons.mic),
        label: Text('Import Audio'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildAudioInputSection(
    ThemeData theme,
    CustomSpacing spacing,
    VoiceAnalysisState state,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.audio_file, color: AppColors.primary, size: 24),
              SizedBox(width: spacing.sm),
              Text(
                'Audio File Analysis',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),

          // Analysis Type Selector
          Container(
            padding: EdgeInsets.symmetric(horizontal: spacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedAnalysisType,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
                onChanged: _onAnalysisTypeChanged,
                items: _analysisTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                      type,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: spacing.lg),

          // File Path Input with Import Button
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _filePathController,
                  focusNode: _filePathFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Audio File Path',
                    hintText: 'Path to audio file (MP3, WAV, M4A)',
                    prefixIcon: Icon(
                      Icons.folder_open,
                      color: AppColors.primary,
                    ),
                    suffixIcon: _isValidFile
                        ? Icon(Icons.check_circle, color: AppColors.success)
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.md),
              ElevatedButton.icon(
                onPressed: _selectAudioFile,
                icon: Icon(Icons.upload_file),
                label: Text('Import'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.lg,
                    vertical: spacing.md + 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),

          // Supported formats info
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 16),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: Text(
                    'Supported formats: MP3, WAV, M4A • Max size: 50MB',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.lg),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isValidFile && state is! VoiceAnalysisLoading
                      ? _analyzeAudio
                      : null,
                  icon: state is VoiceAnalysisLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Icon(Icons.analytics),
                  label: Text(
                    state is VoiceAnalysisLoading
                        ? 'Analyzing...'
                        : 'Analyze Audio',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: spacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.md),
              OutlinedButton.icon(
                onPressed: _clearAnalysis,
                icon: Icon(Icons.clear),
                label: Text('Clear'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error),
                  padding: EdgeInsets.symmetric(vertical: spacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSamplesSection(ThemeData theme, CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.library_music, color: AppColors.secondary, size: 24),
              SizedBox(width: spacing.sm),
              Text(
                'Sample Audio Files',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Text(
            'Select from pre-recorded audio samples to test the analysis',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.lg),
          ...(_sampleAudioFiles.map(
            (sample) => _buildSampleTile(sample, theme, spacing),
          )),
        ],
      ),
    );
  }

  Widget _buildSampleTile(
    AudioSample sample,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      child: InkWell(
        onTap: () => _useSampleAudio(sample.filePath),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: sample.category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  sample.category.icon,
                  color: sample.category.color,
                  size: 24,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sample.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      sample.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    sample.duration,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    sample.category.name,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
