import 'package:dashboard/screens/add_villa/widgets/overview_dialoge.dart';
import 'package:flutter/material.dart';
import '../../../models/villa.dart';

class OverviewsSection extends StatelessWidget {
  final List<Overview> overviews;
  final Function(List<Overview>) onChanged;

  const OverviewsSection({
    super.key,
    required this.overviews,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overviews',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...overviews.map((overview) => _buildOverviewChip(overview)),
                    _buildAddButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewChip(Overview overview) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconData(
              int.tryParse(overview.iconName) ?? Icons.info.codePoint,
              fontFamily: 'MaterialIcons',
            ),
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(overview.description),
        ],
      ),
      onDeleted: () {
        onChanged(overviews.where((o) => o != overview).toList());
      },
      backgroundColor: Colors.blue.withOpacity(0.1),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ActionChip(
      label: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 16),
          SizedBox(width: 4),
          Text('Add Overview'),
        ],
      ),
      onPressed: () => _showAddDialog(context),
      backgroundColor: Colors.green.withOpacity(0.1),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final overview = await showDialog<Overview>(
      context: context,
      builder: (context) => const OverviewDialog(),
    );

    if (overview != null) {
      onChanged([...overviews, overview]);
    }
  }
}