import 'package:flutter/material.dart';
import 'package:flutter_popover/src/arrow_info.dart';
import 'package:flutter_popover/src/anchors.dart';
import 'package:flutter_popover/src/arrow.dart';
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
  });
}
