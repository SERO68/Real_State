import 'package:flutter/material.dart';
import 'widgets/sidebar_navigation.dart';
import 'widgets/places_grid.dart';
import 'widgets/add_place_section.dart';
import '../../models/place.dart';
import '../../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Place> _places = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
 
  }

  Future<void> _refreshPlaces() async {
    await _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
  try {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await ApiService.getAllPlaces();

    if (result['success']) {
      final List<dynamic> placesData = result['data'] as List<dynamic>;
      
      setState(() {
        _places = placesData.map((data) {
          return Place.fromJson(data);
        }).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result['message'];
        _isLoading = false;
      });
    }
  } catch (e) {
    print('Error fetching places: $e');
    setState(() {
      _error = 'Failed to load places';
      _isLoading = false;
    });
  }
}

  void _updatePlace(int index, String newName) {
    setState(() {
      _places[index].name = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SidebarNavigation(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshPlaces,
                      child: _buildContent(),
                    ),
                  ),
                  const SizedBox(height: 16),
                   AddPlaceSection(
                     onPlaceAdded: _fetchPlaces,
                  ),
                 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchPlaces,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_places.isEmpty) {
      return const Center(
        child: Text('No places found'),
      );
    }

    return PlacesGrid(
      places: _places,
      onPlaceUpdated: _updatePlace,
    );
  }
}
