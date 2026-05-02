import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  hex = hex.replaceAll("#", "");
  return Color(int.parse("0xFF$hex"));
}
