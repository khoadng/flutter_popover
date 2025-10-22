/// Defines what user action triggers the popover to show and hide.
///
/// Each trigger mode can have its own specific configuration.
sealed class PopoverTriggerMode {
  const PopoverTriggerMode();
}

/// Shows the popover on mouse enter and hides on mouse exit.
///
/// This mode is ideal for tooltips and preview popovers that should appear
/// when hovering over an element.
class HoverTriggerMode extends PopoverTriggerMode {
  /// The delay before the popover is shown after the mouse enters.
  final Duration waitDuration;

  /// The delay before hiding the popover after the mouse exits.
  ///
  /// This debounce duration prevents accidental dismissal when moving the
  /// cursor between the trigger and the popover content.
  final Duration debounceDuration;

  /// Creates a hover trigger mode.
  const HoverTriggerMode({
    this.waitDuration = Duration.zero,
    this.debounceDuration = const Duration(milliseconds: 50),
  });
}

/// Toggles the popover's visibility on tap.
///
/// This mode is ideal for interactive popovers like menus, dropdowns, and
/// modal content that requires user interaction.
class TapTriggerMode extends PopoverTriggerMode {
  /// Whether a tap outside the popover is consumed, preventing it from
  /// reaching widgets below.
  final bool consumeOutsideTap;

  /// Creates a tap trigger mode.
  const TapTriggerMode({
    this.consumeOutsideTap = false,
  });
}

/// The popover is controlled exclusively via a [PopoverController].
///
/// In this mode, the popover will not respond to any user interaction.
/// Show and hide operations must be performed programmatically using the
/// controller.
class ManualTriggerMode extends PopoverTriggerMode {
  /// Creates a manual trigger mode.
  const ManualTriggerMode();
}
