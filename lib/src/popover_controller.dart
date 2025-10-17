import 'package:flutter/material.dart';

import 'popover_anchors.dart';

/// Manages the state of a [Popover], including its visibility and positioning.
///
/// A [PopoverController] can be used to programmatically show, hide, or toggle
/// a popover. It also holds the calculated [PopoverAnchors] that determine
/// the popover's placement relative to its target.
class PopoverController extends ChangeNotifier {
  bool _isShowing = false;
  PopoverAnchors _anchors = const PopoverAnchors(
    targetAnchor: Alignment.topLeft,
    followerAnchor: Alignment.bottomLeft,
  );

  /// Whether the popover is currently showing.
  bool get isShowing => _isShowing;

  /// The current anchor configuration for positioning the popover.
  PopoverAnchors get anchors => _anchors;

  /// Shows the popover.
  ///
  /// If the popover is already showing, this method does nothing.
  void show() {
    if (!_isShowing) {
      _isShowing = true;
      notifyListeners();
    }
  }

  /// Hides the popover.
  ///
  /// If the popover is already hidden, this method does nothing.
  void hide() {
    if (_isShowing) {
      _isShowing = false;
      notifyListeners();
    }
  }

  /// Toggles the popover's visibility.
  ///
  /// If the popover is showing, it will be hidden. If it is hidden, it will be
  /// shown.
  void toggle() {
    _isShowing = !_isShowing;
    notifyListeners();
  }

  /// Updates the popover's anchor configuration.
  ///
  /// This is typically called internally by the [Popover] widget when it
  /// recalculates its position.
  void setAnchors(PopoverAnchors anchors) {
    if (_anchors != anchors) {
      _anchors = anchors;
      notifyListeners();
    }
  }
}
