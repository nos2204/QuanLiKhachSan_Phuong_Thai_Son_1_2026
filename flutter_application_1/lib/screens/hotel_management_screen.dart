import 'package:flutter/material.dart';
import '../main.dart'; // AppTheme, Customer
 
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
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Tên khách"),
            ),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: "CCCD"),
            ),
            TextField(
              controller: _roomController,
              decoration: const InputDecoration(labelText: "Số phòng"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
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
                _nameController.clear();
                _idController.clear();
                _roomController.clear();
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
              leading: const CircleAvatar(
                backgroundColor: AppTheme.primaryGold,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                customer.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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