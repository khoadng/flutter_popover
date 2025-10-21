import 'package:flutter/rendering.dart';

import 'anchors.dart';

/// Contains the geometric information of the popover.
class PopoverGeometry {
  /// The global bounds of the popover content.
  ///
  /// This is null if [contentWidth] and [contentHeight] were not provided
  /// to the [Popover] widget, as the size cannot be determined until after
  /// the first layout.
  final Rect? popoverBounds;

  /// The global bounds of the trigger widget.
  final Rect? triggerBounds;

  /// The offset applied to the popover.
  final Offset offset;

  /// The direction the popover is facing relative to its trigger.
  final AxisDirection direction;

  /// The alignment of the popover on the cross-axis.
  final Alignment alignment;

  /// Creates a [PopoverGeometry].
  const PopoverGeometry({
    required this.popoverBounds,
    required this.triggerBounds,
    required this.offset,
    required this.direction,
    required this.alignment,
  });

  /// Calculates the popover geometry based on anchors and positioning information.
  factory PopoverGeometry.calculate({
    required PopoverAnchors anchors,
    required Offset offset,
    Offset? leaderGlobalPosition,
    Size? leaderSize,
    double? contentWidth,
    double? contentHeight,
  }) {
    final direction = anchors.isAbove
        ? AxisDirection.up
        : anchors.isBelow
            ? AxisDirection.down
            : anchors.isLeft
                ? AxisDirection.left
                : AxisDirection.right;

    Rect? popoverBounds;
    if (contentWidth != null &&
        contentHeight != null &&
        leaderGlobalPosition != null &&
        leaderSize != null) {
      final popoverX = leaderGlobalPosition.dx +
          (anchors.targetAnchor.x + 1) * leaderSize.width / 2 +
          offset.dx -
          (anchors.followerAnchor.x + 1) * contentWidth / 2;
      final popoverY = leaderGlobalPosition.dy +
          (anchors.targetAnchor.y + 1) * leaderSize.height / 2 +
          offset.dy -
          (anchors.followerAnchor.y + 1) * contentHeight / 2;
      popoverBounds = Rect.fromLTWH(
        popoverX,
        popoverY,
        contentWidth,
        contentHeight,
      );
    }

    Rect? triggerBounds;
    if (leaderGlobalPosition != null && leaderSize != null) {
      triggerBounds = Rect.fromLTWH(
        leaderGlobalPosition.dx,
        leaderGlobalPosition.dy,
        leaderSize.width,
        leaderSize.height,
      );
    }

    return PopoverGeometry(
      popoverBounds: popoverBounds,
      triggerBounds: triggerBounds,
      offset: offset,
      direction: direction,
      alignment: anchors.overlayAlignment,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PopoverGeometry &&
        other.popoverBounds == popoverBounds &&
        other.triggerBounds == triggerBounds &&
        other.offset == offset &&
        other.direction == direction &&
        other.alignment == alignment;
  }

  @override
  int get hashCode =>
      Object.hash(popoverBounds, triggerBounds, offset, direction, alignment);
}
