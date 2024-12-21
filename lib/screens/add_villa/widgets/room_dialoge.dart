import 'package:flutter/material.dart';

class RoomDialog extends StatefulWidget {
  const RoomDialog({super.key});

  @override
  State<RoomDialog> createState() => _RoomDialogState();
}

class _RoomDialogState extends State<RoomDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Room'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Room Description',
          hintText: 'e.g., Master Bedroom, Guest Room',
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.pop(context, _controller.text);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}