import 'package:flutter/material.dart';
import 'package:flutter_popover/flutter_popover.dart';
import 'package:intl/intl.dart';

part 'grid_demo.dart';
part 'chat_demo.dart';
part 'wiki_link_demo.dart';
part 'macos_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scroll Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scroll View Demos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DemoCard(
            title: 'Grid View',
            description: 'Grid layout with popover tooltips',
            icon: Icons.view_quilt,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GridDemo()),
            ),
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'Chat Interface',
            description: 'Teams-like chat with emoji reactions',
            icon: Icons.list,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ListViewDemo()),
            ),
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'Wikipedia-like Links',
            description: 'Hover over links to preview information',
            icon: Icons.link,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WikiLinkDemo()),
            ),
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'macOS Menu Bar',
            description: 'Popover menus with active state highlighting',
            icon: Icons.desktop_mac,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MacosBarDemo()),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _DemoCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
