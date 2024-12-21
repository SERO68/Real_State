import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  const FormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Add a New Compound',
      style: Theme.of(context).textTheme.headlineMedium,
      textAlign: TextAlign.center,
    );
  }
}