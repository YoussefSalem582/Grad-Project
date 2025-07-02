import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ModernTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final bool showCounter;

  const ModernTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.showCounter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: enabled ? Colors.white : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null
                  ? AppColors.error
                  : Colors.grey.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            maxLength: maxLength,
            enabled: enabled,
            focusNode: focusNode,
            textInputAction: textInputAction,
            onEditingComplete: onEditingComplete,
            onSubmitted: onSubmitted,
            textCapitalization: textCapitalization,
            autofocus: autofocus,
            style: TextStyle(
              fontSize: 16,
              color: enabled ? Colors.black87 : Colors.grey,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.withOpacity(0.7),
                fontSize: 16,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.grey, size: 20)
                  : null,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(suffixIcon, color: Colors.grey, size: 20),
                      onPressed: onSuffixIconPressed,
                    )
                  : null,
              counterText: showCounter ? null : '',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(fontSize: 12, color: AppColors.error),
          ),
        ],
      ],
    );
  }
}
