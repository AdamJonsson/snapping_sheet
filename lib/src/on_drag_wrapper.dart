import 'package:flutter/material.dart';

class OnDragWrapper extends StatelessWidget {
  final Widget child;
  final Function(double) dragUpdate;
  final VoidCallback dragStart;
  final VoidCallback dragEnd;

  OnDragWrapper(
      {Key? key,
      required this.dragStart,
      required this.dragEnd,
      required this.child,
      required this.dragUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (_) {
        this.dragStart();
      },
      onVerticalDragEnd: (_) {
        this.dragEnd();
      },
      onVerticalDragUpdate: (dragData) {
        this.dragUpdate(dragData.delta.dy);
      },
      child: this.child,
    );
  }
}
