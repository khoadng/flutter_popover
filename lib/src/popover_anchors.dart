import 'package:flutter/material.dart';

typedef _Spaces = ({double above, double below, double left, double right});

/// Defines how the popover aligns with its trigger along the cross-axis.
///
/// The cross-axis is perpendicular to the main positioning axis. For vertical
/// popovers (above/below), the cross-axis is horizontal. For horizontal
/// popovers (left/right), the cross-axis is vertical.
enum PopoverCrossAxisAlignment {
  /// Aligns to the start edge of the trigger, flipping to the end if needed to
  /// prevent overflow.
  ///
  /// For vertical popovers, this aligns the left edges by default.
  /// For horizontal popovers, this aligns the top edges by default.
  start,

  /// Center-aligns with the trigger.
  ///
  /// This alignment does not flip and may cause the popover to overflow if the
  /// trigger is near a screen edge.
  center,

  /// Aligns to the end edge of the trigger, flipping to the start if needed to
  /// prevent overflow.
  ///
  /// For vertical popovers, this aligns the right edges by default.
  /// For horizontal popovers, this aligns the bottom edges by default.
  end,
}

/// Holds the calculated `Alignment` values for positioning a popover.
///
/// This class contains the necessary alignments for a `CompositedTransformFollower`
/// to correctly position a popover relative to its `CompositedTransformTarget`.
class PopoverAnchors {
  /// The alignment point on the popover's target (the trigger widget).
  final Alignment targetAnchor;

  /// The alignment point on the popover itself (the follower widget).
  final Alignment followerAnchor;

  /// The alignment of the popover content within its bounding box, used to
  /// handle overflow.
  final Alignment overlayAlignment;

  /// Whether the cross-axis alignment was flipped from its preferred direction
  /// to prevent overflow.
  final bool isCrossAxisFlipped;

  /// Creates a set of popover anchors.
  const PopoverAnchors({
    required this.targetAnchor,
    required this.followerAnchor,
    Alignment? overlayAlignment,
    this.isCrossAxisFlipped = false,
  }) : overlayAlignment = overlayAlignment ?? followerAnchor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PopoverAnchors &&
        other.targetAnchor == targetAnchor &&
        other.followerAnchor == followerAnchor &&
        other.overlayAlignment == overlayAlignment &&
        other.isCrossAxisFlipped == isCrossAxisFlipped;
  }

  @override
  int get hashCode => Object.hash(
      targetAnchor, followerAnchor, overlayAlignment, isCrossAxisFlipped);

  @override
  String toString() =>
      'PopoverAnchors(targetAnchor: $targetAnchor, followerAnchor: $followerAnchor, overlayAlignment: $overlayAlignment)';

  /// Whether the popover is positioned above the target.
  bool get isAbove => followerAnchor.y > targetAnchor.y;

  /// Whether the popover is positioned below the target.
  bool get isBelow => followerAnchor.y < targetAnchor.y;

  /// Whether the popover is positioned to the left of the target.
  bool get isLeft => followerAnchor.x > targetAnchor.x;

  /// Whether the popover is positioned to the right of the target.
  bool get isRight => followerAnchor.x < targetAnchor.x;

  /// Whether the popover is aligned to the left side of the target.
  bool get isLeftAligned => followerAnchor.x <= 0;

  /// Whether the popover is aligned to the right side of the target.
  bool get isRightAligned => followerAnchor.x > 0;

  /// Calculates the optimal `PopoverAnchors` based on available screen space.
  ///
  /// This method determines the best position for the popover by checking the
  /// space around the [leaderSize] at [leaderPosition].
  ///
  /// - [leaderPosition]: The global position of the target widget.
  /// - [leaderSize]: The size of the target widget.
  /// - [screenSize]: The size of the screen or layout constraint.
  /// - [overlayChildHeight]: The height of the popover content, if known.
  /// - [overlayChildWidth]: The width of the popover content, if known.
  /// - [preferredDirection]: The desired direction to place the popover.
  /// - [constrainAxis]: An axis to constrain the popover's position to.
  /// - [crossAxisAlignment]: How to align the popover on the cross-axis.
  static PopoverAnchors calculate({
    required Offset leaderPosition,
    required Size leaderSize,
    required Size screenSize,
    double? overlayChildHeight,
    double? overlayChildWidth,
    AxisDirection? preferredDirection,
    Axis? constrainAxis,
    PopoverCrossAxisAlignment crossAxisAlignment =
        PopoverCrossAxisAlignment.start,
  }) {
    // Derive preferredDirection from constrainAxis if null
    preferredDirection ??= switch (constrainAxis) {
      Axis.vertical => AxisDirection.up,
      Axis.horizontal => AxisDirection.right,
      null => AxisDirection.up,
    };
    // Validate that preferredDirection aligns with constrainAxis
    assert(
      constrainAxis == null ||
          (constrainAxis == Axis.vertical &&
              (preferredDirection == AxisDirection.up ||
                  preferredDirection == AxisDirection.down)) ||
          (constrainAxis == Axis.horizontal &&
              (preferredDirection == AxisDirection.left ||
                  preferredDirection == AxisDirection.right)),
      'preferredDirection ($preferredDirection) must align with constrainAxis ($constrainAxis). '
      'Use AxisDirection.up/down with Axis.vertical, or AxisDirection.left/right with Axis.horizontal.',
    );

    // Calculate space available in each direction
    final spaces = (
      above: leaderPosition.dy,
      below: screenSize.height - (leaderPosition.dy + leaderSize.height),
      left: leaderPosition.dx,
      right: screenSize.width - (leaderPosition.dx + leaderSize.width),
    );

    final direction = _chooseDirection(
      spaces: spaces,
      preferredDirection: preferredDirection,
      constrainAxis: constrainAxis,
      overlayChildHeight: overlayChildHeight,
      overlayChildWidth: overlayChildWidth,
      leaderPosition: leaderPosition,
      leaderSize: leaderSize,
      screenSize: screenSize,
    );

    return _buildAnchorsForDirection(
      direction: direction,
      spaces: spaces,
      leaderPosition: leaderPosition,
      leaderSize: leaderSize,
      screenSize: screenSize,
      overlayChildWidth: overlayChildWidth,
      overlayChildHeight: overlayChildHeight,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  static AxisDirection _chooseDirection({
    required _Spaces spaces,
    required AxisDirection preferredDirection,
    required Axis? constrainAxis,
    required double? overlayChildHeight,
    required double? overlayChildWidth,
    required Offset leaderPosition,
    required Size leaderSize,
    required Size screenSize,
  }) {
    final allowedDirections = switch (constrainAxis) {
      Axis.vertical => {AxisDirection.up, AxisDirection.down},
      Axis.horizontal => {AxisDirection.left, AxisDirection.right},
      null => {
          AxisDirection.up,
          AxisDirection.down,
          AxisDirection.left,
          AxisDirection.right
        },
    };

    if (constrainAxis == null) {
      final spaceByDirection = {
        AxisDirection.up: spaces.above,
        AxisDirection.down: spaces.below,
        AxisDirection.left: spaces.left,
        AxisDirection.right: spaces.right,
      };

      final fittingDirections = allowedDirections
          .where((direction) => _directionFits(
                direction: direction,
                spaces: spaces,
                overlayChildHeight: overlayChildHeight,
                overlayChildWidth: overlayChildWidth,
                leaderPosition: leaderPosition,
                leaderSize: leaderSize,
                screenSize: screenSize,
              ))
          .toList();

      if (fittingDirections.isNotEmpty) {
        // Choose the direction with the most space
        return fittingDirections.reduce(
            (a, b) => spaceByDirection[a]! >= spaceByDirection[b]! ? a : b);
      }

      // If nothing fits, choose direction with most space anyway
      return allowedDirections.reduce(
          (a, b) => spaceByDirection[a]! >= spaceByDirection[b]! ? a : b);
    }

    // For constrained axes, prefer the preferred direction if it fits
    if (allowedDirections.contains(preferredDirection) &&
        _directionFits(
          direction: preferredDirection,
          spaces: spaces,
          overlayChildHeight: overlayChildHeight,
          overlayChildWidth: overlayChildWidth,
          leaderPosition: leaderPosition,
          leaderSize: leaderSize,
          screenSize: screenSize,
        )) {
      return preferredDirection;
    }

    // Try opposite direction on same axis
    final oppositeDirection = _getOppositeDirection(preferredDirection);
    if (allowedDirections.contains(oppositeDirection) &&
        _directionFits(
          direction: oppositeDirection,
          spaces: spaces,
          overlayChildHeight: overlayChildHeight,
          overlayChildWidth: overlayChildWidth,
          leaderPosition: leaderPosition,
          leaderSize: leaderSize,
          screenSize: screenSize,
        )) {
      return oppositeDirection;
    }

    // If constrained to an axis, choose the direction with more space on that axis
    if (constrainAxis == Axis.vertical) {
      return spaces.above >= spaces.below
          ? AxisDirection.up
          : AxisDirection.down;
    } else if (constrainAxis == Axis.horizontal) {
      return spaces.left >= spaces.right
          ? AxisDirection.left
          : AxisDirection.right;
    }

    // No constraint - find direction with most space among allowed directions
    final spaceByDirection = {
      AxisDirection.up: spaces.above,
      AxisDirection.down: spaces.below,
      AxisDirection.left: spaces.left,
      AxisDirection.right: spaces.right,
    };

    return allowedDirections
        .reduce((a, b) => spaceByDirection[a]! >= spaceByDirection[b]! ? a : b);
  }

  static AxisDirection _getOppositeDirection(AxisDirection direction) {
    return switch (direction) {
      AxisDirection.up => AxisDirection.down,
      AxisDirection.down => AxisDirection.up,
      AxisDirection.left => AxisDirection.right,
      AxisDirection.right => AxisDirection.left,
    };
  }

  static bool _directionFits({
    required AxisDirection direction,
    required _Spaces spaces,
    required double? overlayChildHeight,
    required double? overlayChildWidth,
    required Offset leaderPosition,
    required Size leaderSize,
    required Size screenSize,
  }) {
    return switch (direction) {
      AxisDirection.up => switch (overlayChildHeight) {
          final double height => spaces.above >= height,
          null => true,
        },
      AxisDirection.down => switch (overlayChildHeight) {
          final double height => spaces.below >= height,
          null => true,
        },
      AxisDirection.left => switch (overlayChildWidth) {
          final double width => spaces.left >= width,
          null => true,
        },
      AxisDirection.right => switch (overlayChildWidth) {
          final double width => spaces.right >= width,
          null => true,
        },
    };
  }

  static PopoverAnchors _buildAnchorsForDirection({
    required AxisDirection direction,
    required _Spaces spaces,
    required Offset leaderPosition,
    required Size leaderSize,
    required Size screenSize,
    required double? overlayChildWidth,
    required double? overlayChildHeight,
    required PopoverCrossAxisAlignment crossAxisAlignment,
  }) {
    return switch (direction) {
      AxisDirection.up => _buildVerticalAnchors(
          isAbove: true,
          spaces: spaces,
          leaderPosition: leaderPosition,
          leaderSize: leaderSize,
          screenSize: screenSize,
          overlayChildWidth: overlayChildWidth,
          crossAxisAlignment: crossAxisAlignment,
        ),
      AxisDirection.down => _buildVerticalAnchors(
          isAbove: false,
          spaces: spaces,
          leaderPosition: leaderPosition,
          leaderSize: leaderSize,
          screenSize: screenSize,
          overlayChildWidth: overlayChildWidth,
          crossAxisAlignment: crossAxisAlignment,
        ),
      AxisDirection.left => _buildHorizontalAnchors(
          isLeft: true,
          spaces: spaces,
          leaderPosition: leaderPosition,
          leaderSize: leaderSize,
          screenSize: screenSize,
          overlayChildHeight: overlayChildHeight,
          crossAxisAlignment: crossAxisAlignment,
        ),
      AxisDirection.right => _buildHorizontalAnchors(
          isLeft: false,
          spaces: spaces,
          leaderPosition: leaderPosition,
          leaderSize: leaderSize,
          screenSize: screenSize,
          overlayChildHeight: overlayChildHeight,
          crossAxisAlignment: crossAxisAlignment,
        ),
    };
  }

  static PopoverAnchors _buildVerticalAnchors({
    required bool isAbove,
    required _Spaces spaces,
    required Offset leaderPosition,
    required Size leaderSize,
    required Size screenSize,
    required double? overlayChildWidth,
    required PopoverCrossAxisAlignment crossAxisAlignment,
  }) {
    final targetY = isAbove ? -1.0 : 1.0;
    final followerY = isAbove ? 1.0 : -1.0;

    switch (crossAxisAlignment) {
      case PopoverCrossAxisAlignment.start:
        // Start alignment: left edge by default, flip to right if not enough space
        final showOnRight = _shouldShowOnRight(
          leaderX: leaderPosition.dx,
          leaderWidth: leaderSize.width,
          screenWidth: screenSize.width,
          spaces: spaces,
          overlayChildWidth: overlayChildWidth,
        );
        final x = showOnRight ? -1.0 : 1.0; // left edge or right edge
        return PopoverAnchors(
          targetAnchor: Alignment(x, targetY),
          followerAnchor: Alignment(x, followerY),
          isCrossAxisFlipped: showOnRight,
        );

      case PopoverCrossAxisAlignment.center:
        // Center alignment: always center, no flipping
        return PopoverAnchors(
          targetAnchor: Alignment(0.0, targetY),
          followerAnchor: Alignment(0.0, followerY),
          isCrossAxisFlipped: false,
        );

      case PopoverCrossAxisAlignment.end:
        // End alignment: right edge by default, flip to left if not enough space
        final canFitOnLeft = overlayChildWidth == null ||
            leaderPosition.dx + leaderSize.width - overlayChildWidth >= 0;
        final x =
            canFitOnLeft ? 1.0 : -1.0; // right edge or left edge (flipped)
        return PopoverAnchors(
          targetAnchor: Alignment(x, targetY),
          followerAnchor: Alignment(x, followerY),
          isCrossAxisFlipped: !canFitOnLeft,
        );
    }
  }

  static PopoverAnchors _buildHorizontalAnchors({
    required bool isLeft,
    required _Spaces spaces,
    required Offset leaderPosition,
    required Size leaderSize,
    required Size screenSize,
    required double? overlayChildHeight,
    required PopoverCrossAxisAlignment crossAxisAlignment,
  }) {
    final targetX = isLeft ? -1.0 : 1.0;
    final followerX = isLeft ? 1.0 : -1.0;

    switch (crossAxisAlignment) {
      case PopoverCrossAxisAlignment.start:
        // Start alignment: top edge by default, flip to bottom if not enough space
        final showOnBottom = _shouldShowOnBottom(
          leaderY: leaderPosition.dy,
          leaderHeight: leaderSize.height,
          screenHeight: screenSize.height,
          spaces: spaces,
          overlayChildHeight: overlayChildHeight,
        );
        final y = showOnBottom ? -1.0 : 1.0; // top edge or bottom edge
        return PopoverAnchors(
          targetAnchor: Alignment(targetX, y),
          followerAnchor: Alignment(followerX, y),
          isCrossAxisFlipped: showOnBottom,
        );

      case PopoverCrossAxisAlignment.center:
        // Center alignment: always center, no flipping
        return PopoverAnchors(
          targetAnchor: Alignment(targetX, 0.0),
          followerAnchor: Alignment(followerX, 0.0),
          isCrossAxisFlipped: false,
        );

      case PopoverCrossAxisAlignment.end:
        // End alignment: bottom edge by default, flip to top if not enough space
        final canFitAbove = overlayChildHeight == null ||
            leaderPosition.dy + leaderSize.height - overlayChildHeight >= 0;
        final y = canFitAbove ? 1.0 : -1.0; // bottom edge or top edge (flipped)
        return PopoverAnchors(
          targetAnchor: Alignment(targetX, y),
          followerAnchor: Alignment(followerX, y),
          isCrossAxisFlipped: !canFitAbove,
        );
    }
  }

  static bool _shouldShowOnRight({
    required double leaderX,
    required double leaderWidth,
    required double screenWidth,
    required _Spaces spaces,
    double? overlayChildWidth,
  }) =>
      switch (overlayChildWidth) {
        final double width => switch ((
            fitsRight: leaderX + width <= screenWidth, // Can fit on right
            fitsLeft: leaderX + leaderWidth - width >= 0, // Can fit on left
          )) {
            (fitsRight: true, fitsLeft: _) => true, // Prefer right if it fits
            (fitsRight: false, fitsLeft: true) => false, // Use left if it fits
            (fitsRight: false, fitsLeft: false) =>
              spaces.right >= spaces.left, // Choose larger space
          },
        null => spaces.right >= spaces.left,
      };

  static bool _shouldShowOnBottom({
    required double leaderY,
    required double leaderHeight,
    required double screenHeight,
    required _Spaces spaces,
    double? overlayChildHeight,
  }) =>
      switch (overlayChildHeight) {
        final double height => switch ((
            fitsBottom: leaderY + height <= screenHeight, // Can fit on bottom
            fitsTop: leaderY + leaderHeight - height >= 0, // Can fit on top
          )) {
            (fitsBottom: true, fitsTop: _) => true, // Prefer bottom if it fits
            (fitsBottom: false, fitsTop: true) => false, // Use top if it fits
            (fitsBottom: false, fitsTop: false) =>
              spaces.below >= spaces.above, // Choose larger space
          },
        null => spaces.below >= spaces.above,
      };
}
