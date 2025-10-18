import 'package:flutter/material.dart';

import 'arrow_info.dart';
import 'rendering/arrows.dart';
import 'popover.dart';
import 'rendering/border.dart';

/// Constant for aligning the arrow to the start of the popover edge.
const double kArrowAlignmentStart = 0.1;

/// Constant for aligning the arrow to the center of the popover edge.
const double kArrowAlignmentCenter = 0.5;

/// Constant for aligning the arrow to the end of the popover edge.
const double kArrowAlignmentEnd = 0.9;

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
    final controller = PopoverData.of(context);
    final anchors = controller.anchors;

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
      margin: EdgeInsets.only(
        top: arrowInfo.direction == AxisDirection.up
            ? effectiveArrowSize.height
            : 0,
        bottom: arrowInfo.direction == AxisDirection.down
            ? effectiveArrowSize.height
            : 0,
        left: arrowInfo.direction == AxisDirection.left
            ? effectiveArrowSize.height
            : 0,
        right: arrowInfo.direction == AxisDirection.right
            ? effectiveArrowSize.height
            : 0,
      ),
      child: child,
    );
  }
}
