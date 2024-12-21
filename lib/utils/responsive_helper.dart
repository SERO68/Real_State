import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
      
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;
      
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static int getGridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  static double getGridItemHeight(BuildContext context) {
    if (isDesktop(context)) return 300;
    if (isTablet(context)) return 250;
    return 200;
  }
}