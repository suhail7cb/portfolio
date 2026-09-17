import 'package:flutter/material.dart';

/// A flexible, content-adaptive responsive grid that sizes each row to fit
/// the tallest child in that row using [IntrinsicHeight] and [CrossAxisAlignment.stretch].
///
/// This eliminates fixed `mainAxisExtent` heights that cause text or badge clipping,
/// while keeping items cleanly aligned in each row on multi-column screens.
class ResponsiveGrid<T> extends StatelessWidget {
  final List<T> items;
  final int crossAxisCount;
  final double spacing;
  final double runSpacing;
  final Widget Function(BuildContext context, T item) itemBuilder;

  const ResponsiveGrid({
    super.key,
    required this.items,
    required this.crossAxisCount,
    this.spacing = 20.0,
    this.runSpacing = 20.0,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    // On single-column (mobile), lay out each card at its natural height.
    if (crossAxisCount <= 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(height: runSpacing),
            itemBuilder(context, items[i]),
          ],
        ],
      );
    }

    // On multi-column (tablet & desktop), chunk items into rows.
    // Each item sizes naturally to its content without rigid height constraints,
    // completely preventing vertical RenderFlex overflow errors.
    final List<List<T>> rows = [];
    for (var i = 0; i < items.length; i += crossAxisCount) {
      rows.add(items.sublist(
        i,
        (i + crossAxisCount > items.length) ? items.length : i + crossAxisCount,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          if (r > 0) SizedBox(height: runSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var c = 0; c < crossAxisCount; c++) ...[
                if (c > 0) SizedBox(width: spacing),
                Expanded(
                  child: c < rows[r].length
                      ? itemBuilder(context, rows[r][c])
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
