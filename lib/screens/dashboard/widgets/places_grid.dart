import 'package:dashboard/screens/dashboard/widgets/edit_place_dialog.dart';
import 'package:flutter/material.dart';
import 'place_card.dart';
import '../../../models/place.dart';

class PlacesGrid extends StatelessWidget {
  final List<Place> places;
  final Function(int, String) onPlaceUpdated;

  const PlacesGrid({
    super.key,
    required this.places,
    required this.onPlaceUpdated,
  });

  @override
  Widget build(BuildContext context) {
        print('Building PlacesGrid with ${places.length} places'); // Add this for debugging
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Places',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 900 ? 2 : 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: places.length,
              itemBuilder: (context, index) => PlaceCard(
                place: places[index],
                onEdit: () => _showEditDialog(context, index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => EditPlaceDialog(
        place: places[index],
        onSave: (newName) => onPlaceUpdated(index, newName),
      ),
    );
  }
}