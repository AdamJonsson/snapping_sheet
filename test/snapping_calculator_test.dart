import 'package:flutter_test/flutter_test.dart';
import 'package:snapping_sheet/src/snapping_calculator.dart';
import 'package:snapping_sheet/src/snapping_position.dart';

void main() {
  double maxHeight = 1000;
  double grabbingHeight = 100;
  List<SnappingPosition> snappingPositions = [
    SnappingPosition.factor(positionFactor: 0.0),
    SnappingPosition.factor(positionFactor: 0.2),
    SnappingPosition.pixels(positionPixels: 500),
    SnappingPosition.factor(positionFactor: 0.7),
    SnappingPosition.factor(positionFactor: 1.0),
  ];

  group("Next snapping position is the same as last snapping position.", () {
    test('Testing with the first snapping position as last snapping pos', () {
      SnappingPosition lastSnappingPosition = snappingPositions.first;
      var next = SnappingCalculator(
              allSnappingPositions: snappingPositions,
              lastSnappingPosition: lastSnappingPosition,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 0.0)
          .getBestSnappingPosition();
      expect(next, lastSnappingPosition);
    });

    test('Testing with the first snapping position as middle snapping pos', () {
      SnappingPosition lastSnappingPosition = snappingPositions[2];
      var next = SnappingCalculator(
              allSnappingPositions: snappingPositions,
              lastSnappingPosition: lastSnappingPosition,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 500.0)
          .getBestSnappingPosition();
      expect(next, lastSnappingPosition);
    });

    test('Testing with the first snapping position as last snapping pos', () {
      SnappingPosition lastSnappingPosition = snappingPositions.last;
      var next = SnappingCalculator(
              allSnappingPositions: snappingPositions,
              lastSnappingPosition: lastSnappingPosition,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 1000.0)
          .getBestSnappingPosition();
      expect(next, lastSnappingPosition);
    });

    test('Testing a little above last snapping position', () {
      SnappingPosition lastSnappingPosition = snappingPositions[2];
      var next = SnappingCalculator(
              allSnappingPositions: snappingPositions,
              lastSnappingPosition: lastSnappingPosition,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 505.0)
          .getBestSnappingPosition();
      expect(next, lastSnappingPosition);
    });

    test('Testing a little below last snapping position', () {
      SnappingPosition lastSnappingPosition = snappingPositions[2];
      var next = SnappingCalculator(
              allSnappingPositions: snappingPositions,
              lastSnappingPosition: lastSnappingPosition,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 495.0)
          .getBestSnappingPosition();
      expect(next, lastSnappingPosition);
    });

    test('Testing position overflow above', () {
      SnappingPosition lastSnappingPosition = snappingPositions.last;
      var next = SnappingCalculator(
              allSnappingPositions: snappingPositions,
              lastSnappingPosition: lastSnappingPosition,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 2000.0)
          .getBestSnappingPosition();
      expect(next, lastSnappingPosition);
    });

    test('Testing position overflow below', () {
      SnappingPosition lastSnappingPosition = snappingPositions.first;
      var next = SnappingCalculator(
              allSnappingPositions: snappingPositions,
              lastSnappingPosition: lastSnappingPosition,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: -2000.0)
          .getBestSnappingPosition();
      expect(next, lastSnappingPosition);
    });
  });

  group("Snapping positions in random order.", () {
    var localSnappingPositions = [
      SnappingPosition.pixels(positionPixels: 500),
      SnappingPosition.pixels(positionPixels: 100),
      SnappingPosition.pixels(positionPixels: 300),
      SnappingPosition.factor(positionFactor: 1.0),
      SnappingPosition.pixels(positionPixels: 700),
    ];
    test('Correct next snapping position when last is first snapping pos', () {
      SnappingPosition lastSnappingPosition = localSnappingPositions.first;
      var next = SnappingCalculator(
              allSnappingPositions: localSnappingPositions,
              lastSnappingPosition: lastSnappingPosition,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 600)
          .getBestSnappingPosition();
      expect(next, localSnappingPositions.last);
    });
    test('Correct next snapping position when last is middle snapping pos', () {
      SnappingPosition lastSnappingPosition = localSnappingPositions[2];
      var next = SnappingCalculator(
              allSnappingPositions: localSnappingPositions,
              lastSnappingPosition: lastSnappingPosition,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 900)
          .getBestSnappingPosition();
      expect(next, localSnappingPositions[3]);
    });
  });

  group("Correct snapping positions are ignored.", () {
    test("Ignoring snapping positions below", () {
      var snappingPositions = [
        SnappingPosition.pixels(positionPixels: 0),
        SnappingPosition.pixels(positionPixels: 10),
        SnappingPosition.pixels(positionPixels: 20),
        SnappingPosition.pixels(positionPixels: 30),
        SnappingPosition.pixels(positionPixels: 100),
      ];
      var next = SnappingCalculator(
              allSnappingPositions: snappingPositions,
              lastSnappingPosition: snappingPositions[2],
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 50)
          .getBestSnappingPosition();
      expect(next, snappingPositions.last);
    });

    test("Ignoring snapping positions above", () {
      var snappingPositions = [
        SnappingPosition.pixels(positionPixels: 0),
        SnappingPosition.pixels(positionPixels: 60),
        SnappingPosition.pixels(positionPixels: 70),
        SnappingPosition.pixels(positionPixels: 80),
        SnappingPosition.pixels(positionPixels: 90),
        SnappingPosition.pixels(positionPixels: 100),
      ];
      var next = SnappingCalculator(
              allSnappingPositions: snappingPositions,
              lastSnappingPosition: snappingPositions[4],
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 50)
          .getBestSnappingPosition();
      expect(next, snappingPositions.first);
    });

    test("Not ignoring when dragging over the highest snapping position", () {
      var localSnappingPositions = [
        SnappingPosition.pixels(positionPixels: 0),
        SnappingPosition.pixels(positionPixels: 200),
        SnappingPosition.pixels(positionPixels: 300),
        SnappingPosition.pixels(positionPixels: 100),
      ];
      var next = SnappingCalculator(
              allSnappingPositions: localSnappingPositions,
              lastSnappingPosition: localSnappingPositions.last,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 400)
          .getBestSnappingPosition();
      expect(next, localSnappingPositions[2]);
    });

    test("Not ignoring when dragging below the lowest snapping position", () {
      var localSnappingPositions = [
        SnappingPosition.pixels(positionPixels: 700),
        SnappingPosition.pixels(positionPixels: 900),
        SnappingPosition.pixels(positionPixels: 1000),
        SnappingPosition.pixels(positionPixels: 800),
      ];
      var next = SnappingCalculator(
              allSnappingPositions: localSnappingPositions,
              lastSnappingPosition: localSnappingPositions[1],
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 600)
          .getBestSnappingPosition();
      expect(next, localSnappingPositions[0]);
    });
  });

  group("Testing with only one snapping position", () {
    var localSnappingPositions = [
      SnappingPosition.factor(positionFactor: 0.5),
    ];

    test('Test with dragging above', () {
      SnappingPosition lastSnappingPosition = localSnappingPositions.first;
      var next = SnappingCalculator(
              allSnappingPositions: localSnappingPositions,
              lastSnappingPosition: lastSnappingPosition,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 700)
          .getBestSnappingPosition();
      expect(next, localSnappingPositions.last);
    });

    test('Test with dragging below', () {
      SnappingPosition lastSnappingPosition = localSnappingPositions.first;
      var next = SnappingCalculator(
              allSnappingPositions: localSnappingPositions,
              lastSnappingPosition: lastSnappingPosition,
              maxHeight: maxHeight,
              grabbingHeight: grabbingHeight,
              currentPosition: 200)
          .getBestSnappingPosition();
      expect(next, localSnappingPositions.last);
    });
  });
}
