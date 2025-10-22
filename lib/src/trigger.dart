/// {@template popover_trigger_mode}
/// Defines what user action triggers the popover to show and hide.
///
/// Each trigger mode can have its own specific configuration.
/// {@endtemplate}
sealed class PopoverTriggerMode {
  const PopoverTriggerMode();

  /// {@macro hover_trigger_mode}
  const factory PopoverTriggerMode.hover({
    Duration? waitDuration,
    Duration? debounceDuration,
  }) = HoverTriggerMode;

  /// {@macro tap_trigger_mode}
  const factory PopoverTriggerMode.tap({
    bool? consumeOutsideTap,
  }) = TapTriggerMode;

  /// {@macro manual_trigger_mode}
  const factory PopoverTriggerMode.manual() = ManualTriggerMode;
}

/// {@macro popover_trigger_mode}
/// {@template hover_trigger_mode}
///
/// Shows the popover on mouse enter and hides on mouse exit.
///
/// {@endtemplate}
class HoverTriggerMode extends PopoverTriggerMode {
  /// The delay before the popover is shown after the mouse enters.
  ///
  /// Defaults to `Duration.zero`, the popover shows immediately.
  final Duration? waitDuration;

  /// The delay before hiding the popover after the mouse exits.
  ///
  /// This debounce duration prevents accidental dismissal when moving the
  /// cursor between the trigger and the popover content.
  ///
  /// Defaults to 50 milliseconds.
  final Duration? debounceDuration;

  /// Creates a hover trigger mode.
  const HoverTriggerMode({
    this.waitDuration,
    this.debounceDuration,
  });
}

/// {@macro popover_trigger_mode}
/// {@template tap_trigger_mode}
///
/// Toggles the popover's visibility on tap.
///
/// {@endtemplate}
class TapTriggerMode extends PopoverTriggerMode {
  /// Whether a tap outside the popover is consumed, preventing it from
  /// reaching widgets below.
  ///
  /// Defaults to `false`, allowing taps to propagate to underlying widgets.
  final bool? consumeOutsideTap;

  /// Creates a tap trigger mode.
  const TapTriggerMode({
    this.consumeOutsideTap,
  });
}

/// {@macro popover_trigger_mode}
/// {@template manual_trigger_mode}
///
/// The popover is controlled exclusively via a [PopoverController].
///
/// In this mode, the popover will not respond to any user interaction.
/// Show and hide operations must be performed programmatically using the
/// controller.
/// {@endtemplate}
class ManualTriggerMode extends PopoverTriggerMode {
  /// Creates a manual trigger mode.
  const ManualTriggerMode();
}
