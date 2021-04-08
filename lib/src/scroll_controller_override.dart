import 'package:flutter/widgets.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:snapping_sheet/src/sheet_size_calculator.dart';
import 'package:snapping_sheet/src/snapping_calculator.dart';

class ScrollControllerOverride extends StatefulWidget {
  final SheetSizeCalculator sizeCalculator;
  final ScrollController scrollController;
  final SheetLocation sheetLocation;
  final Widget child;

  final Function(double) dragUpdate;
  final VoidCallback dragEnd;
  final double currentPosition;
  final SnappingCalculator snappingCalculator;

  ScrollControllerOverride({
    required this.sizeCalculator,
    required this.scrollController,
    required this.dragUpdate,
    required this.dragEnd,
    required this.currentPosition,
    required this.snappingCalculator,
    required this.child,
    required this.sheetLocation,
  });

  @override
  _ScrollControllerOverrideState createState() =>
      _ScrollControllerOverrideState();
}

class _ScrollControllerOverrideState extends State<ScrollControllerOverride> {
  DragDirection? _currentDragDirection;
  double _currentLockPosition = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.removeListener(_onScrollUpdate);
    widget.scrollController.addListener(_onScrollUpdate);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScrollUpdate);
    super.dispose();
  }

  void _onScrollUpdate() {
    if (!_allowScrolling) _lockScrollPosition(widget.scrollController);
  }

  void _overrideScroll(double dragAmount) {
    if (!_allowScrolling) widget.dragUpdate(dragAmount);
  }

  void _setLockPosition() {
    if (_currentDragDirection == DragDirection.up &&
            widget.sheetLocation == SheetLocation.below ||
        _currentDragDirection == DragDirection.down &&
            widget.sheetLocation == SheetLocation.above) {
      _currentLockPosition = widget.scrollController.position.pixels;
    } else {
      _currentLockPosition = 0;
    }
  }

  bool get _allowScrolling {
    if (widget.sheetLocation == SheetLocation.below) {
      if (_currentDragDirection == DragDirection.up) {
        if (widget.currentPosition >= _biggestSnapPos)
          return true;
        else
          return false;
      }
      if (_currentDragDirection == DragDirection.down) {
        if (widget.scrollController.position.pixels > 0) return true;
        if (widget.currentPosition <= _smallestSnapPos)
          return true;
        else
          return false;
      }
    }

    if (widget.sheetLocation == SheetLocation.above) {
      if (_currentDragDirection == DragDirection.down) {
        if (widget.currentPosition <= _smallestSnapPos) {
          return true;
        } else
          return false;
      }
      if (_currentDragDirection == DragDirection.up) {
        if (widget.scrollController.position.pixels > 0) return true;
        if (widget.currentPosition >= _biggestSnapPos)
          return true;
        else
          return false;
      }
    }

    return false;
  }

  double get _biggestSnapPos =>
      widget.snappingCalculator.getBiggestPositionPixels();
  double get _smallestSnapPos =>
      widget.snappingCalculator.getSmallestPositionPixels();

  void _lockScrollPosition(ScrollController controller) {
    controller.position.setPixels(_currentLockPosition);
  }

  void _setDragDirection(double dragAmount) {
    this._currentDragDirection =
        dragAmount > 0 ? DragDirection.down : DragDirection.up;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (dragEvent) {
        _setDragDirection(dragEvent.delta.dy);
        _setLockPosition();
        _overrideScroll(dragEvent.delta.dy);
      },
      onPointerUp: (_) {
        if (!_allowScrolling)
          widget.scrollController.jumpTo(_currentLockPosition);
        widget.dragEnd();
      },
      child: widget.child,
    );
  }
}
