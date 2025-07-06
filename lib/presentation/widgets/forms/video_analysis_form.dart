import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/video_analysis/video_analysis_cubit.dart';

class VideoAnalysisForm extends StatefulWidget {
  const VideoAnalysisForm({super.key});

  @override
  State<VideoAnalysisForm> createState() => _VideoAnalysisFormState();
}

class _VideoAnalysisFormState extends State<VideoAnalysisForm> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  int _frameInterval = 30;
  int _maxFrames = 100;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasAbsolutePath;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Video URL',
                  hintText: 'Enter the URL of the video to analyze',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a video URL';
                  }
                  if (!_isValidUrl(value)) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _frameInterval.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Frame Interval',
                        hintText: 'Analyze every Nth frame',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final interval = int.tryParse(value);
                        if (interval == null || interval < 1) {
                          return 'Must be > 0';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        final interval = int.tryParse(value);
                        if (interval != null && interval > 0) {
                          setState(() => _frameInterval = interval);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _maxFrames.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Max Frames',
                        hintText: 'Maximum frames to analyze',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final frames = int.tryParse(value);
                        if (frames == null || frames < 1) {
                          return 'Must be > 0';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        final frames = int.tryParse(value);
                        if (frames != null && frames > 0) {
                          setState(() => _maxFrames = frames);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.read<VideoAnalysisCubit>().analyzeVideo(
                      videoUrl: _urlController.text,
                      frameInterval: _frameInterval,
                      maxFrames: _maxFrames,
                    );
                  }
                },
                child: const Text('Analyze Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
