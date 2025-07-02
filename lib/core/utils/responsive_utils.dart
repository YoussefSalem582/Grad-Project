import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 1024;
  static const double _desktopBreakpoint = 1440;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < _mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _mobileBreakpoint && width < _tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= _tabletBreakpoint;
  }

  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= _desktopBreakpoint;
  }

  // Get responsive padding
  static EdgeInsets getPadding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final defaultMobile = mobile ?? 16.0;
    final defaultTablet = tablet ?? 24.0;
    final defaultDesktop = desktop ?? 32.0;

    if (isMobile(context)) {
      return EdgeInsets.all(defaultMobile);
    } else if (isTablet(context)) {
      return EdgeInsets.all(defaultTablet);
    } else {
      return EdgeInsets.all(defaultDesktop);
    }
  }

  // Get responsive horizontal padding
  static EdgeInsets getHorizontalPadding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final defaultMobile = mobile ?? 16.0;
    final defaultTablet = tablet ?? 32.0;
    final defaultDesktop = desktop ?? 48.0;

    if (isMobile(context)) {
      return EdgeInsets.symmetric(horizontal: defaultMobile);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: defaultTablet);
    } else {
      return EdgeInsets.symmetric(horizontal: defaultDesktop);
    }
  }

  // Get responsive font size
  static double getFontSize(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final defaultMobile = mobile ?? 14.0;
    final defaultTablet = tablet ?? 16.0;
    final defaultDesktop = desktop ?? 18.0;

    if (isMobile(context)) {
      return defaultMobile;
    } else if (isTablet(context)) {
      return defaultTablet;
    } else {
      return defaultDesktop;
    }
  }

  // Get responsive cross axis count for grids
  static int getCrossAxisCount(
    BuildContext context, {
    int? mobile,
    int? tablet,
    int? desktop,
  }) {
    final defaultMobile = mobile ?? 2;
    final defaultTablet = tablet ?? 3;
    final defaultDesktop = desktop ?? 4;

    if (isMobile(context)) {
      return defaultMobile;
    } else if (isTablet(context)) {
      return defaultTablet;
    } else {
      return defaultDesktop;
    }
  }

  // Get responsive container width
  static double getContainerWidth(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isMobile(context)) {
      return mobile ?? screenWidth * 0.9;
    } else if (isTablet(context)) {
      return tablet ?? screenWidth * 0.8;
    } else {
      return desktop ?? screenWidth * 0.7;
    }
  }

  // Get responsive spacing
  static double getSpacing(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final defaultMobile = mobile ?? 8.0;
    final defaultTablet = tablet ?? 12.0;
    final defaultDesktop = desktop ?? 16.0;

    if (isMobile(context)) {
      return defaultMobile;
    } else if (isTablet(context)) {
      return defaultTablet;
    } else {
      return defaultDesktop;
    }
  }

  // Get responsive card elevation
  static double getCardElevation(BuildContext context) {
    if (isMobile(context)) {
      return 2.0;
    } else if (isTablet(context)) {
      return 4.0;
    } else {
      return 6.0;
    }
  }

  // Get responsive border radius
  static double getBorderRadius(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final defaultMobile = mobile ?? 12.0;
    final defaultTablet = tablet ?? 16.0;
    final defaultDesktop = desktop ?? 20.0;

    if (isMobile(context)) {
      return defaultMobile;
    } else if (isTablet(context)) {
      return defaultTablet;
    } else {
      return defaultDesktop;
    }
  }

  // Get responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    if (isMobile(context)) {
      return 80.0;
    } else if (isTablet(context)) {
      return 95.0;
    } else {
      return 110.0;
    }
  }

  // Check if landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Get responsive columns for layouts
  static int getColumns(BuildContext context) {
    if (isMobile(context)) {
      return isLandscape(context) ? 2 : 1;
    } else if (isTablet(context)) {
      return isLandscape(context) ? 3 : 2;
    } else {
      return isLandscape(context) ? 4 : 3;
    }
  }

  // Get safe area bottom padding
  static double getSafeAreaBottom(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  // Get responsive button height
  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) {
      return 48.0;
    } else if (isTablet(context)) {
      return 52.0;
    } else {
      return 56.0;
    }
  }

  // Get responsive icon size
  static double getIconSize(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final defaultMobile = mobile ?? 20.0;
    final defaultTablet = tablet ?? 24.0;
    final defaultDesktop = desktop ?? 28.0;

    if (isMobile(context)) {
      return defaultMobile;
    } else if (isTablet(context)) {
      return defaultTablet;
    } else {
      return defaultDesktop;
    }
  }
}

// Extension for easier access
extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  bool get isLandscape => ResponsiveUtils.isLandscape(this);

  EdgeInsets responsivePadding({
    double? mobile,
    double? tablet,
    double? desktop,
  }) => ResponsiveUtils.getPadding(
    this,
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
  );

  double responsiveFontSize({
    double? mobile,
    double? tablet,
    double? desktop,
  }) => ResponsiveUtils.getFontSize(
    this,
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
  );

  double responsiveSpacing({double? mobile, double? tablet, double? desktop}) =>
      ResponsiveUtils.getSpacing(
        this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}
