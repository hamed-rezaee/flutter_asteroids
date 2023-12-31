import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_asteroids/enums.dart';
import 'package:flutter_asteroids/helpers.dart';
import 'package:flutter_asteroids/objects/explosion_effect.dart';
import 'package:flutter_asteroids/objects/laser.dart';
import 'package:flutter_asteroids/objects/physical_object.dart';
import 'package:flutter_asteroids/vector.dart';

class Ship extends PhysicalObject {
  Ship({
    required this.size,
    required super.position,
    required this.asteroids,
    super.speed = 0.2,
    super.radius = 10,
    this.rotationSpeed = 0.1,
    this.drag = 0.98,
  });

  final List<PhysicalObject> asteroids;

  Size size;
  double rotationSpeed;
  double drag;

  final List<PhysicalObject> lasers = <Laser>[];

  bool isTurningLeft = false;
  bool isTurningRight = false;
  bool isThrusting = false;

  double _rotation = 0;
  Vector _velocity = Vector.zero();

  @override
  void update() {
    if (isTurningLeft) {
      _turn(Rotation.left);
    }

    if (isTurningRight) {
      _turn(Rotation.right);
    }

    if (isThrusting) {
      _thrust();
    }

    position += _velocity;
    position = wrapEdges(this, size);

    _velocity *= drag;
  }

  @override
  void render(Canvas canvas) {
    _drawLaser(canvas);

    canvas
      ..save()
      ..translate(position.x, position.y)
      ..rotate(_rotation + pi / 2);

    _drawThrust(canvas);
    _drawShip(canvas);

    canvas.restore();
  }

  void shoot() => lasers.add(
        Laser(
          size: size,
          position: position,
          angle: _rotation,
          shipRadius: radius,
        ),
      );

  void explode(Canvas canvas) => drawExplosion(canvas, size, position);

  void _turn(Rotation rotation) =>
      _rotation += (rotation == Rotation.left ? -1 : 1) * rotationSpeed;

  void _thrust() => _velocity += Vector.fromAngle(_rotation) * speed;

  void _drawShip(Canvas canvas) {
    final Paint paintBorder = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..moveTo(0, -radius)
      ..lineTo(radius, radius)
      ..lineTo(0, radius / 2)
      ..lineTo(-radius, radius)
      ..close();

    canvas.drawPath(path, paintBorder);
  }

  void _drawThrust(Canvas canvas) {
    final Paint thrustPaint = Paint()
      ..color = Random().nextBool() ? Colors.yellow : Colors.red
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    if (isThrusting) {
      final Path flame = Path()
        ..moveTo(0, radius / 2)
        ..lineTo(-radius / 2, radius)
        ..lineTo(0, radius * Random().nextDouble() * 2.5 + 1.5)
        ..lineTo(radius / 2, radius)
        ..close();

      canvas.drawPath(flame, thrustPaint);
    }
  }

  void _drawLaser(Canvas canvas) {
    for (int i = 0; i < lasers.length; i++) {
      lasers[i]
        ..render(canvas)
        ..update();

      if (isOffScreen(lasers[i], size)) {
        lasers.removeAt(i);
      }
    }
  }
}
