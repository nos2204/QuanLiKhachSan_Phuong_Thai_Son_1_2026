import 'package:flutter/material.dart';
import '../main.dart';
import 'hotel_management_screen.dart';

class AboutScreen extends StatelessWidget {
const AboutScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.grey[100],
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
color: Colors.white,
child: Column(
children: [
const Text(
"Đặt phòng nhanh – Nghỉ ngơi trọn vẹn",
textAlign: TextAlign.center,
style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
),
const SizedBox(height: 20),

ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green[700],
),
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) =>
const HotelManagementScreen(),
),
);
},
child: const Text("Ấn vào để trải nghiệm ngay"),
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

const SizedBox(height: 20),
],
),
),
);
}

// ===== CONTENT =====
Widget _buildContent() {
return Container(
width: double.infinity,
margin: const EdgeInsets.symmetric(horizontal: 15),
padding: const EdgeInsets.all(15),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
),
child: const Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
"Chào mừng bạn đến trang của chúng tôi",
style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
SizedBox(height: 10),
Text(
"Ứng dụng đặt phòng khách sạn của chúng tôi giúp bạn tìm kiếm và đặt chỗ ở một cách nhanh chóng, tiện lợi và tiết kiệm nhất. "
"Chỉ với vài thao tác đơn giản, bạn có thể khám phá hàng ngàn khách sạn, homestay và resort chất lượng trên khắp mọi điểm đến. "
"Hệ thống thông minh giúp gợi ý nơi ở phù hợp với nhu cầu, ngân sách và sở thích của bạn, đồng thời cập nhật liên tục các ưu đãi hấp dẫn để bạn luôn có được mức giá tốt nhất.\n\n"
"Dù bạn đi du lịch, công tác hay nghỉ dưỡng, ứng dụng luôn sẵn sàng đồng hành, mang đến trải nghiệm đặt phòng mượt mà, an toàn và đáng tin cậy. "
"Hãy để mỗi chuyến đi của bạn trở nên dễ dàng hơn, bắt đầu từ việc chọn một nơi lưu trú lý tưởng ngay trong lòng bàn tay.",

style: TextStyle(height: 1.5),
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

Widget _buildRoomCard(
BuildContext context, String title, String desc, String image) {
return Container(
margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
padding: const EdgeInsets.all(10),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
),
child: Column(
children: [
ClipRRect(
borderRadius: BorderRadius.circular(10),
child: Image.network(image, height: 150, fit: BoxFit.cover),
),
const SizedBox(height: 10),

Text(title,
style:
const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

const SizedBox(height: 5),

Text(desc, textAlign: TextAlign.center),

const SizedBox(height: 10),

ElevatedButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const HotelManagementScreen(),
),
);
},
child: const Text("Tìm hiểu thêm"),
)
],
),
);
}

// ===== GALLERY =====
Widget _buildGallery() {
return Container(
width: double.infinity,
margin: const EdgeInsets.symmetric(horizontal: 15),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
"Thư viện",
style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
),
const SizedBox(height: 10),

Row(
children: [
_galleryImage(
"https://images.unsplash.com/photo-1505691938895-1758d7feb511"),
_galleryImage(
"https://images.unsplash.com/photo-1493809842364-78817add7ffb"),
_galleryImage(
"https://images.unsplash.com/photo-1507089947368-19c1da9775ae"),
],
)
],
),
);
}

Widget _galleryImage(String url) {
return Expanded(
child: Padding(
padding: const EdgeInsets.all(5),
child: ClipRRect(
borderRadius: BorderRadius.circular(10),
child: Image.network(url, height: 80, fit: BoxFit.cover),
),
),
);
}
}