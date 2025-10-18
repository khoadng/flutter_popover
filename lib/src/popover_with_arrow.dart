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
  final double? borderRadius;

  /// The shape of the arrow.
  final ArrowShape? arrowShape;

  /// Overrides the automatic arrow direction.
  final AxisDirection? arrowDirection;

  /// The position of the arrow along the popover's edge (0.0 to 1.0).
  final double? arrowAlignment;

  /// The width of the arrow's base.
  final double? arrowWidth;

  /// The height of the arrow from its base to its tip.
  final double? arrowHeight;

  /// The color of the border.
  final Color? borderColor;

  /// The width of the border.
  final double? borderWidth;

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
    this.arrowWidth,
    this.arrowHeight,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final controller = PopoverData.of(context);
    final anchors = controller.anchors;

    final arrowHeight = this.arrowHeight ?? 10.0;
    final arrowShape = this.arrowShape ?? const SharpArrow();
    final borderRadius = this.borderRadius ?? 8.0;
    final borderWidth = this.borderWidth ?? 0.0;

    final arrowInfo = ArrowInfo.fromAnchors(
      anchors: anchors,
      userArrowDirection: arrowDirection,
      userArrowAlignment: arrowAlignment,
    );

    return Container(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: PopoverShapeBorder(
          arrowShape: arrowShape,
          arrowDirection: arrowInfo.direction,
          arrowAlignment: arrowInfo.alignment,
          arrowWidth: arrowWidth,
          arrowHeight: arrowHeight,
          borderRadius: BorderRadius.circular(borderRadius),
          borderColor: borderColor,
          borderWidth: borderWidth,
        ),
        shadows: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
      ),
      margin: EdgeInsets.only(
        top: arrowInfo.direction == AxisDirection.up ? arrowHeight : 0,
        bottom: arrowInfo.direction == AxisDirection.down ? arrowHeight : 0,
        left: arrowInfo.direction == AxisDirection.left ? arrowHeight : 0,
        right: arrowInfo.direction == AxisDirection.right ? arrowHeight : 0,
      ),
      child: child,
    );
  }
}
