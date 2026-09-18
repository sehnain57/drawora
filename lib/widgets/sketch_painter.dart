import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/stroke.dart';

class SketchPainter extends CustomPainter {
  final List<Stroke> strokes;
  final Color backgroundColor;

  SketchPainter({required this.strokes, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Paint the background first so eraser strokes (BlendMode.clear)
    // reveal it correctly within the layer below.
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    canvas.saveLayer(Offset.zero & size, Paint());

    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.isEraser ? Colors.transparent : stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..blendMode = stroke.isEraser ? BlendMode.clear : BlendMode.srcOver;

      if (stroke.points.length == 1) {
        canvas.drawPoints(
          ui.PointMode.points,
          stroke.points,
          paint..strokeCap = StrokeCap.round,
        );
        continue;
      }

      final path = Path()
        ..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SketchPainter oldDelegate) => true;
}
