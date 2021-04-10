abstract class SheetSizeBehavior {
  const SheetSizeBehavior();
}

/// Fills the available hight in a sheet.
class SheetSizeFill implements SheetSizeBehavior {
  /// If set to `true`, the [SnappingSheetContent.child] will be constrained
  /// to the sheet's visible area as it expands.
  ///
  /// Otherwise, it will be constrained to the maximum size that the sheet can
  /// expand to, and clipped.
  final bool constrainToVisibleArea;

  const SheetSizeFill({this.constrainToVisibleArea = true});
}

/// Make the sheet have a static height.
class SheetSizeStatic implements SheetSizeBehavior {
  /// If true, the sheet expands to the available height when it is greater
  /// than the given [height].
  final bool expandOnOverflow;

  /// The height of the sheet
  final double height;

  SheetSizeStatic({
    this.expandOnOverflow = true,
    required this.height,
  });
}
