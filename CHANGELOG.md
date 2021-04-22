## [3.1.0] - 22/04/2021
* **New feature**: Horizontal snapping sheets are not possible using `SnappingSheet.horizontal(...)`!
* **New feature**: `controller.snapToPosition` returns a future. 
* **Breaking**: New and more callback data on moving events.
* **Breaking**: `SheetSizeStatic(height: 123)` is now `SheetSizeStatic(size: 123)`.
* Remove debug output
  
## [3.0.0+2] - 17/03/2021
* Minor documentation changes
  
## [3.0.0+1] - 17/03/2021
* Fix image previews in README
  
## [3.0.0] - 17/03/2021
* **FULL REFACTORING OF PROJECT**. The package has gone through a full refactoring while adding null-safety. Be aware of many breaking changes, it is strongly recommended to read the documentation of this package again if updating from a earlier version of Snapping Sheet.
* Added many many test for the package to make it more stable and easier to maintain in the feature.
* The Snapping Sheet can now adapt to a scrollable widget located inside it.
* To Snapping Sheet no longer gets stuck at certain positions.

## [3.0.0-nullsafety.0] - 11/03/2021
* First step for null-safety migration. Thanks to [ngxingyu](https://github.com/ngxingyu) for the PR!
**Breaking change:** Replace positionFactor and positionPixel with position and added isFactor parameter.

## [2.0.2] - 30/11/2020
* Fix bug where the snapping sheet could be stuck at the first snapping position when lockOverflowDrag is set to true. Thanks to [b1acKr0se](https://github.com/b1acKr0se) for finding a solution!
**Breaking change:** Change the spelling from "manuel" to "manual" for the SnappingSheetHeight object.

## [2.0.1] - 18/07/2020
* Fix bug where the snapping sheet do not correct it self when the orientation of the device is changed.
  
## [2.0.0] - 07/05/2020
* **Breaking change:** The sheetBelow and sheetAbove parameters now takes in a [snappingSheetContent] widget instead of any widget. To fix, just wrap your current widget with a [snappingSheetContent] widget.
* **Breaking change** Changed so that sheetAboveMargin and sheetBelowMargin must specified in the[snappingSheetContent] widget.
* **Breaking change** Changed so that sheetBelowDraggable and sheetAboveDraggable must specified in the[snappingSheetContent] widget.
* Add the option to specify a heigh behavior when the size of the sheet is changing.

## [1.1.2] - 04/03/2020

* Fix error when sheet dragged after last or first [snappingPosition]. Thank you [N1ght-Fury](https://github.com/N1ght-Fury)
* Remove required syntax for [sheetBlow] parameter. Thank you [Nico04](https://github.com/Nico04)
  
## [1.1.1] - 12/11/2019

* Fix a dragging bug where the grabbing widget is stuck when lockOverflowDrag was set to true

## [1.1.0] - 29/10/2019

* Added the option to make sheetBelow and sheetAbove widget draggable.
* Added the option to lock overflow drag.
* Added new example of using a top sheet.
* Fix minor bugs with the snapping system.
  
## [1.0.0] - 18/10/2019

* Breaking changes, renamed parameters such as
  * sheet -> sheetBelow
  * remaining -> sheetAbove
  * grabing -> grabbing
  * grabingHeight -> grabbingHeight
  * remainingMargin -> sheetAboveMargin
  * snapSheetController -> snappingSheetController

* The option to add negative and positive margin to the sheetBelow widget
* The sheetBelow and sheetAbove widgets are now optional


## [0.1.0] - 07/10/2019

* Improve the snap system for the sheet. Now the sheet only snaps to above snap positions if dragging upwards and snap positions below if dragging downwards
* Made the background widget (child) optional
  
## [0.0.2] - 04/10/2019

* Updated the pubspec description
  
## [0.0.1] - 04/10/2019

* The initial release
