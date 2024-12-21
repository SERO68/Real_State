import 'package:flutter/material.dart';
import '../../../models/place.dart';
import '../../villa_management/villa_management_screen.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onEdit;

  const PlaceCard({
    super.key,
    required this.place,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToVillas(context),
      child: Stack(
        children: [
          _buildCardBackground(),
          _buildPlaceName(),
          _buildEditButton(),
        ],
      ),
    );
  }

  void _navigateToVillas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VillaManagementPage(
          compoundId: place.id,
          compoundName: place.name,
        ),
      ),
    );
  }
  
Widget _buildCardBackground() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildImage(),
      ),
    );
  }

 Widget _buildImage() {

  return Image.network(
    place.imageUrl,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
    errorBuilder: (context, error, stackTrace) {
      print('Error loading image: $error');
      print('Failed URL: ${place.imageUrl}');
      print('Stack trace: $stackTrace');
      
      return Container(
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load image\n${place.name}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    },
  );
}

  Widget _buildPlaceName() {
    return Positioned(
      bottom: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          place.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  
}