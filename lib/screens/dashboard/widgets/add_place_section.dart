import 'package:flutter/material.dart';
import '../../add_place/add_place_screen.dart';

class AddPlaceSection extends StatelessWidget {
  final VoidCallback? onPlaceAdded; // Add this callback

  const AddPlaceSection({
    super.key,
    this.onPlaceAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _buildContainerDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTitle(context),
          const SizedBox(height: 16),
          _buildAddButton(context),
        ],
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Want to add a new place?',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToAddPlace(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: _buildButtonDecoration(),
        child: const Text(
          'Add Place',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildButtonDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Colors.blue, Colors.lightBlueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.blueAccent.withOpacity(0.4),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  Future<void> _navigateToAddPlace(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddPlacePage()),
    );

    // If place was added successfully
    if (result == true && onPlaceAdded != null) {
      onPlaceAdded!();
    }
  }
}