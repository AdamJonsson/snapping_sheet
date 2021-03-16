import 'package:flutter/material.dart';

class SquareMaterial extends StatelessWidget {
  final double? width;
  final double height;
  final Color? color;

  const SquareMaterial({
    Key? key,
    this.height = 100.0,
    this.color,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: 0,
        color: this.color ?? Colors.grey[300],
        child: SizedBox(
          width: this.width,
          height: this.height,
        ),
      ),
    );
  }
}

class TextMaterial extends StatelessWidget {
  final double width;
  final Alignment alignment;

  const TextMaterial(
      {Key? key, required this.width, this.alignment = Alignment.topLeft})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(5),
          ),
          height: 13.0,
          width: width,
        ),
      ),
    );
  }
}
