import 'package:flutter/material.dart';

import 'arrow_info.dart';
import 'data.dart';
import 'rendering/arrows.dart';
import 'popover.dart';
import 'rendering/border.dart';

/// Constant for aligning the arrow to the start of the popover edge.
const double kArrowAlignmentStart = 0.1;

/// Constant for aligning the arrow to the center of the popover edge.
const double kArrowAlignmentCenter = 0.5;

/// Constant for aligning the arrow to the end of the popover edge.
const double kArrowAlignmentEnd = 0.9;

const double _defaultArrowSpacing = 8.0;

/// A container widget that automatically applies a [PopoverShapeBorder] and
/// handles arrow direction based on the popover's calculated position.
///
/// This widget is intended to be used within a [Popover.arrow] factory.
class PopoverWithArrow extends StatelessWidget {
  /// The content to display inside the popover.
  final Widget child;

  /// The background color of the popover.
  final Color? backgroundColor;

  /// The border radius of the popover's corners.
  final BorderRadius? borderRadius;

  /// The shape of the arrow.
  final ArrowShape? arrowShape;

  /// Overrides the automatic arrow direction.
  final AxisDirection? arrowDirection;

  /// The position of the arrow along the popover's edge (0.0 to 1.0).
  final double? arrowAlignment;

  /// The size of the arrow
  final Size? arrowSize;

  /// The border style, color, and width.
  final BorderSide? border;

  /// A list of shadows to apply to the popover container.
  final List<BoxShadow>? boxShadow;

  /// Creates a popover container with an arrow.
  const PopoverWithArrow({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius,
    this.arrowShape,
    this.arrowDirection,
    this.arrowAlignment,
    this.arrowSize,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final popoverData = PopoverData.of(context);
    final controller = popoverData.controller;
    final anchors = controller.anchors;
    final offset = popoverData.geometry.offset;

    final effectiveArrowShape = arrowShape ?? const SharpArrow();
    final effectiveArrowSize = arrowSize ?? const Size(20.0, 10.0);
    final effectiveBorderRadius =
        borderRadius ?? const BorderRadius.all(Radius.circular(8.0));
    final effectiveBorder = border ?? BorderSide.none;

    final arrowInfo = ArrowInfo.fromAnchors(
      anchors: anchors,
      userArrowDirection: arrowDirection,
      userArrowAlignment: arrowAlignment,
    );

    final effectiveBackgroundColor =
        backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer;

    // Don't add margin for NoArrow shape
    final hasArrow = effectiveArrowShape is! NoArrow;

    // Calculate margin accounting for offset to prevent double spacing
    double calculateMargin(AxisDirection direction) {
      if (!hasArrow) return 0;

      final offsetInDirection = switch (direction) {
        AxisDirection.up => offset.dy.abs(),
        AxisDirection.down => offset.dy.abs(),
        AxisDirection.left => offset.dx.abs(),
        AxisDirection.right => offset.dx.abs(),
      };

      // Margin = arrow height - offset component + some offset
      return (effectiveArrowSize.height - offsetInDirection)
              .clamp(0, double.infinity) +
          _defaultArrowSpacing;
    }

    return Container(
      decoration: ShapeDecoration(
        color: effectiveBackgroundColor,
        shape: PopoverShapeBorder(
          arrowShape: effectiveArrowShape,
          arrowDirection: arrowInfo.direction,
          arrowAlignment: arrowInfo.alignment,
          arrowSize: effectiveArrowSize,
          borderRadius: effectiveBorderRadius,
          border: effectiveBorder,
        ),
        shadows: boxShadow,
      ),
      margin: hasArrow
          ? EdgeInsets.only(
              top: arrowInfo.direction == AxisDirection.up
                  ? calculateMargin(AxisDirection.up)
                  : 0,
              bottom: arrowInfo.direction == AxisDirection.down
                  ? calculateMargin(AxisDirection.down)
                  : 0,
              left: arrowInfo.direction == AxisDirection.left
                  ? calculateMargin(AxisDirection.left)
                  : 0,
              right: arrowInfo.direction == AxisDirection.right
                  ? calculateMargin(AxisDirection.right)
                  : 0,
            )
          : EdgeInsets.zero,
      child: child,
    );
  }
}
