import 'package:example/shared/dummy_material.dart';
import 'package:flutter/material.dart';

class DummyContent extends StatelessWidget {
  final bool reverse;
  final ScrollController? controller;

  const DummyContent({Key? key, this.controller, this.reverse = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        reverse: this.reverse,
        padding: EdgeInsets.all(20).copyWith(top: 30),
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextMaterial(width: 150, alignment: Alignment.center),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareMaterial(
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 15),
                SquareMaterial(
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 15),
                SquareMaterial(
                  width: 100,
                  height: 100,
                ),
              ],
            ),
            SizedBox(height: 25),
            TextMaterial(width: double.infinity),
            TextMaterial(width: 160),
            Row(
              children: [
                Expanded(child: SquareMaterial(height: 200)),
                Expanded(child: SquareMaterial(height: 200)),
              ],
            ),
            Row(
              children: [
                Expanded(child: SquareMaterial(height: 200)),
                Expanded(child: SquareMaterial(height: 200)),
                Expanded(child: SquareMaterial(height: 200)),
              ],
            ),
            SizedBox(height: 25),
            TextMaterial(width: double.infinity),
            TextMaterial(width: double.infinity),
            TextMaterial(width: 230),
            SquareMaterial(height: 300),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(child: SquareMaterial(height: 100)),
                Expanded(child: SquareMaterial(height: 100)),
                Expanded(child: SquareMaterial(height: 100)),
                Expanded(child: SquareMaterial(height: 100)),
                Expanded(child: SquareMaterial(height: 100)),
              ],
            ),
            TextMaterial(width: double.infinity),
            TextMaterial(width: 230),
          ],
        ),
      ),
    );
  }
}
