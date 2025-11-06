**`flutter_popover` is deprecated and no longer maintained.**

It has been replaced by **[Anchor](https://github.com/khoadng/anchor)**. All future development will occur in the new repository.

Please migrate to the new package for the latest features, bug fixes, and support.

* **Repository:** [https://github.com/khoadng/anchor](https://github.com/khoadng/anchor)
* **Package:** [https://pub.dev/packages/anchor_ui](https://pub.dev/packages/anchor_ui)

# Flutter Popover

<a href="https://pub.dev/packages/flutter_popover">
    <img src="https://img.shields.io/pub/v/flutter_popover" alt="pub package">
</a>  


A versatile and easy-to-use popover widget for Flutter that supports tap, hover, and manual triggers. Ideal for tooltips, menus, and context-sensitive information displays.

## Features

  * **Multiple Trigger Modes**: Show popovers on `tap`, `hover`, or `manual` control.
  * **Smart Positioning**: Automatically positions the popover to stay within the screen bounds.
  * **Customizable Arrows**: Includes `SharpArrow` and `RoundedArrow`, or you can create your own `ArrowShape`.
  * **Flexible Alignment**: Control vertical and horizontal alignment with `preferredDirection` and `crossAxisAlignment`.
  * **Manual Control**: Use a `PopoverController` for programmatic show/hide functionality.
  * **Animated Transitions**: Smooth fade-in and fade-out animations, fully customizable.

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_popover: ^latest_version
```

Then, run `flutter pub get` in your terminal.

## Usage

### Basic Popover

Wrap any widget with the `Popover` widget and provide an `overlayChildBuilder` to define the content of the popover.

```dart
Popover(
  child: const Icon(Icons.info),
  overlayChildBuilder: (context) => Container(
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
  arrowShape: const RoundedArrow(),
  overlayChildBuilder: (context) => Container(
    padding: const EdgeInsets.all(12),
    child: const Text(
      'This tooltip has a rounded arrow.',
      style: TextStyle(color: Colors.white),
    ),
  ),
);
```

### Trigger Modes

Control how the popover is shown with `triggerMode`:

  * `PopoverTriggerMode.tap` (Default): Shows and hides on tap.
  * `PopoverTriggerMode.hover`: Shows on hover, ideal for desktop and web.
  * `PopoverTriggerMode.manual`: Control visibility with a `PopoverController`.

<!-- end list -->

```dart
// Hover Trigger
Popover(
  triggerMode: PopoverTriggerMode.hover,
  child: const Text('Hover over me'),
  overlayChildBuilder: (context) => const Text('Hello!'),
);

// Manual Trigger
final controller = PopoverController();

Popover(
  controller: controller,
  triggerMode: PopoverTriggerMode.manual,
  child: const Text('A widget'),
  overlayChildBuilder: (context) => const Text('Content'),
);

// Then, show or hide it when you need to:
controller.show();
controller.hide();
```

### Positioning

The popover automatically avoids screen overflow. You can guide its initial placement with:

  * **`preferredDirection`**: `AxisDirection.up`, `down`, `left`, or `right`.
  * **`crossAxisAlignment`**: `PopoverCrossAxisAlignment.start`, `center`, or `end` to align the popover along the perpendicular axis.
  * **`overlayChildHeight` & `overlayChildWidth`**: Provide these when your popover content has a fixed size. This enables precise placement instead of just guessing which side has the most space.

<!-- end list -->

```dart
Popover.arrow(
  child: const Text('Click me'),
  preferredDirection: AxisDirection.down,
  crossAxisAlignment: PopoverCrossAxisAlignment.center,
  overlayChildBuilder: (context) => const Text('I am centered below!'),
);
```

## Examples

This package includes a collection of demos to showcase its capabilities:

  * **Grid Demo**: Demonstrates tooltips on a `GridView`.
  * **Chat Demo**: A Microsoft Teams-like chat interface with hover-triggered emoji reactions.
  * **Wikipedia-like Links**: Shows preview popovers when hovering over links in a block of text.
  * **macOS Menu Bar**: An example of creating status bar menus with manual triggers.

You can find the code for these in the `/example` directory.

## Customization

Take full control over the appearance and behavior of your popovers.

### Styling the Popover and Arrow

Use the `Popover.arrow` constructor for easy and extensive styling. You can customize everything from the background color and border radius to the shape and size of the arrow.

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

  overlayChildBuilder: (context) => Container(
    padding: const EdgeInsets.all(16),
    child: const Text(
      'A highly customized popover.',
      style: TextStyle(color: Colors.white),
    ),
  ),
);
```

### Advanced Behavior

Fine-tune the interaction details for a smoother user experience, especially for hover triggers.

  * **`showDelay` & `debounceDuration`**: Add delays to prevent popovers from flashing on screen when the mouse quickly moves over triggers.
  * **`barrierColor`**: For `tap` triggers, you can add a colored barrier behind the popover to dim the background content.
  * **`consumeOutsideTap`**: Control whether a tap outside the popover should be consumed (closing the popover only) or passed through to the UI behind it.

### Custom Animations

While the default fade transition works well for most cases, you can supply your own `transitionBuilder` to create unique entrance and exit animations, such as a scale or slide transition.

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
  overlayChildBuilder: (context) => const Text('I scale in!'),
);
```

## Contributing

Contributions are welcome\! If you find a bug or have a feature request, please open an issue on the GitHub repository.
