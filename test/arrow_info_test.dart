import 'package:flutter/material.dart';
import 'package:flutter_popover/src/arrow_info.dart';
import 'package:flutter_popover/src/popover_anchors.dart';
import 'package:flutter_popover/src/popover_with_arrow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ArrowInfo', () {
    test('vertical popover with left alignment', () {
      final anchors = PopoverAnchors(
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
      );

      final arrowInfo = ArrowInfo.fromAnchors(anchors: anchors);

      expect(arrowInfo.direction, AxisDirection.up);
      expect(arrowInfo.alignment, kArrowAlignmentStart);
    });

    test('vertical popover with center alignment', () {
      final anchors = PopoverAnchors(
        targetAnchor: Alignment.bottomCenter,
        followerAnchor: Alignment.topCenter,
      );

      final arrowInfo = ArrowInfo.fromAnchors(anchors: anchors);

      expect(arrowInfo.direction, AxisDirection.up);
      expect(arrowInfo.alignment, kArrowAlignmentCenter);
    });

    test('horizontal popover with top alignment', () {
      final anchors = PopoverAnchors(
        targetAnchor: Alignment(-1.0, -1.0),
        followerAnchor: Alignment(1.0, -1.0),
      );

      final arrowInfo = ArrowInfo.fromAnchors(anchors: anchors);

      expect(arrowInfo.direction, AxisDirection.right);
      expect(arrowInfo.alignment, kArrowAlignmentStart);
    });

    test('user-provided alignment is inverted when NOT flipped', () {
      final anchors = PopoverAnchors(
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
        isCrossAxisFlipped: false,
      );

      final arrowInfo = ArrowInfo.fromAnchors(
        anchors: anchors,
        userArrowAlignment: 0.1,
      );

      expect(arrowInfo.direction, AxisDirection.up);
      expect(arrowInfo.alignment, 0.9); // Inverted from 0.1 to 0.9
    });

    test('user-provided alignment stays same when cross-axis IS flipped', () {
      final anchors = PopoverAnchors(
        targetAnchor: Alignment.bottomRight,
        followerAnchor: Alignment.topRight,
        isCrossAxisFlipped: true,
      );

      final arrowInfo = ArrowInfo.fromAnchors(
        anchors: anchors,
        userArrowAlignment: 0.1,
      );

      expect(arrowInfo.direction, AxisDirection.up);
      expect(arrowInfo.alignment, 0.1); // Stays 0.1 when flipped
    });
  });
}
