import 'package:flutter/widgets.dart';
import 'sheet_size_behaviors.dart';

enum SheetLocation {
  above,
  below,
  unknown,
}

class SnappingSheetContent {
  /// The size behavior of the sheet. Can either be [SheetSizeStatic] or
  /// [SheetSizeFill].
  final SheetSizeBehavior sizeBehavior;

  /// When given a scroll controller that is attached to scrollable view, e.g
  /// [ListView] or a [SingleChildScrollView], the sheet will naturally grow
  /// and shrink according to the current scroll position of that view.
  ///
  /// OBS, the scrollable view needs to have the [reverse] parameter set to
  /// false if located in the below sheet and true if located in the above
  /// sheet. Otherwise, the logic do not behave as intended.
  final ScrollController? childScrollController;

  /// If the content should be draggable.
  final bool draggable;
  Widget _child;
  SheetLocation location = SheetLocation.unknown;

  SnappingSheetContent({
    required Widget child,
    this.draggable = false,
    this.sizeBehavior = const SheetSizeFill(),
    this.childScrollController,
  }) : this._child = child;

  double? _getHeight(double maxHeight) {
    var sizeBehavior = this.sizeBehavior;
    if (sizeBehavior is SheetSizeStatic) return sizeBehavior.height;
    if (sizeBehavior is SheetSizeFill && !sizeBehavior.constrainToVisibleArea)
      return maxHeight;
  }

  Widget buildConstrainedChild(double maxHeight) {
    assert(location != SheetLocation.unknown,
        'The location must be known to constrain the child!');
    return OverflowBox(
      alignment: location == SheetLocation.above
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      minHeight: _getHeight(maxHeight),
      maxHeight: _getHeight(maxHeight),
      child: this._child,
    );
  }
}
