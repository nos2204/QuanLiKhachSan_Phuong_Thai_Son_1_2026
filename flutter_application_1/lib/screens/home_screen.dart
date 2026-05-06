import 'package:flutter/material.dart';

void main() {
  runApp(const HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đặt Phòng Khách Sạn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const HotelBookingPage(),
    );
  }
}

class HotelBookingPage extends StatelessWidget {
  const HotelBookingPage({super.key});

  static const Color _navy = Color(0xFF1A3C5E);
  static const Color _gold = Color(0xFFC9A84C);
  static const Color _cream = Color(0xFFF8F5EF);
  static const Color _lightGray = Color(0xFFF2F2F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: CustomScrollView(
        slivers: [
          //Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: _navy,
            title: Row(
              children: [
                const Icon(Icons.hotel, color: _gold, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Đặt Phòng Khách Sạn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: null,
                child: const Text('Trang chủ',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ),
              TextButton(
                onPressed: null,
                child: const Text('Phòng',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ),
              TextButton(
                onPressed: null,
                child: const Text('Liên hệ',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: OutlinedButton(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _gold),
                    foregroundColor: _gold,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: const Text('Đăng nhập', style: TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHero(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: _buildFormCard(),
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Hero
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F2640), Color(0xFF1A3C5E), Color(0xFF26567F)],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: _gold.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'TRẢI NGHIỆM ĐẲNG CẤP 5 SAO',
              style: TextStyle(color: _gold, fontSize: 11, letterSpacing: 2.5),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Đặt Phòng\nKhách Sạn',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 44,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Hoàn tất đặt phòng trong vài phút.\nChúng tôi sẽ liên hệ xác nhận sớm nhất.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 15, height: 1.6),
          ),
        ],
      ),
    );
  }

  //Form
  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin đặt phòng',
            style: TextStyle(
              color: _navy,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(height: 2, width: 40, color: _gold),
          const SizedBox(height: 28),

          _label('Họ và tên'),
          _staticField(hint: 'Nguyễn Văn A', icon: Icons.person_outline),
          const SizedBox(height: 18),

          _label('Email'),
          _staticField(hint: 'example@email.com', icon: Icons.mail_outline),
          const SizedBox(height: 18),

          _label('Số điện thoại'),
          _staticField(hint: '0901 234 567', icon: Icons.phone_outlined),
          const SizedBox(height: 18),

          _label('Loại phòng'),
          _staticDropdown(),
          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Ngày nhận phòng'),
                    _staticDateField(),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Ngày trả phòng'),
                    _staticDateField(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _label('Số khách'),
          _staticGuestSelector(),
          const SizedBox(height: 18),

          _label('Yêu cầu đặc biệt (tùy chọn)'),
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: _lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Phòng tầng cao, view biển, giường phụ...',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 28),

          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: _navy,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Đặt Phòng Ngay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Footer
  Widget _buildFooter() {
    return Container(
      color: const Color(0xFF0F2640),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.hotel, color: _gold, size: 18),
                        SizedBox(width: 6),
                        Text('Đặt Phòng Khách Sạn',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Trải nghiệm nghỉ dưỡng\nđẳng cấp 5 sao tại Việt Nam.',
                      style: TextStyle(
                          color: Colors.white54, fontSize: 13, height: 1.6),
                    ),
                  ],
                ),
              ),
              _footerColumn('Dịch vụ',
                  ['Phòng & Suite', 'Nhà hàng', 'Spa & Wellness', 'Hội nghị']),
              const SizedBox(width: 32),
              _footerColumn(
                  'Hỗ trợ', ['Chính sách huỷ', 'FAQ', 'Liên hệ', 'Phản hồi']),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),
          const Text(
            '© 2025 Đặt Phòng Khách Sạn. Bảo lưu mọi quyền.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Text(text,
            style: const TextStyle(
                color: _navy, fontSize: 13, fontWeight: FontWeight.w600)),
      );

  Widget _staticField({required String hint, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400], size: 20),
          const SizedBox(width: 10),
          Text(hint, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _staticDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Chọn loại phòng',
              style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _staticDateField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined,
              color: Colors.grey[400], size: 16),
          const SizedBox(width: 8),
          Text('Chọn ngày',
              style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _staticGuestSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('1 khách',
              style: TextStyle(fontSize: 14, color: _navy)),
          Row(
            children: [
              Icon(Icons.remove_circle_outline, color: _navy),
              SizedBox(width: 12),
              Text('1',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: _navy)),
              SizedBox(width: 12),
              Icon(Icons.add_circle_outline, color: _navy),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: _gold,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(item,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 13)),
            )),
      ],
    );
  }
}