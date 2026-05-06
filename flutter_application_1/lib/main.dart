import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/hotel_management_screen.dart';
import 'screens/about_screen.dart';

class Customer {
  final String name;
  final String id;
  final String roomAssigned;
  final int price; // Giá phòng (VNĐ/đêm)

  Customer({
    required this.name,
    required this.id,
    required this.roomAssigned,
    this.price = 850000, // Mặc định 850.000đ
  });
}

class AppTheme {
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color darkBlue = Color(0xFF003366);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.darkBlue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const HotelManagementScreen(),
    const AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppTheme.primaryGold,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Quản lý'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Giới thiệu'),
        ],
      ),
    );
  }
}