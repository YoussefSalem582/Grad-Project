import 'package:flutter/material.dart';

/// A utility class providing custom page route transitions for enhanced user experience.
///
/// This class offers various transition animations including slide, fade, scale, rotation,
/// and combination effects. All transitions are optimized for performance and provide
/// smooth animations with customizable durations and curves.
///
/// Usage example:
/// ```dart
/// Navigator.of(context).push(
///   ScreenTransitions.slideFromRight(MyNewPage()),
/// );
/// ```
class ScreenTransitions {
  // Private constructor to prevent instantiation
  ScreenTransitions._();

  // ==========================================================================
  // SLIDE TRANSITIONS
  // ==========================================================================

  /// Creates a slide transition from right to left (iOS-style push).
  ///
  /// This is the most common transition used for forward navigation.
  /// Perfect for navigating to detail pages or deeper levels in the app hierarchy.
  ///
  /// Parameters:
  /// * [page] - The widget to navigate to
  /// * [settings] - Optional route settings for named routes
  /// * [duration] - Animation duration (default: 300ms)
  ///
  /// Returns a [Route] with slide animation from right edge to center.
  static Route<T> slideFromRight<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _createPageRoute<T>(
      page: page,
      settings: settings,
      duration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: _createSlideTween(
            begin: const Offset(1.0, 0.0), // Start from right edge
            curve: Curves.easeInOut,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  /// Creates a slide transition from left to right (back navigation style).
  ///
  /// Useful for back navigation or when navigating to a previous context.
  /// Creates the visual impression of moving backward in the app flow.
  ///
  /// Parameters:
  /// * [page] - The widget to navigate to
  /// * [settings] - Optional route settings for named routes
  /// * [duration] - Animation duration (default: 300ms)
  ///
  /// Returns a [Route] with slide animation from left edge to center.
  static Route<T> slideFromLeft<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _createPageRoute<T>(
      page: page,
      settings: settings,
      duration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: _createSlideTween(
            begin: const Offset(-1.0, 0.0), // Start from left edge
            curve: Curves.easeInOut,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  /// Creates a slide transition from bottom to top (modal-style presentation).
  ///
  /// Perfect for modal dialogs, bottom sheets, or any content that should
  /// appear to emerge from the bottom of the screen. Commonly used in
  /// material design for presenting secondary content.
  ///
  /// Parameters:
  /// * [page] - The widget to navigate to
  /// * [settings] - Optional route settings for named routes
  /// * [duration] - Animation duration (default: 300ms)
  ///
  /// Returns a [Route] with slide animation from bottom edge to center.
  static Route<T> slideFromBottom<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _createPageRoute<T>(
      page: page,
      settings: settings,
      duration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: _createSlideTween(
            begin: const Offset(0.0, 1.0), // Start from bottom edge
            curve: Curves.easeInOut,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  // ==========================================================================
  // BASIC TRANSITIONS
  // ==========================================================================

  /// Creates a simple fade transition.
  ///
  /// A subtle and elegant transition that gradually changes opacity.
  /// Ideal for smooth transitions where you don't want directional movement,
  /// such as switching between tabs or overlaying content.
  ///
  /// Parameters:
  /// * [page] - The widget to navigate to
  /// * [settings] - Optional route settings for named routes
  /// * [duration] - Animation duration (default: 300ms)
  ///
  /// Returns a [Route] with fade animation.
  static Route<T> fade<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _createPageRoute<T>(
      page: page,
      settings: settings,
      duration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Creates a scale transition (zoom effect).
  ///
  /// The new page appears to zoom in from the center, creating a focus effect.
  /// Great for highlighting important content or creating dramatic entrances.
  ///
  /// Parameters:
  /// * [page] - The widget to navigate to
  /// * [settings] - Optional route settings for named routes
  /// * [duration] - Animation duration (default: 300ms)
  ///
  /// Returns a [Route] with scale animation from 0% to 100%.
  static Route<T> scale<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _createPageRoute<T>(
      page: page,
      settings: settings,
      duration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: _createScaleTween(
            begin: 0.0,
            end: 1.0,
            curve: Curves.easeInOut,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  /// Creates a rotation transition.
  ///
  /// The new page rotates into view, creating a playful and dynamic effect.
  /// Best used sparingly for special occasions or when you want to add
  /// personality to your app's navigation.
  ///
  /// Parameters:
  /// * [page] - The widget to navigate to
  /// * [settings] - Optional route settings for named routes
  /// * [duration] - Animation duration (default: 400ms, slightly longer for smoothness)
  ///
  /// Returns a [Route] with rotation animation (one full turn).
  static Route<T> rotation<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return _createPageRoute<T>(
      page: page,
      settings: settings,
      duration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: _createRotationTween(
            begin: 0.0,
            end: 1.0,
            curve: Curves.easeInOut,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  // ==========================================================================
  // COMBINATION TRANSITIONS
  // ==========================================================================

  /// Creates a combined fade and scale transition.
  ///
  /// The new page fades in while simultaneously scaling up from 80% to 100%.
  /// This creates a polished, modern effect that's both subtle and engaging.
  /// Perfect for presenting important content with elegance.
  ///
  /// Parameters:
  /// * [page] - The widget to navigate to
  /// * [settings] - Optional route settings for named routes
  /// * [duration] - Animation duration (default: 300ms)
  ///
  /// Returns a [Route] combining fade and scale animations.
  static Route<T> fadeScale<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _createPageRoute<T>(
      page: page,
      settings: settings,
      duration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: _createScaleTween(
              begin: 0.8, // Start slightly smaller
              end: 1.0,
              curve: Curves.easeInOut,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  /// Creates a combined slide and fade transition.
  ///
  /// The new page slides in from a specified direction while fading in.
  /// This combination creates depth and sophistication, making the transition
  /// feel more three-dimensional and polished.
  ///
  /// Parameters:
  /// * [page] - The widget to navigate to
  /// * [settings] - Optional route settings for named routes
  /// * [duration] - Animation duration (default: 300ms)
  /// * [beginOffset] - Starting position offset (default: slight upward slide)
  ///
  /// Returns a [Route] combining slide and fade animations.
  static Route<T> slideFade<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
    Offset beginOffset = const Offset(0.0, 0.3), // Slide up slightly
  }) {
    return _createPageRoute<T>(
      page: page,
      settings: settings,
      duration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: _createSlideTween(
              begin: beginOffset,
              curve: Curves.easeInOut,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  // ==========================================================================
  // HELPER METHODS
  // ==========================================================================

  /// Creates a reusable PageRouteBuilder with common configuration.
  ///
  /// This helper reduces code duplication across all transition methods
  /// and ensures consistent behavior.
  static PageRouteBuilder<T> _createPageRoute<T extends Object?>({
    required Widget page,
    required Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    )
    transitionsBuilder,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration, // Consistent reverse timing
      transitionsBuilder: transitionsBuilder,
    );
  }

  /// Creates a slide animation tween with consistent configuration.
  ///
  /// Standardizes slide animations across different methods.
  static Animatable<Offset> _createSlideTween({
    required Offset begin,
    Offset end = Offset.zero,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  }

  /// Creates a scale animation tween with consistent configuration.
  ///
  /// Standardizes scale animations across different methods.
  static Animatable<double> _createScaleTween({
    required double begin,
    required double end,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  }

  /// Creates a rotation animation tween with consistent configuration.
  ///
  /// Standardizes rotation animations across different methods.
  static Animatable<double> _createRotationTween({
    required double begin,
    required double end,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  }
}
