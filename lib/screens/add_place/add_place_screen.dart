import 'package:flutter/material.dart';
import 'widgets/compound_form.dart';
import '../../utils/constants.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Compound'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > AppConstants.maxDesktopWidth;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Center(
              child: CompoundForm(isDesktop: isDesktop),
            ),
          );
        },
      ),
    );
  }
}