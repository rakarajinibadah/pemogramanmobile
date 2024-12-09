import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF09453E);
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle subheading = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle smallText = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );
}
