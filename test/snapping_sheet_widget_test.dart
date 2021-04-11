import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

void main() {
  group(
    "Test the draggability of the snapping sheet widget.",
    () {
      testWidgets("Grabbing widget should be draggable",
          (WidgetTester tester) async {
        final controller = SnappingSheetController();
        double currentSheetPos = 0;

        var snappingSheetSize = await _createSnappingSheet(
          positions: [
            SnappingPosition.pixels(positionPixels: 50),
            SnappingPosition.factor(positionFactor: 0.5),
            SnappingPosition.factor(positionFactor: 1),
          ],
          controller: controller,
          onMove: (pos) {
            currentSheetPos = pos;
          },
          contentBelow: null,
          contentAbove: null,
          child: SizedBox(),
          tester: tester,
        );

        await tester.timedDragFrom(
          Offset(0.0, snappingSheetSize.height - 1),
          Offset(0.0, -100.0),
          Duration(seconds: 1),
        );
        await tester.pumpAndSettle();

        expect(currentSheetPos, snappingSheetSize.height * 0.5);
      });

      testWidgets("Sheet content should not be draggable",
          (WidgetTester tester) async {
        final controller = SnappingSheetController();
        double currentSheetPos = 0;

        var snappingSheetSize = await _createSnappingSheet(
          positions: [
            SnappingPosition.pixels(positionPixels: 200),
            SnappingPosition.factor(positionFactor: 0.5),
            SnappingPosition.factor(positionFactor: 1),
          ],
          controller: controller,
          onMove: (pos) {
            currentSheetPos = pos;
          },
          contentBelow: SnappingSheetContent(
            child: Container(
              color: Colors.white,
            ),
            draggable: false,
          ),
          contentAbove: null,
          child: SizedBox(),
          tester: tester,
        );

        await tester.timedDragFrom(
          Offset(0.0, snappingSheetSize.height - 1),
          Offset(0.0, -100.0),
          Duration(seconds: 1),
        );
        await tester.pumpAndSettle();

        expect(currentSheetPos, 200);
      });

      testWidgets("Sheet content should be draggable",
          (WidgetTester tester) async {
        final controller = SnappingSheetController();
        double currentSheetPos = 0;

        var snappingSheetSize = await _createSnappingSheet(
          positions: [
            SnappingPosition.pixels(positionPixels: 200),
            SnappingPosition.factor(positionFactor: 0.5),
            SnappingPosition.factor(positionFactor: 1),
          ],
          controller: controller,
          onMove: (pos) {
            currentSheetPos = pos;
          },
          contentBelow: SnappingSheetContent(
            child: Container(
              color: Colors.white,
            ),
            draggable: true,
          ),
          contentAbove: null,
          child: SizedBox(),
          tester: tester,
        );

        await tester.timedDragFrom(
          Offset(0.0, snappingSheetSize.height - 1),
          Offset(0.0, -100.0),
          Duration(seconds: 1),
        );
        await tester.pumpAndSettle();

        expect(currentSheetPos, snappingSheetSize.height * 0.5);
      });
    },
  );

  testWidgets("Can access items behind snapping sheet",
      (WidgetTester tester) async {
    final controller = SnappingSheetController();
    int buttonPressCount = 0;
    await _createSnappingSheet(
      positions: [
        SnappingPosition.factor(positionFactor: 1),
        SnappingPosition.factor(positionFactor: 0.5),
        SnappingPosition.factor(positionFactor: 0.1),
      ],
      controller: controller,
      onMove: (pos) => {},
      contentBelow: _createDummySheetContent(),
      contentAbove: null,
      child: Container(
        child: Center(
          child: ElevatedButton(
            key: ValueKey("BehindSheetButton"),
            onPressed: () {
              buttonPressCount++;
            },
            child: Text("Access me"),
          ),
        ),
      ),
      tester: tester,
    );

    // The first tap should not work as the snapping content is in the way
    await tester.tap(find.byKey(ValueKey("BehindSheetButton")));
    expect(buttonPressCount, 0);

    controller.snapToPosition(SnappingPosition.factor(positionFactor: 0.1));

    // The tap should now work as its position is not covering the button
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey("BehindSheetButton")));
    expect(buttonPressCount, 1);
  });
}

SnappingSheetContent _createDummySheetContent() {
  return SnappingSheetContent(
    child: Container(
      color: Colors.white,
      child: Placeholder(),
    ),
  );
}

Future<Size> _createSnappingSheet({
  required List<SnappingPosition> positions,
  required SnappingSheetController controller,
  required Function(double pos) onMove,
  required SnappingSheetContent? contentAbove,
  required SnappingSheetContent? contentBelow,
  required Widget child,
  required WidgetTester tester,
}) async {
  await tester.pumpWidget(
    _BasicSnappingSheet(
      controller: controller,
      onMove: onMove,
      contentAbove: contentAbove,
      contentBelow: contentBelow,
      child: child,
      positions: positions,
    ),
  );

  await tester.pump();
  await tester.pumpAndSettle();
  return tester.getSize(find.byKey(ValueKey("SnappingSheet")));
}

class _BasicSnappingSheet extends StatelessWidget {
  final List<SnappingPosition> positions;
  final SnappingSheetController controller;
  final Function(double pos) onMove;
  final SnappingSheetContent? contentAbove;
  final SnappingSheetContent? contentBelow;
  final Widget child;

  _BasicSnappingSheet({
    Key? key,
    required this.onMove,
    required this.controller,
    required this.positions,
    this.contentAbove,
    this.contentBelow,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1000.0,
      child: MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
          body: Container(
            constraints: BoxConstraints.expand(),
            child: SnappingSheet(
              controller: controller,
              key: ValueKey("SnappingSheet"),
              snappingPositions: positions,
              onSheetMoved: onMove,
              child: child,
              grabbingHeight: 100,
              grabbing: Container(
                color: Colors.red,
              ),
              sheetBelow: contentBelow,
              sheetAbove: contentAbove,
            ),
          ),
        ),
      ),
    );
  }
}
