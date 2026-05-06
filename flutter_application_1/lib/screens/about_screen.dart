import 'package:flutter/material.dart';
 
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
            const Text(
              "Đồ án: Quản lý khách sạn",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const Text("Thành viên thực hiện:"),
            const SizedBox(height: 10),
            _buildMemberTile("Nguyễn Minh Phương"),
            _buildMemberTile("Trần Văn Thái"),
            _buildMemberTile("Nguyễn Hoàng Sơn"),
            const Spacer(),
            const Center(
              child: Text(
                "Phiên bản 1.0.0 - 2026",
                style: TextStyle(color: Colors.grey),
              ),
            ),
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