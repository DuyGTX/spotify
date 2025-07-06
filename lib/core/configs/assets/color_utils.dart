// lib/common/helpers/color_utils.dart
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Future<Color?> fetchDominantColor(String imageUrl) async {
  try {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
      size: const Size(200, 200),
    );
    return paletteGenerator.dominantColor?.color;
  } catch (e) {
    return null;
  }
}
