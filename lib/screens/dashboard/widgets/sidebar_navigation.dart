import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarNavigation extends StatelessWidget {
  const SidebarNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SidebarXController(selectedIndex: 0, extended: true);

    return SidebarX(
      controller: controller,
      theme: const SidebarXTheme(
        decoration: BoxDecoration(color: Colors.blueGrey),
        textStyle: TextStyle(color: Colors.white),
        selectedTextStyle: TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        selectedIconTheme: IconThemeData(color: Colors.blue),
      ),
      extendedTheme: const SidebarXTheme(
        width: 250,
        decoration: BoxDecoration(color: Colors.blueGrey),
      ),
      items: _buildSidebarItems(),
    );
  }

  List<SidebarXItem> _buildSidebarItems() {
    final items = [
      (Icons.dashboard, 'Dashboard'),
      (Icons.hotel, 'Places'),
      (Icons.analytics, 'Analytics'),
      (Icons.settings, 'Settings'),
    ];

    return items.map((item) => _buildSidebarItem(item.$1, item.$2)).toList();
  }

  SidebarXItem _buildSidebarItem(IconData icon, String label) {
    return SidebarXItem(
      iconWidget: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
      label: '',
    );
  }
}