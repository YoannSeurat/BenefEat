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

final Color white = HexColor("eaeaea");
final Color whiter = HexColor("fafafa");


final Color lightgreyred = HexColor("CA7B7B");
final Color red = HexColor("c94c4b");
final Color darkred = HexColor("b54544");

final Color green = HexColor("64c94b");
final Color darkgreen = HexColor("3E9728");

final Color blue = HexColor("5EAAC9");

final Color grey = HexColor("7D7D7D");
final Color kindalightgrey = HexColor("DADADA");
final Color lightgrey = HexColor("E5E5E5");

final Color black = HexColor("323232");