import 'package:flutter/material.dart';

typedef _Spaces = ({double above, double below, double left, double right});

/// Defines how the popover should automatically flip to fit on screen.
///
/// The flip behavior controls both main-axis flipping (changing direction)
/// and cross-axis flipping (changing alignment).
enum FlipMode {
  /// No automatic flipping. The popover stays in the preferred direction
  /// and alignment, even if it overflows the screen.
  none,

  /// Only flip the main positioning axis (direction).
  ///
  /// For example, if the popover doesn't fit below, it will flip to appear above.
  /// However, the cross-axis alignment (left/right for vertical popovers,
  /// top/bottom for horizontal popovers) will not flip.
  mainAxis,

  /// Only flip the cross-axis alignment.
  ///
  /// The popover will stay in the preferred direction, but the alignment
  /// may flip. For example, a popover below that is left-aligned may flip
  /// to be right-aligned if there's not enough space on the right.
  crossAxis,

  /// Flip both main and cross axes as needed.
  ///
  /// The popover will flip its direction and alignment to best fit on screen.
  both,
}

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

  /// Returns the offset based on the popover's position direction.
  Offset calculateOffset({double spacing = 8.0}) {
    if (isAbove) {
      return Offset(0, -spacing);
    } else if (isBelow) {
      return Offset(0, spacing);
    } else if (isLeft) {
      return Offset(-spacing, 0);
    } else if (isRight) {
      return Offset(spacing, 0);
    }

    return Offset.zero;
  }

  /// Calculates the optimal `PopoverAnchors` based on available screen space.
  ///
  /// This method determines the best position for the popover by checking the
  /// space around the [leaderSize] at [leaderPosition].
  ///
  /// - [leaderPosition]: The global position of the target widget.
  /// - [leaderSize]: The size of the target widget.
  /// - [screenSize]: The size of the screen or layout constraint.
  /// - [contentHeight]: The height of the popover content, if known.
  /// - [contentWidth]: The width of the popover content, if known.
  /// - [preferredDirection]: The desired direction to place the popover.
  /// - [constrainAxis]: An axis to constrain the popover's position to.
  /// - [crossAxisAlignment]: How to align the popover on the cross-axis.
  /// - [flipMode]: Controls how the popover flips to fit on screen.
  ///   Defaults to [FlipMode.both], which allows flipping both direction and alignment.
  static PopoverAnchors calculate({
    required Offset leaderPosition,
    required Size leaderSize,
    required Size screenSize,
    double? contentHeight,
    double? contentWidth,
    AxisDirection? preferredDirection,
    Axis? constrainAxis,
    PopoverCrossAxisAlignment crossAxisAlignment =
        PopoverCrossAxisAlignment.start,
    FlipMode? flipMode,
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

    // Apply default flipMode early to ensure it's used in all logic
    final effectiveFlipMode = flipMode ?? FlipMode.both;

    final direction = effectiveFlipMode == FlipMode.mainAxis ||
            effectiveFlipMode == FlipMode.both
        ? _chooseDirection(
            spaces: spaces,
            preferredDirection: preferredDirection,
            constrainAxis: constrainAxis,
            contentHeight: contentHeight,
            contentWidth: contentWidth,
            leaderPosition: leaderPosition,
            leaderSize: leaderSize,
            screenSize: screenSize,
          )
        : preferredDirection;

    return _buildAnchorsForDirection(
      direction: direction,
      spaces: spaces,
      leaderPosition: leaderPosition,
      leaderSize: leaderSize,
      screenSize: screenSize,
      contentWidth: contentWidth,
      contentHeight: contentHeight,
      crossAxisAlignment: crossAxisAlignment,
      flipMode: effectiveFlipMode,
    );
  }

  static AxisDirection _chooseDirection({
    required _Spaces spaces,
    required AxisDirection preferredDirection,
    required Axis? constrainAxis,
    required double? contentHeight,
    required double? contentWidth,
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
                contentHeight: contentHeight,
                contentWidth: contentWidth,
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
          contentHeight: contentHeight,
          contentWidth: contentWidth,
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
          contentHeight: contentHeight,
          contentWidth: contentWidth,
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
    required double? contentHeight,
    required double? contentWidth,
    required Offset leaderPosition,
    required Size leaderSize,
    required Size screenSize,
  }) {
    return switch (direction) {
      AxisDirection.up => switch (contentHeight) {
          final double height => spaces.above >= height,
          null => true,
        },
      AxisDirection.down => switch (contentHeight) {
          final double height => spaces.below >= height,
          null => true,
        },
      AxisDirection.left => switch (contentWidth) {
          final double width => spaces.left >= width,
          null => true,
        },
      AxisDirection.right => switch (contentWidth) {
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
    required double? contentWidth,
    required double? contentHeight,
    required PopoverCrossAxisAlignment crossAxisAlignment,
    required FlipMode flipMode,
  }) {
    return switch (direction) {
      AxisDirection.up => _buildVerticalAnchors(
          isAbove: true,
          spaces: spaces,
          leaderPosition: leaderPosition,
          leaderSize: leaderSize,
          screenSize: screenSize,
          contentWidth: contentWidth,
          crossAxisAlignment: crossAxisAlignment,
          flipMode: flipMode,
        ),
      AxisDirection.down => _buildVerticalAnchors(
          isAbove: false,
          spaces: spaces,
          leaderPosition: leaderPosition,
          leaderSize: leaderSize,
          screenSize: screenSize,
          contentWidth: contentWidth,
          crossAxisAlignment: crossAxisAlignment,
          flipMode: flipMode,
        ),
      AxisDirection.left => _buildHorizontalAnchors(
          isLeft: true,
          spaces: spaces,
          leaderPosition: leaderPosition,
          leaderSize: leaderSize,
          screenSize: screenSize,
          contentHeight: contentHeight,
          crossAxisAlignment: crossAxisAlignment,
          flipMode: flipMode,
        ),
      AxisDirection.right => _buildHorizontalAnchors(
          isLeft: false,
          spaces: spaces,
          leaderPosition: leaderPosition,
          leaderSize: leaderSize,
          screenSize: screenSize,
          contentHeight: contentHeight,
          crossAxisAlignment: crossAxisAlignment,
          flipMode: flipMode,
        ),
    };
  }

  static PopoverAnchors _buildVerticalAnchors({
    required bool isAbove,
    required _Spaces spaces,
    required Offset leaderPosition,
    required Size leaderSize,
    required Size screenSize,
    required double? contentWidth,
    required PopoverCrossAxisAlignment crossAxisAlignment,
    required FlipMode flipMode,
  }) {
    final targetY = isAbove ? -1.0 : 1.0;
    final followerY = isAbove ? 1.0 : -1.0;
    final allowCrossAxisFlip =
        flipMode == FlipMode.crossAxis || flipMode == FlipMode.both;

    switch (crossAxisAlignment) {
      case PopoverCrossAxisAlignment.start:
        final shouldFlip = allowCrossAxisFlip &&
            !_shouldShowOnRight(
              leaderX: leaderPosition.dx,
              leaderWidth: leaderSize.width,
              screenWidth: screenSize.width,
              spaces: spaces,
              contentWidth: contentWidth,
            );
        final x = shouldFlip ? 1.0 : -1.0;
        return PopoverAnchors(
          targetAnchor: Alignment(x, targetY),
          followerAnchor: Alignment(x, followerY),
          isCrossAxisFlipped: shouldFlip,
        );

      case PopoverCrossAxisAlignment.center:
        return PopoverAnchors(
          targetAnchor: Alignment(0.0, targetY),
          followerAnchor: Alignment(0.0, followerY),
          isCrossAxisFlipped: false,
        );

      case PopoverCrossAxisAlignment.end:
        final canFitOnLeft = contentWidth == null ||
            leaderPosition.dx + leaderSize.width - contentWidth >= 0;
        final shouldFlip = allowCrossAxisFlip && !canFitOnLeft;
        final x = shouldFlip ? -1.0 : 1.0;
        return PopoverAnchors(
          targetAnchor: Alignment(x, targetY),
          followerAnchor: Alignment(x, followerY),
          isCrossAxisFlipped: shouldFlip,
        );
    }
  }

  static PopoverAnchors _buildHorizontalAnchors({
    required bool isLeft,
    required _Spaces spaces,
    required Offset leaderPosition,
    required Size leaderSize,
    required Size screenSize,
    required double? contentHeight,
    required PopoverCrossAxisAlignment crossAxisAlignment,
    required FlipMode flipMode,
  }) {
    final targetX = isLeft ? -1.0 : 1.0;
    final followerX = isLeft ? 1.0 : -1.0;
    final allowCrossAxisFlip =
        flipMode == FlipMode.crossAxis || flipMode == FlipMode.both;

    switch (crossAxisAlignment) {
      case PopoverCrossAxisAlignment.start:
        final shouldFlip = allowCrossAxisFlip &&
            !_shouldShowOnBottom(
              leaderY: leaderPosition.dy,
              leaderHeight: leaderSize.height,
              screenHeight: screenSize.height,
              spaces: spaces,
              contentHeight: contentHeight,
            );
        final y = shouldFlip ? 1.0 : -1.0;
        return PopoverAnchors(
          targetAnchor: Alignment(targetX, y),
          followerAnchor: Alignment(followerX, y),
          isCrossAxisFlipped: shouldFlip,
        );

      case PopoverCrossAxisAlignment.center:
        return PopoverAnchors(
          targetAnchor: Alignment(targetX, 0.0),
          followerAnchor: Alignment(followerX, 0.0),
          isCrossAxisFlipped: false,
        );

      case PopoverCrossAxisAlignment.end:
        final canFitAbove = contentHeight == null ||
            leaderPosition.dy + leaderSize.height - contentHeight >= 0;
        final shouldFlip = allowCrossAxisFlip && !canFitAbove;
        final y = shouldFlip ? -1.0 : 1.0;
        return PopoverAnchors(
          targetAnchor: Alignment(targetX, y),
          followerAnchor: Alignment(followerX, y),
          isCrossAxisFlipped: shouldFlip,
        );
    }
  }

  static bool _shouldShowOnRight({
    required double leaderX,
    required double leaderWidth,
    required double screenWidth,
    required _Spaces spaces,
    double? contentWidth,
  }) =>
      switch (contentWidth) {
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
    double? contentHeight,
  }) =>
      switch (contentHeight) {
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
