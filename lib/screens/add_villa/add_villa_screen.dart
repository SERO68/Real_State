import 'package:flutter/material.dart';
import '../../models/villa.dart';
import 'widgets/villa_form.dart';

class AddVillaPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddVilla;
  final String compoundId;
  final String compoundName;
  final Villa? villa;
  final bool isEditing;

  const AddVillaPage({
    super.key,
    required this.onAddVilla,
    required this.compoundId,
    required this.compoundName,
    this.villa,
    this.isEditing = false,
  });

  @override
  State<AddVillaPage> createState() => _AddVillaPageState();
}

class _AddVillaPageState extends State<AddVillaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.villa == null 
          ? 'Add New Villa in ${widget.compoundName}' 
          : 'Edit Villa in ${widget.compoundName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: VillaForm(
              onAddVilla: widget.onAddVilla,
              initialVilla: widget.villa,
              compoundId: widget.compoundId,
              compoundName: widget.compoundName,
              isEditing: widget.isEditing, // Add this line
            ),
          ),
        ),
      ),
    );
  }
}