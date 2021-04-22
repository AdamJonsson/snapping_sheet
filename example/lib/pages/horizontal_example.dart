import 'package:example/shared/appbar.dart';
import 'package:example/shared/dummy_background.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class HorizontalExample extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DarkAppBar(title: "Snapping Sheet").build(context),
      body: Stack(
        children: [
          DummyBackgroundContent(),
          Positioned(
            right: 0,
            left: 0,
            top: 200,
            height: 100,
            child: SnappingSheet.horizontal(
              lockOverflowDrag: true,
              snappingPositions: [
                SnappingPosition.factor(
                  positionFactor: 1.0,
                  grabbingContentOffset: GrabbingContentOffset.bottom,
                ),
                SnappingPosition.factor(
                  positionFactor: 0.5,
                ),
                SnappingPosition.factor(
                  positionFactor: 0.2,
                ),
              ],
              grabbingWidth: 50,
              grabbing: _GrabbingWidget(),
              sheetRight: SnappingSheetContent(
                draggable: true,
                childScrollController: _scrollController,
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.all(15),
                    scrollDirection: Axis.horizontal,
                    children: [
                      NumberBox(number: "1"),
                      NumberBox(number: "2"),
                      NumberBox(number: "3"),
                      NumberBox(number: "4"),
                      NumberBox(number: "5"),
                      NumberBox(number: "6"),
                      NumberBox(number: "7"),
                      NumberBox(number: "8"),
                      NumberBox(number: "9"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GrabbingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15),
            width: 7,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          Container(
            width: 2,
            color: Colors.grey[300],
            margin: EdgeInsets.only(top: 15, bottom: 15),
          )
        ],
      ),
    );
  }
}

class NumberBox extends StatelessWidget {
  final String number;

  const NumberBox({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Center(child: Text(number)),
      width: 75,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.lightGreen[300],
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }
}
