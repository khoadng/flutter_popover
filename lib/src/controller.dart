import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'anchors.dart';
import 'geometry.dart';
import 'popover.dart';

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
  PopoverGeometry _geometry = const PopoverGeometry(
    popoverBounds: null,
    triggerBounds: null,
    offset: Offset.zero,
    direction: AxisDirection.down,
    alignment: Alignment.topLeft,
  );

  /// Whether the popover is currently showing.
  bool get isShowing => _isShowing;

  /// The current anchor configuration for positioning the popover.
  PopoverAnchors get anchors => _anchors;

  /// The current geometry information for the popover.
  @internal
  PopoverGeometry get geometry => _geometry;

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
  @internal
  void setAnchors(PopoverAnchors anchors) {
    if (_anchors != anchors) {
      _anchors = anchors;
      notifyListeners();
    }
  }

  /// Updates the popover's geometry.
  ///
  /// This is typically called internally by the [Popover] widget when it
  /// recalculates its position.
  @internal
  void setGeometry(PopoverGeometry geometry) {
    if (_geometry != geometry) {
      _geometry = geometry;
      notifyListeners();
    }
  }
}
