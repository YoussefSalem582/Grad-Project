import 'package:flutter/material.dart';
import 'text_analysis_about_dialog.dart';

/// App bar widget for the Enhanced Text Analysis screen
///
/// Provides a clean, transparent app bar with the title and
/// an info button that shows the about dialog.
class EnhancedTextAnalysisAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EnhancedTextAnalysisAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text('AI Text Analysis'),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => TextAnalysisAboutDialog.show(context),
          tooltip: 'About Text Analysis',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
