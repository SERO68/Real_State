import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class CustomContainer extends StatelessWidget {
  final bool isDesktop;
  final Widget child;

  const CustomContainer({
    Key? key,
    required this.isDesktop,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isDesktop ? AppConstants.maxDesktopWidth : double.infinity,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}