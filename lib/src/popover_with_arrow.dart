import 'package:flutter/material.dart';

import 'arrows.dart';
import 'popover.dart';

/// Constant for aligning the arrow to the start of the popover edge.
const double kArrowAlignmentStart = 0.1;

/// Constant for aligning the arrow to the center of the popover edge.
const double kArrowAlignmentCenter = 0.5;

/// Constant for aligning the arrow to the end of the popover edge.
const double kArrowAlignmentEnd = 0.9;

/// A [ShapeBorder] that draws a customizable speech bubble-like shape with
/// an arrow.
class PopoverShapeBorder extends ShapeBorder {
  /// The shape of the arrow (e.g., sharp or rounded).
  final ArrowShape arrowShape;

  /// The direction the arrow points.
  final AxisDirection arrowDirection;

  /// The position of the arrow along the popover edge, from 0.0 (start) to
  /// 1.0 (end).
  final double? arrowAlignment;

  /// The base width of the arrow.
  final double? arrowWidth;

  /// The height of the arrow from its base to its tip.
  final double? arrowHeight;

  /// The border radius for the main body of the popover.
  final BorderRadius borderRadius;

  /// The color of the border.
  final Color? borderColor;

  /// The width of the border.
  final double borderWidth;

  /// Creates a shape for a popover with an arrow.
  const PopoverShapeBorder({
    this.arrowShape = const SharpArrow(),
    required this.arrowDirection,
    this.arrowAlignment,
    this.arrowWidth,
    this.arrowHeight,
    this.borderRadius = BorderRadius.zero,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final rrect = borderRadius.toRRect(rect);
    return _buildArrowPath(rect, rrect);
  }

  Path _buildArrowPath(Rect rect, RRect rrect) {
    final path = Path();

    // Calculate arrow position based on alignment (0.0 to 1.0)
    late final Offset arrowBaseStart;
    late final Offset arrowBaseEnd;
    final arrowAlignment = this.arrowAlignment ?? kArrowAlignmentStart;
    final arrowWidth = this.arrowWidth ?? 20.0;
    final arrowHeight = this.arrowHeight ?? 10.0;

    switch (arrowDirection) {
      case AxisDirection.up:
        final centerX = rect.left + (rect.width * arrowAlignment);
        arrowBaseStart = Offset(centerX - arrowWidth / 2, rect.top);
        arrowBaseEnd = Offset(centerX + arrowWidth / 2, rect.top);
        break;
      case AxisDirection.down:
        final centerX = rect.left + (rect.width * arrowAlignment);
        arrowBaseStart = Offset(centerX - arrowWidth / 2, rect.bottom);
        arrowBaseEnd = Offset(centerX + arrowWidth / 2, rect.bottom);
        break;
      case AxisDirection.left:
        final centerY = rect.top + (rect.height * arrowAlignment);
        arrowBaseStart = Offset(rect.left, centerY - arrowWidth / 2);
        arrowBaseEnd = Offset(rect.left, centerY + arrowWidth / 2);
        break;
      case AxisDirection.right:
        final centerY = rect.top + (rect.height * arrowAlignment);
        arrowBaseStart = Offset(rect.right, centerY - arrowWidth / 2);
        arrowBaseEnd = Offset(rect.right, centerY + arrowWidth / 2);
        break;
    }

    // Start from top-left, draw clockwise
    path.moveTo(rrect.left, rrect.top + rrect.tlRadiusY);

    // Top-left corner
    if (rrect.tlRadius != Radius.zero) {
      path.arcToPoint(
        Offset(rrect.left + rrect.tlRadiusX, rrect.top),
        radius: rrect.tlRadius,
      );
    }

    // Top edge
    if (arrowDirection == AxisDirection.up) {
      path.lineTo(arrowBaseStart.dx, arrowBaseStart.dy);
      arrowShape.buildArrowPath(
        path: path,
        baseStart: arrowBaseStart,
        baseEnd: arrowBaseEnd,
        direction: arrowDirection,
        arrowHeight: arrowHeight,
      );
    }
    path.lineTo(rrect.right - rrect.trRadiusX, rrect.top);

    // Top-right corner
    if (rrect.trRadius != Radius.zero) {
      path.arcToPoint(
        Offset(rrect.right, rrect.top + rrect.trRadiusY),
        radius: rrect.trRadius,
      );
    }

    // Right edge
    if (arrowDirection == AxisDirection.right) {
      path.lineTo(arrowBaseStart.dx, arrowBaseStart.dy);
      arrowShape.buildArrowPath(
        path: path,
        baseStart: arrowBaseStart,
        baseEnd: arrowBaseEnd,
        direction: arrowDirection,
        arrowHeight: arrowHeight,
      );
    }
    path.lineTo(rrect.right, rrect.bottom - rrect.brRadiusY);

    // Bottom-right corner
    if (rrect.brRadius != Radius.zero) {
      path.arcToPoint(
        Offset(rrect.right - rrect.brRadiusX, rrect.bottom),
        radius: rrect.brRadius,
      );
    }

    // Bottom edge
    if (arrowDirection == AxisDirection.down) {
      path.lineTo(arrowBaseEnd.dx, arrowBaseEnd.dy);
      arrowShape.buildArrowPath(
        path: path,
        baseStart: arrowBaseEnd,
        baseEnd: arrowBaseStart,
        direction: arrowDirection,
        arrowHeight: arrowHeight,
      );
    }
    path.lineTo(rrect.left + rrect.blRadiusX, rrect.bottom);

    // Bottom-left corner
    if (rrect.blRadius != Radius.zero) {
      path.arcToPoint(
        Offset(rrect.left, rrect.bottom - rrect.blRadiusY),
        radius: rrect.blRadius,
      );
    }

    // Left edge
    if (arrowDirection == AxisDirection.left) {
      path.lineTo(arrowBaseEnd.dx, arrowBaseEnd.dy);
      arrowShape.buildArrowPath(
        path: path,
        baseStart: arrowBaseEnd,
        baseEnd: arrowBaseStart,
        direction: arrowDirection,
        arrowHeight: arrowHeight,
      );
    }
    path.lineTo(rrect.left, rrect.top + rrect.tlRadiusY);

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (borderColor != null && borderWidth > 0) {
      final paint = Paint()
        ..color = borderColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;

      canvas.drawPath(getOuterPath(rect, textDirection: textDirection), paint);
    }
  }

  @override
  ShapeBorder scale(double t) {
    return PopoverShapeBorder(
      arrowShape: arrowShape,
      arrowDirection: arrowDirection,
      arrowAlignment: arrowAlignment,
      arrowWidth: (arrowWidth ?? 20.0) * t,
      arrowHeight: (arrowHeight ?? 10.0) * t,
      borderRadius: borderRadius * t,
      borderColor: borderColor,
      borderWidth: borderWidth * t,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PopoverShapeBorder &&
          runtimeType == other.runtimeType &&
          arrowShape == other.arrowShape &&
          arrowDirection == other.arrowDirection &&
          arrowAlignment == other.arrowAlignment &&
          arrowWidth == other.arrowWidth &&
          arrowHeight == other.arrowHeight &&
          borderRadius == other.borderRadius &&
          borderColor == other.borderColor &&
          borderWidth == other.borderWidth;

  @override
  int get hashCode => Object.hash(
        runtimeType,
        arrowShape,
        arrowDirection,
        arrowAlignment,
        arrowWidth,
        arrowHeight,
        borderRadius,
        borderColor,
        borderWidth,
      );
}

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

    final AxisDirection finalArrowDirection;
    final double finalArrowAlignment;
    final arrowHeight = this.arrowHeight ?? 10.0;
    final arrowShape = this.arrowShape ?? const SharpArrow();
    final borderRadius = this.borderRadius ?? 8.0;
    final borderWidth = this.borderWidth ?? 0.0;

    if (arrowDirection != null) {
      finalArrowDirection = arrowDirection!;
      finalArrowAlignment = arrowAlignment ?? kArrowAlignmentCenter;
    } else {
      // Adjust arrow alignment if cross-axis was flipped
      final adjustedArrowAlignment =
          anchors.isCrossAxisFlipped && arrowAlignment != null
              ? arrowAlignment
              : 1.0 - arrowAlignment!;

      if (anchors.isLeft) {
        finalArrowDirection = AxisDirection.right;
        finalArrowAlignment = adjustedArrowAlignment ?? kArrowAlignmentStart;
      } else if (anchors.isRight) {
        finalArrowDirection = AxisDirection.left;
        finalArrowAlignment = adjustedArrowAlignment ?? kArrowAlignmentStart;
      } else if (anchors.isBelow) {
        finalArrowDirection = AxisDirection.up;
        finalArrowAlignment = adjustedArrowAlignment ??
            (anchors.isLeftAligned ? kArrowAlignmentStart : kArrowAlignmentEnd);
      } else {
        finalArrowDirection = AxisDirection.down;
        finalArrowAlignment = adjustedArrowAlignment ??
            (anchors.isLeftAligned ? kArrowAlignmentStart : kArrowAlignmentEnd);
      }
    }

    return Container(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: PopoverShapeBorder(
          arrowShape: arrowShape,
          arrowDirection: finalArrowDirection,
          arrowAlignment: finalArrowAlignment,
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
        top: finalArrowDirection == AxisDirection.up ? arrowHeight : 0,
        bottom: finalArrowDirection == AxisDirection.down ? arrowHeight : 0,
        left: finalArrowDirection == AxisDirection.left ? arrowHeight : 0,
        right: finalArrowDirection == AxisDirection.right ? arrowHeight : 0,
      ),
      child: child,
    );
  }
}
