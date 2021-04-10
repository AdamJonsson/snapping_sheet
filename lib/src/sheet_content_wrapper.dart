import 'package:flutter/widgets.dart';
import 'package:snapping_sheet/src/on_drag_wrapper.dart';
import 'package:snapping_sheet/src/scroll_controller_override.dart';
import 'package:snapping_sheet/src/sheet_size_calculator.dart';
import 'package:snapping_sheet/src/snapping_calculator.dart';
import 'package:snapping_sheet/src/snapping_sheet_content.dart';

class SheetContentWrapper extends StatefulWidget {
  final SheetSizeCalculator sizeCalculator;
  final SnappingSheetContent? sheetData;

  final Function(double) dragUpdate;
  final VoidCallback dragEnd;
  final double currentPosition;
  final SnappingCalculator snappingCalculator;

  const SheetContentWrapper(
      {Key? key,
      required this.sheetData,
      required this.sizeCalculator,
      required this.currentPosition,
      required this.snappingCalculator,
      required this.dragUpdate,
      required this.dragEnd})
      : super(key: key);

  @override
  _SheetContentWrapperState createState() => _SheetContentWrapperState();
}

class _SheetContentWrapperState extends State<SheetContentWrapper> {
  Widget _wrapWithDragWrapper(Widget child) {
    return OnDragWrapper(
      dragEnd: widget.dragEnd,
      child: child,
      dragUpdate: widget.dragUpdate,
    );
  }

  Widget _wrapWithScrollControllerOverride(Widget child) {
    return ScrollControllerOverride(
      sizeCalculator: widget.sizeCalculator,
      scrollController: widget.sheetData!.childScrollController!,
      dragUpdate: widget.dragUpdate,
      dragEnd: widget.dragEnd,
      currentPosition: widget.currentPosition,
      snappingCalculator: widget.snappingCalculator,
      sheetLocation: widget.sheetData!.location,
      child: child,
    );
  }

  Widget _wrapWithNecessaryWidgets(Widget child) {
    Widget wrappedChild = child;
    if (widget.sheetData!.draggable) {
      if (widget.sheetData!.childScrollController != null) {
        wrappedChild = _wrapWithScrollControllerOverride(wrappedChild);
      } else {
        wrappedChild = _wrapWithDragWrapper(wrappedChild);
      }
    }
    return wrappedChild;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sheetData == null) return SizedBox();
    return widget.sizeCalculator.positionWidget(
      child: _wrapWithNecessaryWidgets(widget.sheetData!
          .buildConstrainedChild(widget.sizeCalculator.maxHeight)),
    );
  }
}
