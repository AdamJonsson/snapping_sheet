library snapping_sheet;

import 'dart:math';

import 'package:flutter/widgets.dart';

enum SnappingSheetType { manuel, fixed, fit }

class SnappingSheetHeight {
  final SnappingSheetType _type;

  /// When the users drag over the snapp positions that generates the
  /// maximum height of the sheet, the sheet can either expand its height
  /// oer keep its height fixed.
  final bool expandOnSnapPositionOverflow;

  /// The minimum height of the sheet
  final double minHeight;

  /// the maximum height of the seet
  final double maxHeight;

  /// Make the sheet height manuel by specifing the minHeight or the maxHeight
  const SnappingSheetHeight.manuel(
      {@required this.minHeight, @required this.maxHeight})
      : _type = SnappingSheetType.manuel,
        expandOnSnapPositionOverflow = false;

  /// Make the sheet height the maximum sheet possible and keep the height fixed.
  /// [expandOnSnapPositionOverflow] default is true
  const SnappingSheetHeight.fixed({this.expandOnSnapPositionOverflow = true})
      : this._type = SnappingSheetType.fixed,
        this.minHeight = null,
        this.maxHeight = null;

  /// Make the sheet height fit the avaiable space
  const SnappingSheetHeight.fit()
      : this._type = SnappingSheetType.fit,
        this.expandOnSnapPositionOverflow = false,
        this.minHeight = null,
        this.maxHeight = null;
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

  SnappingSheetContent(
      {this.child,
      this.margin = const EdgeInsets.all(0.0),
      this.heightBehavior = const SnappingSheetHeight.fit(),
      this.draggable = false});
}

/// A snapping position that tells how a [SnappingSheet] snapps to different positions
class SnapPosition {
  /// The snapping position in pixels
  /// [positionFactor] should be null if this is used.
  final double positionPixel;

  /// The snapping position in relation of the
  /// available height. [positionPixel] should be null if this is used.
  final double positionFactor;

  /// The animation curve to this snapping position
  final Curve snappingCurve;

  /// The snapping duration
  final Duration snappingDuration;

  const SnapPosition(
      {this.positionFactor,
      this.positionPixel,
      this.snappingCurve = Curves.easeOutExpo,
      this.snappingDuration = const Duration(milliseconds: 500)});

  /// Getting the position in pixels
  double _getPositionInPixels(double height) {
    if (positionPixel != null) {
      return positionPixel;
    }
    return height * positionFactor;
  }
}

/// A sheet that snaps to different positions
class SnappingSheet extends StatefulWidget {
  /// The widget behind the [sheetBelow] widget. It has a constant height
  /// and do not change when the sheet is draged up or down.
  final Widget child;

  /// The sheet that is placed below the [grabbing] widget
  final SnappingSheetContent sheetBelow;

  /// The sheet that is placed above the [grabbing] widget
  final SnappingSheetContent sheetAbove;

  /// The widget for grabing the [sheetBelow] or [sheetAbove]. It placed between the [sheetBelow] and the
  /// [sheetAbove] widget.
  final Widget grabbing;

  /// The height of the grabing widget
  final double grabbingHeight;

  /// The different snapping positions for the [sheetBelow]
  final List<SnapPosition> snapPositions;

  /// The init snap position. If this position is not included in [snapPositions]
  /// it can not be snapped back after the sheet is leaving this position. If [initSnapPosition]
  /// is null the init snap position is taken from the first snapPosition from [snapPositions]
  final SnapPosition initSnapPosition;

  /// If true, the grabbing widget can not be draget below the lowest [snapPositions]
  /// or over the heightest [snapPositions].
  final bool lockOverflowDrag;

  /// The controller for the [SnappingSheet]
  final SnappingSheetController snappingSheetController;

  /// Is called when the [sheetBelow] is being moved
  final Function(double pixelPosition) onMove;

  final VoidCallback onSnapBegin;

  /// Is called when the [sheetBelow] is snappet to one of the [snapPositions]
  final VoidCallback onSnapEnd;

  const SnappingSheet({
    Key key,
    this.child,
    this.sheetBelow,
    this.sheetAbove,
    this.grabbing,
    this.grabbingHeight = 75.0,
    this.snapPositions = const [
      SnapPosition(positionPixel: 0.0),
      SnapPosition(positionFactor: 0.5),
      SnapPosition(positionFactor: 0.9),
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

class _SnappingSheetState extends State<SnappingSheet>
    with SingleTickerProviderStateMixin {
  /// How heigh up the sheet is dragged in pixels
  double _currentDragAmount;

  /// The controller for the snapping animation
  AnimationController _snappingAnimationController;

  /// The snapping animation
  Animation<double> _snappingAnimation;

  /// Last constrains of SnapSheet
  BoxConstraints _currentConstraints;

  /// Last snapping location
  SnapPosition _lastSnappingLocation;

  /// The init snap position for the sheet
  SnapPosition _initSnapPosition;

  /// The last orientation
  Orientation _lastOrientation;

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
      if (widget.onMove != null) {
        widget.onMove(_currentDragAmount);
      }
      if (widget.onSnapEnd != null &&
          _snappingAnimationController.isCompleted) {
        widget.onSnapEnd();
      }
    });

    // Connect the given listeners
    widget.snappingSheetController?._addListeners(_snapToPosition);
    widget.snappingSheetController?.snapPositions = widget.snapPositions;
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
    double minDistance;
    SnapPosition closestSnapPosition;

    // Check if the user is dragging downwards or upwards
    final isDraggingUpwards =
        _currentDragAmount > _getSnapPositionInPixels(_lastSnappingLocation);

    // Find the closest snapping position
    for (var snapPosition in widget.snapPositions) {
      final snapPositionPixels = _getSnapPositionInPixels(snapPosition);

      if (snapPosition != _lastSnappingLocation) {
        bool dragOverflowLastSnapPosition =
            (snapPosition == widget.snapPositions.last &&
                _currentDragAmount >
                    _getSnapPositionInPixels(widget.snapPositions.last));
        bool dragOverflowFirstSnapPosition =
            (snapPosition == widget.snapPositions.first &&
                _currentDragAmount <
                    _getSnapPositionInPixels(widget.snapPositions.first));

        // Ignore snap positions below if dragging upwards
        if (isDraggingUpwards &&
            snapPositionPixels < _currentDragAmount &&
            !dragOverflowLastSnapPosition) {
          continue;
        }

        // Ignore snap positions above if dragging downwards
        if (!isDraggingUpwards &&
            snapPositionPixels > _currentDragAmount &&
            !dragOverflowFirstSnapPosition) {
          continue;
        }
      }

      // Getting the distance to the current snapPosition
      var snappingDistance = (snapPositionPixels - _currentDragAmount).abs();

      // It should be hard to snap to the last snapping location.
      var snappingFactor = snapPosition == _lastSnappingLocation ? 0.1 : 1;

      // Check if this snapPosition has the minimum distance
      if (minDistance == null ||
          minDistance > snappingDistance / snappingFactor) {
        minDistance = snappingDistance / snappingFactor;
        closestSnapPosition = snapPosition;
      }
    }

    return closestSnapPosition;
  }

  /// Animates the the closest stop
  void _animateToClosestStop() {
    // Get the closest snapping location
    var closestSnapPosition = _getClosestSnapPosition();
    _snapToPosition(closestSnapPosition);
  }

  /// Snaps to a given [SnapPosition]
  void _snapToPosition(SnapPosition snapPosition) {
    // Update the info about the last snapping location
    _lastSnappingLocation = snapPosition;
    widget.snappingSheetController?.currentSnapPosition = snapPosition;

    // Create a new cureved animation between the current drag amount and the snapping
    // location
    _snappingAnimation = Tween<double>(
            begin: _currentDragAmount,
            end: _getSnapPositionInPixels(snapPosition))
        .animate(CurvedAnimation(
      curve: snapPosition.snappingCurve,
      parent: _snappingAnimationController,
    ));

    // Reset and start animation
    _snappingAnimationController.duration = snapPosition.snappingDuration;
    _snappingAnimationController.reset();
    _snappingAnimationController.forward();

    if (widget.onSnapBegin != null) {
      widget.onSnapBegin();
    }
  }

  /// Getting the snap position in pixels
  double _getSnapPositionInPixels(SnapPosition snapPosition) {
    return snapPosition._getPositionInPixels(
        _currentConstraints.maxHeight - widget.grabbingHeight);
  }

  /// Builds the widget located behind the sheet
  Widget _buildBackground() {
    if (widget.child == null) {
      return SizedBox();
    }

    return Positioned.fill(
      child: widget.child,
    );
  }

  bool _isDraggable(listenerType) {
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

  Widget _wrapDraggable(bool ignoreGestureDetection, Widget child,
      SnappingSheetListenerType listenerType) {
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
          var newDragAmount = _currentDragAmount - dragEvent.delta.dy;
          if (newDragAmount <
              widget.snapPositions.first._getPositionInPixels(
                  _currentConstraints.maxHeight - widget.grabbingHeight)) {
            return;
          }

          var lastSnapPositionInPixels = widget.snapPositions.last
              ._getPositionInPixels(_currentConstraints.maxHeight);
          if (newDragAmount +
                  widget.grabbingHeight *
                      lastSnapPositionInPixels /
                      _currentConstraints.maxHeight >
              lastSnapPositionInPixels) {
            return;
          }
        }
        setState(() {
          _currentDragAmount -= dragEvent.delta.dy;
        });
        if (widget.onMove != null) {
          widget.onMove(_currentDragAmount);
        }
      },
    );
  }

  double _getSheetHeight(bool isAbove) {
    double fitHeight;
    SnappingSheetHeight heightBehavior;

    if (isAbove) {
      fitHeight = _currentConstraints.maxHeight -
          _currentDragAmount -
          widget.grabbingHeight;
      heightBehavior = widget.sheetAbove.heightBehavior;
    } else {
      fitHeight = _currentDragAmount;
      heightBehavior = widget.sheetBelow.heightBehavior;
    }

    switch (heightBehavior._type) {
      case SnappingSheetType.fit:
        return fitHeight;
      case SnappingSheetType.manuel:
        return max(
            min(fitHeight, heightBehavior.maxHeight), heightBehavior.minHeight);
      case SnappingSheetType.fixed:
        return _getMaximumSheetHeight(
            isAbove, heightBehavior.expandOnSnapPositionOverflow);
      default:
        return fitHeight;
    }
  }

  double _getMaximumSheetHeight(
      bool isAbove, bool expandOnSnapPositionOverflow) {
    double maxHeight = 0;
    widget.snapPositions.forEach((snapPosition) {
      double snapHeight = 0;
      if (isAbove) {
        snapHeight = _currentConstraints.maxHeight -
            _getSnapPositionInPixels(snapPosition) -
            widget.grabbingHeight;
      } else {
        snapHeight = _getSnapPositionInPixels(snapPosition);
      }
      if (maxHeight < snapHeight) {
        maxHeight = snapHeight;
      }
    });

    if (isAbove) {
      return maxHeight -
          (expandOnSnapPositionOverflow ? min(_currentDragAmount, 0) : 0);
    } else {
      return (expandOnSnapPositionOverflow
          ? max(_currentDragAmount, maxHeight)
          : maxHeight);
    }
  }

  void _setCurrentDragAmount(double newAmount) {
    _currentDragAmount = newAmount;
    if (widget.onMove != null) {
      widget.onMove(_currentDragAmount);
    }
  }

  void _checkCurrentDragAmount(
      BoxConstraints constraints, Orientation newOrientation) {
    if (_currentDragAmount == null) {
      _currentDragAmount = _getSnapPositionInPixels(_initSnapPosition);
    }
    if (_lastOrientation != newOrientation) {
      _currentDragAmount = _getSnapPositionInPixels(_lastSnappingLocation);
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _setCurrentDragAmount(_currentDragAmount));
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

          // The grabing area
          Positioned(
              left: 0,
              right: 0,
              height: widget.grabbingHeight,
              bottom: _currentDragAmount,
              child: _wrapDraggable(
                  false, widget.grabbing, SnappingSheetListenerType.draggable)),

          // The sheet below
          widget.sheetAbove != null
              ? Positioned(
                  bottom: _currentDragAmount +
                      widget.sheetAbove.margin.bottom +
                      widget.grabbingHeight,
                  left: widget.sheetAbove.margin.left,
                  right: widget.sheetAbove.margin.right,
                  height: _getSheetHeight(true),
                  child: _wrapDraggable(false, widget.sheetAbove.child,
                      SnappingSheetListenerType.sheetAbove),
                )
              : SizedBox(),

          // The sheet below
          widget.sheetBelow != null
              ? Positioned(
                  top: constraints.maxHeight -
                      _currentDragAmount +
                      widget.sheetBelow.margin.top,
                  left: widget.sheetBelow.margin.left,
                  right: widget.sheetBelow.margin.right,
                  height: _getSheetHeight(false),
                  child: _wrapDraggable(false, widget.sheetBelow.child,
                      SnappingSheetListenerType.sheetBelow),
                )
              : SizedBox(),
        ]);
      });
    });
  }
}

/// Controlls the [SnappingSheet] widget
class SnappingSheetController {
  Function(SnapPosition value) _setSnapSheetPositionListener;

  /// The different snap positions the [SnappingSheet] currently has.
  List<SnapPosition> snapPositions;

  /// The current snap positions of the [SnappingSheet].
  SnapPosition currentSnapPosition;

  void _addListeners(
      Function(SnapPosition value) setSnapSheetPositionListener) {
    this._setSnapSheetPositionListener = setSnapSheetPositionListener;
  }

  /// Snaps to a given [SnapPosition]
  void snapToPosition(SnapPosition snapPosition) {
    _setSnapSheetPositionListener(snapPosition);
  }
}
