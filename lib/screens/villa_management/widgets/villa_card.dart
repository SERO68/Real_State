import 'package:flutter/material.dart';
import '../../../models/villa.dart';

class VillaCard extends StatelessWidget {
  final Villa villa;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VillaCard({
    super.key,
    required this.villa,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildImage(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  villa.unitName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  villa.unitMainFeature,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 18),
                    Text('${villa.price} / night'),
                  ],
                ),
                const SizedBox(height: 12),
                _buildOverviews(),
              ],
            ),
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildImage() {
  if (villa.imageUrlPath == null) {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 40),
      ),
    );
  }

  // Construct the full URL by combining the base URL with the image path
  final imageUrl = 'http://realstateapi.runasp.net/${villa.imageUrlPath!.replaceAll('\\', '/')}';
  
  print('Loading image from URL: $imageUrl'); // For debugging

  return Image.network(
    imageUrl,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Container(
        color: Colors.grey.shade200,
        child: Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / 
                  loadingProgress.expectedTotalBytes!
                : null,
          ),
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) {
      print('Error loading image: $error'); // For debugging
      return Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.error_outline, size: 40),
        ),
      );
    },
  );
}

  Widget _buildOverviews() {
    return Wrap(
      spacing: 4,
      children: villa.overviews.map((overview) {
        return Chip(
          label: Text(
            overview.description,
            style: const TextStyle(fontSize: 10),
          ),
          avatar: Icon(
            IconData(
              int.tryParse(overview.iconName) ?? Icons.info.codePoint,
              fontFamily: 'MaterialIcons',
            ),
            size: 16,
          ),
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }

  Widget _buildActions() {
    return OverflowBar(
      alignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit'),
        ),
        TextButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete, size: 16, color: Colors.red),
          label: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}