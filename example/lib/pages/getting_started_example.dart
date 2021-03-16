import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class GettingStartedExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SnappingSheet(
        child: MyOwnPageContent(), // TODO: Add your content here
        grabbingHeight: 75,
        grabbing: MyOwnGrabbingWidget(), // TODO: Add your grabbing widget here,
        sheetAbove: SnappingSheetContent(
          draggable: true,
          child: MyOwnSheetContent(), // TODO: Add your sheet content here
        ),
      ),
    );
  }
}

class MyOwnPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

class MyOwnGrabbingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

class MyOwnSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
