import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

enum SnappingSheetType { manual, fixed, fit }

class SnappingSheetHeight {
  final SnappingSheetType _type;

  /// When the users drag over the snap positions that generates the
  /// maximum height of the sheet, the sheet can either expand its height
  /// oer keep its height fixed.
  final bool expandOnSnapPositionOverflow;

  /// The minimum height of the sheet
  final double minHeight;

  /// the maximum height of the sheet
  final double maxHeight;

  /// Make the sheet height manual by specifying the minHeight or the maxHeight
  const SnappingSheetHeight.manual({required this.minHeight, required this.maxHeight})
      : _type = SnappingSheetType.manual,
        expandOnSnapPositionOverflow = false;

  /// Make the sheet height the maximum sheet possible and keep the height fixed.
  /// [expandOnSnapPositionOverflow] default is true
  const SnappingSheetHeight.fixed({this.expandOnSnapPositionOverflow = true})
      : this._type = SnappingSheetType.fixed,
        this.minHeight = 0,
        this.maxHeight = 0;

  /// Make the sheet height fit the available space
  const SnappingSheetHeight.fit()
      : this._type = SnappingSheetType.fit,
        this.expandOnSnapPositionOverflow = false,
        this.minHeight = 0,
        this.maxHeight = 0;
}

class SnappingSheetContent {
  /// The content of the sheet;
  final Widget child;

  /// The margin of the sheet. Values in the [EdgeInsets] can be negative.
  final EdgeInsets margin;

  /// If the sheet should listen for drag events.
  /// Should be false if the [child] have scrollable content.
  final bool draggable;

  /// How the sheet height should behave
  final SnappingSheetHeight heightBehavior;

  const SnappingSheetContent(
      {required this.child, this.margin = const EdgeInsets.all(0.0), this.heightBehavior = const SnappingSheetHeight.fit(), this.draggable = false});
}

/// A snapping position that tells how a [SnappingSheet] snaps to different positions
class SnapPosition {
  /// The snapping position in pixels
  /// [positionFactor] should be null if this is used.
  final num position;

  /// [isFactor] should be false if position is in pixels.
  final bool isFactor;

  /// The snapping position in relation of the
  /// available height. [positionPixel] should be null if this is used.

  /// The animation curve to this snapping position
  final Curve snappingCurve;

  /// The snapping duration
  final Duration snappingDuration;

  const SnapPosition(
      {required this.position,
      this.isFactor = true,
      this.snappingCurve = Curves.easeOutExpo,
      this.snappingDuration = const Duration(milliseconds: 500)});

  /// Getting the position in pixels
  double _getPositionInPixels(double height) {
    if (isFactor) {
      return height * position;
    } else {
      return position.toDouble();
    }
  }
}

/// A sheet that snaps to different positions
class SnappingSheet extends StatefulWidget {
  /// The widget behind the [sheetBelow] widget. It has a constant height
  /// and do not change when the sheet is dragged up or down.
  final Widget child;

  /// The sheet that is placed below the [grabbing] widget
  final SnappingSheetContent sheetBelow;

  /// The sheet that is placed above the [grabbing] widget
  final SnappingSheetContent sheetAbove;

  /// The widget for grabbing the [sheetBelow] or [sheetAbove]. It placed between the [sheetBelow] and the
  /// [sheetAbove] widget.
  final Widget grabbing;

  /// The height of the grabbing widget
  final double grabbingHeight;

  /// The different snapping positions for the [sheetBelow]
  final List<SnapPosition> snapPositions;

  /// The init snap position. If this position is not included in [snapPositions]
  /// it can not be snapped back after the sheet is leaving this position. If [initSnapPosition]
  /// is null the init snap position is taken from the first snapPosition from [snapPositions]
  final SnapPosition? initSnapPosition;

  /// If true, the grabbing widget can not be draget below the lowest [snapPositions]
  /// or over the highest [snapPositions].
  final bool lockOverflowDrag;

  /// The controller for the [SnappingSheet]
  final SnappingSheetController? snappingSheetController;

  /// Is called when the [sheetBelow] is being moved
  final Function(double pixelPosition)? onMove;

  final VoidCallback? onSnapBegin;

  /// Is called when the [sheetBelow] is snapped to one of the [snapPositions]
  final VoidCallback? onSnapEnd;

  const SnappingSheet({
    Key? key,
    this.child = const SizedBox(),
    this.sheetBelow = const SnappingSheetContent(child: const SizedBox()),
    this.sheetAbove = const SnappingSheetContent(child: const SizedBox()),
    this.grabbing = const GrabSection(),
    this.grabbingHeight = 75.0,
    this.snapPositions = const [
      SnapPosition(position: 0.0),
      SnapPosition(position: 0.5),
      SnapPosition(position: 0.9),
    ],
    this.initSnapPosition,
    this.lockOverflowDrag = false,
    this.snappingSheetController,
    this.onMove,
    this.onSnapBegin,
    this.onSnapEnd,
  }) : super(key: key);

  @override
  _SnappingSheetState createState() => _SnappingSheetState();
}

enum SnappingSheetListenerType { draggable, sheetAbove, sheetBelow }

class _SnappingSheetState extends State<SnappingSheet> with SingleTickerProviderStateMixin {
  /// How heigh up the sheet is dragged in pixels
  late double _currentDragAmount;

  /// The controller for the snapping animation
  late AnimationController _snappingAnimationController;

  /// The snapping animation
  late Animation<double> _snappingAnimation;

  /// Last constrains of SnapSheet
  late BoxConstraints _currentConstraints;

  /// Last snapping location
  late SnapPosition _lastSnappingLocation;

  /// The init snap position for the sheet
  late SnapPosition _initSnapPosition;

  bool _init = false;

  /// The last orientation
  Orientation? _lastOrientation;

  @override
  void initState() {
    super.initState();

    // Set the init snap position
    _initSnapPosition = widget.initSnapPosition ?? widget.snapPositions.first;
    _lastSnappingLocation = _initSnapPosition;

    // Create the snapping controller
    _snappingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );

    // Listen when the snapping begin
    _snappingAnimationController.addListener(() {
      setState(() {
        _currentDragAmount = _snappingAnimation.value;
      });
      widget.onMove?.call(_currentDragAmount);
      if (_snappingAnimationController.isCompleted) {
        widget.onSnapEnd?.call();
      }
    });

    // Connect the given listeners
    widget.snappingSheetController?._addListeners(_snapToPosition);
    widget.snappingSheetController?.snapPositions = widget.snapPositions;
    widget.snappingSheetController?.currentSnapPosition = _initSnapPosition;
  }

  @override
  void didUpdateWidget(SnappingSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.snappingSheetController?.snapPositions = widget.snapPositions;
  }

  @override
  void dispose() {
    _snappingAnimationController.dispose();
    super.dispose();
  }

  /// Get the closest snapping location
  SnapPosition _getClosestSnapPosition() {
    // Set the init for comparing values.
    double minDistance = -1;
    late SnapPosition closestSnapPosition;

    // Check if the user is dragging downwards or upwards
    final isDraggingUpwards = _currentDragAmount > _getSnapPositionInPixels(_lastSnappingLocation);

    // Find the closest snapping position
    for (final snapPosition in widget.snapPositions) {
      final snapPositionPixels = _getSnapPositionInPixels(snapPosition);
      if (snapPosition != _lastSnappingLocation) {
        final dragOverflowLastSnapPosition =
            (snapPosition == widget.snapPositions.last && _currentDragAmount > _getSnapPositionInPixels(widget.snapPositions.last));
        final dragOverflowFirstSnapPosition =
            (snapPosition == widget.snapPositions.first && _currentDragAmount < _getSnapPositionInPixels(widget.snapPositions.first));

        // Ignore snap positions below if dragging upwards
        if (isDraggingUpwards && snapPositionPixels < _currentDragAmount && !dragOverflowLastSnapPosition) {
          continue;
        }

        // Ignore snap positions above if dragging downwards
        if (!isDraggingUpwards && snapPositionPixels > _currentDragAmount && !dragOverflowFirstSnapPosition) {
          continue;
        }
      }

      // Getting the distance to the current snapPosition
      final snappingDistance = (snapPositionPixels - _currentDragAmount).abs();

      // It should be hard to snap to the last snapping location.
      final snappingFactor = snapPosition == _lastSnappingLocation ? 0.1 : 1;

      // Check if this snapPosition has the minimum distance
      if (minDistance == -1 || minDistance > snappingDistance / snappingFactor) {
        minDistance = snappingDistance / snappingFactor;
        closestSnapPosition = snapPosition;
      }
    }

    return closestSnapPosition;
  }

  /// Animates the the closest stop
  void _animateToClosestStop() {
    // Get the closest snapping location
    final closestSnapPosition = _getClosestSnapPosition();
    _snapToPosition(closestSnapPosition);
  }

  /// Snaps to a given [SnapPosition]
  void _snapToPosition(SnapPosition snapPosition) {
    // Update the info about the last snapping location
    _lastSnappingLocation = snapPosition;
    widget.snappingSheetController?.currentSnapPosition = snapPosition;

    // Create a new curved animation between the current drag amount and the snapping
    // location
    _snappingAnimation = Tween<double>(begin: _currentDragAmount, end: _getSnapPositionInPixels(snapPosition)).animate(CurvedAnimation(
      curve: snapPosition.snappingCurve,
      parent: _snappingAnimationController,
    ));

    // Reset and start animation
    _snappingAnimationController.duration = snapPosition.snappingDuration;
    _snappingAnimationController.reset();
    _snappingAnimationController.forward();

    widget.onSnapBegin?.call();
  }

  /// Getting the snap position in pixels
  double _getSnapPositionInPixels(SnapPosition snapPosition) {
    return snapPosition._getPositionInPixels(_currentConstraints.maxHeight - widget.grabbingHeight);
  }

  /// Builds the widget located behind the sheet
  Widget _buildBackground() {
    return Positioned.fill(
      child: widget.child,
    );
  }

  bool _isDraggable(SnappingSheetListenerType listenerType) {
    switch (listenerType) {
      case SnappingSheetListenerType.sheetAbove:
        if (widget.sheetAbove.draggable) {
          return true;
        }
        return false;
      case SnappingSheetListenerType.sheetBelow:
        if (widget.sheetBelow.draggable) {
          return true;
        }
        return false;
      default:
        return true;
    }
  }

  Widget _wrapDraggable(bool ignoreGestureDetection, Widget child, SnappingSheetListenerType listenerType) {
    if (ignoreGestureDetection) {
      return child;
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      child: child,
      onPointerUp: (_) {
        if (!_isDraggable(listenerType)) {
          return;
        }
        _animateToClosestStop();
      },
      onPointerDown: (_) {
        if (!_isDraggable(listenerType)) {
          return;
        }
        // Stop the current snapping animation so the user is
        // able to drag again.
        _snappingAnimationController.stop();
      },
      onPointerMove: (dragEvent) {
        if (!_isDraggable(listenerType)) {
          return;
        }
        if (widget.lockOverflowDrag) {
          final newDragAmount = _currentDragAmount - dragEvent.delta.dy;
          if (newDragAmount < _getSnapPositionInPixels(widget.snapPositions.first)) {
            return;
          }

          final lastSnapPositionInPixels = widget.snapPositions.last._getPositionInPixels(_currentConstraints.maxHeight);
          if (newDragAmount + widget.grabbingHeight * lastSnapPositionInPixels / _currentConstraints.maxHeight > lastSnapPositionInPixels) {
            return;
          }
        }
        setState(() {
          _currentDragAmount -= dragEvent.delta.dy;
        });
        widget.onMove?.call(_currentDragAmount);
      },
    );
  }

  double _getSheetHeight(bool isAbove) {
    double fitHeight;
    SnappingSheetHeight heightBehavior;

    if (isAbove) {
      fitHeight = _currentConstraints.maxHeight - _currentDragAmount - widget.grabbingHeight;
      heightBehavior = widget.sheetAbove.heightBehavior;
    } else {
      fitHeight = _currentDragAmount;
      heightBehavior = widget.sheetBelow.heightBehavior;
    }

    switch (heightBehavior._type) {
      case SnappingSheetType.fit:
        return fitHeight;
      case SnappingSheetType.manual:
        return max(min(fitHeight, heightBehavior.maxHeight), heightBehavior.minHeight);
      case SnappingSheetType.fixed:
        return _getMaximumSheetHeight(isAbove, heightBehavior.expandOnSnapPositionOverflow);
      default:
        return fitHeight;
    }
  }

  double _getMaximumSheetHeight(bool isAbove, bool expandOnSnapPositionOverflow) {
    double maxHeight = 0;
    widget.snapPositions.forEach((snapPosition) {
      double snapHeight = 0;
      if (isAbove) {
        snapHeight = _currentConstraints.maxHeight - _getSnapPositionInPixels(snapPosition) - widget.grabbingHeight;
      } else {
        snapHeight = _getSnapPositionInPixels(snapPosition);
      }
      if (maxHeight < snapHeight) {
        maxHeight = snapHeight;
      }
    });

    if (isAbove) {
      return maxHeight - (expandOnSnapPositionOverflow ? min(_currentDragAmount, 0) : 0);
    } else {
      return (expandOnSnapPositionOverflow ? max(_currentDragAmount, maxHeight) : maxHeight);
    }
  }

  void _setCurrentDragAmount(double newAmount) {
    _currentDragAmount = newAmount;
    widget.onMove?.call(_currentDragAmount);
  }

  void _checkCurrentDragAmount(BoxConstraints constraints, Orientation newOrientation) {
    if (_init) {
      _currentDragAmount = _getSnapPositionInPixels(_initSnapPosition);
      _snapToPosition(_initSnapPosition);
      _init = false;
    }
    if (_lastOrientation != newOrientation) {
      _currentDragAmount = _getSnapPositionInPixels(_lastSnappingLocation);
      WidgetsBinding.instance?.addPostFrameCallback((_) => _setCurrentDragAmount(_currentDragAmount));
    }

    _lastOrientation = newOrientation;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return LayoutBuilder(builder: (context, constraints) {
        _currentConstraints = constraints;
        _checkCurrentDragAmount(constraints, orientation);

        return Stack(fit: StackFit.expand, children: <Widget>[
          // The widget behind the sheet
          _buildBackground(),

          // The grabbing area
          Positioned(
              left: 0,
              right: 0,
              height: widget.grabbingHeight,
              bottom: _currentDragAmount,
              child: _wrapDraggable(false, widget.grabbing, SnappingSheetListenerType.draggable)),

          // The sheet below
          Positioned(
            bottom: _currentDragAmount + widget.sheetAbove.margin.bottom + widget.grabbingHeight,
            left: widget.sheetAbove.margin.left,
            right: widget.sheetAbove.margin.right,
            height: _getSheetHeight(true),
            child: _wrapDraggable(false, widget.sheetAbove.child, SnappingSheetListenerType.sheetAbove),
          ),
          // widget.sheetAbove != null
          //     ?
          //     : SizedBox(),

          // The sheet below

          Positioned(
            top: constraints.maxHeight - _currentDragAmount + widget.sheetBelow.margin.top,
            left: widget.sheetBelow.margin.left,
            right: widget.sheetBelow.margin.right,
            height: _getSheetHeight(false),
            child: _wrapDraggable(false, widget.sheetBelow.child, SnappingSheetListenerType.sheetBelow),
          ),
          // widget.sheetBelow != null
          //     ?
          //     : SizedBox(),
        ]);
      });
    });
  }
}

/// Controls the [SnappingSheet] widget
class SnappingSheetController {
  late Function(SnapPosition value) _setSnapSheetPositionListener;

  /// The different snap positions the [SnappingSheet] currently has.
  List<SnapPosition> snapPositions = const [
    SnapPosition(position: 0, snappingCurve: Curves.elasticOut, snappingDuration: Duration(milliseconds: 750)),
    SnapPosition(position: 0.4),
    SnapPosition(position: 0.8),
  ];

  /// The current snap positions of the [SnappingSheet].
  late SnapPosition currentSnapPosition;

  void _addListeners(Function(SnapPosition value) setSnapSheetPositionListener) {
    this._setSnapSheetPositionListener = setSnapSheetPositionListener;
  }

  /// Snaps to a given [SnapPosition]
  void snapToPosition(SnapPosition snapPosition) {
    _setSnapSheetPositionListener(snapPosition);
  }
}

class GrabSection extends StatelessWidget {
  const GrabSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20.0,
            color: Colors.black.withOpacity(0.2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 100.0,
            height: 10.0,
            margin: EdgeInsets.only(top: 15.0),
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.all(Radius.circular(5.0))),
          ),
        ],
      ),
    );
  }
}
