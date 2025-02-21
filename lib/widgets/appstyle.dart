import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mind_keeper/app/utils/size_utils.dart';

TextStyle appStyle(double size, Color color, FontWeight weight) {
  return GoogleFonts.poppins(
      fontSize: size.fSize, color: color, fontWeight: weight);
}
