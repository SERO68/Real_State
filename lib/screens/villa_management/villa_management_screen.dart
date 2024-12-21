import 'package:dashboard/services/api_service.dart';
import 'package:flutter/material.dart';
import 'widgets/empty_state.dart';
import 'widgets/villa_grid.dart';
import '../../models/villa.dart';
import '../add_villa/add_villa_screen.dart';

class VillaManagementPage extends StatefulWidget {
  final String compoundId;
  final String compoundName;

  const VillaManagementPage({
    super.key,
    required this.compoundId,
    required this.compoundName,
  });

  @override
  State<VillaManagementPage> createState() => _VillaManagementPageState();
}

class _VillaManagementPageState extends State<VillaManagementPage> {
  List<Villa> villas = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVillas();
  }

  Future<void> _loadVillas() async {
  try {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await ApiService.getCompoundUnits(widget.compoundId);

    if (result['success']) {
      final unitsData = result['data']['units'] as List;
      setState(() {
        villas = unitsData.map((unit) => Villa.fromJson(unit)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result['message'];
        _isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      _error = 'Failed to load villas';
      _isLoading = false;
    });
    print('Error loading villas: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.compoundName} - Units'),
      ),
      body: _buildContent(),
      floatingActionButton: villas.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _addNewVilla,
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
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
              onPressed: _loadVillas,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: villas.isEmpty
          ? EmptyState(onAddPressed: _addNewVilla)
          : VillaGrid(
              villas: villas,
              onEdit: _editVilla,
              onDelete: _deleteVilla,
            ),
    );
  }

  void _addNewVilla() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddVillaPage(
        compoundId: widget.compoundId,
        compoundName: widget.compoundName,
        onAddVilla: (villaData) {
          // This callback is optional, as the villa is returned through Navigator.pop
        },
      ),
    ),
  );

  if (result != null) {
    // Convert the Map to a Villa object
    final newVilla = Villa.fromJson(result as Map<String, dynamic>);
    setState(() {
      villas.add(newVilla);
    });
    // Optionally refresh the list from the server
    _loadVillas();
  }
}

void _editVilla(int index) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddVillaPage(
        compoundId: widget.compoundId,
        compoundName: widget.compoundName,
        villa: villas[index], // Pass the existing villa for editing
        onAddVilla: (updatedVilla) {
          // This callback is optional
        },
              isEditing: true,

      ),
    ),
  );

  if (result != null) {
    // Convert the Map to a Villa object
    final editedVilla = Villa.fromJson(result as Map<String, dynamic>);
    setState(() {
      villas[index] = editedVilla;
    });
    // Optionally refresh the list from the server
    _loadVillas();
  }
}
  Future<void> _deleteVilla(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Villa'),
        content: const Text('Are you sure you want to delete this villa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => villas.removeAt(index));
      _loadVillas();
    }
  }
}