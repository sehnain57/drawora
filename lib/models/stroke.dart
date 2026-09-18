import 'dart:ui';

/// A single continuous stroke drawn on the canvas.
class Stroke {
  final List<Offset> points;
  final Color color;
  final double width;
  final bool isEraser;

  Stroke({
    required this.points,
    required this.color,
    required this.width,
    this.isEraser = false,
  });

  Stroke copyWith({List<Offset>? points}) {
    return Stroke(
      points: points ?? this.points,
      color: color,
      width: width,
      isEraser: isEraser,
    );
  }
}
