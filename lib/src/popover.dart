import 'dart:async';
import 'package:flutter/material.dart';

import 'arrows.dart';
import 'popover_anchors.dart';
import 'popover_controller.dart';
import 'popover_with_arrow.dart';

const _defaultShowDelay = Duration.zero;
const _defaultDebounceDuration = Duration(milliseconds: 50);
const _defaultOffset = Offset.zero;
const _defaultTriggerMode = PopoverTriggerMode.tap;
const _defaultBarrierColor = Colors.transparent;
const _defaultBackgroundColor = Colors.white;
const _defaultBorderRadius = 8.0;
const _defaultTransitionDuration = Duration(milliseconds: 100);
const _defaultConsumeOutsideTap = false;
const _defaultCrossAxisAlignment = PopoverCrossAxisAlignment.start;

/// Defines what user action triggers the popover to show and hide.
enum PopoverTriggerMode {
  /// Shows the popover on mouse enter and hides on mouse exit.
  hover,

  /// Toggles the popover's visibility on tap.
  tap,

  /// The popover is controlled exclusively via a [PopoverController].
  manual
}

/// Provides the [PopoverController] to the popover's overlay child.
///
/// Widgets within the `overlayChildBuilder` can access the controller via
/// `PopoverData.of(context)`.
class PopoverData extends InheritedWidget {
  /// The controller for the popover.
  final PopoverController controller;

  /// Creates a [PopoverData] widget.
  const PopoverData({
    super.key,
    required this.controller,
    required super.child,
  });

  /// Retrieves the [PopoverController] from the nearest [PopoverData] ancestor.
  ///
  /// This method asserts that a `PopoverData` is found in the widget tree.
  static PopoverController of(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<PopoverData>();
    assert(
      data != null,
      'PopoverData not found in context. Make sure you are calling PopoverData.of() inside a Popover overlayChildBuilder.',
    );
    return data!.controller;
  }

  /// Retrieves the [PopoverController] from the nearest [PopoverData] ancestor,
  /// returning null if none is found.
  static PopoverController? maybeOf(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<PopoverData>();
    return data?.controller;
  }

  @override
  bool updateShouldNotify(PopoverData oldWidget) {
    return controller != oldWidget.controller;
  }
}

/// A widget that displays a pop-up overlay relative to its child.
///
/// The popover uses an [OverlayPortal] to display content, and it automatically
/// positions itself to stay within the screen boundaries.
class Popover extends StatefulWidget {
  /// Creates a popover widget.
  const Popover({
    super.key,
    required this.child,
    required this.overlayChildBuilder,
    this.controller,
    this.showDelay,
    this.debounceDuration,
    this.offset,
    this.overlayChildHeight,
    this.overlayChildWidth,
    this.triggerMode,
    this.barrierColor,
    this.anchors,
    this.preferredDirection,
    this.constrainAxis,
    this.crossAxisAlignment,
    this.transitionDuration,
    this.transitionBuilder,
    this.consumeOutsideTap,
  });

  /// Creates a [Popover] with a decorative arrow pointing towards the trigger.
  factory Popover.arrow({
    Key? key,
    required Widget child,
    required WidgetBuilder overlayChildBuilder,
    PopoverController? controller,
    Duration? showDelay,
    Duration? debounceDuration,
    Offset? offset,
    double? overlayChildHeight,
    double? overlayChildWidth,
    PopoverTriggerMode? triggerMode,
    Color? barrierColor,
    PopoverAnchors? anchors,
    Color? backgroundColor,
    double? borderRadius,
    ArrowShape? arrowShape,
    double? arrowHeight,
    double? arrowWidth,
    double? arrowAlignment,
    AxisDirection? preferredDirection,
    Axis? constrainAxis,
    PopoverCrossAxisAlignment? crossAxisAlignment,
    Duration? transitionDuration,
    Widget Function(BuildContext, Animation<double>, Widget)? transitionBuilder,
    bool? consumeOutsideTap,
    List<BoxShadow>? boxShadow,
    BorderSide? border,
  }) {
    return Popover(
      key: key,
      controller: controller,
      showDelay: showDelay,
      debounceDuration: debounceDuration,
      offset: offset,
      overlayChildHeight: overlayChildHeight,
      overlayChildWidth: overlayChildWidth,
      triggerMode: triggerMode,
      barrierColor: barrierColor,
      anchors: anchors,
      preferredDirection: preferredDirection,
      constrainAxis: constrainAxis,
      crossAxisAlignment: crossAxisAlignment,
      transitionDuration: transitionDuration ?? _defaultTransitionDuration,
      transitionBuilder: transitionBuilder,
      consumeOutsideTap: consumeOutsideTap,
      overlayChildBuilder: (context) {
        return Builder(
          builder: (context) {
            return PopoverWithArrow(
              backgroundColor: backgroundColor ?? _defaultBackgroundColor,
              borderRadius: borderRadius ?? _defaultBorderRadius,
              arrowShape: arrowShape ?? const SharpArrow(),
              arrowHeight: arrowHeight,
              arrowWidth: arrowWidth,
              arrowAlignment: arrowAlignment,
              boxShadow: boxShadow,
              borderColor: border?.color,
              borderWidth: border?.width,
              child: overlayChildBuilder(context),
            );
          },
        );
      },
      child: child,
    );
  }

  /// The widget that triggers the popover.
  final Widget child;

  /// A builder for the content of the popover.
  final WidgetBuilder overlayChildBuilder;

  /// An optional controller to manage the popover's state programmatically.
  final PopoverController? controller;

  /// The delay before the popover is shown, typically for hover mode.
  final Duration? showDelay;

  /// The delay before hiding the popover, used in hover mode to prevent
  /// accidental dismissal when moving the cursor between the child and popover.
  final Duration? debounceDuration;

  /// The offset between the child and the popover.
  final Offset? offset;

  /// The height of the popover content. Providing this helps with positioning.
  final double? overlayChildHeight;

  /// The width of the popover content. Providing this helps with positioning.
  final double? overlayChildWidth;

  /// How the popover is triggered.
  final PopoverTriggerMode? triggerMode;

  /// The color of the barrier behind the
  final Color? barrierColor;

  /// A fixed anchor configuration. If provided, automatic calculation is skipped.
  final PopoverAnchors? anchors;

  /// The preferred direction to show the popover if space allows.
  final AxisDirection? preferredDirection;

  /// Constrains the popover's position to a single axis.
  final Axis? constrainAxis;

  /// How to align the popover on the cross-axis.
  final PopoverCrossAxisAlignment? crossAxisAlignment;

  /// The duration for the entry and exit animations.
  final Duration? transitionDuration;

  /// A custom builder for the popover's animation.
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  )? transitionBuilder;

  /// Whether a tap outside the popover is consumed, preventing it from reaching
  /// widgets below.
  final bool? consumeOutsideTap;

  @override
  State<Popover> createState() => _PopoverState();
}

class _PopoverState extends State<Popover> with SingleTickerProviderStateMixin {
  final _overlayController = OverlayPortalController();
  final _layerLink = LayerLink();
  final _tapRegionGroupId = Object();

  final _isChildHovered = ValueNotifier<bool>(false);
  final _isOverlayHovered = ValueNotifier<bool>(false);

  Timer? _showTimer;
  Timer? _hideTimer;

  PopoverController? _internalController;
  late final AnimationController _animationController;

  PopoverController get _controller =>
      widget.controller ?? (_internalController ??= PopoverController());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    );
    _animationController.addStatusListener(_handleAnimationStatusChanged);

    _isChildHovered.addListener(_handleHoverChange);
    _isOverlayHovered.addListener(_handleHoverChange);
    _controller.addListener(_handleControllerChange);
  }

  @override
  void didUpdateWidget(Popover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      _controller.addListener(_handleControllerChange);
    }
    if (oldWidget.transitionDuration != widget.transitionDuration) {
      _animationController.duration = widget.transitionDuration;
    }
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_handleAnimationStatusChanged);
    _animationController.dispose();

    _isChildHovered.removeListener(_handleHoverChange);
    _isOverlayHovered.removeListener(_handleHoverChange);
    _controller.removeListener(_handleControllerChange);
    _isChildHovered.dispose();
    _isOverlayHovered.dispose();
    _internalController?.dispose();
    _showTimer?.cancel();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _handleAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && _overlayController.isShowing) {
      _overlayController.hide();
    }
  }

  void _handleControllerChange() {
    if (_controller.isShowing) {
      _showPopover();
    } else {
      _hidePopover();
    }
  }

  void _showPopover() {
    if (_overlayController.isShowing) return;
    _calculateAnchors();
    _overlayController.show();
    _animationController.forward();
  }

  void _hidePopover() {
    if (!_overlayController.isShowing) return;
    _animationController.reverse();
  }

  void _tryShow() {
    if (_overlayController.isShowing || (_showTimer?.isActive ?? false)) return;
    final showDelay = widget.showDelay ?? _defaultShowDelay;
    _showTimer = Timer(showDelay, _showPopover);
  }

  void _calculateAnchors() {
    // If user provided fixed anchors, use them directly
    if (widget.anchors != null) {
      _controller.setAnchors(widget.anchors!);
      return;
    }

    final leaderSize = _layerLink.leaderSize;
    if (leaderSize == null) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final leaderGlobalPosition = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.sizeOf(context);

    final newAnchors = PopoverAnchors.calculate(
      leaderPosition: leaderGlobalPosition,
      leaderSize: leaderSize,
      screenSize: screenSize,
      overlayChildHeight: widget.overlayChildHeight,
      overlayChildWidth: widget.overlayChildWidth,
      preferredDirection: widget.preferredDirection,
      constrainAxis: widget.constrainAxis,
      crossAxisAlignment:
          widget.crossAxisAlignment ?? _defaultCrossAxisAlignment,
    );

    _controller.setAnchors(newAnchors);
  }

  void _handleHoverChange() {
    _hideTimer?.cancel();
    if (!_isChildHovered.value && !_isOverlayHovered.value) {
      final debounceDuration =
          widget.debounceDuration ?? _defaultDebounceDuration;
      _hideTimer = Timer(debounceDuration, _hidePopover);
    }
  }

  void _handleTap() {
    if (_animationController.isAnimating) return;
    if (_overlayController.isShowing) {
      _hidePopover();
    } else {
      _showPopover();
    }
  }

  void _handleTapOutside(PointerDownEvent event) {
    if (_overlayController.isShowing) {
      _hidePopover();
    }
  }

  Widget _defaultTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    if (widget.transitionDuration == Duration.zero) {
      return child;
    }
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final triggerMode = widget.triggerMode ?? _defaultTriggerMode;
    final isManualMode = triggerMode == PopoverTriggerMode.manual;
    final enableHover =
        !isManualMode && triggerMode == PopoverTriggerMode.hover;
    final enableTap = !isManualMode && triggerMode == PopoverTriggerMode.tap;

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (context) {
        return TapRegion(
          groupId: _tapRegionGroupId,
          onTapOutside: enableTap ? _handleTapOutside : null,
          consumeOutsideTaps:
              widget.consumeOutsideTap ?? _defaultConsumeOutsideTap,
          child: Stack(
            children: [
              if (enableTap &&
                  (widget.barrierColor ?? _defaultBarrierColor) !=
                      Colors.transparent)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: widget.barrierColor ?? _defaultBarrierColor,
                    ),
                  ),
                ),
              ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  final anchors = _controller.anchors;
                  final offset = widget.offset ?? _defaultOffset;

                  final popoverContent = PopoverData(
                    controller: _controller,
                    child: MouseRegion(
                      onEnter: enableHover
                          ? (_) => _isOverlayHovered.value = true
                          : null,
                      onExit: enableHover
                          ? (_) => _isOverlayHovered.value = false
                          : null,
                      child: widget.overlayChildBuilder(context),
                    ),
                  );

                  return CompositedTransformFollower(
                    link: _layerLink,
                    targetAnchor: anchors.targetAnchor,
                    followerAnchor: anchors.followerAnchor,
                    offset: offset,
                    child: Align(
                      alignment: anchors.overlayAlignment,
                      child: (widget.transitionBuilder ??
                          _defaultTransitionBuilder)(
                        context,
                        _animationController,
                        popoverContent,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      child: TapRegion(
        groupId: _tapRegionGroupId,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: enableTap ? _handleTap : null,
            child: MouseRegion(
              onEnter: enableHover
                  ? (_) {
                      _isChildHovered.value = true;
                      _hideTimer?.cancel();
                      _tryShow();
                    }
                  : null,
              onExit: enableHover
                  ? (_) {
                      _showTimer?.cancel();
                      _isChildHovered.value = false;
                    }
                  : null,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
