import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

enum DeviceScreenType { mobile, tablet, desktop }

/// Utility builder that provides current screen type and builds appropriate widget.
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceScreenType screenType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  static DeviceScreenType getDeviceType(double width) {
    if (width >= AppDimensions.tabletBreakpoint) {
      return DeviceScreenType.desktop;
    } else if (width >= AppDimensions.mobileBreakpoint) {
      return DeviceScreenType.tablet;
    } else {
      return DeviceScreenType.mobile;
    }
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppDimensions.mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return width >= AppDimensions.mobileBreakpoint && width < AppDimensions.tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppDimensions.tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = getDeviceType(constraints.maxWidth);
        return builder(context, screenType);
      },
    );
  }
}
