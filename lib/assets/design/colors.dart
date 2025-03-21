import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // put "FF" in front of string to represent full opacity
    }
    return int.parse(hexColor, radix: 16);
  }
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

final Color green = HexColor("64c94b");

final Color red = HexColor("c94c4b");
final Color darkred = HexColor("b54544");

final Color blue = HexColor("5eaac9");