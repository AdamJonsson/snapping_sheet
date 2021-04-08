import 'package:flutter/widgets.dart';
import 'package:snapping_sheet/src/above_sheet_size_calculator.dart';
import 'package:snapping_sheet/src/below_sheet_size_calculator.dart';
import 'package:snapping_sheet/src/on_drag_wrapper.dart';
import 'package:snapping_sheet/src/sheet_content_wrapper.dart';
import 'package:snapping_sheet/src/snap_event_callback.dart';
import 'package:snapping_sheet/src/snapping_calculator.dart';
import 'package:snapping_sheet/src/snapping_position.dart';
import 'package:snapping_sheet/src/snapping_sheet_content.dart';

class SnappingSheet extends StatefulWidget {
  /// The content for the above part of the sheet.
  ///
  /// Needs to be of type
  /// [SnappingSheetContent] where a widget can be passed in.
  final SnappingSheetContent? sheetAbove;

  /// The content for the below part of the sheet.
  ///
  /// Needs to be of type
  /// [SnappingSheetContent] where a widget can be passed in.
  final SnappingSheetContent? sheetBelow;

  /// The grabbing widget that is used to indicate the the sheet can be dragged
  /// up and down.
  ///
  /// If no widget is wanted, pass in a [SizedBox] with zero height
  /// and set [grabbingHeight] to zero.
  final Widget grabbing;

  /// The height of the grabbing widget.
  final double grabbingHeight;

  /// The widget under the snapping sheet.
  ///
  /// Is often the main content of a page or app.
  final Widget child;

  /// Prevents overflow drag.
  ///
  /// If set to true, the snapping sheet can not be dragged over or under the
  /// highest or lowest [SnappingPosition].
  final bool lockOverflowDrag;

  /// The snapping positions were the sheet can snap to.
  ///
  /// Takes a list of [SnappingPosition]. You can specify the location using a
  /// factor or pixels.
  ///
  /// ```dart
  /// SnappingPosition.factor(positionFactor: 0.25)
  /// SnappingPosition.pixels(positionPixels: 420)
  /// ```
  ///
  /// You also have the option to set duration and curve for each
  /// [SnappingPosition].
  ///
  /// ```dart
  /// SnappingPosition.factor(
  ///   snappingCurve: Curves.bounceOut,
  ///   snappingDuration: Duration(seconds: 1),
  ///   positionFactor: 1.0,
  /// ),
  /// ```
  final List<SnappingPosition> snappingPositions;

  /// The initial snapping position.
  ///
  /// If no value is given, the default value is the first snapping position
  /// given in the [snappingPosition] parameter.
  final SnappingPosition? initialSnappingPosition;

  /// The controller for executing commands and reading current status of the
  /// [SnappingSheet]
  final SnappingSheetController? controller;

  /// Callback for when the sheet moves.
  ///
  /// Is called every time the sheet moves, both when snapping and moving
  /// the sheet manually.
  final Function(double position, double maximumPosition)? onSheetMoved;

  /// Callback for when a snapping animation is completed.
  final SnapEventCallback? onSnapCompleted;

  /// This is called when a snapping animation starts.
  final SnapEventCallback? onSnapStart;

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
    this.controller,
    this.onSheetMoved,
    this.onSnapCompleted,
    this.onSnapStart,
  })  : assert(snappingPositions.isNotEmpty),
        super(key: key);

  @override
  _SnappingSheetState createState() => _SnappingSheetState();
}

class _SnappingSheetState extends State<SnappingSheet>
    with TickerProviderStateMixin {
  double _currentPositionPrivate = 0;
  BoxConstraints? _latestConstraints;
  late SnappingPosition _lastSnappingPosition;
  late AnimationController _animationController;
  Animation<double>? _snappingAnimation;

  @override
  void initState() {
    super.initState();
    _setSheetLocationData();

    _lastSnappingPosition = _initSnappingPosition;
    _animationController = AnimationController(vsync: this);
    _animationController.addListener(() {
      if (_snappingAnimation == null) return;
      setState(() {
        _currentPosition = _snappingAnimation!.value;
      });
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onSnapCompleted?.call(
          _currentPosition,
          _latestConstraints!.maxHeight,
          _lastSnappingPosition,
        );
      }
    });

    Future.delayed(Duration(seconds: 0)).then((value) {
      setState(() {
        _currentPosition = _initSnappingPosition.getPositionInPixels(
          _latestConstraints!.maxHeight,
          widget.grabbingHeight,
        );
      });
    });

    if (widget.controller != null) {
      widget.controller!._attachState(this);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SnappingSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setSheetLocationData();
  }

  void _setSheetLocationData() {
    if (widget.sheetAbove != null)
      widget.sheetAbove!.location = SheetLocation.above;
    if (widget.sheetBelow != null)
      widget.sheetBelow!.location = SheetLocation.below;
  }

  set _currentPosition(double newPosition) {
    widget.onSheetMoved?.call(newPosition, _latestConstraints!.maxHeight);
    _currentPositionPrivate = newPosition;
  }

  double get _currentPosition => _currentPositionPrivate;

  SnappingPosition get _initSnappingPosition {
    return widget.initialSnappingPosition ?? widget.snappingPositions.first;
  }

  double _getNewPosition(double dragAmount) {
    var newPosition = _currentPosition - dragAmount;
    if (widget.lockOverflowDrag) {
      var calculator = _getSnappingCalculator();
      var maxPos = calculator.getBiggestPositionPixels();
      var minPos = calculator.getSmallestPositionPixels();
      if (newPosition > maxPos) return maxPos;
      if (newPosition < minPos) return minPos;
    }
    return newPosition;
  }

  void _dragSheet(double dragAmount) {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    setState(() {
      _currentPosition = _getNewPosition(dragAmount);
    });
  }

  void _dragEnd() {
    var bestSnappingPosition =
        _getSnappingCalculator().getBestSnappingPosition();
    _snapToPosition(bestSnappingPosition);
  }

  void _snapToPosition(SnappingPosition snappingPosition) {
    widget.onSnapStart?.call(
      _currentPosition,
      _latestConstraints!.maxHeight,
      snappingPosition,
    );
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

  SnappingCalculator _getSnappingCalculator() {
    return SnappingCalculator(
        allSnappingPositions: widget.snappingPositions,
        lastSnappingPosition: _lastSnappingPosition,
        maxHeight: _latestConstraints!.maxHeight,
        grabbingHeight: widget.grabbingHeight,
        currentPosition: _currentPosition);
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

              // The grabber content
              Positioned(
                left: 0,
                right: 0,
                bottom: _currentPosition - widget.grabbingHeight / 2,
                height: widget.grabbingHeight,
                child: OnDragWrapper(
                  dragEnd: _dragEnd,
                  dragUpdate: _dragSheet,
                  child: widget.grabbing,
                ),
              ),

              // The above sheet content
              SheetContentWrapper(
                dragEnd: _dragEnd,
                dragUpdate: _dragSheet,
                currentPosition: _currentPosition,
                snappingCalculator: _getSnappingCalculator(),
                sizeCalculator: AboveSheetSizeCalculator(
                  sheetData: widget.sheetAbove,
                  currentPosition: _currentPosition,
                  maxHeight: constraints.maxHeight,
                  grabbingHeight: widget.grabbingHeight,
                ),
                sheetData: widget.sheetAbove,
              ),

              // The below sheet content
              SheetContentWrapper(
                dragEnd: _dragEnd,
                dragUpdate: _dragSheet,
                currentPosition: _currentPosition,
                snappingCalculator: _getSnappingCalculator(),
                sizeCalculator: BelowSheetSizeCalculator(
                  sheetData: widget.sheetBelow,
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

  void _setSheetPositionPixel(double positionPixel) {
    _animationController.stop();
    setState(() {
      _currentPosition = positionPixel;
    });
  }

  void _setSheetPositionFactor(double factor) {
    _animationController.stop();
    setState(() {
      _currentPosition = factor * _latestConstraints!.maxHeight;
    });
  }
}

class SnappingSheetController {
  _SnappingSheetState? _state;

  /// If a state is attached to this controller. [isAttached] must be true
  /// before any function call from this controller is made
  bool get isAttached => _state != null;

  void _attachState(_SnappingSheetState state) {
    _state = state;
  }

  void _checkAttachment() {
    assert(
      isAttached,
      "SnappingSheet must be attached before calling any function from the controller. Pass in the controller to the snapping sheet widget to attached. Use [isAttached] to check if it is attached or not.",
    );
  }

  /// Snaps to a given snapping position.
  void snapToPosition(SnappingPosition snappingPosition) {
    _checkAttachment();
    _state!._snapToPosition(snappingPosition);
  }

  /// This sets the position of the snapping sheet directly without any
  /// animation. To use animation, see the [snapToPosition] method.
  void setSnappingSheetPosition(double positionInPixels) {
    _checkAttachment();
    _state!._setSheetPositionPixel(positionInPixels);
  }

  /// This sets the position of the snapping sheet directly without any
  /// animation. To use animation, see the [snapToPosition] method.
  void setSnappingSheetFactor(double positionAsFactor) {
    _checkAttachment();
    _state!._setSheetPositionFactor(positionAsFactor);
  }

  /// Getting the current position of the sheet. This is calculated from bottom
  /// to top. That is, when the grabbing widget is at the bottom, the
  /// [currentPosition] is close to zero. If the grabbing widget is at the top,
  /// the [currentPosition] is close the the height of the available height of
  /// the [SnappingSheet].
  double get currentPosition {
    _checkAttachment();
    return _state!._currentPosition;
  }

  /// Getting the current snapping position of the sheet.
  SnappingPosition get currentSnappingPosition {
    _checkAttachment();
    return _state!._lastSnappingPosition;
  }

  /// Returns true if the snapping sheet is currently trying to snap to a
  /// position.
  bool get currentlySnapping {
    _checkAttachment();
    return _state!._animationController.isAnimating;
  }

  /// Stops the current snapping if there is one ongoing.
  void stopCurrentSnapping() {
    _checkAttachment();
    return _state!._animationController.stop();
  }
}
