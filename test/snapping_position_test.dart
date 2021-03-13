import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapping_sheet/src/snapping_position.dart';

void main() {
  group("Testing with snapping position factor.", () {
    test('Testing with factor 0.3 and offset middle', () {
      var snappingPosition = SnappingPosition.factor(
        positionFactor: 0.3,
        grabbingContentOffset: GrabbingContentOffset.middle,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), 300);
    });
    test('Testing with factor 0.7 and offset middle', () {
      var snappingPosition = SnappingPosition.factor(
        positionFactor: 0.7,
        grabbingContentOffset: GrabbingContentOffset.middle,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), 700);
    });
    test('Testing with factor 0.7 and offset top', () {
      var snappingPosition = SnappingPosition.factor(
        positionFactor: 0.7,
        grabbingContentOffset: GrabbingContentOffset.top,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), 750);
    });
    test('Testing with factor 0.7 and offset bottom', () {
      var snappingPosition = SnappingPosition.factor(
        positionFactor: 0.7,
        grabbingContentOffset: GrabbingContentOffset.bottom,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), 650);
    });
    test('Testing overshoot position', () {
      var snappingPosition = SnappingPosition.factor(
        positionFactor: 2.3,
        grabbingContentOffset: GrabbingContentOffset.middle,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), 2300);
    });
    test('Testing undershoot position', () {
      var snappingPosition = SnappingPosition.factor(
        positionFactor: -2.3,
        grabbingContentOffset: GrabbingContentOffset.middle,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), -2300);
    });
  });

  group("Testing with snapping position pixels.", () {
    test('Testing with pixels 300 and offset middle', () {
      var snappingPosition = SnappingPosition.pixels(
        positionPixels: 300,
        grabbingContentOffset: GrabbingContentOffset.middle,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), 300);
    });
    test('Testing with decimal pixels 123.4567 and offset middle', () {
      var snappingPosition = SnappingPosition.pixels(
        positionPixels: 123.4567,
        grabbingContentOffset: GrabbingContentOffset.middle,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), 123.4567);
    });
    test('Testing with pixels 750 and offset top', () {
      var snappingPosition = SnappingPosition.pixels(
        positionPixels: 750,
        grabbingContentOffset: GrabbingContentOffset.top,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), 800);
    });
    test('Testing with pixels 750 and offset bottom', () {
      var snappingPosition = SnappingPosition.pixels(
        positionPixels: 750,
        grabbingContentOffset: GrabbingContentOffset.bottom,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), 700);
    });
    test('Testing overshoot position', () {
      var snappingPosition = SnappingPosition.pixels(
        positionPixels: 1200,
        grabbingContentOffset: GrabbingContentOffset.middle,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), 1200);
    });
    test('Testing undershoot position', () {
      var snappingPosition = SnappingPosition.pixels(
        positionPixels: -1200,
        grabbingContentOffset: GrabbingContentOffset.middle,
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), -1200);
    });
  });

  group("Testing optional parameters", () {
    test('Testing with default different parameters', () {
      var snappingPosition = SnappingPosition.pixels(
        positionPixels: 200,
        grabbingContentOffset: GrabbingContentOffset.middle,
        snappingCurve: Curves.decelerate,
        snappingDuration: Duration(seconds: 4),
      );
      expect(snappingPosition.getPositionInPixels(1000, 100), 200);
    });
  });
}
