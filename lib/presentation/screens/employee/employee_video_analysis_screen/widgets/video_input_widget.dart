import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/core.dart';

/// Video input widget supporting both URL and file upload
class VideoInputWidget extends StatefulWidget {
  final TextEditingController urlController;
  final FocusNode urlFocusNode;
  final Animation<double> animation;
  final VoidCallback onChanged;
  final Function(File)? onFileSelected;
  final File? selectedFile;

  const VideoInputWidget({
    super.key,
    required this.urlController,
    required this.urlFocusNode,
    required this.animation,
    required this.onChanged,
    this.onFileSelected,
    this.selectedFile,
  });

  @override
  State<VideoInputWidget> createState() => _VideoInputWidgetState();
}

class _VideoInputWidgetState extends State<VideoInputWidget> {
  bool _isUrlInput = true;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.animation,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with toggle buttons
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.video_collection_rounded,
                    color: Color(0xFF667EEA),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Video Source',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                // Toggle buttons
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildToggleButton(
                        'URL',
                        Icons.link_rounded,
                        _isUrlInput,
                        () => setState(() => _isUrlInput = true),
                      ),
                      _buildToggleButton(
                        'File',
                        Icons.upload_file_rounded,
                        !_isUrlInput,
                        () => setState(() => _isUrlInput = false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Input area
            if (_isUrlInput) _buildUrlInput() else _buildFileInput(),
            
            const SizedBox(height: 10),
            
            // Info text
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _isUrlInput
                        ? 'Enter video URL from YouTube, Vimeo, or direct links'
                        : kIsWeb
                            ? 'File upload is not supported on web. Use URL input instead.'
                            : 'Upload video files from your device (MP4, AVI, MOV)',
                    style: TextStyle(
                      fontSize: 12,
                      color: kIsWeb && !_isUrlInput
                          ? Colors.orange
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF667EEA) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlInput() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: widget.urlFocusNode.hasFocus
            ? const Color(0xFF667EEA).withValues(alpha: 0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.urlFocusNode.hasFocus
              ? const Color(0xFF667EEA)
              : AppColors.border.withValues(alpha: 0.5),
          width: widget.urlFocusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: widget.urlController,
        focusNode: widget.urlFocusNode,
        decoration: InputDecoration(
          hintText: 'Enter video URL (YouTube, Vimeo, etc.)',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontSize: 14,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.link_rounded,
            color: widget.urlFocusNode.hasFocus
                ? const Color(0xFF667EEA)
                : AppColors.textSecondary,
            size: 20,
          ),
          suffixIcon: widget.urlController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    widget.urlController.clear();
                    widget.onChanged();
                  },
                  child: const Icon(
                    Icons.clear_rounded,
                    color: AppColors.textSecondary,
                  ),
                )
              : null,
        ),
        onChanged: (value) => widget.onChanged(),
      ),
    );
  }

  Widget _buildFileInput() {
    final isWebUnsupported = kIsWeb;
    
    return GestureDetector(
      onTap: isWebUnsupported ? null : _pickVideoFile,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isWebUnsupported
              ? Colors.grey.withValues(alpha: 0.1)
              : widget.selectedFile != null
                  ? const Color(0xFF667EEA).withValues(alpha: 0.05)
                  : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isWebUnsupported
                ? Colors.grey.withValues(alpha: 0.3)
                : widget.selectedFile != null
                    ? const Color(0xFF667EEA)
                    : AppColors.border.withValues(alpha: 0.5),
            width: widget.selectedFile != null ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isWebUnsupported
                  ? Icons.warning_rounded
                  : widget.selectedFile != null
                      ? Icons.video_file_rounded
                      : Icons.upload_file_rounded,
              color: isWebUnsupported
                  ? Colors.orange
                  : widget.selectedFile != null
                      ? const Color(0xFF667EEA)
                      : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isWebUnsupported
                        ? 'File upload not supported on web'
                        : widget.selectedFile != null
                            ? _getFileName(widget.selectedFile!)
                            : 'Tap to select video file',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: widget.selectedFile != null
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: isWebUnsupported
                          ? Colors.orange
                          : widget.selectedFile != null
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                    ),
                  ),
                  if (widget.selectedFile != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _getFileSize(widget.selectedFile!),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.selectedFile != null && !isWebUnsupported)
              GestureDetector(
                onTap: () {
                  widget.onFileSelected?.call(File(''));
                  widget.onChanged();
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickVideoFile() async {
    try {
      HapticFeedback.lightImpact();
      
      // Check if we're on web platform
      if (kIsWeb) {
        // For web, show a message that file upload isn't supported
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File upload is not supported on web. Please use URL input instead.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
      
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        widget.onFileSelected?.call(file);
        widget.onChanged();
        HapticFeedback.selectionClick();
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking video file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getFileName(File file) {
    return file.path.split('/').last;
  }

  String _getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}
