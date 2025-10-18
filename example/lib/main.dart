import 'package:example/widgets/demo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popover/flutter_popover.dart';
import 'package:intl/intl.dart';

part 'pages/grid_demo.dart';
part 'pages/chat_demo.dart';
part 'pages/wiki_link_demo.dart';
part 'pages/macos_bar.dart';

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
          DemoCard(
            title: 'Grid View',
            description: 'Grid layout with popover tooltips',
            icon: Icons.view_quilt,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GridDemo()),
            ),
          ),
          const SizedBox(height: 16),
          DemoCard(
            title: 'Chat Interface',
            description: 'Teams-like chat with emoji reactions',
            icon: Icons.list,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ListViewDemo()),
            ),
          ),
          const SizedBox(height: 16),
          DemoCard(
            title: 'Wikipedia-like Links',
            description: 'Hover over links to preview information',
            icon: Icons.link,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WikiLinkDemo()),
            ),
          ),
          const SizedBox(height: 16),
          DemoCard(
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
