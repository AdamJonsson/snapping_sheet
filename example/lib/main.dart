import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

void main() {
  runApp(SnappingSheetExample());
}

class SnappingSheetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Menu(),
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SnappingSheet(
          snappingPositions: [
            SnappingPosition.factor(
              snappingCurve: Curves.bounceOut,
              grabbingContentOffset: GrabbingContentOffset.top,
              snappingDuration: Duration(milliseconds: 1000),
              positionFactor: 0.0,
            ),
            SnappingPosition.pixels(
              snappingCurve: Curves.elasticOut,
              snappingDuration: Duration(milliseconds: 1500),
              positionPixels: 500,
            )
          ],
          lockOverflowDrag: true,
          child: Placeholder(
            color: Colors.red,
          ),
          grabbingHeight: 100,
          grabbing: Container(
            color: Colors.blue,
            child: Placeholder(
              color: Colors.pink,
            ),
          ),
          sheetAbove: SnappingSheetContent(
            sizeBehavior: SheetSizeDynamic(),
            child: Container(
              child: Placeholder(
                color: Colors.blue,
              ),
            ),
          ),
          sheetBelow: SnappingSheetContent(
            sizeBehavior: SheetSizeStatic(
              expandOnOverflow: true,
              height: 300,
            ),
            draggable: true,
            child: Container(
              color: Colors.white,
              child: Placeholder(
                color: Colors.green,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
