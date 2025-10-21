import 'package:flutter/widgets.dart';

import 'controller.dart';
import 'geometry.dart';

/// Defines how the popover responds to scrolling of ancestor scrollable widgets.
enum PopoverScrollBehavior {
  /// Hide the popover immediately when any ancestor scrollable widget scrolls.
  ///
  /// This is the default behavior and prevents awkward positioning issues when
  /// the trigger widget scrolls offscreen or gets clipped.
  dismiss,

  /// Recalculate positioning during scroll to handle screen bounds properly.
  ///
  /// The popover visually follows its trigger automatically
  /// but this mode recalculates anchors on every scroll event to ensure proper
  /// positioning, flipping, and alignment relative to screen bounds.
  ///
  /// Automatically hides when the trigger scrolls completely outside the viewport.
  ///
  /// Note: Recalculating positioning on every scroll event may impact performance
  /// for complex popover content.
  reposition,

  /// No special scroll handling.
  ///
  /// The popover will remain in its initial position.
  none,
}

/// Provides the [PopoverController] to the popover's content.
class PopoverData extends InheritedWidget {
  /// The controller for the popover.
  final PopoverController controller;

  /// The geometric information of the popover.
  final PopoverGeometry geometry;

  /// Creates a [PopoverData] widget.
  const PopoverData({
    super.key,
    required this.controller,
    required this.geometry,
    required super.child,
  });

  /// Retrieves the [PopoverController] from the nearest [PopoverData] ancestor.
  ///
  /// This method asserts that a `PopoverData` is found in the widget tree.
  static PopoverData of(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<PopoverData>();
    assert(
      data != null,
      'PopoverData not found in context. Make sure you are calling PopoverData.of() inside a Popover contentBuilder.',
    );
    return data!;
  }

  /// Retrieves the [PopoverController] from the nearest [PopoverData] ancestor,
  /// returning null if none is found.
  static PopoverData? maybeOf(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<PopoverData>();
    return data;
  }

  @override
  bool updateShouldNotify(PopoverData oldWidget) {
    return controller != oldWidget.controller || geometry != oldWidget.geometry;
  }
}
