part of '../main.dart';

class MacosDesktopDemo extends StatefulWidget {
  const MacosDesktopDemo({super.key});

  @override
  State<MacosDesktopDemo> createState() => _MacosDesktopDemoState();
}

class _MacosDesktopDemoState extends State<MacosDesktopDemo> {
  String? _activeMenuKey;
  bool _isDockOnLeft = false;

  final Map<String, PopoverController> _popoverControllers = {
    'music': PopoverController(),
    'bluetooth': PopoverController(),
    'wifi': PopoverController(),
    'battery': PopoverController(),
  };

  @override
  void dispose() {
    _popoverControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _toggleMenu(String menuKey) {
    if (_activeMenuKey != null) {
      _popoverControllers[_activeMenuKey!]!.hide();
    }

    if (_activeMenuKey != menuKey) {
      setState(() {
        _activeMenuKey = menuKey;
        _popoverControllers[menuKey]!.show();
      });
    } else {
      setState(() {
        _activeMenuKey = null;
      });
    }
  }

  Widget _buildMenuItem({
    required String key,
    required IconData icon,
    required Widget content,
  }) {
    return Popover(
      crossAxisAlignment: PopoverCrossAxisAlignment.start,
      controller: _popoverControllers[key],
      triggerMode: const PopoverTriggerMode.manual(),
      preferredDirection: AxisDirection.down,
      constrainAxis: Axis.vertical,
      offset: const Offset(0, 10),
      contentBuilder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: content,
      ),
      child: _MenuBarItem(
        icon: Icon(icon, color: Colors.black87),
        isActive: _activeMenuKey == key,
        onTap: () => _toggleMenu(key),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        // This gesture detector handles taps on the main content area,
        // which closes any active popover.
        onTap: () {
          if (_activeMenuKey != null) {
            _toggleMenu(_activeMenuKey!);
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Spacer(),
                  _buildMenuItem(
                    key: 'music',
                    icon: Icons.music_note,
                    content: const _MusicPopoverContent(),
                  ),
                  const SizedBox(width: 8),
                  _buildMenuItem(
                    key: 'bluetooth',
                    icon: Icons.bluetooth,
                    content: const _BluetoothPopoverContent(),
                  ),
                  const SizedBox(width: 8),
                  _buildMenuItem(
                    key: 'wifi',
                    icon: Icons.wifi,
                    content: const _WifiPopoverContent(),
                  ),
                  const SizedBox(width: 8),
                  _buildMenuItem(
                    key: 'battery',
                    icon: Icons.battery_charging_full,
                    content: const _BatteryPopoverContent(),
                  ),
                  const SizedBox(width: 16),
                  const MenuBarClock(),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Click an icon in the top-right bar or hover over dock icons. 👆',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isDockOnLeft = !_isDockOnLeft;
                            });
                          },
                          icon: Icon(
                            _isDockOnLeft
                                ? Icons.arrow_downward
                                : Icons.arrow_back,
                          ),
                          label: Text(
                            _isDockOnLeft
                                ? 'Move Dock to Bottom'
                                : 'Move Dock to Left',
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_isDockOnLeft)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(child: _MacosDock(isVertical: false)),
                    ),
                  if (_isDockOnLeft)
                    Positioned(
                      left: 16,
                      top: 0,
                      bottom: 0,
                      child: Center(child: _MacosDock(isVertical: true)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The tappable icon shown in the menu bar.
class _MenuBarItem extends StatelessWidget {
  final Icon icon;
  final bool isActive;
  final VoidCallback onTap;

  const _MenuBarItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.blue.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: icon,
      ),
    );
  }
}

/// Popover content widgets.
class _BatteryPopoverContent extends StatelessWidget {
  const _BatteryPopoverContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12.0),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Battery',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('100%', style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Power Source: Power Adapter',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            'Fully Charged',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Divider(height: 24, color: Colors.white24),
          _SectionHeader(title: 'Using Significant Energy'),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.flash_on, color: Color(0xFFF75A0D), size: 20),
              SizedBox(width: 8),
              Text('Brave Browser', style: TextStyle(color: Colors.white)),
            ],
          ),
          Divider(height: 24, color: Colors.white24),
          Text('Battery Settings...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _WifiPopoverContent extends StatelessWidget {
  const _WifiPopoverContent();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(12.0),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Wi-Fi'),
          SizedBox(height: 8),
          _ContentRow(
            icon: Icons.wifi,
            text: 'MyHomeNetwork_5G',
            isConnected: true,
          ),
          _ContentRow(icon: Icons.wifi, text: 'CoffeeShop_Guest'),
          _ContentRow(icon: Icons.wifi_off, text: 'NeighborNet', isDim: true),
          Divider(height: 24, color: Colors.white24),
          Text('Network Settings...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _BluetoothPopoverContent extends StatelessWidget {
  const _BluetoothPopoverContent();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(12.0),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Bluetooth'),
          SizedBox(height: 8),
          _ContentRow(
            icon: Icons.headphones,
            text: 'My AirPods',
            isConnected: true,
          ),
          _ContentRow(icon: Icons.mouse, text: 'Magic Mouse'),
          Divider(height: 24, color: Colors.white24),
          Text('Bluetooth Settings...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _MusicPopoverContent extends StatelessWidget {
  const _MusicPopoverContent();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  color: Colors.blueGrey,
                  height: 40,
                  width: 40,
                  child: const Icon(Icons.music_note, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Song Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Artist Name',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.skip_previous, color: Colors.white),
              Icon(Icons.pause, color: Colors.white, size: 32),
              Icon(Icons.skip_next, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}

/// Helper widgets for popover content.
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: 13,
      ),
    );
  }
}

class _ContentRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isConnected;
  final bool isDim;

  const _ContentRow({
    required this.icon,
    required this.text,
    this.isConnected = false,
    this.isDim = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDim
        ? Colors.white38
        : isConnected
        ? Colors.blue
        : Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(color: color)),
          ),
          if (isConnected)
            const Icon(Icons.check, color: Colors.blue, size: 20),
        ],
      ),
    );
  }
}

/// A widget that displays a static time (read-only).
class MenuBarClock extends StatelessWidget {
  const MenuBarClock({super.key});

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('E d MMM HH:mm').format(DateTime.now());

    return Text(
      formattedTime,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 13,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

/// A macOS-style dock with app icons and tooltips
class _MacosDock extends StatelessWidget {
  final bool isVertical;

  _MacosDock({required this.isVertical});

  final List<_DockApp> _apps = [
    _DockApp(name: 'Finder', icon: Icons.folder, color: Colors.blue),
    _DockApp(name: 'Safari', icon: Icons.language, color: Colors.blue[700]!),
    _DockApp(name: 'Mail', icon: Icons.mail, color: Colors.blue[400]!),
    _DockApp(name: 'Messages', icon: Icons.message, color: Colors.green),
    _DockApp(
      name: 'Photos',
      icon: Icons.photo_library,
      color: Colors.red[400]!,
    ),
    _DockApp(name: 'Music', icon: Icons.music_note, color: Colors.pink[400]!),
    _DockApp(name: 'Calendar', icon: Icons.calendar_today, color: Colors.red),
    _DockApp(name: 'Settings', icon: Icons.settings, color: Colors.grey[600]!),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: isVertical
          ? Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: _apps
                  .map((app) => _DockIcon(app: app, isVertical: isVertical))
                  .toList(),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: _apps
                  .map((app) => _DockIcon(app: app, isVertical: isVertical))
                  .toList(),
            ),
    );
  }
}

class _DockApp {
  final String name;
  final IconData icon;
  final Color color;

  _DockApp({required this.name, required this.icon, required this.color});
}

/// A single app icon in the dock with tooltip
class _DockIcon extends StatelessWidget {
  final _DockApp app;
  final bool isVertical;

  const _DockIcon({required this.app, required this.isVertical});

  @override
  Widget build(BuildContext context) {
    return Popover.tooltip(
      message: Text(
        app.name,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      triggerMode: const PopoverTriggerMode.hover(),
      preferredDirection: isVertical ? AxisDirection.right : AxisDirection.up,
      constrainAxis: isVertical ? Axis.horizontal : Axis.vertical,
      backgroundColor: Colors.grey[800],
      arrowShape: const RoundedArrow(),
      arrowSize: const Size(16, 8),
      border: BorderSide(color: Colors.grey[700]!, width: 2),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: app.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(app.icon, color: Colors.white, size: 28),
      ),
    );
  }
}
