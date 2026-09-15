import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';
import 'responsive_builder.dart';

/// Container that limits content width on large desktop screens and adds uniform horizontal padding.
class ResponsiveContentWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContentWrapper({
    super.key,
    required this.child,
    this.maxWidth = AppDimensions.desktopMaxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveBuilder.isMobile(context);
    final EdgeInsets effectivePadding = (padding as EdgeInsets?) ??
        EdgeInsets.symmetric(
          horizontal: isMobile ? AppDimensions.paddingL : AppDimensions.paddingXXL,
        );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: effectivePadding,
          child: child,
        ),
      ),
    );
  }
}

/// Adaptive layout displaying desktopWidget or mobileWidget based on screen size.
class AdaptiveView extends StatelessWidget {
  final Widget desktop;
  final Widget? tablet;
  final Widget mobile;

  const AdaptiveView({
    super.key,
    required this.desktop,
    this.tablet,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        switch (screenType) {
          case DeviceScreenType.desktop:
            return desktop;
          case DeviceScreenType.tablet:
            return tablet ?? desktop;
          case DeviceScreenType.mobile:
            return mobile;
        }
      },
    );
  }
}
