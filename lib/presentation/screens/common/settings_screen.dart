import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// A comprehensive settings screen with organized sections
class SettingsScreen extends StatefulWidget {
  final String title;
  final List<SettingsSection> sections;
  final VoidCallback? onBack;
  final bool showBackButton;

  const SettingsScreen({
    super.key,
    this.title = 'Settings',
    required this.sections,
    this.onBack,
    this.showBackButton = true,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildContent(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.sections.length,
      itemBuilder: (context, index) {
        final section = widget.sections[index];
        return _buildSection(section, index);
      },
    );
  }

  Widget _buildSection(SettingsSection section, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index > 0) const SizedBox(height: 32),
        
        // Section header
        if (section.title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              section.title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
        
        // Section items
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: section.items.asMap().entries.map((entry) {
              final itemIndex = entry.key;
              final item = entry.value;
              final isLast = itemIndex == section.items.length - 1;
              
              return _buildSettingsItem(item, isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(SettingsItem item, bool isLast) {
    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? const Border(
                bottom: BorderSide(color: AppColors.border, width: 0.5),
              )
            : null,
      ),
      child: ListTile(
        leading: item.icon != null
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (item.iconColor ?? AppColors.primary)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  color: item.iconColor ?? AppColors.primary,
                  size: 20,
                ),
              )
            : null,
        title: Text(
          item.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: item.subtitle != null
            ? Text(
                item.subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: _buildTrailing(item),
        onTap: item.onTap != null
            ? () {
                HapticFeedback.selectionClick();
                item.onTap!();
              }
            : null,
      ),
    );
  }

  Widget? _buildTrailing(SettingsItem item) {
    switch (item.type) {
      case SettingsItemType.navigation:
        return const Icon(
          Icons.chevron_right,
          color: AppColors.textTertiary,
        );
        
      case SettingsItemType.toggle:
        return Switch(
          value: item.value ?? false,
          onChanged: item.onChanged != null
              ? (value) {
                  HapticFeedback.selectionClick();
                  item.onChanged!(value);
                }
              : null,
          activeColor: AppColors.primary,
        );
        
      case SettingsItemType.info:
        return item.trailingText != null
            ? Text(
                item.trailingText!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              )
            : null;
            
      case SettingsItemType.action:
        return item.trailingIcon != null
            ? Icon(
                item.trailingIcon,
                color: item.iconColor ?? AppColors.textTertiary,
              )
            : null;
    }
  }
}

/// Model classes for settings
class SettingsSection {
  final String? title;
  final List<SettingsItem> items;

  const SettingsSection({
    this.title,
    required this.items,
  });
}

class SettingsItem {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final SettingsItemType type;
  final VoidCallback? onTap;
  final Function(bool)? onChanged;
  final bool? value;
  final String? trailingText;
  final IconData? trailingIcon;

  const SettingsItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.type = SettingsItemType.navigation,
    this.onTap,
    this.onChanged,
    this.value,
    this.trailingText,
    this.trailingIcon,
  });

  // Factory constructors for common settings items
  factory SettingsItem.navigation({
    required String title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return SettingsItem(
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      type: SettingsItemType.navigation,
      onTap: onTap,
    );
  }

  factory SettingsItem.toggle({
    required String title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SettingsItem(
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      type: SettingsItemType.toggle,
      value: value,
      onChanged: onChanged,
    );
  }

  factory SettingsItem.info({
    required String title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    String? trailingText,
  }) {
    return SettingsItem(
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      type: SettingsItemType.info,
      trailingText: trailingText,
    );
  }

  factory SettingsItem.action({
    required String title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    IconData? trailingIcon,
    required VoidCallback onTap,
  }) {
    return SettingsItem(
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      type: SettingsItemType.action,
      trailingIcon: trailingIcon,
      onTap: onTap,
    );
  }
}

enum SettingsItemType {
  navigation,
  toggle,
  info,
  action,
}
