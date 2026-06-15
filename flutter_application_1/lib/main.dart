import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tích hợp Plugin Cloud Firestore
import 'firebase_options.dart';                     // File cấu hình tự động sinh từ CLI

import 'screens/home_screen.dart';
import 'screens/hotel_management_screen.dart';
import 'screens/about_screen.dart';

// 1. Đối tượng Khách hàng - Sẽ được lưu thành các 'Document' trong CSDL Không quan hệ
class Customer {
  final String name;
  final String id;
  final String roomAssigned;
  final int price;

  Customer({
    required this.name,
    required this.id,
    required this.roomAssigned,
    this.price = 850000, // Mặc định 850.000đ theo thiết kế hệ thống
  });
}

// Bảng màu thiết kế giao diện Khách sạn (Gold & Dark Blue)
class AppTheme {
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color darkBlue = Color(0xFF003366);
}

// Khai báo Instance kết nối toàn cục tới bộ sưu tập 'profile' trên Firestore
final CollectionReference profileCollection = FirebaseFirestore.instance.collection('profile');

// Hàm CRUD: Tạo bản ghi mới lên Cloud Firestore (Sử dụng debugPrint chuẩn lint)
Future<void> addUser(String name, String room, String customerId) {
  return profileCollection
      .add({
        'username': name,
        'roomAssigned': room,
        'customerId': customerId,
        'email': 'hello@test.com', // $\$ Giá trị demo theo mẫu tư liệu
        'price': 850000,
        'createdAt': FieldValue.serverTimestamp(), // Tự động lưu thời gian tạo bản ghi
      })
      .then((value) => debugPrint("User Added Successfully to Firebase!"))
      .catchError((error) => debugPrint("Failed to add user: $error"));
}

// Hàm khởi chạy hệ thống bất đồng bộ (Async Main) chuẩn FlutterFire cho mọi nền tảng
Future<void> main() async {
  // Tuân thủ nguyên tắc khởi tạo hệ thống lõi của Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Kích hoạt Firebase nền tảng (Áp dụng cho cả Web, Android, iOS...)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  // ĐÃ SỬA: Đổi 'const home_screen()' thành 'const HomeScreen()' để khớp với Class định nghĩa
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