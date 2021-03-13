import 'package:flutter/widgets.dart';
import 'package:snapping_sheet/src/above_sheet_size_calculator.dart';
import 'package:snapping_sheet/src/below_sheet_size_calculator.dart';
import 'package:snapping_sheet/src/on_drag_wrapper.dart';
import 'package:snapping_sheet/src/sheet_content_wrapper.dart';
import 'package:snapping_sheet/src/snapping_calculator.dart';
import 'package:snapping_sheet/src/snapping_position.dart';
import 'package:snapping_sheet/src/snapping_sheet_content.dart';

class SnappingSheet extends StatefulWidget {
  final SnappingSheetContent? sheetAbove;
  final SnappingSheetContent? sheetBelow;
  final Widget grabbing;
  final double grabbingHeight;
  final Widget child;
  final bool lockOverflowDrag;
  final List<SnappingPosition> snappingPositions;
  final SnappingPosition? initialSnappingPosition;

  SnappingSheet({
    Key? key,
    this.sheetAbove,
    this.sheetBelow,
    this.grabbing = const SizedBox(),
    this.grabbingHeight = 0,
    this.snappingPositions = const [
      SnappingPosition.factor(
        positionFactor: 0.0,
        grabbingContentOffset: GrabbingContentOffset.top,
      ),
      SnappingPosition.factor(positionFactor: 0.5),
      SnappingPosition.factor(
        positionFactor: 1.0,
        grabbingContentOffset: GrabbingContentOffset.bottom,
      ),
    ],
    this.initialSnappingPosition,
    required this.child,
    this.lockOverflowDrag = false,
  })  : assert(snappingPositions.isNotEmpty),
        super(key: key);

  @override
  _SnappingSheetState createState() => _SnappingSheetState();
}

class _SnappingSheetState extends State<SnappingSheet>
    with TickerProviderStateMixin {
  double _currentPosition = 200;
  BoxConstraints? _latestConstraints;
  late SnappingPosition _lastSnappingPosition;
  late AnimationController _animationController;
  Animation<double>? _snappingAnimation;

  @override
  void initState() {
    super.initState();
    _lastSnappingPosition = initSnappingPosition;
    _animationController = AnimationController(vsync: this);
    _animationController.addListener(() {
      if (_snappingAnimation == null) return;
      setState(() {
        _currentPosition = _snappingAnimation!.value;
      });
    });

    Future.delayed(Duration(seconds: 0)).then((value) {
      setState(() {
        _currentPosition = initSnappingPosition.getPositionInPixels(
          _latestConstraints!.maxHeight,
          widget.grabbingHeight,
        );
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  SnappingPosition get initSnappingPosition {
    return widget.initialSnappingPosition ?? widget.snappingPositions.first;
  }

  double _getNewPosition(double dragAmount) {
    var newPosition = _currentPosition - dragAmount;
    if (widget.lockOverflowDrag) {
      var calculator = SnappingCalculator(
          allSnappingPositions: widget.snappingPositions,
          lastSnappingPosition: _lastSnappingPosition,
          maxHeight: _latestConstraints!.maxHeight,
          grabbingHeight: widget.grabbingHeight,
          currentPosition: _currentPosition);
      var maxPos = calculator.getBiggestPositionPixels();
      var minPos = calculator.getSmallestPositionPixels();
      if (newPosition > maxPos) return maxPos;
      if (newPosition < minPos) return minPos;
    }
    return newPosition;
  }

  void _dragSheet(double dragAmount) {
    setState(() {
      _currentPosition = _getNewPosition(dragAmount);
    });
  }

  void _dragEnd() {
    var bestSnappingPosition = SnappingCalculator(
            allSnappingPositions: widget.snappingPositions,
            lastSnappingPosition: _lastSnappingPosition,
            maxHeight: _latestConstraints!.maxHeight,
            grabbingHeight: widget.grabbingHeight,
            currentPosition: _currentPosition)
        .getBestSnappingPosition();
    _snapToPosition(bestSnappingPosition);
  }

  void _dragStart() {
    _animationController.stop();
  }

  void _snapToPosition(SnappingPosition snappingPosition) {
    _animateToPosition(snappingPosition);
    _lastSnappingPosition = snappingPosition;
  }

  void _animateToPosition(SnappingPosition snappingPosition) {
    _animationController.duration = snappingPosition.snappingDuration;
    var endPosition = snappingPosition.getPositionInPixels(
      _latestConstraints!.maxHeight,
      widget.grabbingHeight,
    );
    _snappingAnimation = Tween(
      begin: _currentPosition,
      end: endPosition,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: snappingPosition.snappingCurve,
      ),
    );
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _latestConstraints = constraints;
        return Container(
          constraints: BoxConstraints.expand(),
          child: Stack(
            children: [
              // The background of the snapping sheet
              Positioned.fill(child: widget.child),

              // The above sheet content
              SheetContentWrapper(
                dragEnd: _dragEnd,
                dragStart: _dragStart,
                dragUpdate: _dragSheet,
                sizeCalculator: AboveSheetSizeCalculator(
                  sheetData: widget.sheetAbove!,
                  currentPosition: _currentPosition,
                  maxHeight: constraints.maxHeight,
                  grabbingHeight: widget.grabbingHeight,
                ),
                sheetData: widget.sheetAbove,
              ),

              // The grabber content
              Positioned(
                left: 0,
                right: 0,
                bottom: _currentPosition - widget.grabbingHeight / 2,
                height: widget.grabbingHeight,
                child: OnDragWrapper(
                  dragEnd: _dragEnd,
                  dragStart: _dragStart,
                  dragUpdate: _dragSheet,
                  child: widget.grabbing,
                ),
              ),

              // The below sheet content
              SheetContentWrapper(
                dragEnd: _dragEnd,
                dragStart: _dragStart,
                dragUpdate: _dragSheet,
                sizeCalculator: BelowSheetSizeCalculator(
                  sheetData: widget.sheetBelow!,
                  currentPosition: _currentPosition,
                  maxHeight: constraints.maxHeight,
                  grabbingHeight: widget.grabbingHeight,
                ),
                sheetData: widget.sheetBelow,
              ),
            ],
          ),
        );
      },
    );
  }
}
