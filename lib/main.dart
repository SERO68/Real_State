
import 'package:flutter/material.dart';

import 'screens/dashboard/dashboard_screen.dart';


void main() {
  runApp(const HotelAdminDashboard());
}

class HotelAdminDashboard extends StatelessWidget {
  const HotelAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(
          headlineMedium:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}



