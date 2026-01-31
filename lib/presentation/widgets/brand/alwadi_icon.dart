import 'package:flutter/material.dart';

class AlwadiIcon extends StatelessWidget {
  const AlwadiIcon({super.key, this.size = 70, this.color});

  static const Color _brandNavy = Color(0xFF1F2933);

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.ac_unit, size: size, color: color ?? _brandNavy);
  }
}
