import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// A comprehensive search screen with filters and results
class SearchScreen extends StatefulWidget {
  final String title;
  final String hintText;
  final List<SearchFilter>? filters;
  final Future<List<dynamic>> Function(String query, Map<String, dynamic> filters)? onSearch;
  final Widget Function(BuildContext, dynamic)? itemBuilder;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final VoidCallback? onBack;
  final bool showBackButton;

  const SearchScreen({
    super.key,
    this.title = 'Search',
    this.hintText = 'Search...',
    this.filters,
    this.onSearch,
    this.itemBuilder,
    this.emptyWidget,
    this.loadingWidget,
    this.onBack,
    this.showBackButton = true,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  List<dynamic> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  Map<String, dynamic> _appliedFilters = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    if (widget.onSearch == null) return;
    
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _results.clear();
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final results = await widget.onSearch!(query, _appliedFilters);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _results.clear();
        _isLoading = false;
      });
    }
  }

  void _showFilters() {
    if (widget.filters == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFiltersSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack ?? () => Navigator.pop(context),
              )
            : null,
        actions: [
          if (widget.filters != null) ...[
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.filter_list),
                  if (_appliedFilters.isNotEmpty) ...[
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              onPressed: _showFilters,
            ),
          ],
        ],
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildSearchBar(),
                Expanded(child: _buildContent()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          filled: true,
          fillColor: AppColors.surfaceContainer,
        ),
        onChanged: (value) {
          setState(() {});
          // Optional: implement debounced search
          Future.delayed(const Duration(milliseconds: 500), () {
            if (_searchController.text == value) {
              _performSearch();
            }
          });
        },
        onSubmitted: (value) => _performSearch(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return widget.loadingWidget ??
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
    }

    if (!_hasSearched) {
      return _buildInitialState();
    }

    if (_results.isEmpty) {
      return widget.emptyWidget ?? _buildEmptyState();
    }

    return _buildResults();
  }

  Widget _buildInitialState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: AppColors.textTertiary,
          ),
          SizedBox(height: 16),
          Text(
            'Start typing to search',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textTertiary,
          ),
          SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final item = _results[index];
        if (widget.itemBuilder != null) {
          return widget.itemBuilder!(context, item);
        }
        return _buildDefaultItem(item);
      },
    );
  }

  Widget _buildDefaultItem(dynamic item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(item.toString()),
        onTap: () {
          HapticFeedback.selectionClick();
          // Handle item tap
        },
      ),
    );
  }

  Widget _buildFiltersSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _appliedFilters.clear();
                    });
                    _performSearch();
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Filters content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.filters?.length ?? 0,
              itemBuilder: (context, index) {
                final filter = widget.filters![index];
                return _buildFilterItem(filter);
              },
            ),
          ),
          
          // Apply button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _performSearch();
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(SearchFilter filter) {
    // Implementation depends on filter type
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            filter.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          // Filter options based on type
          // This would be expanded based on specific filter types
        ],
      ),
    );
  }
}

/// Model class for search filters
class SearchFilter {
  final String title;
  final String key;
  final SearchFilterType type;
  final List<String>? options;
  final String? selectedOption;
  final bool? isEnabled;

  const SearchFilter({
    required this.title,
    required this.key,
    required this.type,
    this.options,
    this.selectedOption,
    this.isEnabled,
  });
}

enum SearchFilterType {
  dropdown,
  checkbox,
  toggle,
  range,
}
