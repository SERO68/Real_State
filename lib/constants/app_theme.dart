import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.lightBlueAccent;
  static const Color backgroundColor = Colors.white;
  static const Color shadowColor = Colors.black12;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, accentColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Box Shadows
  static const BoxShadow defaultShadow = BoxShadow(
    color: shadowColor,
    blurRadius: 10,
    offset: Offset(0, 5),
  );

  // Border Radius
  static final BorderRadius defaultBorderRadius = BorderRadius.circular(8);

  // Text Styles
  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  // Decorations
  static BoxDecoration get containerDecoration => BoxDecoration(
        color: backgroundColor,
        borderRadius: defaultBorderRadius,
        boxShadow: const [defaultShadow],
      );

  static BoxDecoration get buttonDecoration => BoxDecoration(
        gradient: primaryGradient,
        borderRadius: defaultBorderRadius,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      );
}