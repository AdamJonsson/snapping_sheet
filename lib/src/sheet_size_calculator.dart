import 'package:flutter/widgets.dart';
import 'package:snapping_sheet/src/sheet_size_behaviors.dart';
import 'package:snapping_sheet/src/snapping_sheet_content.dart';

abstract class SheetSizeCalculator {
  final SnappingSheetContent sheetData;
  final double maxHeight;

  SheetSizeCalculator(
    this.sheetData,
    this.maxHeight,
  );

  double? getSheetStartPosition() {
    var sizeBehavior = sheetData.sizeBehavior;
    if (sizeBehavior is SheetSizeDynamic) return 0;
    if (sizeBehavior is SheetSizeStatic) {
      if (!sizeBehavior.expandOnOverflow) return null;
      if (getVisibleHeight() > sizeBehavior.height) {
        return 0;
      }
    }
    return null;
  }

  double getVisibleHeight();
  double getSheetEndPosition();
  Positioned positionWidget({required Widget child});
}
