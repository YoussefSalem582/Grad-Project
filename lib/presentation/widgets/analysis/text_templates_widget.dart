import 'package:flutter/material.dart';
import '../../../core/core.dart';

class TextTemplatesWidget extends StatelessWidget {
  final List<TextTemplate> templates;
  final Function(String) onTemplateSelected;
  final String? selectedCategory;
  final Function(String)? onCategoryChanged;

  const TextTemplatesWidget({
    super.key,
    required this.templates,
    required this.onTemplateSelected,
    this.selectedCategory,
    this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    // Group templates by category
    final groupedTemplates = <String, List<TextTemplate>>{};
    for (final template in templates) {
      groupedTemplates
          .putIfAbsent(template.category.name, () => [])
          .add(template);
    }

    final categories = groupedTemplates.keys.toList();
    final displayTemplates = selectedCategory != null
        ? groupedTemplates[selectedCategory] ?? []
        : templates;

    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      padding: EdgeInsets.all(customSpacing.lg),
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
              Container(
                padding: EdgeInsets.all(customSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.text_snippet,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text Templates',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: customSpacing.xs),
                    Text(
                      'Quick-start with pre-made text samples',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // View All Button
              if (categories.length > 1)
                TextButton(
                  onPressed: () => _showAllTemplates(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: customSpacing.md,
                      vertical: customSpacing.sm,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View All'),
                      SizedBox(width: customSpacing.xs),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
            ],
          ),

          SizedBox(height: customSpacing.lg),

          // Category Filter
          if (categories.length > 1 && onCategoryChanged != null)
            _buildCategoryFilter(categories, theme, customSpacing),

          SizedBox(height: customSpacing.md),

          // Templates Grid
          _buildTemplatesGrid(displayTemplates, theme, customSpacing),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(
    List<String> categories,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip(
                'All',
                selectedCategory == null,
                theme,
                spacing,
                () => onCategoryChanged?.call(''),
              ),
              SizedBox(width: spacing.sm),
              ...categories.map((category) {
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: EdgeInsets.only(right: spacing.sm),
                  child: _buildCategoryChip(
                    category,
                    isSelected,
                    theme,
                    spacing,
                    () => onCategoryChanged?.call(category),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        SizedBox(height: spacing.lg),
      ],
    );
  }

  Widget _buildCategoryChip(
    String label,
    bool isSelected,
    ThemeData theme,
    CustomSpacing spacing,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.2),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTemplatesGrid(
    List<TextTemplate> displayTemplates,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacing.md,
        mainAxisSpacing: spacing.md,
        childAspectRatio: 1.1,
      ),
      itemCount: displayTemplates.length > 6 ? 6 : displayTemplates.length,
      itemBuilder: (context, index) {
        final template = displayTemplates[index];
        return _buildTemplateCard(template, theme, spacing);
      },
    );
  }

  Widget _buildTemplateCard(
    TextTemplate template,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return GestureDetector(
      onTap: () => onTemplateSelected(template.content),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  template.category.color,
                  template.category.color.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  top: -20,
                  right: -20,
                  child: Icon(
                    template.category.icon,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.sm,
                          vertical: spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              template.category.icon,
                              size: 12,
                              color: template.category.color,
                            ),
                            SizedBox(width: spacing.xs),
                            Text(
                              template.category.name,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: template.category.color,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Template content preview
                      Text(
                        template.content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: spacing.sm),

                      // Use button
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.sm,
                              vertical: spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Use',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: template.category.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: spacing.xs),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 12,
                                  color: template.category.color,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAllTemplates(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AllTemplatesBottomSheet(
        templates: templates,
        onTemplateSelected: onTemplateSelected,
      ),
    );
  }
}

class _AllTemplatesBottomSheet extends StatefulWidget {
  final List<TextTemplate> templates;
  final Function(String) onTemplateSelected;

  const _AllTemplatesBottomSheet({
    required this.templates,
    required this.onTemplateSelected,
  });

  @override
  State<_AllTemplatesBottomSheet> createState() =>
      _AllTemplatesBottomSheetState();
}

class _AllTemplatesBottomSheetState extends State<_AllTemplatesBottomSheet> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    final groupedTemplates = <String, List<TextTemplate>>{};
    for (final template in widget.templates) {
      groupedTemplates
          .putIfAbsent(template.category.name, () => [])
          .add(template);
    }

    final categories = groupedTemplates.keys.toList();
    final displayTemplates = selectedCategory != null
        ? groupedTemplates[selectedCategory] ?? []
        : widget.templates;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: customSpacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(customSpacing.lg),
            child: Row(
              children: [
                Text(
                  'Text Templates',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Category Filter
          if (categories.length > 1)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('All', selectedCategory == null),
                    SizedBox(width: customSpacing.sm),
                    ...categories.map((category) {
                      final isSelected = selectedCategory == category;
                      return Padding(
                        padding: EdgeInsets.only(right: customSpacing.sm),
                        child: _buildCategoryChip(category, isSelected),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

          SizedBox(height: customSpacing.md),

          // Templates List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
              itemCount: displayTemplates.length,
              itemBuilder: (context, index) {
                final template = displayTemplates[index];
                return _buildTemplateListItem(template, theme, customSpacing);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = isSelected
              ? null
              : (label == 'All' ? null : label);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: customSpacing.md,
          vertical: customSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateListItem(
    TextTemplate template,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(spacing.md),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: template.category.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            template.category.icon,
            color: template.category.color,
            size: 24,
          ),
        ),
        title: Text(
          template.content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: spacing.sm),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.xs,
            ),
            decoration: BoxDecoration(
              color: template.category.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              template.category.name,
              style: theme.textTheme.bodySmall?.copyWith(
                color: template.category.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            widget.onTemplateSelected(template.content);
            Navigator.pop(context);
          },
          icon: Icon(Icons.add_circle, color: AppColors.primary, size: 32),
        ),
      ),
    );
  }
}
