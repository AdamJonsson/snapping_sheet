import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class LayoutSnapSheetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Layout example'),
      ),
      body: SnappingSheet(
        child: Placeholder(color: Colors.red,),
        sheet: Placeholder(color: Colors.blue,),
        grabbing: Container(
          color: Colors.white.withOpacity(0.0),
          child: Placeholder(color: Colors.green,),
        ),
        remaining: Placeholder(color: Colors.purple,),
      ),
    );
  }
}