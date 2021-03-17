import 'package:flutter/widgets.dart';

/// This class is an helper class for specifying the [grabbingContentOffset]
/// param in a given [SnappingPosition].
class GrabbingContentOffset {
  /// The snapping position aligns at the top part of the grabbing content
  static const top = 1.0;

  /// The snapping position aligns at the middle part of the grabbing content
  static const middle = 0.0;

  /// The snapping position aligns at the bottom part of the grabbing content
  static const bottom = -1.0;
}

class SnappingPosition {
  final double? _positionPixel;
  final double? _positionFactor;

  /// The snapping position alignment regarding the grabbing content.
  ///
  /// This is often used when you want a snapping position at the top or bottom
  /// of the screen, but want the entire grabbing widget to be visible.
  ///
  /// For example, if you have a snapping position at the top of the screen,
  /// you usually use [GrabbingContentOffset.bottom]. See example:
  /// ```dart
  /// SnappingPosition.factor(
  ///   positionFactor: 1.0,
  ///   grabbingContentOffset: GrabbingContentOffset.bottom,
  /// ),
  /// ```
  ///
  /// Or if you have a snapping position at the bottom of the screen, you
  /// usually use [GrabbingContentOffset.bottom]. See example:
  /// ```dart
  /// SnappingPosition.factor(
  ///   positionFactor: 0.0,
  ///   grabbingContentOffset: GrabbingContentOffset.top,
  /// ),
  /// ```
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
  /// and smaller than 0 if that is wanted.
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

  bool operator ==(other) =>
      other is SnappingPosition &&
      other._positionFactor == this._positionFactor &&
      other._positionPixel == this._positionPixel;
  int get hashCode => _positionFactor.hashCode ^ _positionPixel.hashCode;
}
