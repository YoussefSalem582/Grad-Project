import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';

import '../../../core/core.dart';

class BatchProcessingScreen extends StatefulWidget {
  const BatchProcessingScreen({super.key});

  @override
  State<BatchProcessingScreen> createState() => _BatchProcessingScreenState();
}

class _BatchProcessingScreenState extends State<BatchProcessingScreen> {
  final List<TextEditingController> _controllers = [];
  final ScrollController _scrollController = ScrollController();
  int _textCount = 3;
  static const int _maxTexts = 10;
  static const int _minTexts = 2;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers.clear();
    for (int i = 0; i < _textCount; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _addTextField() {
    if (_textCount < _maxTexts) {
      setState(() {
        _textCount++;
        _controllers.add(TextEditingController());
      });
    }
  }

  void _removeTextField(int index) {
    if (_textCount > _minTexts) {
      setState(() {
        _controllers[index].dispose();
        _controllers.removeAt(index);
        _textCount--;
      });
    }
  }

  void _processBatch() {
    final texts = _controllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (texts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one text to analyze'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.read<EmotionProvider>().analyzeBatchEmotions(texts);
  }

  void _clearAll() {
    for (final controller in _controllers) {
      controller.clear();
    }
  }

  void _loadSampleTexts() {
    final samples = [
      "I'm so excited about this new opportunity!",
      "This weather is making me feel really down.",
      "I can't believe how frustrating this situation is.",
      "That movie was absolutely terrifying to watch.",
      "What a wonderful surprise this turned out to be!",
    ];

    for (int i = 0; i < _controllers.length && i < samples.length; i++) {
      _controllers[i].text = samples[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batch Processing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Analyze multiple texts simultaneously',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Consumer<EmotionProvider>(
            builder: (context, provider, child) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: provider.isBatchProcessing
                      ? AppColors.warning.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  provider.isBatchProcessing ? 'Processing...' : 'Ready',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: Column(
          children: [
            _buildControls(),
            Expanded(child: _buildTextInputs()),
            _buildActions(),
            Consumer<EmotionProvider>(
              builder: (context, provider, child) {
                if (provider.batchResults.isNotEmpty) {
                  return _buildResults(provider.batchResults);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Text Inputs ($_textCount/$_maxTexts)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Add up to $_maxTexts texts for batch analysis',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _textCount < _maxTexts ? _addTextField : null,
                icon: const Icon(Icons.add_circle),
                color: AppColors.success,
                tooltip: 'Add text field',
              ),
              IconButton(
                onPressed: _loadSampleTexts,
                icon: const Icon(Icons.auto_awesome),
                color: AppColors.accent,
                tooltip: 'Load sample texts',
              ),
              IconButton(
                onPressed: _clearAll,
                icon: const Icon(Icons.clear_all),
                color: AppColors.error,
                tooltip: 'Clear all',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextInputs() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _textCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surface,
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Text ${index + 1}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (_textCount > _minTexts)
                        IconButton(
                          onPressed: () => _removeTextField(index),
                          icon: const Icon(
                            Icons.remove_circle,
                            color: AppColors.error,
                          ),
                          iconSize: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controllers[index],
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter text for emotion analysis...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                      counterText: '${_controllers[index].text.length}/500',
                    ),
                    maxLength: 500,
                    onChanged: (value) => setState(() {}),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Consumer<EmotionProvider>(
        builder: (context, provider, child) {
          final hasTexts = _controllers.any(
            (controller) => controller.text.trim().isNotEmpty,
          );

          return Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: (hasTexts && !provider.isBatchProcessing)
                      ? _processBatch
                      : null,
                  icon: provider.isBatchProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.psychology),
                  label: Text(
                    provider.isBatchProcessing
                        ? 'Processing...'
                        : 'Analyze Batch',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: provider.batchResults.isNotEmpty
                      ? () => provider.clearBatchResults()
                      : null,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Results'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResults(List<dynamic> results) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.success.withValues(alpha: 0.1),
                AppColors.surface,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.batch_prediction,
                        color: AppColors.success,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Batch Results',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${results.length} texts analyzed successfully',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _exportResults(results),
                      icon: const Icon(Icons.download),
                      color: AppColors.primary,
                      tooltip: 'Export results',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: EmotionUtils.getEmotionColor(
                          result.emotion,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: EmotionUtils.getEmotionColor(
                            result.emotion,
                          ).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: EmotionUtils.getEmotionColor(
                                result.emotion,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              EmotionUtils.getEmotionIcon(result.emotion),
                              color: EmotionUtils.getEmotionColor(
                                result.emotion,
                              ),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Text ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  result.emotion.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: EmotionUtils.getEmotionColor(
                                      result.emotion,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${(result.confidence * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _exportResults(List<dynamic> results) {
    // Mock export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
