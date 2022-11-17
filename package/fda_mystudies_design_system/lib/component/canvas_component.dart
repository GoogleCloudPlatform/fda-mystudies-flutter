import 'package:flutter/material.dart';

class CanvasComponent extends StatelessWidget {
  final double height;
  final double width;
  final List<Offset> points;
  final void Function(bool) updateParentScrollState;
  final void Function(Offset) addPointToList;

  const CanvasComponent(
      {super.key,
      required this.height,
      required this.width,
      required this.points,
      required this.updateParentScrollState,
      required this.addPointToList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: height,
        child: GestureDetector(
            onPanStart: (details) => updateParentScrollState(false),
            onPanDown: (details) => updateParentScrollState(false),
            onPanUpdate: (DragUpdateDetails details) {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              Offset localPosition =
                  renderBox.globalToLocal(details.globalPosition);
              if (localPosition.dx > 0 &&
                  localPosition.dx < width &&
                  localPosition.dy > 0 &&
                  localPosition.dy < height) {
                addPointToList(localPosition);
              }
            },
            onPanEnd: (DragEndDetails details) {
              updateParentScrollState(true);
              addPointToList(Offset.infinite);
            },
            child: CustomPaint(
                painter: Drawing(points: points, context: context),
                size: Size.infinite)));
  }
}

class Drawing extends CustomPainter {
  List<Offset> points;
  BuildContext context;
  Drawing({required this.points, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Theme.of(context).colorScheme.onBackground
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;
    for (int i = 0; i < points.length - 1; ++i) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Drawing oldDelegate) {
    return true;
  }
}
