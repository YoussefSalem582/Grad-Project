import 'package:flutter/material.dart';
import '../../../presentation/widgets/common/animated_loading_indicator.dart';

/// Demo screen to showcase EMO loading animations
class EmoLoadingDemo extends StatelessWidget {
  const EmoLoadingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMO Loading Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Emosense EMO Loading Indicators',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // Analysis loader
            Text(
              'Analysis Loader',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [EmoLoader.analysis()],
            ),
            SizedBox(height: 40),

            // Standard loader
            Text(
              'Standard Loader',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [EmoLoader.standard()],
            ),
            SizedBox(height: 40),

            // Mini loader
            Text(
              'Mini Loader',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [EmoLoader.mini()],
            ),
            SizedBox(height: 40),

            // Fade loader
            Text(
              'Fade Loader',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [EmoLoader.fade()],
            ),
            SizedBox(height: 40),

            // Rotate loader
            Text(
              'Rotate Loader',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [EmoLoader.rotate()],
            ),
            SizedBox(height: 40),

            // Custom EmoLoadingIndicator examples
            Text(
              'Custom Styles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Bounce', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 8),
                    EmoLoadingIndicator(
                      size: 60,
                      animationStyle: EmoAnimationStyle.bounce,
                      color: Colors.blue,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Wave', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 8),
                    EmoLoadingIndicator(
                      size: 60,
                      animationStyle: EmoAnimationStyle.wave,
                      color: Colors.teal,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Pulse', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 8),
                    EmoLoadingIndicator(
                      size: 60,
                      animationStyle: EmoAnimationStyle.pulse,
                      color: Colors.purple,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Rotate', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 8),
                    EmoLoadingIndicator(
                      size: 60,
                      animationStyle: EmoAnimationStyle.rotate,
                      color: Colors.green,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Fade', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 8),
                    EmoLoadingIndicator(
                      size: 60,
                      animationStyle: EmoAnimationStyle.fade,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
