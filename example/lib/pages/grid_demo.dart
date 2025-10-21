part of '../main.dart';

const kTooltipHeight = 200.0;
const kTooltipWidth = 200.0;

class _BackdropClipper extends CustomClipper<Path> {
  final Rect? exclude;

  const _BackdropClipper({this.exclude});

  @override
  Path getClip(Size size) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (exclude != null) {
      path.addRect(exclude!);
      path.fillType = PathFillType.evenOdd;
    }

    return path;
  }

  @override
  bool shouldReclip(covariant _BackdropClipper oldClipper) {
    return exclude != oldClipper.exclude;
  }
}

class GridDemo extends StatelessWidget {
  const GridDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid Demo')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        itemCount: 30,
        itemBuilder: (context, index) {
          final colors = [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.purple,
            Colors.teal,
          ];

          return Popover.arrow(
            backgroundColor: Colors.grey[900],
            contentHeight: kTooltipHeight,
            contentWidth: kTooltipWidth,
            triggerMode: const TapTriggerMode(consumeOutsideTap: true),
            backdropBuilder: (context) => ClipPath(
              clipper: _BackdropClipper(
                exclude: PopoverData.of(context).geometry.triggerBounds,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(color: Colors.black26),
              ),
            ),
            arrowShape: const RoundedArrow(),
            borderRadius: BorderRadius.circular(16),
            border: const BorderSide(color: Colors.blue, width: 1),
            contentBuilder: (context) =>
                _TooltipContainer(title: 'Grid Item $index'),
            child: Container(
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Item $index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TooltipContainer extends StatelessWidget {
  final String title;

  const _TooltipContainer({required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kTooltipHeight,
      width: kTooltipWidth,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              primary: false,
              itemCount: 15,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[800]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.article, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onLongPress: () {
                            debugPrint('Tooltip title long-pressed: $title');
                          },
                          onTap: () {
                            debugPrint('Tooltip title tapped: $title');
                          },
                          child: Text(
                            'Property ${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
