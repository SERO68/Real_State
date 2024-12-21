import 'package:flutter/material.dart';
import '../../../models/villa.dart';
import 'villa_card.dart';

class VillaGrid extends StatelessWidget {
  final List<Villa> villas;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const VillaGrid({
    super.key,
    required this.villas,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: villas.length,
      itemBuilder: (context, index) => VillaCard(
        villa: villas[index],
        onEdit: () => onEdit(index),
        onDelete: () => onDelete(index),
      ),
    );
  }
}