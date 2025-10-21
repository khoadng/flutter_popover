import 'package:flutter/material.dart';
import 'package:flutter_popover/flutter_popover.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PopoverCrossAxisAlignment - Vertical Popovers', () {
    group('start alignment', () {
      test('aligns left edges when enough space on right', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(50, 300),
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 100,
          contentWidth: 200,
          preferredDirection: AxisDirection.down,
          constrainAxis: Axis.vertical,
          crossAxisAlignment: PopoverCrossAxisAlignment.start,
        );

        // Popover below trigger, left edges aligned
        expect(anchors.targetAnchor, Alignment.bottomLeft);
        expect(anchors.followerAnchor, Alignment.topLeft);
      });

      test('flips to align right edges when not enough space on right', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(650, 300), // Near right edge
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 100,
          contentWidth: 200, // Would overflow on right
          preferredDirection: AxisDirection.down,
          constrainAxis: Axis.vertical,
          crossAxisAlignment: PopoverCrossAxisAlignment.start,
        );

        // Should flip to align right edges instead
        expect(anchors.targetAnchor, Alignment.bottomRight);
        expect(anchors.followerAnchor, Alignment.topRight);
      });
    });

    group('center alignment', () {
      test('centers horizontally when enough space on both sides', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(300, 300),
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 100,
          contentWidth: 200,
          preferredDirection: AxisDirection.down,
          constrainAxis: Axis.vertical,
          crossAxisAlignment: PopoverCrossAxisAlignment.center,
        );

        // Popover below trigger, centers aligned
        expect(anchors.targetAnchor, Alignment.bottomCenter);
        expect(anchors.followerAnchor, Alignment.topCenter);
      });

      test('stays centered even when close to left edge', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(50, 300), // Close to left edge
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 100,
          contentWidth: 200,
          preferredDirection: AxisDirection.down,
          constrainAxis: Axis.vertical,
          crossAxisAlignment: PopoverCrossAxisAlignment.center,
        );

        // Should still center align (might overflow left)
        expect(anchors.targetAnchor, Alignment.bottomCenter);
        expect(anchors.followerAnchor, Alignment.topCenter);
      });

      test('stays centered even when close to right edge', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(700, 300), // Close to right edge
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 100,
          contentWidth: 200,
          preferredDirection: AxisDirection.down,
          constrainAxis: Axis.vertical,
          crossAxisAlignment: PopoverCrossAxisAlignment.center,
        );

        // Should still center align (might overflow right)
        expect(anchors.targetAnchor, Alignment.bottomCenter);
        expect(anchors.followerAnchor, Alignment.topCenter);
      });
    });

    group('end alignment', () {
      test('aligns right edges when enough space on left', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(600, 300),
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 100,
          contentWidth: 200,
          preferredDirection: AxisDirection.down,
          constrainAxis: Axis.vertical,
          crossAxisAlignment: PopoverCrossAxisAlignment.end,
        );

        // Popover below trigger, right edges aligned
        expect(anchors.targetAnchor, Alignment.bottomRight);
        expect(anchors.followerAnchor, Alignment.topRight);
      });

      test('flips to align left edges when not enough space on left', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(50, 300), // Near left edge
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 100,
          contentWidth: 200, // Would overflow on left
          preferredDirection: AxisDirection.down,
          constrainAxis: Axis.vertical,
          crossAxisAlignment: PopoverCrossAxisAlignment.end,
        );

        // Should flip to align left edges instead
        expect(anchors.targetAnchor, Alignment.bottomLeft);
        expect(anchors.followerAnchor, Alignment.topLeft);
      });
    });
  });

  group('PopoverCrossAxisAlignment - Horizontal Popovers', () {
    group('start alignment', () {
      test('aligns top edges when enough space below', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(400, 50),
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 200,
          contentWidth: 150,
          preferredDirection: AxisDirection.right,
          constrainAxis: Axis.horizontal,
          crossAxisAlignment: PopoverCrossAxisAlignment.start,
        );

        // Popover to right of trigger, top edges aligned
        expect(anchors.targetAnchor, Alignment.topRight);
        expect(anchors.followerAnchor, Alignment.topLeft);
      });

      test('flips to align bottom edges when not enough space below', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(400, 450), // Near bottom edge
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 200, // Would overflow below
          contentWidth: 150,
          preferredDirection: AxisDirection.right,
          constrainAxis: Axis.horizontal,
          crossAxisAlignment: PopoverCrossAxisAlignment.start,
        );

        // Should flip to align bottom edges instead
        expect(anchors.targetAnchor, Alignment.bottomRight);
        expect(anchors.followerAnchor, Alignment.bottomLeft);
      });
    });

    group('center alignment', () {
      test('centers vertically when enough space above and below', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(400, 300),
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 200,
          contentWidth: 150,
          preferredDirection: AxisDirection.right,
          constrainAxis: Axis.horizontal,
          crossAxisAlignment: PopoverCrossAxisAlignment.center,
        );

        // Popover to right of trigger, centers aligned vertically
        expect(anchors.targetAnchor, Alignment.centerRight);
        expect(anchors.followerAnchor, Alignment.centerLeft);
      });

      test('stays centered even when close to top edge', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(400, 50), // Close to top
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 200,
          contentWidth: 150,
          preferredDirection: AxisDirection.right,
          constrainAxis: Axis.horizontal,
          crossAxisAlignment: PopoverCrossAxisAlignment.center,
        );

        // Should still center align (might overflow top)
        expect(anchors.targetAnchor, Alignment.centerRight);
        expect(anchors.followerAnchor, Alignment.centerLeft);
      });

      test('stays centered even when close to bottom edge', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(400, 500), // Close to bottom
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 200,
          contentWidth: 150,
          preferredDirection: AxisDirection.right,
          constrainAxis: Axis.horizontal,
          crossAxisAlignment: PopoverCrossAxisAlignment.center,
        );

        // Should still center align (might overflow bottom)
        expect(anchors.targetAnchor, Alignment.centerRight);
        expect(anchors.followerAnchor, Alignment.centerLeft);
      });
    });

    group('end alignment', () {
      test('aligns bottom edges when enough space above', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(400, 400),
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 200,
          contentWidth: 150,
          preferredDirection: AxisDirection.right,
          constrainAxis: Axis.horizontal,
          crossAxisAlignment: PopoverCrossAxisAlignment.end,
        );

        // Popover to right of trigger, bottom edges aligned
        expect(anchors.targetAnchor, Alignment.bottomRight);
        expect(anchors.followerAnchor, Alignment.bottomLeft);
      });

      test('flips to align top edges when not enough space above', () {
        final anchors = PopoverAnchors.calculate(
          leaderPosition: const Offset(400, 50), // Near top edge
          leaderSize: const Size(100, 50),
          screenSize: const Size(800, 600),
          contentHeight: 200, // Would overflow above
          contentWidth: 150,
          preferredDirection: AxisDirection.right,
          constrainAxis: Axis.horizontal,
          crossAxisAlignment: PopoverCrossAxisAlignment.end,
        );

        // Should flip to align top edges instead
        expect(anchors.targetAnchor, Alignment.topRight);
        expect(anchors.followerAnchor, Alignment.topLeft);
      });
    });
  });
}
