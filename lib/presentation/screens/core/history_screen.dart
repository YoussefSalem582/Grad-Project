import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/core.dart';
import '../../providers/providers.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Joy',
    'Sadness',
    'Anger',
    'Fear',
    'Surprise',
    'Disgust',
    'Neutral',
  ];

  // Mock history data - in real app this would come from local storage/database
  final List<HistoryItem> _historyItems = [
    HistoryItem(
      id: '1',
      text: 'I am so happy today!',
      emotion: 'joy',
      confidence: 0.95,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    HistoryItem(
      id: '2',
      text: 'This weather makes me feel sad',
      emotion: 'sadness',
      confidence: 0.87,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    HistoryItem(
      id: '3',
      text: 'I cannot believe this happened!',
      emotion: 'surprise',
      confidence: 0.92,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    HistoryItem(
      id: '4',
      text: 'This is absolutely frustrating',
      emotion: 'anger',
      confidence: 0.89,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    HistoryItem(
      id: '5',
      text: 'The presentation went well',
      emotion: 'joy',
      confidence: 0.78,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HistoryItem> get _filteredItems {
    List<HistoryItem> filtered = _historyItems;

    // Apply emotion filter
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where(
            (item) =>
                item.emotion.toLowerCase() == _selectedFilter.toLowerCase(),
          )
          .toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where(
            (item) => item.text.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildFilterSection(),
              Expanded(child: _buildHistoryList()),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analysis History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_filteredItems.length} results found',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showExportDialog,
            icon: const Icon(
              Icons.file_download,
              color: Colors.white,
              size: 24,
            ),
            tooltip: 'Export History',
          ),
          IconButton(
            onPressed: _clearHistory,
            icon: const Icon(Icons.delete_sweep, color: Colors.white, size: 24),
            tooltip: 'Clear History',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() {}),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search your analysis history...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? filter : 'All';
                      });
                    },
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    selectedColor: Colors.white.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.8),
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
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
        child: _filteredItems.isEmpty
            ? _buildEmptyState()
            : _buildHistoryItems(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty
                ? 'No matching results'
                : 'No analysis history yet',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Start analyzing emotions to build your history',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItems() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildHistoryCard(item, index);
      },
    );
  }

  Widget _buildHistoryCard(HistoryItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                EmotionUtils.getEmotionColor(item.emotion).withValues(alpha: 0.1),
                AppColors.surface,
              ],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showDetailDialog(item),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: EmotionUtils.getEmotionColor(
                              item.emotion,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            EmotionUtils.getEmotionIcon(item.emotion),
                            color: EmotionUtils.getEmotionColor(item.emotion),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.emotion.toUpperCase(),
                                style: TextStyle(
                                  color: EmotionUtils.getEmotionColor(
                                    item.emotion,
                                  ),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${(item.confidence * 100).toStringAsFixed(1)}% confidence',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _formatTimestamp(item.timestamp),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.text,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: item.confidence,
                      backgroundColor: EmotionUtils.getEmotionColor(
                        item.emotion,
                      ).withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        EmotionUtils.getEmotionColor(item.emotion),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(HistoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              EmotionUtils.getEmotionIcon(item.emotion),
              color: EmotionUtils.getEmotionColor(item.emotion),
            ),
            const SizedBox(width: 8),
            Text(item.emotion.toUpperCase()),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Text Analyzed:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(item.text),
            const SizedBox(height: 16),
            Text(
              'Confidence: ${(item.confidence * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Analyzed: ${_formatFullTimestamp(item.timestamp)}',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _reAnalyze(item.text);
            },
            child: const Text('Re-analyze'),
          ),
        ],
      ),
    );
  }

  void _reAnalyze(String text) {
    final provider = context.read<EmotionProvider>();
    provider.analyzeEmotion(text);
    Navigator.pop(context); // Go back to main screen
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export History'),
        content: const Text(
          'Export your analysis history as CSV or JSON file?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exportAsCSV();
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exportAsJSON();
            },
            child: const Text('JSON'),
          ),
        ],
      ),
    );
  }

  void _exportAsCSV() {
    // Mock export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV export feature coming soon!')),
    );
  }

  void _exportAsJSON() {
    // Mock export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('JSON export feature coming soon!')),
    );
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to clear all analysis history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _historyItems.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History cleared successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatFullTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} at ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class HistoryItem {
  final String id;
  final String text;
  final String emotion;
  final double confidence;
  final DateTime timestamp;

  HistoryItem({
    required this.id,
    required this.text,
    required this.emotion,
    required this.confidence,
    required this.timestamp,
  });
}

