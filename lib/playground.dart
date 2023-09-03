import 'package:flutter/material.dart';
import 'package:flutter_asteroids/ship.dart';

class Playground extends CustomPainter {
  Playground({
    required this.ship,
    this.drawDebug = false,
  });

  final bool drawDebug;
  final Ship ship;

  @override
  void paint(Canvas canvas, Size size) {
    if (drawDebug) {
      _drawBorder(canvas, size);
    }

    ship.render(canvas);
  }

  void _drawBorder(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
