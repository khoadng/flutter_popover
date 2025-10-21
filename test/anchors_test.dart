import 'package:flutter/material.dart';
import 'package:flutter_popover/flutter_popover.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PopoverAnchors.calculate - Vertical (default)', () {
    test('tooltip at top-left corner, fits on right and below', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(0, 0),
        leaderSize: const Size(100, 50),
        screenSize: const Size(400, 800),
        contentHeight: 100,
        contentWidth: 300,
        preferredDirection: AxisDirection.up,
        constrainAxis: Axis.vertical,
      );

      expect(anchors.targetAnchor, Alignment.bottomLeft);
      expect(anchors.followerAnchor, Alignment.topLeft);
      expect(anchors.overlayAlignment, Alignment.topLeft);
    });

    test('tooltip at top-right corner, fits on left and below', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(300, 0),
        leaderSize: const Size(100, 50),
        screenSize: const Size(400, 800),
        contentHeight: 100,
        contentWidth: 300,
      );

      expect(anchors.targetAnchor, Alignment.bottomRight);
      expect(anchors.followerAnchor, Alignment.topRight);
      expect(anchors.overlayAlignment, Alignment.topRight);
    });

    test('tooltip at bottom-left corner, fits on right and above', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(0, 700),
        leaderSize: const Size(100, 50),
        screenSize: const Size(400, 800),
        contentHeight: 100,
        contentWidth: 300,
      );

      expect(anchors.targetAnchor, Alignment.topLeft);
      expect(anchors.followerAnchor, Alignment.bottomLeft);
      expect(anchors.overlayAlignment, Alignment.bottomLeft);
    });

    test('tooltip at bottom-right corner, fits on left and above', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(300, 700),
        leaderSize: const Size(100, 50),
        screenSize: const Size(400, 800),
        contentHeight: 100,
        contentWidth: 300,
      );

      expect(anchors.targetAnchor, Alignment.topRight);
      expect(anchors.followerAnchor, Alignment.bottomRight);
      expect(anchors.overlayAlignment, Alignment.bottomRight);
    });

    test('tooltip in center, chooses direction with most space', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(200, 400),
        leaderSize: const Size(100, 50),
        screenSize: const Size(600, 900),
        contentHeight: 100,
        contentWidth: 300,
      );

      expect(anchors.targetAnchor, Alignment.bottomLeft);
      expect(anchors.followerAnchor, Alignment.topLeft);
      expect(anchors.overlayAlignment, Alignment.topLeft);
    });

    test('tooltip width exactly fits on right from left edge', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(0, 100),
        leaderSize: const Size(159, 120),
        screenSize: const Size(326, 862),
        contentHeight: 100,
        contentWidth: 300,
      );

      expect(anchors.targetAnchor, Alignment.bottomLeft);
      expect(anchors.followerAnchor, Alignment.topLeft);
      expect(anchors.overlayAlignment, Alignment.topLeft);
    });

    test('tooltip width does not fit on right, chooses most space', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(100, 100),
        leaderSize: const Size(200, 120),
        screenSize: const Size(400, 800),
        contentHeight: 100,
        contentWidth: 350,
      );

      expect(anchors.targetAnchor, Alignment.bottomLeft);
      expect(anchors.followerAnchor, Alignment.topLeft);
    });

    test('tooltip without dimensions falls back to space comparison', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(100, 100),
        leaderSize: const Size(100, 50),
        screenSize: const Size(400, 800),
        contentHeight: null,
        contentWidth: null,
      );

      expect(anchors.targetAnchor, Alignment.bottomLeft);
      expect(anchors.followerAnchor, Alignment.topLeft);
      expect(anchors.overlayAlignment, Alignment.topLeft);
    });

    test(
      'small tooltip at top, should show below even with more space above',
      () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(100, 50),
          leaderSize: const Size(100, 50),
          screenSize: const Size(400, 800),
          contentHeight: 100,
          contentWidth: 200,
        );

        expect(anchors.targetAnchor, Alignment.bottomLeft);
        expect(anchors.followerAnchor, Alignment.topLeft);
        expect(anchors.overlayAlignment, Alignment.topLeft);
      },
    );

    test('exact case from debug output', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(0.0, 286.83333333333337),
        leaderSize: const Size(159.0, 90.0),
        screenSize: const Size(326.0, 862.0),
        contentHeight: 100.0,
        contentWidth: 300.0,
      );

      expect(anchors.targetAnchor, Alignment.bottomLeft);
      expect(anchors.followerAnchor, Alignment.topLeft);
      expect(anchors.overlayAlignment, Alignment.topLeft);
    });

    test('position (0, 252) with leader size 159x120', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(0.0, 252.0),
        leaderSize: const Size(159.0, 120.0),
        screenSize: const Size(326.0, 862.0),
        contentHeight: 100.0,
        contentWidth: 300.0,
      );

      expect(anchors.targetAnchor, Alignment.bottomLeft);
      expect(anchors.followerAnchor, Alignment.topLeft);
      expect(anchors.overlayAlignment, Alignment.topLeft);
    });
  });

  group('PopoverAnchors.calculate - Horizontal', () {
    test('left side with enough space', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(400, 300),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 600),
        contentHeight: 100,
        contentWidth: 300,
        preferredDirection: AxisDirection.left,
        constrainAxis: Axis.horizontal,
      );

      expect(anchors.targetAnchor, Alignment.topLeft);
      expect(anchors.followerAnchor, Alignment.topRight);
    });

    test('right side with enough space', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(100, 300),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 600),
        contentHeight: 100,
        contentWidth: 300,
        preferredDirection: AxisDirection.right,
        constrainAxis: Axis.horizontal,
      );

      expect(anchors.targetAnchor, Alignment.topRight);
      expect(anchors.followerAnchor, Alignment.topLeft);
    });

    test('left side with center alignment', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(400, 300),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 600),
        crossAxisAlignment: PopoverCrossAxisAlignment.center,
        contentHeight: 100,
        contentWidth: 300,
        preferredDirection: AxisDirection.left,
        constrainAxis: Axis.horizontal,
      );

      // With center alignment
      expect(anchors.targetAnchor, Alignment.centerLeft);
      expect(anchors.followerAnchor, Alignment.centerRight);
    });

    test('right side with center alignment', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(100, 300),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 600),
        crossAxisAlignment: PopoverCrossAxisAlignment.center,
        contentHeight: 100,
        contentWidth: 300,
        preferredDirection: AxisDirection.right,
        constrainAxis: Axis.horizontal,
      );

      // With center alignment
      expect(anchors.targetAnchor, Alignment.centerRight);
      expect(anchors.followerAnchor, Alignment.centerLeft);
    });
  });

  group('PopoverAnchors.calculate - Unconstrained', () {
    test('chooses side with most space when unconstrained', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(100, 100),
        leaderSize: const Size(100, 50),
        screenSize: const Size(400, 300),
        crossAxisAlignment: PopoverCrossAxisAlignment.center,
        contentHeight: 100,
        contentWidth: 200,
        preferredDirection: AxisDirection.up,
        constrainAxis: null,
      );

      expect(anchors.targetAnchor, Alignment.centerRight);
      expect(anchors.followerAnchor, Alignment.centerLeft);
    });

    test('falls back to horizontal when vertical has no space', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(350, 10),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 200),
        crossAxisAlignment: PopoverCrossAxisAlignment.center,
        contentHeight: 150,
        contentWidth: 100,
        preferredDirection: AxisDirection.up,
        constrainAxis: null,
      );

      expect(anchors.targetAnchor, Alignment.centerLeft);
      expect(anchors.followerAnchor, Alignment.centerRight);
    });

    test(
        'should choose top when there is more space above than to the right (Grid Item 11 scenario)',
        () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(10, 600),
        leaderSize: const Size(120, 120),
        screenSize: const Size(400, 800),
        contentHeight: 200,
        contentWidth: 200,
        preferredDirection: AxisDirection.right,
        constrainAxis: null,
      );

      expect(anchors.targetAnchor, Alignment.topLeft,
          reason:
              'Should position above when there is more space above than to the right');
      expect(anchors.followerAnchor, Alignment.bottomLeft,
          reason:
              'Popover should be anchored below (positioned above the target)');
    });

    test('should respect preferred direction only when space is comparable',
        () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(100, 400),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 900),
        crossAxisAlignment: PopoverCrossAxisAlignment.center,
        contentHeight: 200,
        contentWidth: 200,
        preferredDirection: AxisDirection.right,
        constrainAxis: null,
      );

      expect(anchors.targetAnchor, Alignment.centerRight,
          reason:
              'Should respect preferred direction when it has sufficient space');
    });
  });

  group('PopoverAnchors.calculate - Validation', () {
    test(
        'throws assertion error when preferredDirection conflicts with vertical constraint',
        () {
      expect(
        () => PopoverAnchors.calculate(
          leaderPosition: const Offset(100, 100),
          leaderSize: const Size(100, 50),
          screenSize: const Size(400, 800),
          preferredDirection: AxisDirection.left,
          constrainAxis: Axis.vertical,
        ),
        throwsAssertionError,
      );
    });

    test(
        'throws assertion error when preferredDirection conflicts with horizontal constraint',
        () {
      expect(
        () => PopoverAnchors.calculate(
          leaderPosition: const Offset(100, 100),
          leaderSize: const Size(100, 50),
          screenSize: const Size(400, 800),
          preferredDirection: AxisDirection.up,
          constrainAxis: Axis.horizontal,
        ),
        throwsAssertionError,
      );
    });

    test('allows any preferredDirection when constrainAxis is null', () {
      expect(
        () => PopoverAnchors.calculate(
          leaderPosition: const Offset(100, 100),
          leaderSize: const Size(100, 50),
          screenSize: const Size(400, 800),
          preferredDirection: AxisDirection.left,
          constrainAxis: null,
        ),
        returnsNormally,
      );
    });

    test('allows vertical preferredDirection with vertical constraint', () {
      expect(
        () => PopoverAnchors.calculate(
          leaderPosition: const Offset(100, 100),
          leaderSize: const Size(100, 50),
          screenSize: const Size(400, 800),
          preferredDirection: AxisDirection.up,
          constrainAxis: Axis.vertical,
        ),
        returnsNormally,
      );
    });

    test('allows horizontal preferredDirection with horizontal constraint', () {
      expect(
        () => PopoverAnchors.calculate(
          leaderPosition: const Offset(100, 100),
          leaderSize: const Size(100, 50),
          screenSize: const Size(400, 800),
          preferredDirection: AxisDirection.right,
          constrainAxis: Axis.horizontal,
        ),
        returnsNormally,
      );
    });
  });

  group('PopoverAnchors.calculate - flipMode behavior', () {
    test(
        'FlipMode.both (default) - flips to opposite direction when not enough space',
        () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(100, 20),
        leaderSize: const Size(100, 50),
        screenSize: const Size(400, 800),
        contentHeight: 100,
        contentWidth: 200,
        preferredDirection: AxisDirection.up,
        constrainAxis: Axis.vertical,
        flipMode: FlipMode.both,
      );

      expect(anchors.isBelow, true,
          reason: 'Should flip to below when not enough space above');
      expect(anchors.isAbove, false);
      expect(anchors.targetAnchor, Alignment.bottomLeft);
      expect(anchors.followerAnchor, Alignment.topLeft);
    });

    test(
        'FlipMode.none - does NOT flip to opposite direction even when not enough space',
        () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(100, 20),
        leaderSize: const Size(100, 50),
        screenSize: const Size(400, 800),
        contentHeight: 100,
        contentWidth: 200,
        preferredDirection: AxisDirection.up,
        constrainAxis: Axis.vertical,
        crossAxisAlignment: PopoverCrossAxisAlignment.start,
        flipMode: FlipMode.none,
      );

      expect(anchors.isAbove, true,
          reason: 'Should stay above when flipMode is none');
      expect(anchors.isBelow, false);
      expect(anchors.targetAnchor.y, -1.0,
          reason: 'Should be positioned above (y=-1.0)');
      expect(anchors.followerAnchor.y, 1.0,
          reason: 'Should be positioned above (y=1.0)');
    });

    test('FlipMode.both - flips cross-axis alignment when not enough space',
        () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(650, 300),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 600),
        contentHeight: 100,
        contentWidth: 200,
        preferredDirection: AxisDirection.down,
        constrainAxis: Axis.vertical,
        crossAxisAlignment: PopoverCrossAxisAlignment.start,
        flipMode: FlipMode.both,
      );

      expect(anchors.targetAnchor, Alignment.bottomRight,
          reason: 'Should flip to right edge alignment');
      expect(anchors.followerAnchor, Alignment.topRight);
    });

    test(
        'FlipMode.none - does NOT flip cross-axis alignment even when not enough space',
        () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(650, 300),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 600),
        contentHeight: 100,
        contentWidth: 200,
        preferredDirection: AxisDirection.down,
        constrainAxis: Axis.vertical,
        crossAxisAlignment: PopoverCrossAxisAlignment.start,
        flipMode: FlipMode.none,
      );

      expect(anchors.isCrossAxisFlipped, false,
          reason: 'Should not flip cross-axis when flipMode is none');
      expect(anchors.targetAnchor, Alignment.bottomLeft,
          reason: 'Should stay aligned to left edges');
      expect(anchors.followerAnchor, Alignment.topLeft);
    });

    test('FlipMode.none - horizontal popover does not flip cross-axis', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(300, 10),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 600),
        contentHeight: 200,
        contentWidth: 100,
        preferredDirection: AxisDirection.left,
        constrainAxis: Axis.horizontal,
        crossAxisAlignment: PopoverCrossAxisAlignment.start,
        flipMode: FlipMode.none,
      );

      expect(anchors.isCrossAxisFlipped, false);
      expect(anchors.targetAnchor, Alignment.topLeft,
          reason: 'Should stay aligned to top edges');
      expect(anchors.followerAnchor, Alignment.topRight);
    });

    test('FlipMode.none with end alignment - does not flip to start', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(10, 100),
        leaderSize: const Size(100, 50),
        screenSize: const Size(400, 800),
        contentHeight: 100,
        contentWidth: 300,
        preferredDirection: AxisDirection.down,
        constrainAxis: Axis.vertical,
        crossAxisAlignment: PopoverCrossAxisAlignment.end,
        flipMode: FlipMode.none,
      );

      expect(anchors.isCrossAxisFlipped, false);
      expect(anchors.targetAnchor.x, 1.0,
          reason: 'Should stay aligned to right edges (x=1.0)');
      expect(anchors.followerAnchor.x, 1.0);
    });

    test('FlipMode.mainAxis - flips direction but NOT cross-axis alignment',
        () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(650, 20),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 600),
        contentHeight: 100,
        contentWidth: 200,
        preferredDirection: AxisDirection.up,
        constrainAxis: Axis.vertical,
        crossAxisAlignment: PopoverCrossAxisAlignment.start,
        flipMode: FlipMode.mainAxis,
      );

      expect(anchors.isBelow, true,
          reason: 'Should flip to below when not enough space above');
      expect(anchors.isAbove, false);

      expect(anchors.isCrossAxisFlipped, false,
          reason: 'Should not flip cross-axis with FlipMode.mainAxis');
      expect(anchors.targetAnchor, Alignment.bottomLeft,
          reason: 'Should be left-aligned even if overflowing');
      expect(anchors.followerAnchor, Alignment.topLeft);
    });

    test('FlipMode.crossAxis - flips alignment but NOT direction', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(650, 20),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 600),
        contentHeight: 100,
        contentWidth: 200,
        preferredDirection: AxisDirection.up,
        constrainAxis: Axis.vertical,
        crossAxisAlignment: PopoverCrossAxisAlignment.start,
        flipMode: FlipMode.crossAxis,
      );

      expect(anchors.isAbove, true,
          reason: 'Should stay above with FlipMode.crossAxis');
      expect(anchors.isBelow, false);

      expect(anchors.isCrossAxisFlipped, true,
          reason: 'Should flip cross-axis alignment');
      expect(anchors.targetAnchor, Alignment.topRight,
          reason: 'Should flip to right edge alignment');
      expect(anchors.followerAnchor, Alignment.bottomRight);
    });

    test(
        'FlipMode.mainAxis - horizontal popover flips direction but not alignment',
        () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(50, 10),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 600),
        contentHeight: 200,
        contentWidth: 100,
        preferredDirection: AxisDirection.left,
        constrainAxis: Axis.horizontal,
        crossAxisAlignment: PopoverCrossAxisAlignment.start,
        flipMode: FlipMode.mainAxis,
      );

      expect(anchors.isRight, true,
          reason: 'Should flip to right when not enough space on left');
      expect(anchors.isLeft, false);

      expect(anchors.isCrossAxisFlipped, false,
          reason: 'Should not flip cross-axis with FlipMode.mainAxis');
      expect(anchors.targetAnchor, Alignment.topRight,
          reason: 'Should be top-aligned even if overflowing');
      expect(anchors.followerAnchor, Alignment.topLeft);
    });

    test(
        'FlipMode.crossAxis - horizontal popover flips alignment but not direction',
        () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(300, 500),
        leaderSize: const Size(100, 50),
        screenSize: const Size(800, 600),
        contentHeight: 200,
        contentWidth: 100,
        preferredDirection: AxisDirection.right,
        constrainAxis: Axis.horizontal,
        crossAxisAlignment: PopoverCrossAxisAlignment.start,
        flipMode: FlipMode.crossAxis,
      );

      expect(anchors.isRight, true,
          reason: 'Should stay on right with FlipMode.crossAxis');
      expect(anchors.isLeft, false);

      expect(anchors.isCrossAxisFlipped, true,
          reason: 'Should flip cross-axis alignment');
      expect(anchors.targetAnchor, Alignment.bottomRight,
          reason: 'Should flip to bottom edge alignment');
      expect(anchors.followerAnchor, Alignment.bottomLeft);
    });
  });
}
