part of 'main.dart';

const kTooltipHeight = 200.0;
const kTooltipWidth = 200.0;

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
            constrainAxis: null,
            crossAxisAlignment: PopoverCrossAxisAlignment.center,
            preferredDirection: AxisDirection.right,
            backgroundColor: Colors.grey[900],
            overlayChildHeight: kTooltipHeight,
            overlayChildWidth: kTooltipWidth,
            showDelay: const Duration(milliseconds: 300),
            barrierColor: Colors.black54,
            arrowShape: const RoundedArrow(),
            consumeOutsideTap: true,
            arrowAlignment: 0.5,
            border: BorderSide(color: Colors.blue, width: 1),
            overlayChildBuilder: (context) =>
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
