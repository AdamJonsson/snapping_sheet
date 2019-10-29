import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class PlaceholderSnapSheetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placeholder example'),
      ),
      body: SnappingSheet(
        child: Placeholder(color: Colors.red,),
        sheetBelow: Placeholder(color: Colors.blue,),
        grabbing: Container(
          color: Colors.white.withOpacity(0.0),
          child: Placeholder(color: Colors.green,),
        ),
        sheetAbove: Placeholder(color: Colors.purple,),
      ),
    );
  }
}