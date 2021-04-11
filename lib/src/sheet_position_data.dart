class SheetPositionData {
  final double _pixels;
  final double _relativeToSheetHeight;
  final double _relativeToSnappingPositions;

  SheetPositionData(
    this._pixels,
    this._relativeToSheetHeight,
    this._relativeToSnappingPositions,
  );

  /// This is the sheets positions in pixels calculated from bottom to top.
  double get pixels => _pixels;

  /// This is a value often ranging between 0 and 1. The value 0 means that the
  /// sheet is at the bottom of the available height and the value 1 means that
  /// it is at the top.
  double get relativeToSheetHeight => _relativeToSheetHeight;

  /// This is a value often ranging between 0 and 1. The value 0 means that the
  /// sheet is at smallest snapping position and the value 1 means that it is at
  /// the biggest snapping position.
  double get relativeToSnappingPositions => _relativeToSnappingPositions;
}
