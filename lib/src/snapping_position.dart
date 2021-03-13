import 'package:flutter/widgets.dart';

class GrabbingContentOffset {
  static const top = 1.0;
  static const middle = 0.0;
  static const bottom = -1.0;
}

class SnappingPosition {
  final double? _positionPixel;
  final double? _positionFactor;

  /// How the snapping position should be offset from the grabbing content
  /// height. Must be a value between -1 and 1. Use the helper class
  /// [GrabbingContentOffset] with choosing correct offset. Default is
  /// [GrabbingContentOffset.middle]
  final double grabbingContentOffset;

  /// The animation curve to this snapping position
  final Curve snappingCurve;

  /// The snapping duration
  final Duration snappingDuration;

  /// Creates a snapping position that is given by the amount of pixels
  const SnappingPosition.pixels({
    required double positionPixels,
    this.snappingCurve = Curves.ease,
    this.snappingDuration = const Duration(milliseconds: 250),
    this.grabbingContentOffset = GrabbingContentOffset.middle,
  })  : this._positionPixel = positionPixels,
        this._positionFactor = null;

  /// Creates a snapping position that is given a positionFactor
  /// [positionFactor]: 1 = Full size; 0 = Smallest size. Can be bigger than 1
  /// and smaller than 0
  const SnappingPosition.factor({
    required double positionFactor,
    this.snappingCurve = Curves.easeOutSine,
    this.snappingDuration = const Duration(milliseconds: 250),
    this.grabbingContentOffset = GrabbingContentOffset.middle,
  })  : this._positionPixel = null,
        this._positionFactor = positionFactor;

  double getPositionInPixels(double maxHeight, double grabbingHeight) {
    var centerPosition = this._getCenterPositionInPixels(maxHeight);
    var centerOffset = grabbingHeight * this.grabbingContentOffset / 2;
    return centerPosition + centerOffset;
  }

  double _getCenterPositionInPixels(double maxHeight) {
    if (this._positionPixel != null) return this._positionPixel!;
    return this._positionFactor! * maxHeight;
  }
}
