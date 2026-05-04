import 'package:flutter/material.dart';

class Customer {
  final String name;
  final String id;
  final String roomAssigned;
  Customer({required this.name, required this.id, required this.roomAssigned});
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

// ---------------------------------------------------------
// 3. MAIN NAVIGATION (Mục 2: Bottom Navigator Bar)
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

// ---------------------------------------------------------
// 4. CÁC MÀN HÌNH CHI TIẾT (Mục 1 & 3.2)
// ---------------------------------------------------------

// --- MÀN HÌNH TRANG CHỦ (HOME) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QUẢN LÝ KHÁCH SẠN"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://scontent.fhan14-5.fna.fbcdn.net/v/t39.30808-6/319888352_906647430511337_922734217827518560_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=1d70fc&_nc_ohc=8UnfVBwkI6gQ7kNvwHC4yuq&_nc_oc=AdqwgQXpdJxaHEI-rjZeHD3wHNrcAPkRJExMpwZdIqi1VfOFg_vzoFSWV0FlybZuFEo&_nc_zt=23&_nc_ht=scontent.fhan14-5.fna&_nc_gid=MUV8_wPAyRlwyLjO0pRkbQ&_nc_ss=7f289&oh=00_Af7-d2DGQemfAk-L8oX7psiUHOvDYQjP8bepZSPy981o1w&oe=69FDAD2E',
                width: 320,
                height: 220,
                fit: BoxFit.cover, 
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator();
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text("Chào mừng đến với KHÁCH SẠN ABC", 
                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkBlue)),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Hệ thống quản lý khách hàng", textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelManagementScreen extends StatefulWidget {
  const HotelManagementScreen({super.key});

  @override
  State<HotelManagementScreen> createState() => _HotelManagementScreenState();
}

class _HotelManagementScreenState extends State<HotelManagementScreen> {
  final List<Customer> _customerList = [
    Customer(name: 'Nguyễn Hoàng Sơn', id: '001xxx', roomAssigned: 'P102'),
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thêm Khách Hàng"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Tên khách")),
            TextField(controller: _idController, decoration: const InputDecoration(labelText: "CCCD")),
            TextField(controller: _roomController, decoration: const InputDecoration(labelText: "Số phòng")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                setState(() {
                  _customerList.add(Customer(
                    name: _nameController.text,
                    id: _idController.text,
                    roomAssigned: _roomController.text,
                  ));
                });
                _nameController.clear(); _idController.clear(); _roomController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Thêm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        foregroundColor: Colors.white,
        title: const Text("DANH SÁCH THUÊ PHÒNG"),
      ),
      body: ListView.builder(
        itemCount: _customerList.length,
        itemBuilder: (context, index) {
          final customer = _customerList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: AppTheme.primaryGold, child: Icon(Icons.person, color: Colors.white)),
              title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("CCCD: ${customer.id} | Phòng: ${customer.roomAssigned}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => _customerList.removeAt(index)),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.darkBlue,
        foregroundColor: Colors.white,
        onPressed: _showAddCustomerDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --- MÀN HÌNH THÔNG TIN (ABOUT) ---
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("THÔNG TIN NHÓM")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Đồ án: Quản lý khách sạn", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            const Text("Thành viên thực hiện:"),
            const SizedBox(height: 10),
            _buildMemberTile("Nguyễn Minh Phương"),
            _buildMemberTile("Trần Văn Thái"),
            _buildMemberTile("Nguyễn Hoàng Sơn"),
            const Spacer(),
            const Center(child: Text("Phiên bản 1.0.0 - 2026", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Text(name, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}