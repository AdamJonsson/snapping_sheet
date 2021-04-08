import 'package:snapping_sheet/src/snapping_position.dart';

/// A callback used to report snap events like starting and stopping.
typedef SnapEventCallback = Function(
  double position,
  double maximumPosition,
  SnappingPosition snappingPosition,
);
