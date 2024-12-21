import 'package:dashboard/screens/add_villa/widgets/room_dialoge.dart';
import 'package:flutter/material.dart';

class RoomsSection extends StatelessWidget {
  final List<String> rooms;
  final Function(List<String>) onChanged;

  const RoomsSection({
    super.key,
    required this.rooms,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rooms',
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
                    ...rooms.map((room) => _buildRoomChip(room)),
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

  Widget _buildRoomChip(String room) {
    return Chip(
      label: Text(room),
      onDeleted: () {
        onChanged(rooms.where((r) => r != room).toList());
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
          Text('Add Room'),
        ],
      ),
      onPressed: () => _showAddDialog(context),
      backgroundColor: Colors.green.withOpacity(0.1),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final room = await showDialog<String>(
      context: context,
      builder: (context) => const RoomDialog(),
    );

    if (room != null && room.isNotEmpty) {
      onChanged([...rooms, room]);
    }
  }
}