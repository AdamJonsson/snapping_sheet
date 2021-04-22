import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:snapping_sheet/src/sheet_position_data.dart';

void main() {
  group("Test callback functions. ", () {
    testWidgets("Test onSheetMove", (WidgetTester tester) async {
      final controller = SnappingSheetController();
      SheetPositionData? currentPosData;

      var sheetSize = await _createSnappingSheet(
        sheet: SnappingSheet(
          snappingPositions: [
            SnappingPosition.factor(positionFactor: 0.0),
            SnappingPosition.factor(positionFactor: 0.2),
            SnappingPosition.factor(positionFactor: 0.4),
            SnappingPosition.factor(positionFactor: 0.6),
            SnappingPosition.factor(positionFactor: 0.8),
          ],
          controller: controller,
          onSheetMoved: (pos) {
            currentPosData = pos;
          },
          sheetBelow: _createDummySheetContent(),
          sheetAbove: null,
          child: Container(),
        ),
        tester: tester,
      );

      int index = 0;
      for (var i = 0.0; i < 1; i += 0.2) {
        controller.snapToPosition(SnappingPosition.factor(positionFactor: i));
        await tester.pumpAndSettle();
        expect(currentPosData!.pixels, sheetSize.height * i);
        expect(currentPosData!.relativeToSheetHeight, i);
        expect(
          (currentPosData!.relativeToSnappingPositions * 100).round(),
          index / 4 * 100,
        );
        index++;
      }
    });
    testWidgets("Test onSnapStart & onSnapCompleted",
        (WidgetTester tester) async {
      final controller = SnappingSheetController();
      bool startHasExecuted = false;
      bool completedHasExecuted = false;

      await _createSnappingSheet(
        sheet: SnappingSheet(
          snappingPositions: [
            SnappingPosition.factor(positionFactor: 0.0),
            SnappingPosition.factor(positionFactor: 0.2),
          ],
          controller: controller,
          onSnapStart: (posData, snappingPositionData) {
            startHasExecuted = true;
          },
          onSnapCompleted: (posData, snappingPositionData) {
            completedHasExecuted = true;
          },
          sheetBelow: _createDummySheetContent(),
          sheetAbove: null,
          child: Container(),
        ),
        tester: tester,
      );

      controller.snapToPosition(SnappingPosition.factor(positionFactor: 0.2));
      await tester.pump();
      expect(startHasExecuted, true);
      expect(completedHasExecuted, false);
      await tester.pumpAndSettle();
      expect(completedHasExecuted, true);
    });
  });

  group(
    "Test the draggability of the snapping sheet widget.",
    () {
      testWidgets("Grabbing widget should be draggable",
          (WidgetTester tester) async {
        final controller = SnappingSheetController();
        double currentSheetPos = 0;

        var snappingSheetSize = await _createSnappingSheet(
          sheet: SnappingSheet(
            snappingPositions: [
              SnappingPosition.pixels(positionPixels: 50),
              SnappingPosition.factor(positionFactor: 0.5),
              SnappingPosition.factor(positionFactor: 1),
            ],
            controller: controller,
            onSheetMoved: (pos) {
              currentSheetPos = pos.pixels;
            },
            grabbingHeight: 100,
            grabbing: Container(color: Colors.white),
            sheetBelow: null,
            sheetAbove: null,
            child: SizedBox(),
          ),
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
          sheet: SnappingSheet(
            snappingPositions: [
              SnappingPosition.pixels(positionPixels: 200),
              SnappingPosition.factor(positionFactor: 0.5),
              SnappingPosition.factor(positionFactor: 1),
            ],
            controller: controller,
            onSheetMoved: (pos) {
              currentSheetPos = pos.pixels;
            },
            sheetBelow: SnappingSheetContent(
              child: Container(
                color: Colors.white,
              ),
              draggable: false,
            ),
            sheetAbove: null,
            child: SizedBox(),
          ),
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
          sheet: SnappingSheet(
            snappingPositions: [
              SnappingPosition.pixels(positionPixels: 200),
              SnappingPosition.factor(positionFactor: 0.5),
              SnappingPosition.factor(positionFactor: 1),
            ],
            controller: controller,
            onSheetMoved: (pos) {
              currentSheetPos = pos.pixels;
            },
            sheetBelow: SnappingSheetContent(
              child: Container(
                color: Colors.white,
              ),
              draggable: true,
            ),
            sheetAbove: null,
            child: SizedBox(),
          ),
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
      sheet: SnappingSheet(
        controller: controller,
        snappingPositions: [
          SnappingPosition.factor(positionFactor: 1),
          SnappingPosition.factor(positionFactor: 0.5),
          SnappingPosition.factor(positionFactor: 0.1),
        ],
        grabbingHeight: 100,
        grabbing: Container(
          color: Colors.red,
        ),
        sheetBelow: _createDummySheetContent(),
        sheetAbove: null,
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
  required SnappingSheet sheet,
  required WidgetTester tester,
}) async {
  await tester.pumpWidget(
    _SnappingSheetWrapper(
      child: sheet,
    ),
  );

  await tester.pump();
  await tester.pumpAndSettle();
  return tester.getSize(find.byKey(ValueKey("SnappingSheet")));
}

class _SnappingSheetWrapper extends StatelessWidget {
  final Widget child;

  _SnappingSheetWrapper({
    Key? key,
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
            key: ValueKey("SnappingSheet"),
            constraints: BoxConstraints.expand(),
            child: child,
          ),
        ),
      ),
    );
  }
}
