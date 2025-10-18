import 'package:flutter/material.dart';

import 'popover_anchors.dart';
import 'popover_with_arrow.dart';

/// Contains calculated information about the arrow's direction and alignment
/// for a popover.
///
/// This class encapsulates the logic for determining arrow positioning based
/// on the popover's anchor configuration, making it easily testable.
class ArrowInfo {
  /// The direction the arrow points.
  final AxisDirection direction;

  /// The position of the arrow along the popover's edge (0.0 to 1.0).
  final double alignment;

  /// Creates arrow information with the given direction and alignment.
  const ArrowInfo({
    required this.direction,
    required this.alignment,
  });

  /// Calculates the arrow direction and alignment based on popover anchors.
  ///
  /// If [userArrowDirection] is provided, it will be used and [userArrowAlignment]
  /// defaults to center if not provided.
  ///
  /// If [userArrowDirection] is null, the direction is automatically determined
  /// from the [anchors], and alignment is calculated based on the cross-axis
  /// position unless [userArrowAlignment] is provided.
  ///
  /// When [userArrowAlignment] is provided, the value represents the position
  /// along the trigger element's edge (0.0 = start, 0.5 = center, 1.0 = end).
  /// The arrow will automatically adjust to point to the same relative position
  /// on the trigger, regardless of which side the popover appears on due to
  /// screen constraints.
  factory ArrowInfo.fromAnchors({
    required PopoverAnchors anchors,
    AxisDirection? userArrowDirection,
    double? userArrowAlignment,
  }) {
    if (userArrowDirection != null) {
      return ArrowInfo(
        direction: userArrowDirection,
        alignment: userArrowAlignment ?? kArrowAlignmentCenter,
      );
    }

    final direction = switch (anchors) {
      PopoverAnchors(isLeft: true) => AxisDirection.right,
      PopoverAnchors(isRight: true) => AxisDirection.left,
      PopoverAnchors(isBelow: true) => AxisDirection.up,
      _ => AxisDirection.down, // isAbove
    };

    // Calculate alignment
    final alignment = switch (userArrowAlignment) {
      // User provided alignment: flip based on whether cross-axis was flipped
      // When NOT flipped, we need to invert (0.1 -> 0.9) because the alignment
      // is relative to the trigger edge, not the popover edge
      final double value when !anchors.isCrossAxisFlipped => 1.0 - value,
      final double value => value,
      // Auto-calculate alignment from anchor position
      null => _calculateAutoAlignment(anchors: anchors, direction: direction),
    };

    return ArrowInfo(
      direction: direction,
      alignment: alignment,
    );
  }

  /// Calculates automatic arrow alignment based on cross-axis positioning.
  ///
  /// For horizontal arrows (left/right), uses the vertical (y) anchor position.
  /// For vertical arrows (up/down), uses the horizontal (x) anchor position.
  static double _calculateAutoAlignment({
    required PopoverAnchors anchors,
    required AxisDirection direction,
  }) {
    final crossAxisValue = switch (direction) {
      AxisDirection.left || AxisDirection.right => anchors.followerAnchor.y,
      AxisDirection.up || AxisDirection.down => anchors.followerAnchor.x,
    };

    return switch (crossAxisValue) {
      <= -0.5 => kArrowAlignmentStart, // Aligned to start edge
      >= 0.5 => kArrowAlignmentEnd, // Aligned to end edge
      _ => kArrowAlignmentCenter, // Center aligned
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArrowInfo &&
          runtimeType == other.runtimeType &&
          direction == other.direction &&
          alignment == other.alignment;

  @override
  int get hashCode => Object.hash(direction, alignment);

  @override
  String toString() =>
      'ArrowInfo(direction: $direction, alignment: $alignment)';
}
