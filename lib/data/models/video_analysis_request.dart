class VideoAnalysisRequest {
  final String videoUrl;
  final int frameInterval;
  final int maxFrames;

  VideoAnalysisRequest({
    required this.videoUrl,
    this.frameInterval = 30, // Default: analyze every 30th frame
    this.maxFrames = 100, // Default: analyze up to 100 frames
  });

  Map<String, dynamic> toJson() {
    return {
      'video_url': videoUrl,
      'frame_interval': frameInterval,
      'max_frames': maxFrames,
    };
  }
}
