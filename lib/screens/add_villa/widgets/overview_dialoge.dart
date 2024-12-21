import 'package:flutter/material.dart';
import '../../../models/villa.dart';

class OverviewDialog extends StatefulWidget {
  const OverviewDialog({super.key});

  @override
  State<OverviewDialog> createState() => _OverviewDialogState();
}

class _OverviewDialogState extends State<OverviewDialog> {
  String description = '';
  IconData? selectedIcon;

  final List<Map<String, dynamic>> icons = [
    {'icon': Icons.bed, 'name': 'Bedroom'},
    {'icon': Icons.bathtub, 'name': 'Bathroom'},
    {'icon': Icons.kitchen, 'name': 'Kitchen'},
    {'icon': Icons.living, 'name': 'Living Room'},
    {'icon': Icons.pool, 'name': 'Pool'},
    {'icon': Icons.wifi, 'name': 'WiFi'},
    {'icon': Icons.ac_unit, 'name': 'AC'},
    {'icon': Icons.local_parking, 'name': 'Parking'},
    {'icon': Icons.tv, 'name': 'TV'},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Overview'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => setState(() => description = value),
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter overview description',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<IconData>(
              value: selectedIcon,
              decoration: const InputDecoration(
                labelText: 'Icon',
                hintText: 'Select an icon',
              ),
              items: icons.map((icon) {
                return DropdownMenuItem<IconData>(
                  value: icon['icon'] as IconData,
                  child: Row(
                    children: [
                      Icon(icon['icon'] as IconData),
                      const SizedBox(width: 8),
                      Text(icon['name'] as String),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (icon) => setState(() => selectedIcon = icon),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _canSubmit() ? _handleSubmit : null,
          child: const Text('Add'),
        ),
      ],
    );
  }

  bool _canSubmit() => description.isNotEmpty && selectedIcon != null;

  void _handleSubmit() {
    Navigator.pop(
      context,
      Overview(
        iconName: selectedIcon!.codePoint.toString(),
        description: description,
      ),
    );
  }
}