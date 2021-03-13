abstract class SheetSizeBehavior {
  const SheetSizeBehavior();
}

class SheetSizeDynamic implements SheetSizeBehavior {
  const SheetSizeDynamic();
}

class SheetSizeStatic implements SheetSizeBehavior {
  final bool expandOnOverflow;
  final double height;

  SheetSizeStatic({
    required this.expandOnOverflow,
    required this.height,
  });
}
