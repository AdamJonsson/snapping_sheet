import 'package:example/shared/appbar.dart';
import 'package:example/shared/dummy_background.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class PlaceholderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DarkAppBar(title: "Placeholder Example").build(context),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SnappingSheet(
          snappingPositions: [
            SnappingPosition.factor(
              positionFactor: 0.0,
              snappingCurve: Curves.easeOutExpo,
              snappingDuration: Duration(seconds: 1),
              grabbingContentOffset: GrabbingContentOffset.top,
            ),
            SnappingPosition.factor(
              snappingCurve: Curves.elasticOut,
              snappingDuration: Duration(milliseconds: 1750),
              positionFactor: 0.5,
            ),
            SnappingPosition.factor(
              grabbingContentOffset: GrabbingContentOffset.bottom,
              snappingCurve: Curves.bounceOut,
              snappingDuration: Duration(seconds: 1),
              positionFactor: 1.0,
            ),
          ],
          child: DummyBackgroundContent(),
          grabbingHeight: 100,
          grabbing: Container(
            color: Colors.white.withOpacity(0.75),
            child: Placeholder(color: Colors.black),
          ),
          sheetAbove: SnappingSheetContent(
            draggable: true,
            child: Container(
                color: Colors.white.withOpacity(0.75),
                child: Placeholder(color: Colors.green)),
          ),
          sheetBelow: SnappingSheetContent(
            draggable: true,
            child: Container(
              color: Colors.white.withOpacity(0.75),
              child: Placeholder(color: Colors.green[800] ?? Colors.green),
            ),
          ),
        ),
      ),
    );
  }
}
