abstract class SheetSizeBehavior {
  const SheetSizeBehavior();
}

/// Fills the available hight in a sheet.
class SheetSizeFill implements SheetSizeBehavior {
  const SheetSizeFill();
}

/// Make the sheet have a static height.
class SheetSizeStatic implements SheetSizeBehavior {
  /// If true, the sheet expands to the available height when it is greater
  /// than the given [size].
  final bool expandOnOverflow;

  /// The height of the sheet
  final double size;

  SheetSizeStatic({
    this.expandOnOverflow = true,
    required this.size,
  });
}
