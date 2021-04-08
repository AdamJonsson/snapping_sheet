import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

final _scrollHeight = 2000.0;

void main() {
  group(
    "Testing ScrollControllerOverride with sheetBelow.",
    () {
      testWidgets(
        'Test that the scrolling is correctly overwritten when scrolling up.',
        (WidgetTester tester) async {
          final controller = ScrollController();
          double currentSheetPos = 0;

          var snappingSheetSize = await _createSnappingSheet(
            tester,
            controller,
            (pos, maxPos) => currentSheetPos = pos,
            [
              SnappingPosition.factor(positionFactor: 0.25),
              SnappingPosition.factor(positionFactor: 0.5),
              SnappingPosition.factor(positionFactor: 1),
            ],
            false,
          );

          await tester.timedDragFrom(
            Offset(0.0, snappingSheetSize.height - 1),
            Offset(0.0, -100.0),
            Duration(seconds: 1),
          );
          await tester.pumpAndSettle();

          expect(snappingSheetSize.height * 0.5, currentSheetPos);
          expect(controller.position.pixels, 0);
        },
      );

      testWidgets(
        'Test that scrolling automatically begins when scrolling up.',
        (WidgetTester tester) async {
          final controller = ScrollController();
          double currentSheetPos = 0;

          var snappingSheetSize = await _createSnappingSheet(
            tester,
            controller,
            (pos, maxPos) => currentSheetPos = pos,
            [
              SnappingPosition.factor(positionFactor: 0.25),
              SnappingPosition.factor(positionFactor: 0.5),
            ],
            false,
          );

          await tester.timedDragFrom(
            Offset(0.0, snappingSheetSize.height - 1),
            Offset(0.0, -snappingSheetSize.height),
            Duration(seconds: 3),
          );

          expect(controller.position.pixels, snappingSheetSize.height * 0.75);
          await tester.pumpAndSettle();
          expect(snappingSheetSize.height * 0.5, currentSheetPos);
        },
      );

      testWidgets(
          'Test that scrolling automatically begins when scrolling down.',
          (WidgetTester tester) async {
        final controller = ScrollController(initialScrollOffset: 123);
        double currentSheetPos = 0;

        var snappingSheetSize = await _createSnappingSheet(
          tester,
          controller,
          (pos, maxPos) => currentSheetPos = pos,
          [
            SnappingPosition.factor(positionFactor: 1),
            SnappingPosition.factor(positionFactor: 0.5),
          ],
          false,
        );

        await tester.timedDragFrom(
          Offset(0.0, 0.0),
          Offset(0.0, snappingSheetSize.height),
          Duration(seconds: 3),
        );

        expect(controller.position.pixels, 0);
        await tester.pumpAndSettle();
        expect(snappingSheetSize.height * 0.5, currentSheetPos);
      });
    },
  );

  group(
    "Testing ScrollControllerOverride with sheetAbove.",
    () {
      testWidgets(
        'Test that the scrolling is correctly overwritten when scrolling down.',
        (WidgetTester tester) async {
          final controller = ScrollController();
          double currentSheetPos = 0;

          var snappingSheetSize = await _createSnappingSheet(
            tester,
            controller,
            (pos, maxPos) => currentSheetPos = pos,
            [
              SnappingPosition.factor(positionFactor: 0.75),
              SnappingPosition.factor(positionFactor: 0.5),
              SnappingPosition.factor(positionFactor: 0.0),
            ],
            true,
          );

          await tester.timedDragFrom(
            Offset(0.0, 0.0),
            Offset(0.0, 100.0),
            Duration(seconds: 1),
          );
          await tester.pumpAndSettle();

          expect(snappingSheetSize.height * 0.5, currentSheetPos);
          expect(controller.position.pixels, 0);
        },
      );

      testWidgets(
        'Test that scrolling automatically begins when scrolling down.',
        (WidgetTester tester) async {
          final controller = ScrollController();
          double currentSheetPos = 0;

          var snappingSheetSize = await _createSnappingSheet(
            tester,
            controller,
            (pos, maxPos) => currentSheetPos = pos,
            [
              SnappingPosition.factor(positionFactor: 0.75),
              SnappingPosition.factor(positionFactor: 0.5),
            ],
            true,
          );

          await tester.timedDragFrom(
            Offset(0.0, 0.0),
            Offset(0.0, snappingSheetSize.height),
            Duration(seconds: 3),
          );

          expect(
            controller.position.pixels > snappingSheetSize.height * 0.25,
            true,
          );
          await tester.pumpAndSettle();
          expect(snappingSheetSize.height * 0.5, currentSheetPos);
        },
      );

      testWidgets(
        'Test that scrolling automatically begins when scrolling down.',
        (WidgetTester tester) async {
          final controller = ScrollController(initialScrollOffset: 123);
          double currentSheetPos = 0;

          var snappingSheetSize = await _createSnappingSheet(
            tester,
            controller,
            (pos, maxPos) => currentSheetPos = pos,
            [
              SnappingPosition.factor(positionFactor: 0.0),
              SnappingPosition.factor(positionFactor: 0.6),
            ],
            true,
          );

          await tester.timedDragFrom(
            Offset(0.0, snappingSheetSize.height - 1),
            Offset(0.0, -snappingSheetSize.height),
            Duration(seconds: 3),
          );

          expect(controller.position.pixels, 0);
          await tester.pumpAndSettle();
          expect(snappingSheetSize.height * 0.6, currentSheetPos);
        },
      );
    },
  );
}

Future<Size> _createSnappingSheet(
  WidgetTester tester,
  ScrollController controller,
  Function(double, double) onSheetMove,
  List<SnappingPosition> snapPos,
  bool isAbove,
) async {
  await tester.pumpWidget(
    _BasicSnappingSheet(
      isAbove: isAbove,
      scrollHeight: _scrollHeight,
      controller: controller,
      onMove: onSheetMove,
      positions: snapPos,
    ),
  );

  await tester.pump();
  await tester.pumpAndSettle();

  return tester.getSize(find.byKey(ValueKey("SnappingSheet")));
}

class _BasicSnappingSheet extends StatelessWidget {
  final bool isAbove;
  final List<SnappingPosition> positions;
  final double scrollHeight;
  final ScrollController controller;
  final Function(double pos, double macPos) onMove;

  _BasicSnappingSheet(
      {Key? key,
      required this.scrollHeight,
      required this.onMove,
      required this.controller,
      required this.positions,
      required this.isAbove})
      : super(key: key);

  SnappingSheetContent _generateScrollContent() {
    return SnappingSheetContent(
      childScrollController: controller,
      draggable: true,
      child: SingleChildScrollView(
        reverse: isAbove,
        key: ValueKey("ScrollContent"),
        controller: controller,
        child: Container(
          height: 2000,
          color: Colors.white,
          child: Placeholder(),
        ),
      ),
    );
  }

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
              key: ValueKey("SnappingSheet"),
              snappingPositions: positions,
              onSheetMoved: onMove,
              child: Placeholder(),
              grabbingHeight: 0,
              sheetBelow: isAbove ? null : _generateScrollContent(),
              sheetAbove: !isAbove ? null : _generateScrollContent(),
            ),
          ),
        ),
      ),
    );
  }
}
