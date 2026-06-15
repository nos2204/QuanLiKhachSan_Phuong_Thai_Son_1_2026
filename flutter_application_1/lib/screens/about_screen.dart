import 'package:flutter/material.dart';
import '../main.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        foregroundColor: Colors.white,
        title: const Text("GIỚI THIỆU DỰ ÁN"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: const Column(
                children: [
                  Text(
                    "Đặt phòng nhanh – Nghỉ ngơi trọn vẹn",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.darkBlue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ứng dụng quản lý khách sạn hiện đại, tối ưu và thân thiện.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== IMAGE =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  "https://images.unsplash.com/photo-1566073771259-6a8506099945",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== TEXT CONTENT =====
            _buildContent(),

            const SizedBox(height: 20),

            // ===== ROOMS =====
            _buildRoomSection(context),

            const SizedBox(height: 20),

            // ===== GALLERY =====
            _buildGallery(),

            const SizedBox(height: 20),

            const Text(
              "Phiên bản 1.0.0 - 2026",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ===== CONTENT =====
  Widget _buildContent() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chào mừng bạn đến hệ thống",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkBlue),
          ),
          SizedBox(height: 10),
          Text(
            "Ứng dụng quản lý khách sạn giúp bạn quản lý phòng, khách hàng, và đặt phòng một cách nhanh chóng, tiện lợi và chính xác. "
            "Với giao diện hiện đại, bạn có thể dễ dàng theo dõi doanh thu, trạng thái phòng và lịch sử giao dịch.\n\n"
            "Dù bạn quản lý khách sạn nhỏ hay chuỗi resort, ứng dụng luôn đáp ứng tốt nhu cầu nghiệp vụ, mang đến trải nghiệm mượt mà, an toàn.",
            style: TextStyle(height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // ===== ROOM SECTION =====
  Widget _buildRoomSection(BuildContext context) {
    return Column(
      children: [
        _buildRoomCard(
          context,
          "Phòng Bình Dân",
          "Không gian sống trang nhã và lãng mạn. Hoàn toàn khép kín...",
          "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85",
        ),
        _buildRoomCard(
          context,
          "Phòng VIP",
          "Không gian cao cấp, tiện nghi hiện đại, view đẹp...",
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
        ),
      ],
    );
  }

  Widget _buildRoomCard(BuildContext context, String title, String desc, String image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: Image.network(image, height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkBlue)),
                const SizedBox(height: 8),
                Text(desc, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ===== GALLERY =====
  Widget _buildGallery() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thư viện",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkBlue),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _galleryImage("https://images.unsplash.com/photo-1505691938895-1758d7feb511"),
              _galleryImage("https://images.unsplash.com/photo-1493809842364-78817add7ffb"),
              _galleryImage("https://images.unsplash.com/photo-1507089947368-19c1da9775ae"),
            ],
          )
        ],
      ),
    );
  }

  Widget _galleryImage(String url) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(url, height: 80, fit: BoxFit.cover),
        ),
      ),
    );
  }
}