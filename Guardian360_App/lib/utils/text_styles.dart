// utils/app_text_styles.dart

import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // Hardcoded styles
  static const TextStyle normal = TextStyle(
    fontSize: 25, // Normal font size
    fontWeight: FontWeight.normal,
    color: Colors.black, // Default color
  );

  static TextStyle bold = TextStyle(
    fontSize: 25, // Bold font size
    fontWeight: FontWeight.bold,
    color: AppColors.orange// Default color
  );

  static const TextStyle lightBold = TextStyle(
    fontSize: 25, // Light bold font size
    fontWeight: FontWeight.w300, // Light bold
    color: Colors.black, // Default color
  );

  static const TextStyle extraBold = TextStyle(
    fontSize: 25, // Extra bold font size
    fontWeight: FontWeight.w800, // Extra bold
    color: Colors.black, // Default color
  );

  // Custom styles with specific sizes and colors
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.brown,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: Colors.brown,
  );

  static const TextStyle highlighted = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}
