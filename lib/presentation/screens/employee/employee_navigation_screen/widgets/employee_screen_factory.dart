import 'package:flutter/material.dart';
import '../../employee_dashboard_screen/employee_dashboard_screen.dart';
import '../../employee_profile_screen/employee_profile_screen.dart';
import '../../employee_tickets_screen/employee_tickets_screen.dart';
import '../../employee_video_analysis_screen/employee_video_analysis_screen.dart';
import '../../employee_analysis_tools_screen/employee_analysis_tools_screen.dart';
import '../../../analytics/customer_analytics_screen.dart';
import '../../../common/placeholder_screen.dart';

/// Factory class for managing employee screens with lazy loading and caching
class EmployeeScreenFactory {
  static final Map<int, Widget> _screenCache = {};
  static final Set<int> _preloadedScreens = {};

  /// Get screen by index with lazy loading and caching
  static Widget getScreen(int index, {Function(int)? onAnalysisToolSelected}) {
    // Return cached screen if available
    if (_screenCache.containsKey(index)) {
      return _screenCache[index]!;
    }

    // Create new screen and cache it
    Widget screen = _createScreen(index, onAnalysisToolSelected);
    _screenCache[index] = screen;
    return screen;
  }

  /// Preload essential screens for better performance
  static void preloadScreens(List<int> indices) {
    for (int index in indices) {
      if (!_preloadedScreens.contains(index) &&
          !_screenCache.containsKey(index)) {
        _screenCache[index] = _createScreen(index, null);
        _preloadedScreens.add(index);
      }
    }
  }

  /// Clear cache to free memory
  static void clearCache() {
    _screenCache.clear();
    _preloadedScreens.clear();
  }

  /// Remove specific screen from cache
  static void removeFromCache(int index) {
    _screenCache.remove(index);
    _preloadedScreens.remove(index);
  }

  /// Create screen instance
  static Widget _createScreen(
    int index,
    Function(int)? onAnalysisToolSelected,
  ) {
    switch (index) {
      case 0: // Dashboard
        return const EmployeeDashboardScreen();
      case 1: // Performance (placeholder)
        return _buildPerformanceScreen();
      case 2: // Customer Analytics
        return const CustomerAnalyticsScreen();
      case 3: // Profile
        return const EmployeeProfileScreen();
      case 4: // Tickets
        return const EmployeeTicketsScreen();
      case 5: // Analysis Tools
        return EmployeeAnalysisToolsScreen(
          onAnalysisToolSelected: onAnalysisToolSelected,
        );
      case 6: // Video Analysis
        return const EmployeeVideoAnalysisScreen();
      case 7: // Text Analysis (placeholder for navigation)
        return _buildTextAnalysisPlaceholder();
      case 8: // Voice Analysis (placeholder for navigation)
        return _buildVoiceAnalysisPlaceholder();
      default:
        return _buildPlaceholderScreen(index);
    }
  }

  /// Build performance screen placeholder
  static Widget _buildPerformanceScreen() {
    return const PlaceholderScreen(
      title: 'Performance Analytics',
      description: 'Track your performance metrics and goals',
      icon: Icons.trending_up,
      comingSoon: true,
    );
  }

  /// Build text analysis placeholder
  static Widget _buildTextAnalysisPlaceholder() {
    return const PlaceholderScreen(
      title: 'Text Analysis',
      description: 'Navigate via Analysis Tools for text analysis features',
      icon: Icons.text_fields,
      comingSoon: false,
    );
  }

  /// Build voice analysis placeholder
  static Widget _buildVoiceAnalysisPlaceholder() {
    return const PlaceholderScreen(
      title: 'Voice Analysis',
      description: 'Navigate via Analysis Tools for voice analysis features',
      icon: Icons.mic,
      comingSoon: false,
    );
  }

  /// Build placeholder screen for invalid indices
  static Widget _buildPlaceholderScreen(int index) {
    return PlaceholderScreen(
      title: 'Screen $index',
      description: 'This screen is under development',
      icon: Icons.construction,
      comingSoon: true,
    );
  }

  /// Get cache statistics for debugging
  static Map<String, dynamic> getCacheStats() {
    return {
      'cached_screens': _screenCache.keys.toList(),
      'preloaded_screens': _preloadedScreens.toList(),
      'cache_size': _screenCache.length,
    };
  }

  /// Check if screen is cached
  static bool isScreenCached(int index) {
    return _screenCache.containsKey(index);
  }

  /// Warm up cache with all screens (use carefully)
  static void warmUpCache({Function(int)? onAnalysisToolSelected}) {
    for (int i = 0; i < 7; i++) {
      if (!_screenCache.containsKey(i)) {
        _screenCache[i] = _createScreen(i, onAnalysisToolSelected);
      }
    }
  }
}
