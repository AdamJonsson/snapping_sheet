import 'dart:math';

import 'package:snapping_sheet/src/snapping_position.dart';

enum DragDirection {
  up,
  down,
}

class SnappingCalculator {
  final List<SnappingPosition> allSnappingPositions;
  final SnappingPosition lastSnappingPosition;
  final double maxHeight;
  final double grabbingHeight;
  final double currentPosition;

  const SnappingCalculator({
    required this.allSnappingPositions,
    required this.lastSnappingPosition,
    required this.maxHeight,
    required this.grabbingHeight,
    required this.currentPosition,
  });

  SnappingPosition getBestSnappingPosition() {
    var snappingPositionsSorted = _getSnappingPositionInSizeOrder();
    if (currentPosition > getBiggestPositionPixels())
      return snappingPositionsSorted.last;
    if (currentPosition < getSmallestPositionPixels())
      return snappingPositionsSorted.first;

    var relevantSnappingPositions = _getRelevantSnappingPositions();
    return _getClosestSnappingPosition(relevantSnappingPositions);
  }

  SnappingPosition _getClosestSnappingPosition(
    List<SnappingPosition> snappingPositionsToCheck,
  ) {
    double? minDistance;
    SnappingPosition? closestSnappingPosition;
    snappingPositionsToCheck.forEach((snappingPosition) {
      double sensitivityFactor =
          snappingPosition == lastSnappingPosition ? 5.0 : 1.0;
      double distance =
          _getDistanceToSnappingPosition(snappingPosition) * sensitivityFactor;

      if (minDistance == null || distance < minDistance!) {
        minDistance = distance;
        closestSnappingPosition = snappingPosition;
      }
    });
    return closestSnappingPosition!;
  }

  /// Exclude all the snapping positions that are not on the same side as the
  /// drag direction. That is, if drag direction is up, all the snapping
  /// position located below the last snapping positions are ignored. Also, if
  /// the drag direction is down, all the snapping positions above the last
  /// snapping position are ignored.
  List<SnappingPosition> _getRelevantSnappingPositions() {
    var dragDirection = _getDragDirection();

    return allSnappingPositions.where((snappingPosition) {
      // Always include the last snapping position
      if (snappingPosition == lastSnappingPosition) return true;

      double posPixels = snappingPosition.getPositionInPixels(
        this.maxHeight,
        this.grabbingHeight,
      );

      // We have a perfect match. Often happens when overflow drag.
      if (posPixels == currentPosition) return true;

      bool isAbove = posPixels > currentPosition;

      if (isAbove && dragDirection == DragDirection.down) return false;
      if (!isAbove && dragDirection == DragDirection.up) return false;
      return true;
    }).toList();
  }

  double getBiggestPositionPixels() {
    return _getSnappingPositionsPositionInPixels().reduce(max);
  }

  double getSmallestPositionPixels() {
    return _getSnappingPositionsPositionInPixels().reduce(min);
  }

  List<double> _getSnappingPositionsPositionInPixels() {
    return this.allSnappingPositions.map((snappingPosition) {
      return snappingPosition.getPositionInPixels(maxHeight, grabbingHeight);
    }).toList();
  }

  DragDirection _getDragDirection() {
    double lastPosPixel = this.lastSnappingPosition.getPositionInPixels(
          this.maxHeight,
          this.grabbingHeight,
        );
    if (this.currentPosition > lastPosPixel)
      return DragDirection.up;
    else
      return DragDirection.down;
  }

  double _getDistanceToSnappingPosition(SnappingPosition snappingPosition) {
    double pos = snappingPosition.getPositionInPixels(
      this.maxHeight,
      this.grabbingHeight,
    );
    return (pos - this.currentPosition).abs();
  }

  List<SnappingPosition> _getSnappingPositionInSizeOrder() {
    var snappingPositionsToSort = [...this.allSnappingPositions];
    snappingPositionsToSort.sort((a, b) {
      return a
          .getPositionInPixels(maxHeight, grabbingHeight)
          .compareTo(b.getPositionInPixels(maxHeight, grabbingHeight));
    });
    return snappingPositionsToSort;
  }
}
