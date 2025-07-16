import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart' as di;
import '../../../cubit/text_analysis/text_analysis_cubit.dart';
import '../../../widgets/common/animated_background_widget.dart';
import '../../../widgets/common/animated_loading_indicator.dart';
import 'widgets/widgets.dart';

/// Unified Text Analysis Screen - Modularized with Widgets
///
/// Comprehensive text analysis interface supporting:
/// - YouTube Comments Analysis
/// - Amazon Product Reviews Analysis
/// - General Text Analysis
/// - Social Media Posts Analysis
class UnifiedTextAnalysisScreen extends StatefulWidget {
  const UnifiedTextAnalysisScreen({super.key});

  @override
  State<UnifiedTextAnalysisScreen> createState() =>
      _UnifiedTextAnalysisScreenState();
}

class _UnifiedTextAnalysisScreenState extends State<UnifiedTextAnalysisScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final FocusNode _urlFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _backgroundAnimation;

  final String _selectedAnalysisType = 'Sentiment Analysis';
  String _selectedSourceType = 'Direct Text';

  final List<String> _sourceTypes = [
    'Direct Text',
    'YouTube Comments',
    'Amazon Reviews',
    'Social Media Posts',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _textFocusNode.addListener(_onFocusChanged);
    _urlFocusNode.addListener(_onFocusChanged);
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    // Only keep background animation, remove fade and slide animations for content
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  void _onFocusChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _urlController.dispose();
    _textFocusNode.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<TextAnalysisCubit>(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            // Animated Background
            AnimatedBackgroundWidget(animation: _backgroundAnimation),
            // Content
            BlocBuilder<TextAnalysisCubit, TextAnalysisState>(
              builder: (context, state) {
                return _buildBody(context, state);
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Text Analysis Hub',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TextAnalysisState state) {
    final bool isAnalyzing = state is TextAnalysisLoading;
    final bool hasText = _textController.text.trim().isNotEmpty;
    final bool hasResults =
        state is TextAnalysisSuccess || state is TextAnalysisDemo;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + kToolbarHeight + 16,
        16,
        16,
      ),
      child: Column(
        children: [
          // Mode Selector Widget
          TextAnalysisModeSelector(
            selectedSourceType: _selectedSourceType,
            sourceTypes: _sourceTypes,
            onSourceTypeChanged: (type) {
              setState(() {
                _selectedSourceType = type;
                _textController.clear();
                _urlController.clear();
              });
            },
          ),
          const SizedBox(height: 16),

          // Input Section Widget (conditional)
          if (_selectedSourceType == 'Direct Text')
            TextAnalysisInputSection(
              textController: _textController,
              textFocusNode: _textFocusNode,
              selectedSourceType: _selectedSourceType,
            ),

          // URL Section Widget (conditional)
          if (_selectedSourceType != 'Direct Text') ...[
            TextAnalysisUrlSection(
              urlController: _urlController,
              urlFocusNode: _urlFocusNode,
              selectedSourceType: _selectedSourceType,
            ),
            const SizedBox(height: 16),
            TextAnalysisInputSection(
              textController: _textController,
              textFocusNode: _textFocusNode,
              selectedSourceType: _selectedSourceType,
            ),
          ],

          const SizedBox(height: 16),

          // Sample Texts Widget
          TextAnalysisSamplesSection(
            selectedSourceType: _selectedSourceType,
            onSampleTapped: (text) {
              setState(() {
                _textController.text = text;
              });
            },
          ),
          const SizedBox(height: 16),

          // Action Buttons Widget
          TextAnalysisActionButtons(
            isAnalyzing: isAnalyzing,
            hasText: hasText,
            selectedSourceType: _selectedSourceType,
            onAnalyze: () => _performAnalysis(context),
            onClear: () => _clearInputs(),
            onImportFromUrl:
                _selectedSourceType != 'Direct Text'
                    ? () => _importFromUrl(context)
                    : null,
          ),
          const SizedBox(height: 24),

          // Show loading indicator when analyzing
          if (isAnalyzing)
            Column(
              children: [
                EmoLoader.analysis(),
                const SizedBox(height: 16),
                Text(
                  'Analyzing your text...',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),

          const SizedBox(height: 24),

          // Results Display Widget
          if (hasResults)
            TextAnalysisResultsDisplay(
              hasResults: hasResults,
              analysisResults: _getAnalysisResultsMap(state),
              selectedAnalysisType: _selectedAnalysisType,
            ),
        ],
      ),
    );
  }

  void _performAnalysis(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    context.read<TextAnalysisCubit>().analyzeText(
      text: text,
      analysisType: _selectedAnalysisType,
    );
  }

  Map<String, dynamic>? _getAnalysisResultsMap(TextAnalysisState state) {
    if (state is TextAnalysisSuccess) {
      final result = state.result;
      return {
        'sentiment': _getPrimarySentiment(result.sentiments),
        'confidence': result.confidence,
        'emotions': result.sentiments,
        'topics': result.keywords,
        'insights': result.details,
      };
    } else if (state is TextAnalysisDemo) {
      final result = state.demoResult;
      return {
        'sentiment': _getPrimarySentiment(result.sentiments),
        'confidence': result.confidence,
        'emotions': result.sentiments,
        'topics': result.keywords,
        'insights': result.details,
      };
    }
    return null;
  }

  String _getPrimarySentiment(Map<String, double> sentiments) {
    if (sentiments.isEmpty) return 'neutral';

    final entry = sentiments.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    return entry.key;
  }

  void _clearInputs() {
    setState(() {
      _textController.clear();
      _urlController.clear();
    });
  }

  void _importFromUrl(BuildContext context) {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      _showSnackBar(context, 'Please enter a URL first');
      return;
    }

    // Mock URL import functionality
    String mockImportedText = '';

    if (_selectedSourceType == 'YouTube Comments') {
      mockImportedText = '''Amazing video! Thanks for sharing.
      
User1: Great explanation! Really helpful 👍
User2: This is exactly what I was looking for
User3: Could you make a tutorial on this topic?
User4: Subscribed! Keep up the great work
User5: The production quality has improved a lot''';
    } else if (_selectedSourceType == 'Amazon Reviews') {
      mockImportedText = '''⭐⭐⭐⭐⭐ Excellent product!

Review 1: Fast delivery and great packaging. The product works as described.
Review 2: Good value for money. Would recommend to others.
Review 3: Quality is better than expected. Very satisfied with purchase.
Review 4: Customer service was helpful when I had questions.
Review 5: Will definitely buy again. Great experience overall.''';
    } else {
      mockImportedText = '''Great experience overall! The service was excellent.
Really impressed with the quality and attention to detail.
Will definitely recommend to friends and family.
Some minor issues but nothing major.
Looking forward to using this service again.''';
    }

    setState(() {
      _textController.text = mockImportedText;
    });

    _showSnackBar(context, 'Content imported successfully!');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
