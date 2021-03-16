abstract class SheetSizeBehavior {
  const SheetSizeBehavior();
}

class SheetSizeFill implements SheetSizeBehavior {
  const SheetSizeFill();
}

class SheetSizeStatic implements SheetSizeBehavior {
  final bool expandOnOverflow;
  final double height;

  SheetSizeStatic({
    required this.expandOnOverflow,
    required this.height,
  });
}
