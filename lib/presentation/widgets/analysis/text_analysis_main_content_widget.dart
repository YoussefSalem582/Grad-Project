import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../../core/constants/text_templates.dart' as core_templates;
import '../../cubit/text_analysis/text_analysis_cubit.dart';
import '../../services/text_analysis_actions_handler.dart';
import 'analysis.dart';

/// Main scrollable content widget for the Enhanced Text Analysis screen
///
/// Contains all the main sections: header, settings, input, templates,
/// results, quick actions, and history in a CustomScrollView.
class TextAnalysisMainContentWidget extends StatefulWidget {
  final TextAnalysisState state;

  const TextAnalysisMainContentWidget({super.key, required this.state});

  @override
  State<TextAnalysisMainContentWidget> createState() =>
      _TextAnalysisMainContentWidgetState();
}

class _TextAnalysisMainContentWidgetState
    extends State<TextAnalysisMainContentWidget> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  String _selectedAnalysisType = TextAnalysisConstants.defaultAnalysisType;

  late TextAnalysisActionsHandler _actionsHandler;

  @override
  void initState() {
    super.initState();
    _textFocusNode.addListener(_onFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _actionsHandler = TextAnalysisActionsHandler(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return CustomScrollView(
      slivers: [
        // Header Section
        const SliverToBoxAdapter(child: EnhancedTextAnalysisHeaderWidget()),

        // Settings Section
        _buildSettingsSection(),

        // Input Section
        _buildInputSection(),

        // Templates Section
        _buildTemplatesSection(),

        // Results Section
        if (widget.state is TextAnalysisSuccess ||
            widget.state is TextAnalysisDemo)
          _buildResultsSection(),

        // Quick Actions Section
        _buildQuickActionsSection(customSpacing),

        // History Section
        _buildHistorySection(customSpacing),

        // Bottom spacing
        SliverToBoxAdapter(child: SizedBox(height: customSpacing.xl)),
      ],
    );
  }

  /// Build the settings section
  Widget _buildSettingsSection() {
    return SliverToBoxAdapter(
      child: TextAnalysisSettingsWidget(
        selectedAnalysisType: _selectedAnalysisType,
        analysisTypes: TextAnalysisConstants.analysisTypes,
        onAnalysisTypeChanged: (type) {
          setState(() {
            _selectedAnalysisType = type;
          });
        },
      ),
    );
  }

  /// Build the input section
  Widget _buildInputSection() {
    return SliverToBoxAdapter(
      child: TextInputWidget(
        textController: _textController,
        isAnalyzing: widget.state is TextAnalysisLoading,
        selectedAnalysisType: _selectedAnalysisType,
        analysisTypes: TextAnalysisConstants.analysisTypes,
        onAnalysisTypeChanged: (type) {
          setState(() {
            _selectedAnalysisType = type;
          });
        },
        onAnalyze: _analyzeText,
        onClear: _clearAnalysis,
        analysisResult:
            widget.state is TextAnalysisSuccess
                ? (widget.state as TextAnalysisSuccess).result.toMap()
                : widget.state is TextAnalysisDemo
                ? (widget.state as TextAnalysisDemo).demoResult.toMap()
                : null,
      ),
    );
  }

  /// Build the templates section
  Widget _buildTemplatesSection() {
    return SliverToBoxAdapter(
      child: TextTemplatesWidget(
        templates: core_templates.DefaultTextTemplates.all,
        onTemplateSelected: _useTemplate,
      ),
    );
  }

  /// Build the results section
  Widget _buildResultsSection() {
    final state = widget.state;

    return SliverToBoxAdapter(
      child: TextAnalysisResultWidget(
        result:
            state is TextAnalysisSuccess
                ? state.result.toMap()
                : (state as TextAnalysisDemo).demoResult.toMap(),
        isLoading: false,
        analysisType: _selectedAnalysisType,
        onRetry: _analyzeText,
        onShare:
            () => _actionsHandler.shareResult(
              text: _textController.text,
              result:
                  state is TextAnalysisSuccess
                      ? state.result.toMap()
                      : (state as TextAnalysisDemo).demoResult.toMap(),
            ),
        onSave:
            () => _actionsHandler.saveResult(
              text: _textController.text,
              result:
                  state is TextAnalysisSuccess
                      ? state.result.toMap()
                      : (state as TextAnalysisDemo).demoResult.toMap(),
            ),
      ),
    );
  }

  /// Build the quick actions section
  Widget _buildQuickActionsSection(CustomSpacing customSpacing) {
    final quickActions = TextAnalysisConstants.getQuickActions(
      onBatchProcessing: () => _actionsHandler.navigateToBatchProcessing(),
      onExportResults: () => _actionsHandler.exportResults(),
      onCompareTexts: () => _actionsHandler.compareTexts(),
      onSettings: () => _actionsHandler.navigateToSettings(),
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(customSpacing.md),
        child: AnalysisQuickActionsWidget(actions: quickActions),
      ),
    );
  }

  /// Build the history section
  Widget _buildHistorySection(CustomSpacing customSpacing) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(customSpacing.md),
        child: AnalysisHistoryWidget(
          historyItems: TextAnalysisConstants.sampleHistory,
          onItemTap: _showHistoryDetails,
        ),
      ),
    );
  }

  /// Analyze the text
  Future<void> _analyzeText() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Please enter some text to analyze'),
            ],
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    context.read<TextAnalysisCubit>().analyzeText(
      text: _textController.text.trim(),
      analysisType: _selectedAnalysisType,
    );
  }

  /// Clear the analysis
  void _clearAnalysis() {
    _textController.clear();
    context.read<TextAnalysisCubit>().clearAnalysis();
  }

  /// Use a template
  void _useTemplate(String content) {
    _textController.text = content;
    // Auto-focus the text field after template selection
    _textFocusNode.requestFocus();
  }

  /// Show history details
  void _showHistoryDetails(dynamic item) {
    setState(() {
      _selectedAnalysisType = item.type;
    });
    // Load this item's result in the cubit
    context.read<TextAnalysisCubit>().loadDemoData(item.type);
  }
}
