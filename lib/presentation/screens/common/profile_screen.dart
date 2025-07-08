import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// A comprehensive profile screen with editable sections
class ProfileScreen extends StatefulWidget {
  final String title;
  final ProfileData profileData;
  final List<ProfileSection> sections;
  final VoidCallback? onSave;
  final VoidCallback? onBack;
  final bool showBackButton;
  final bool isEditable;

  const ProfileScreen({
    super.key,
    this.title = 'Profile',
    required this.profileData,
    required this.sections,
    this.onSave,
    this.onBack,
    this.showBackButton = true,
    this.isEditable = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isEditing = false;
  bool _hasChanges = false;

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

  void _toggleEdit() {
    if (_isEditing && _hasChanges) {
      _showSaveDialog();
    } else {
      setState(() {
        _isEditing = !_isEditing;
        _hasChanges = false;
      });
    }
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Changes'),
        content: const Text('Do you want to save your changes?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isEditing = false;
                _hasChanges = false;
              });
            },
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveChanges();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    if (widget.onSave != null) {
      widget.onSave!();
    }
    setState(() {
      _isEditing = false;
      _hasChanges = false;
    });
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
          if (widget.isEditable) ...[
            IconButton(
              icon: Icon(_isEditing ? Icons.check : Icons.edit),
              onPressed: _toggleEdit,
            ),
          ],
        ],
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
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          _buildProfileSections(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          // Profile picture
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainer,
                  border: Border.all(color: AppColors.border, width: 2),
                ),
                child: widget.profileData.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          widget.profileData.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        ),
                      )
                    : _buildDefaultAvatar(),
              ),
              
              if (_isEditing) ...[
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Name
          Text(
            widget.profileData.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Email or subtitle
          if (widget.profileData.email != null) ...[
            Text(
              widget.profileData.email!,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          
          const SizedBox(height: 8),
          
          // Status or role
          if (widget.profileData.role != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.profileData.role!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return const Icon(
      Icons.person,
      size: 50,
      color: AppColors.textSecondary,
    );
  }

  Widget _buildProfileSections() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: widget.sections.length,
      itemBuilder: (context, index) {
        final section = widget.sections[index];
        return _buildSection(section, index);
      },
    );
  }

  Widget _buildSection(ProfileSection section, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index > 0) const SizedBox(height: 24),
        
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
              
              return _buildProfileItem(item, isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(ProfileItem item, bool isLast) {
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
        subtitle: item.value != null
            ? Text(
                item.value!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: _isEditing && item.isEditable
            ? const Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              )
            : null,
        onTap: (_isEditing && item.isEditable) || item.onTap != null
            ? () {
                HapticFeedback.selectionClick();
                if (item.onTap != null) {
                  item.onTap!();
                } else if (_isEditing) {
                  // Handle edit action
                  setState(() {
                    _hasChanges = true;
                  });
                }
              }
            : null,
      ),
    );
  }
}

/// Model classes for profile
class ProfileData {
  final String name;
  final String? email;
  final String? role;
  final String? avatarUrl;
  final String? phone;
  final String? location;

  const ProfileData({
    required this.name,
    this.email,
    this.role,
    this.avatarUrl,
    this.phone,
    this.location,
  });
}

class ProfileSection {
  final String? title;
  final List<ProfileItem> items;

  const ProfileSection({
    this.title,
    required this.items,
  });
}

class ProfileItem {
  final String title;
  final String? value;
  final IconData? icon;
  final Color? iconColor;
  final bool isEditable;
  final VoidCallback? onTap;

  const ProfileItem({
    required this.title,
    this.value,
    this.icon,
    this.iconColor,
    this.isEditable = false,
    this.onTap,
  });
}
