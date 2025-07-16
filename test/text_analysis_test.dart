import 'package:flutter_test/flutter_test.dart';
import 'package:emosense_app/data/services/emotion_api_service.dart';

void main() {
  group('Text Analysis Tests', () {
    late EmotionApiService apiService;

    setUp(() {
      apiService = EmotionApiService();
    });

    test('should analyze positive text correctly', () async {
      const text = 'I am so happy and excited about this amazing day!';

      final result = await apiService.predictEmotion(text);

      expect(result.emotion, equals('joy'));
      expect(result.sentiment, equals('positive'));
      expect(result.confidence, greaterThan(0.8));
    });

    test('should analyze negative text correctly', () async {
      const text = 'I am very sad and disappointed about this situation.';

      final result = await apiService.predictEmotion(text);

      expect(result.emotion, equals('sadness'));
      expect(result.sentiment, equals('negative'));
      expect(result.confidence, greaterThan(0.8));
    });

    test('should analyze neutral text correctly', () async {
      const text = 'The weather is okay today.';

      final result = await apiService.predictEmotion(text);

      expect(result.emotion, equals('neutral'));
      expect(result.sentiment, equals('neutral'));
      expect(result.confidence, greaterThan(0.7));
    });

    test('should handle angry text correctly', () async {
      const text = 'I am so angry and mad about this terrible service!';

      final result = await apiService.predictEmotion(text);

      expect(result.emotion, equals('anger'));
      expect(result.sentiment, equals('negative'));
      expect(result.confidence, greaterThan(0.8));
    });

    test('should provide all emotion scores', () async {
      const text = 'This is a test message.';

      final result = await apiService.predictEmotion(text);

      expect(result.allEmotions, isNotEmpty);
      expect(result.allEmotions.keys, contains(result.emotion));
      expect(result.processingTimeMs, isNotNull);
    });
  });
}
