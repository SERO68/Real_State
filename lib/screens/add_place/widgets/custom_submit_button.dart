import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomSubmitButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: _buildDecoration(),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
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
}