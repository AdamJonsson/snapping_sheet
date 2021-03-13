import 'package:flutter/widgets.dart';
import 'package:snapping_sheet/src/on_drag_wrapper.dart';
import 'package:snapping_sheet/src/sheet_size_calculator.dart';
import 'package:snapping_sheet/src/snapping_sheet_content.dart';

class SheetContentWrapper extends StatelessWidget {
  final SheetSizeCalculator sizeCalculator;
  final SnappingSheetContent? sheetData;

  final Function(double) dragUpdate;
  final VoidCallback dragStart;
  final VoidCallback dragEnd;

  const SheetContentWrapper(
      {Key? key,
      required this.sheetData,
      required this.sizeCalculator,
      required this.dragUpdate,
      required this.dragStart,
      required this.dragEnd})
      : super(key: key);

  Widget _wrapSheetDataWithDraggable() {
    if (!sheetData!.draggable) return sheetData!;
    return OnDragWrapper(
      dragStart: dragStart,
      dragEnd: dragEnd,
      child: sheetData!,
      dragUpdate: dragUpdate,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (sheetData == null) return SizedBox();
    return sizeCalculator.positionWidget(child: _wrapSheetDataWithDraggable());
  }
}
