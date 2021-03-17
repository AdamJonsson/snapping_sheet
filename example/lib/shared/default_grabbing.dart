import 'dart:math';

import 'package:flutter/material.dart';

class DefaultGrabbing extends StatelessWidget {
  final Color color;
  final bool reverse;

  const DefaultGrabbing(
      {Key? key, this.color = Colors.white, this.reverse = false})
      : super(key: key);

  BorderRadius _getBorderRadius() {
    var radius = Radius.circular(25.0);
    return BorderRadius.only(
      topLeft: reverse ? Radius.zero : radius,
      topRight: reverse ? Radius.zero : radius,
      bottomLeft: reverse ? radius : Radius.zero,
      bottomRight: reverse ? radius : Radius.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 10,
            color: Colors.black.withOpacity(0.15),
          )
        ],
        borderRadius: _getBorderRadius(),
        color: this.color,
      ),
      child: Transform.rotate(
        angle: reverse ? pi : 0,
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -0.5),
              child: _GrabbingIndicator(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  height: 2.0,
                  color: Colors.grey[300],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _GrabbingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.grey[400],
      ),
      height: 5,
      width: 75,
    );
  }
}
