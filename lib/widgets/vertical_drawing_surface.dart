import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A drawing surface that wins the pointer gesture against surrounding
/// ListViews, so strokes work horizontally, vertically and diagonally.
class VerticalDrawingSurface extends StatefulWidget {
  final Color color;
  final ValueChanged<List<List<Offset>>>? onChanged;
  final CustomPainter Function(List<List<Offset>> strokes, List<Offset> current)
      painterBuilder;
  final Widget? child;

  const VerticalDrawingSurface({
    super.key,
    required this.color,
    required this.painterBuilder,
    this.onChanged,
    this.child,
  });

  @override
  State<VerticalDrawingSurface> createState() => _VerticalDrawingSurfaceState();
}

class _VerticalDrawingSurfaceState extends State<VerticalDrawingSurface> {
  final List<List<Offset>> strokes = <List<Offset>>[];
  final List<Offset> current = <Offset>[];

  void _down(PointerDownEvent e) {
    setState(() {
      current
        ..clear()
        ..add(e.localPosition);
    });
  }

  void _move(PointerMoveEvent e) {
    if (current.isEmpty) return;
    setState(() => current.add(e.localPosition));
  }

  void _up(PointerUpEvent e) {
    if (current.length > 1) {
      strokes.add(List<Offset>.from(current));
      widget.onChanged?.call(List<List<Offset>>.from(strokes));
    }
    setState(current.clear);
  }

  void clear() => setState(() {
        strokes.clear();
        current.clear();
        widget.onChanged?.call(<List<Offset>>[]);
      });

  @override
  Widget build(BuildContext context) => RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          EagerGestureRecognizer: GestureRecognizerFactoryWithHandlers<
              EagerGestureRecognizer>(
            EagerGestureRecognizer.new,
            (_) {},
          ),
        },
        behavior: HitTestBehavior.opaque,
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: _down,
          onPointerMove: _move,
          onPointerUp: _up,
          onPointerCancel: (_) => setState(current.clear),
          child: CustomPaint(
            painter: widget.painterBuilder(strokes, current),
            child: widget.child ?? const SizedBox.expand(),
          ),
        ),
      );
}
