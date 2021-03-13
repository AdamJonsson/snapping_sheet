import 'package:flutter/widgets.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:snapping_sheet/src/sheet_size_calculator.dart';
import 'package:snapping_sheet/src/snapping_sheet_content.dart';

class BelowSheetSizeCalculator extends SheetSizeCalculator {
  final SnappingSheetContent? sheetData;
  final double currentPosition;
  final double maxHeight;
  final double grabbingHeight;

  BelowSheetSizeCalculator(
      {required this.sheetData,
      required this.currentPosition,
      required this.maxHeight,
      required this.grabbingHeight})
      : super(sheetData, maxHeight);

  @override
  double getSheetEndPosition() {
    return maxHeight - currentPosition + grabbingHeight / 2;
  }

  @override
  double getVisibleHeight() {
    return maxHeight - getSheetEndPosition();
  }

  @override
  Positioned positionWidget({required Widget child}) {
    return Positioned(
      left: 0,
      right: 0,
      top: getSheetEndPosition(),
      bottom: getSheetStartPosition(),
      child: child,
    );
  }
}
