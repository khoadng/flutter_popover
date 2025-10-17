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
        overlayChildHeight: 100,
        overlayChildWidth: 300,
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
        overlayChildHeight: 100,
        overlayChildWidth: 300,
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
        overlayChildHeight: 100,
        overlayChildWidth: 300,
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
        overlayChildHeight: 100,
        overlayChildWidth: 300,
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
        overlayChildHeight: 100,
        overlayChildWidth: 300,
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
        overlayChildHeight: 100,
        overlayChildWidth: 300,
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
        overlayChildHeight: 100,
        overlayChildWidth: 350,
      );

      expect(anchors.targetAnchor, Alignment.bottomLeft);
      expect(anchors.followerAnchor, Alignment.topLeft);
    });

    test('tooltip without dimensions falls back to space comparison', () {
      final anchors = PopoverAnchors.calculate(
        leaderPosition: const Offset(100, 100),
        leaderSize: const Size(100, 50),
        screenSize: const Size(400, 800),
        overlayChildHeight: null,
        overlayChildWidth: null,
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
          overlayChildHeight: 100,
          overlayChildWidth: 200,
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
        overlayChildHeight: 100.0,
        overlayChildWidth: 300.0,
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
        overlayChildHeight: 100.0,
        overlayChildWidth: 300.0,
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
        overlayChildHeight: 100,
        overlayChildWidth: 300,
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
        overlayChildHeight: 100,
        overlayChildWidth: 300,
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
        overlayChildHeight: 100,
        overlayChildWidth: 300,
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
        overlayChildHeight: 100,
        overlayChildWidth: 300,
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
        overlayChildHeight: 100,
        overlayChildWidth: 200,
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
        overlayChildHeight: 150,
        overlayChildWidth: 100,
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
        overlayChildHeight: 200,
        overlayChildWidth: 200,
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
        overlayChildHeight: 200,
        overlayChildWidth: 200,
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
}
