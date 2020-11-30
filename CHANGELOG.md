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
