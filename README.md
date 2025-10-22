# Flutter Popover

<a href="https://pub.dev/packages/flutter_popover">
    <img src="https://img.shields.io/pub/v/flutter_popover" alt="pub package">
</a>  


A versatile and easy-to-use popover widget for Flutter that supports tap, hover, and manual triggers. Ideal for tooltips, menus, and context-sensitive information displays.

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_popover: ^latest_version
```

Then, run `flutter pub get` in your terminal.

## Usage

### Basic Popover

Wrap any widget with the `Popover` widget and provide an `contentBuilder` to define the content of the popover.

```dart
Popover(
  child: const Icon(Icons.info),
  contentBuilder: (context) => Container(
    padding: const EdgeInsets.all(12),
    child: const Text('This is some helpful information.'),
  ),
);
```

### Arrow Tooltips

For a classic tooltip with an arrow, use the `Popover.arrow` factory constructor.

```dart
Popover.arrow(
  child: const Icon(Icons.help),
  backgroundColor: Colors.grey[800],
  arrowShape: const RoundedArrow(), // or SharpArrow()
  contentBuilder: (context) => Container(
    padding: const EdgeInsets.all(12),
    child: const Text(
      'This tooltip has a rounded arrow.',
      style: TextStyle(color: Colors.white),
    ),
  ),
);
```

### Text Tooltips

For simple text tooltips, use the `Popover.tooltip` factory. It defaults to a hover trigger.

```dart
Popover.tooltip(
  child: const Icon(Icons.help),
  message: const Text('This is a simple text tooltip.'),
);
```

### Trigger Modes

Control how the popover is shown with `triggerMode`:

  * `PopoverTriggerMode.tap()`: Shows and hides on tap.
  * `PopoverTriggerMode.hover()`: Shows on hover, ideal for desktop and web.
  * `PopoverTriggerMode.manual()`: Control visibility with a `PopoverController`.

```dart
// Hover Trigger
Popover(
  triggerMode: const PopoverTriggerMode.hover(),
  child: const Text('Hover over me'),
  contentBuilder: (context) => const Text('Hello!'),
);

// Manual Trigger
final controller = PopoverController();

Popover(
  controller: controller,
  triggerMode: const PopoverTriggerMode.manual(),
  child: const Text('A widget'),
  contentBuilder: (context) => const Text('Content'),
);

// Then, show or hide it when you need to:
controller.show();
controller.hide();
```

### Positioning

Guide the popover's placement with:

  * **`preferredDirection`**: `AxisDirection.up`, `down`, `left`, or `right`.
  * **`crossAxisAlignment`**: `PopoverCrossAxisAlignment.start`, `center`, or `end`.
  * **`contentHeight` & `contentWidth`**: Provide for fixed-size content to ensure accurate positioning.
  * **`flipMode`**: Control how the popover flips to fit:
    - `FlipMode.both` (default): Flips both direction and alignment to fit.
    - `FlipMode.mainAxis`: Only flips direction.
    - `FlipMode.crossAxis`: Only flips alignment.
    - `FlipMode.none`: No flipping; may overflow.

```dart
Popover.arrow(
  child: const Text('Click me'),
  preferredDirection: AxisDirection.down,
  crossAxisAlignment: PopoverCrossAxisAlignment.center,
  contentBuilder: (context) => const Text('I am centered below!'),
);
```

## Examples

See the `/example` directory for demos:

  * **Grid Demo**: Tooltips on a `GridView`.
  * **Chat Demo**: Microsoft Teams-like emoji reactions.
  * **Wikipedia-like Links**: Hover-to-preview links.
  * **macOS Desktop**: Status bar menus with manual triggers.

## Customization

### Styling the Popover and Arrow

Customize the popover's appearance using `Popover.arrow` parameters.

```dart
Popover.arrow(
  child: const Text('Styled Popover'),

  // Popover body styling
  backgroundColor: const Color(0xFF1E293B),
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 10,
    ),
  ],
  border: const BorderSide(color: Colors.blueAccent, width: 1.0),

  // Arrow styling
  arrowShape: const RoundedArrow(spread: 0.5, liftOff: 0.2),
  arrowSize: const Size(24, 12),

  contentBuilder: (context) => Container(
    padding: const EdgeInsets.all(16),
    child: const Text(
      'A highly customized popover.',
      style: TextStyle(color: Colors.white),
    ),
  ),
);
```

### Advanced Behavior

Configure trigger modes for advanced interactions:

```dart
// Hover trigger with delays
Popover(
  triggerMode: const HoverTriggerMode(
    waitDuration: Duration(milliseconds: 300),
  ),
  child: const Text('Hover over me'),
  contentBuilder: (context) => const Text('Delayed tooltip'),
);

// Tap trigger with backdrop and outside tap handling
Popover(
  triggerMode: const TapTriggerMode(
    consumeOutsideTap: true,
  ),
  backdropBuilder: (context) => Container(color: Colors.black54),
  child: const Text('Click me'),
  contentBuilder: (context) => const Text('Modal-like popover'),
);
```

### Custom Animations

Supply a `transitionBuilder` for custom animations.

```dart
Popover(
  child: const Icon(Icons.animation),
  transitionDuration: const Duration(milliseconds: 300),
  transitionBuilder: (context, animation, child) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  },
  contentBuilder: (context) => const Text('I scale in!'),
);
```

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue on the GitHub repository.
