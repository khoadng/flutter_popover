part of '../main.dart';

class MacosBarDemo extends StatefulWidget {
  const MacosBarDemo({super.key});

  @override
  State<MacosBarDemo> createState() => _MacosBarDemoState();
}

class _MacosBarDemoState extends State<MacosBarDemo> {
  String? _activeMenuKey;

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
      triggerMode: PopoverTriggerMode.manual,
      barrierColor: Colors.transparent,
      preferredDirection: AxisDirection.down,
      offset: const Offset(0, 10),
      overlayChildBuilder: (context) => Container(
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
            const Expanded(
              child: Center(
                child: Text(
                  'Click an icon in the top-right bar. 👆',
                  style: TextStyle(color: Colors.grey),
                ),
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
