<img src="https://github.com/AdamJonsson/snapping_sheet/raw/3.0.0/assets/ReadmeBanner.png">

# Snapping Sheet
![example workflow](https://github.com/adamjonsson/snapping_sheet/actions/workflows/dart.yml/badge.svg)
[![pub points](https://badges.bar/snapping_sheet/pub%20points)](https://pub.dev/packages/snapping_sheet/score)
[![popularity](https://badges.bar/snapping_sheet/popularity)](https://pub.dev/packages/snapping_sheet/score)
[![likes](https://badges.bar/snapping_sheet/likes)](https://pub.dev/packages/snapping_sheet/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A package that provides a highly customizable sheet widget that snaps to different vertical positions
</br></br>
<table >
    <tr>
        <td>
            <b>
                Can adapt to scrollable <br> 
                widgets inside the sheet.
            </b>
        </td>
        <td>
            <b>
                Fully customizable animation </br> 
                and content.
            </b>
        </td>
        <td>
            <b>
                Not limited to the bottom part 
                </br> of the app.
            </b>
        </td>
    <tr>
    <tr>
        <td>
            <img src="https://github.com/AdamJonsson/snapping_sheet/raw/3.0.0/assets/preview.gif" width="300">
        </td>
        <td>
            <img src="https://github.com/AdamJonsson/snapping_sheet/raw/3.0.0/assets/placeholder.gif" width="300">
        </td>
        <td>
            <img src="https://github.com/AdamJonsson/snapping_sheet/raw/3.0.0/assets/preview_reverse.gif" width="300">
        </td>
    </tr>
</table>
</br>

You can find and run the examples closing this repository and running the app from the [example](https://github.com/AdamJonsson/snapping_sheet/example/) folder.

## Getting started

As usual, begin by adding the package to your pubspec.yaml file, see [install instruction](https://pub.dev/packages/snapping_sheet#-installing-tab-).

Here is the most basic setup with the Snapping Sheet:
```dart
    import 'package:flutter/material.dart';
    import 'package:snapping_sheet/snapping_sheet.dart';

    class GettingStartedExample extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
            return Scaffold(
                body: SnappingSheet(
                    // TODO: Add your content that is placed
                    // behind the sheet.
                    child: MyOwnPageContent(), 
                    grabbingHeight: 75,
                    // TODO: Add your grabbing widget here,
                    grabbing: MyOwnGrabbingWidget(),
                    sheetAbove: SnappingSheetContent(
                        draggable: true,
                        // TODO: Add your sheet content here
                        child: MyOwnSheetContent(),
                    ),
                ),
            );
        }
    }
```

## Customize snapping positions

To change the snap positions for the sheet, change the `snappingPositions` parameter 
witch takes in a list of `SnappingPosition.factor` or `SnappingPosition.pixels`. These 
two objects are used to specify the location using a factor or pixels. You also have the option 
to specify the duration and curve of how the sheet should snap to that given position.

```dart
    SnappingSheet(
        snappingPositions: [
            SnappingPosition.factor(
                positionFactor: 0.0,
                snappingCurve: Curves.easeOutExpo,
                snappingDuration: Duration(seconds: 1),
                grabbingContentOffset: GrabbingContentOffset.top,
            ),
            SnappingPosition.pixels(
                positionPixels: 400,
                snappingCurve: Curves.elasticOut,
                snappingDuration: Duration(milliseconds: 1750),
            ),
            SnappingPosition.factor(
                positionFactor: 1.0,
                snappingCurve: Curves.bounceOut,
                snappingDuration: Duration(seconds: 1),
                grabbingContentOffset: GrabbingContentOffset.bottom,
            ),
        ],
    )
```

## Adding content to the sheet
You can place content both below or/and above the grabbing part of the sheet. If you do not want any content in the above or below part of the sheet, pass in null. 
* **`sizeBehavior`**: How the size of the content should behave. Can either be `SheetSizeFill` which fills the available height of the sheet, or `SheetSizeStatic`, which takes in a height that is respected in the sheet.
* **`draggable`**: If the sheet itself can be draggable to expand or close the Snapping Sheet.
* **`child`**: Any Widget of your choosing.
```dart
    SnappingSheet(
        sheetAbove: SnappingSheetContent(
            sizeBehavior: SheetSizeFill(),
            draggable: false,
            child: Container(color: Colors.blue),
        ),
        sheetBelow: SnappingSheetContent(
            sizeBehavior: SheetSizeStatic(height: 300),
            draggable: true,
            child: Container(color: Colors.red),
        ),
    )
```

## Make SnappingSheet adapt to a scroll controller
In order to make the sheet know about the scroll controller, you need to provide it in the SnappingSheetContent class (See example below). It is recommended to set `lockOverflowDrag` to true to prevent the sheet to be dragged above or below its max and min snapping position.
```dart
     SnappingSheet(
        lockOverflowDrag: true, // (Recommended) Set this to true.
        sheetBelow: SnappingSheetContent(
            // Pass in the scroll controller here!
            childScrollController: _myScrollController,
            draggable: true,
            child: ListView(
                // And in the scrollable widget that you create!
                controller: _myScrollController,

                // OBS! Should be false if it is in sheetBelow.
                // OBS! Should be true if it is in sheetAbove.
                reverse: false,
            ),
        ),
    )
```
**OBS** that the scrollable widget, e.g `ListView`, `SingleChildScrollView`, etc. needs to have the correct `reverse` value depending on were it is located. If the scrollable widget is in the sheetBelow, the reverse value should be set to false. If it is located in the sheetAbove it should be set to true. The reason is that the current logic of the SnappingSheet only support that configuration of a scrollable widget.  

## Using the SnappingSheetController
You can control the Snapping Sheet using the `SnappingSheetController`
```dart
    // Create your controller
    final snappingSheetController = SnappingSheetController();
    SnappingSheet(

        // Connect it to the SnappingSheet
        controller: SnappingSheetController();

        sheetAbove: SnappingSheetContent(
            draggable: false,
            child: Container(color: Colors.blue),
        ),
        sheetBelow: SnappingSheetContent(
            draggable: true,
            child: Container(color: Colors.red),
        ),
    )

    // You can now control the sheet in multiple ways.
    snappingSheetController.snapToPosition(
      SnappingPosition.factor(positionFactor: 0.75),
    );
    snappingSheetController.stopCurrentSnapping();
    snappingSheetController.setSnappingSheetPosition(100);

    // You can also extract information from the sheet
    snappingSheetController.currentPosition;
    snappingSheetController.currentSnappingPosition;
    snappingSheetController.currentlySnapping;
    snappingSheetController.isAttached;
```

## Listen to changes
You can listen to movement and when a snapping animation is completed by using the following parameters:
```dart
    SnappingSheet(
        onSheetMoved: (sheetPosition, maximumSheetPosition) {
            print("Current position $sheetPosition");
        },
        onSnapCompleted: (sheetPosition, maximumSheetPosition, snappingPosition) {
            print("Current position $sheetPosition");
            print("Current snapping position $snappingPosition");
        },
        onSnapStart: (sheetPosition, maximumSheetPosition, snappingPosition) {
            print("Current position $sheetPosition");
            print("Next snapping position $snappingPosition");
        },
    )
```