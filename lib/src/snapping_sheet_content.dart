import 'package:flutter/widgets.dart';
import 'sheet_size_behaviors.dart';

enum SnappingSheetContentSize {
  // The size of the sheet content changes to the available height
  dynamicSize,

  /// The size is static and do not change when the sheet is dragged
  staticSize,
}

class SnappingSheetContent extends StatelessWidget {
  final SheetSizeBehavior sizeBehavior;
  final Widget child;
  final bool draggable;

  SnappingSheetContent({
    Key? key,
    required this.child,
    this.draggable = false,
    this.sizeBehavior = const SheetSizeDynamic(),
  }) : super(key: key);

  double? _getHeight() {
    var sizeBehavior = this.sizeBehavior;
    if (sizeBehavior is SheetSizeStatic) return sizeBehavior.height;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _getHeight(),
      child: this.child,
    );
  }
}
