# Snapping sheet

A package that provides a highly customizable bottom sheet widget that snaps to different vertical positions

<table>
    <tr>
        <td>Using only placeholders</td>
        <td>A more robust example</td>
    <tr>
    <tr>
        <td>
            <img src="https://raw.githubusercontent.com/AdamJonsson/snapping_sheet/master/assets/layoutExample.gif" width="275">
        </td>
        <td>
            <img src="https://raw.githubusercontent.com/AdamJonsson/snapping_sheet/master/assets/useExample.gif" width="275">
        </td>
    </tr>
</table>

## Quick start

Begin by following the install instruction.

You can add the snapping sheet to you app by adding the following code
```dart
    import 'package:flutter/material.dart';
    import 'package:snapping_sheet/snapping_sheet.dart';

    class SnapSheetExample extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
            return Scaffold(
            body: SnappingSheet(
                    sheet: Container(
                        color: Colors.red
                    ),
                    grabing: Container(
                        color: Colors.blue,
                    ),
                ),
            );
        }
    }
```

## Snap positions

To change the snap positions for the sheet, change the `snapPositions` parameter 
witch takes in a list of `SnapPosition`.

```dart
    SnappingSheet(
        snapPositions: [
            SnapPosition(
                positionPixel: 25.0, 
                snappingCurve: Curves.elasticOut, 
                snappingDuration: Duration(milliseconds: 750)
            ),
            SnapPosition(
                positionFactor: 0.5, 
                snappingCurve: Curves.ease, 
                snappingDuration: Duration(milliseconds: 500)
            ),
        ],
    )
```
