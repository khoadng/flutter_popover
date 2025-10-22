import 'dart:async';
import 'package:flutter/material.dart';

import 'anchors.dart';
import 'controller.dart';
import 'arrow.dart';
import 'data.dart';
import 'geometry.dart';
import 'rendering/arrows.dart';
import 'trigger.dart';

const _defaultTransitionDuration = Duration(milliseconds: 100);
const _defaultCrossAxisAlignment = PopoverCrossAxisAlignment.center;

/// A widget that displays a pop-up overlay relative to its child.
class Popover extends StatefulWidget {
  /// Creates a popover widget.
  const Popover({
    super.key,
    required this.child,
    required this.contentBuilder,
    this.controller,
    this.spacing,
    this.offset,
    this.contentHeight,
    this.contentWidth,
    this.triggerMode = const TapTriggerMode(),
    this.preferredDirection,
    this.constrainAxis,
    this.crossAxisAlignment,
    this.flipMode,
    this.scrollBehavior,
    this.transitionDuration,
    this.transitionBuilder,
    this.backdropBuilder,
    this.onShow,
    this.onHide,
  });

  /// Creates a [Popover] configured as a tooltip with a text message.
  ///
  /// This is a convenience factory for creating simple text tooltips that
  /// appear on hover. It builds on top of [Popover.arrow] with tooltip-specific
  /// defaults.
  static Widget tooltip({
    Key? key,
    required Widget child,
    required Widget message,
    PopoverController? controller,
    double? spacing,
    Offset? offset,
    PopoverTriggerMode triggerMode = const HoverTriggerMode(),
    Color? backgroundColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Size? arrowSize,
    double? arrowAlignment,
    ArrowShape? arrowShape,
    AxisDirection? preferredDirection,
    Axis? constrainAxis,
    PopoverCrossAxisAlignment? crossAxisAlignment,
    FlipMode? flipMode,
    PopoverScrollBehavior? scrollBehavior,
    Duration? transitionDuration,
    AnimatedTransitionBuilder? transitionBuilder,
    WidgetBuilder? backdropBuilder,
    List<BoxShadow>? boxShadow,
    BorderSide? border,
    Duration? showDuration,
    VoidCallback? onShow,
    VoidCallback? onHide,
  }) {
    return _PopoverConfig(
      enableOverlayHover: false,
      child: Popover.arrow(
        key: key,
        controller: controller,
        spacing: spacing,
        offset: offset,
        triggerMode:
            showDuration != null ? const ManualTriggerMode() : triggerMode,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        arrowSize: arrowSize,
        arrowAlignment: arrowAlignment,
        arrowShape: arrowShape,
        preferredDirection: preferredDirection,
        constrainAxis: constrainAxis,
        crossAxisAlignment: crossAxisAlignment,
        flipMode: flipMode,
        scrollBehavior: scrollBehavior,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        backdropBuilder: backdropBuilder,
        boxShadow: boxShadow,
        border: border,
        onShow: onShow,
        onHide: onHide,
        contentBuilder: (context) {
          final effectivePadding = padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

          return Padding(
            padding: effectivePadding,
            child: message,
          );
        },
        child: child,
      ),
    );
  }

  /// Creates a [Popover] with a decorative arrow pointing towards the trigger.
  factory Popover.arrow({
    Key? key,
    required Widget child,
    required WidgetBuilder contentBuilder,
    PopoverController? controller,
    double? spacing,
    Offset? offset,
    double? contentHeight,
    double? contentWidth,
    PopoverTriggerMode triggerMode = const TapTriggerMode(),
    Color? backgroundColor,
    BorderRadius? borderRadius,
    ArrowShape? arrowShape,
    Size? arrowSize,
    double? arrowAlignment,
    AxisDirection? preferredDirection,
    Axis? constrainAxis,
    PopoverCrossAxisAlignment? crossAxisAlignment,
    FlipMode? flipMode,
    PopoverScrollBehavior? scrollBehavior,
    Duration? transitionDuration,
    AnimatedTransitionBuilder? transitionBuilder,
    WidgetBuilder? backdropBuilder,
    List<BoxShadow>? boxShadow,
    BorderSide? border,
    VoidCallback? onShow,
    VoidCallback? onHide,
  }) {
    return Popover(
      key: key,
      controller: controller,
      spacing: spacing,
      offset: offset,
      contentHeight: contentHeight,
      contentWidth: contentWidth,
      triggerMode: triggerMode,
      preferredDirection: preferredDirection,
      constrainAxis: constrainAxis,
      crossAxisAlignment: crossAxisAlignment,
      flipMode: flipMode,
      scrollBehavior: scrollBehavior,
      transitionDuration: transitionDuration ?? _defaultTransitionDuration,
      transitionBuilder: transitionBuilder,
      backdropBuilder: backdropBuilder,
      onShow: onShow,
      onHide: onHide,
      contentBuilder: (context) {
        return Builder(
          builder: (context) {
            return PopoverWithArrow(
              backgroundColor: backgroundColor,
              borderRadius: borderRadius,
              arrowShape: arrowShape,
              arrowSize: arrowSize,
              arrowAlignment: arrowAlignment,
              boxShadow: boxShadow,
              border: border,
              child: contentBuilder(context),
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
  final WidgetBuilder contentBuilder;

  /// An optional controller to manage the popover's state programmatically.
  final PopoverController? controller;

  /// Distance from the trigger to the popover content. Automatically adjusts
  /// based on direction when the popover flips.
  final double? spacing;

  /// Absolute position adjustment applied after spacing. Use this for fine-tuning
  /// when automatic positioning needs adjustment.
  final Offset? offset;

  /// The height of the popover content. Providing this helps with positioning.
  final double? contentHeight;

  /// The width of the popover content. Providing this helps with positioning.
  final double? contentWidth;

  /// How the popover is triggered and its mode-specific configuration.
  final PopoverTriggerMode triggerMode;

  /// The preferred direction to show the popover if space allows.
  final AxisDirection? preferredDirection;

  /// Constrains the popover's position to a single axis.
  final Axis? constrainAxis;

  /// How to align the popover on the cross-axis.
  final PopoverCrossAxisAlignment? crossAxisAlignment;

  /// Controls how the popover flips to fit on screen.
  ///
  /// - [FlipMode.both] (default): The popover will flip both its direction
  ///   (up/down, left/right) and alignment to fit within screen bounds.
  /// - [FlipMode.mainAxis]: Only flips the direction, keeping alignment fixed.
  /// - [FlipMode.crossAxis]: Only flips the alignment, keeping direction fixed.
  /// - [FlipMode.none]: No flipping; the popover may overflow the screen.
  final FlipMode? flipMode;

  /// Defines how the popover responds to scrolling of ancestor scrollable widgets.
  ///
  /// - [PopoverScrollBehavior.dismiss] (default): Immediately hides when scrolling
  ///   begins, preventing awkward positioning issues.
  /// - [PopoverScrollBehavior.reposition]: Recalculates positioning during scroll
  ///   to handle screen bounds, flipping, and alignment. Hides when trigger scrolls
  ///   completely offscreen.
  /// - [PopoverScrollBehavior.none]: No special handling; popover may appear
  ///   misaligned or detached during scroll.
  final PopoverScrollBehavior? scrollBehavior;

  /// The duration for the entry and exit animations.
  final Duration? transitionDuration;

  /// A custom builder for the popover's animation.
  final AnimatedTransitionBuilder? transitionBuilder;

  /// A builder for the backdrop widget displayed behind the popover.
  final WidgetBuilder? backdropBuilder;

  /// Called when the popover is shown.
  final VoidCallback? onShow;

  /// Called when the popover begins hiding.
  final VoidCallback? onHide;

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
  Size? _lastScreenSize;
  late final AnimationController _animationController;

  ScrollPosition? _scrollPosition;

  PopoverController get _controller =>
      widget.controller ?? (_internalController ??= PopoverController());

  Duration get _effectiveTransitionDuration =>
      widget.transitionDuration ?? _defaultTransitionDuration;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _effectiveTransitionDuration,
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
      _animationController.duration = _effectiveTransitionDuration;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentSize = MediaQuery.sizeOf(context);

    if (_lastScreenSize != currentSize && _overlayController.isShowing) {
      _lastScreenSize = currentSize;
      _calculateAnchors();
    } else {
      _lastScreenSize = currentSize;
    }

    if (widget.scrollBehavior != PopoverScrollBehavior.none) {
      final newScrollPosition = Scrollable.maybeOf(context)?.position;
      if (_scrollPosition != newScrollPosition) {
        _scrollPosition?.removeListener(_handleScroll);
        _scrollPosition = newScrollPosition;
        _scrollPosition?.addListener(_handleScroll);
      }
    } else {
      _scrollPosition?.removeListener(_handleScroll);
      _scrollPosition = null;
    }
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_handleAnimationStatusChanged);
    _animationController.dispose();

    _isChildHovered.removeListener(_handleHoverChange);
    _isOverlayHovered.removeListener(_handleHoverChange);
    _controller.removeListener(_handleControllerChange);
    _scrollPosition?.removeListener(_handleScroll);
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

  // Sync is set to false to avoid infinite loops when the controller changes
  void _handleControllerChange() {
    if (_controller.isShowing) {
      _showPopover(sync: false);
    } else {
      _hidePopover(sync: false);
    }
  }

  void _showPopover({bool sync = true}) {
    if (_overlayController.isShowing) return;
    _calculateAnchors();
    _overlayController.show();
    _animationController.forward();
    if (sync && !_controller.isShowing) {
      _controller.show();
    }

    if (sync) {
      widget.onShow?.call();
    }
  }

  void _hidePopover({bool sync = true}) {
    if (!_overlayController.isShowing) return;
    _animationController.reverse();
    if (sync && _controller.isShowing) {
      _controller.hide();
    }

    if (sync) {
      widget.onHide?.call();
    }
  }

  void _tryShow() {
    if (_overlayController.isShowing || (_showTimer?.isActive ?? false)) return;
    final showDelay = switch (widget.triggerMode) {
      HoverTriggerMode(:final showDelay) => showDelay,
      _ => Duration.zero,
    };
    _showTimer = Timer(showDelay, _showPopover);
  }

  void _calculateAnchors() {
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
      contentHeight: widget.contentHeight,
      contentWidth: widget.contentWidth,
      preferredDirection: widget.preferredDirection,
      constrainAxis: widget.constrainAxis,
      crossAxisAlignment:
          widget.crossAxisAlignment ?? _defaultCrossAxisAlignment,
      flipMode: widget.flipMode,
    );

    final spacingOffset = switch (widget.spacing) {
      final spacing? => newAnchors.calculateOffset(spacing: spacing),
      null => newAnchors.calculateOffset(),
    };

    final offset = spacingOffset + (widget.offset ?? Offset.zero);

    final geometry = PopoverGeometry.calculate(
      anchors: newAnchors,
      offset: offset,
      leaderGlobalPosition: leaderGlobalPosition,
      leaderSize: leaderSize,
      contentWidth: widget.contentWidth,
      contentHeight: widget.contentHeight,
    );

    _controller.setAnchors(newAnchors);
    _controller.setGeometry(geometry);
  }

  void _handleHoverChange() {
    _hideTimer?.cancel();
    if (!_isChildHovered.value && !_isOverlayHovered.value) {
      final debounceDuration = switch (widget.triggerMode) {
        HoverTriggerMode(:final debounceDuration) => debounceDuration,
        _ => const Duration(milliseconds: 50),
      };
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

  void _handleScroll() {
    if (!_overlayController.isShowing) return;
    if (_animationController.isAnimating) return;

    switch (widget.scrollBehavior ?? PopoverScrollBehavior.dismiss) {
      case PopoverScrollBehavior.dismiss:
        _showTimer?.cancel();
        _hideTimer?.cancel();
        _hidePopover();
        break;

      case PopoverScrollBehavior.reposition:
        if (_isTriggerInViewport()) {
          _calculateAnchors();
        } else {
          _showTimer?.cancel();
          _hideTimer?.cancel();
          _hidePopover();
        }
        break;

      case PopoverScrollBehavior.none:
        // Should never be called since we don't attach listener for 'none'
        break;
    }
  }

  bool _isTriggerInViewport() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return false;

    final triggerGlobalPosition = renderBox.localToGlobal(Offset.zero);
    final triggerSize = renderBox.size;
    final screenSize = MediaQuery.sizeOf(context);

    // Check if trigger is completely outside the viewport
    final triggerRect = triggerGlobalPosition & triggerSize;
    final screenRect = Offset.zero & screenSize;

    return screenRect.overlaps(triggerRect);
  }

  @override
  Widget build(BuildContext context) {
    final triggerMode = widget.triggerMode;
    final enableHover = triggerMode is HoverTriggerMode;
    final enableTap = triggerMode is TapTriggerMode;
    final enableOverlayHover =
        _PopoverConfig.maybeOf(context)?.enableOverlayHover ?? true;

    final consumeOutsideTap = switch (triggerMode) {
      TapTriggerMode(:final consumeOutsideTap) => consumeOutsideTap,
      _ => false,
    };

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (context) {
        return TapRegion(
          groupId: _tapRegionGroupId,
          onTapOutside: enableTap ? _handleTapOutside : null,
          consumeOutsideTaps: consumeOutsideTap,
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              final anchors = _controller.anchors;
              final geometry = _controller.geometry;
              final offset = geometry.offset;

              return PopoverData(
                controller: _controller,
                geometry: geometry,
                child: Stack(
                  children: [
                    if (widget.backdropBuilder case final builder?)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Builder(
                            builder: (context) => builder(context),
                          ),
                        ),
                      ),
                    CompositedTransformFollower(
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
                          MouseRegion(
                            onEnter: enableHover && enableOverlayHover
                                ? (_) => _isOverlayHovered.value = true
                                : null,
                            onExit: enableHover && enableOverlayHover
                                ? (_) => _isOverlayHovered.value = false
                                : null,
                            child: widget.contentBuilder(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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

/// Internal configuration for popover behavior.
class _PopoverConfig extends InheritedWidget {
  final bool enableOverlayHover;

  const _PopoverConfig({
    required this.enableOverlayHover,
    required super.child,
  });

  static _PopoverConfig? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_PopoverConfig>();
  }

  @override
  bool updateShouldNotify(_PopoverConfig oldWidget) {
    return enableOverlayHover != oldWidget.enableOverlayHover;
  }
}
