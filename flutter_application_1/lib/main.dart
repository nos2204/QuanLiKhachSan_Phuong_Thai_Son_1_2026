import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'database/database_helper.dart';
import 'screens/dashboard_screen.dart';
import 'screens/booking_list_screen.dart';
import 'screens/room_list_screen.dart';
import 'screens/customer_list_screen.dart';
import 'screens/invoice_list_screen.dart';
import 'screens/about_screen.dart';
import 'screens/room_type_list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/employee_account_screen.dart';
import 'screens/change_request_list_screen.dart';
import 'models/app_user.dart';

// Dinh nghia mau sac chu dao cua ung dung
class AppTheme {
  static const Color darkBlue = Color(0xFF003366);
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color cream = Color(0xFFF8F5EF);
  static const Color bgGray = Color(0xFFF4F6F9);
}

// Ham main, diem bat dau cua ung dung
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Kiem tra moi truong chay app de khoi tao database tuong ung
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    try {
      if (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
    } catch (_) {}
  }
  runApp(const HotelManagementApp());
}

// Widget goc cua ung dung quan ly khach san
class HotelManagementApp extends StatefulWidget {
  const HotelManagementApp({super.key});

  @override
  State<HotelManagementApp> createState() => _HotelManagementAppState();
}

class _HotelManagementAppState extends State<HotelManagementApp> {
  AppUser? _currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Khách Sạn',
      debugShowCheckedModeBanner: false,
      // Cau hinh theme chinh cho app (Mau sac, font chu, kieu UI)
      theme: ThemeData(
        primaryColor: AppTheme.darkBlue,
        scaffoldBackgroundColor: AppTheme.bgGray,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.darkBlue,
          primary: AppTheme.darkBlue,
          secondary: AppTheme.primaryGold,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', 'VN'), // Vietnamese
      ],
      home: _currentUser == null
          ? LoginScreen(onLogin: (user) => setState(() => _currentUser = user))
          : MainNavigation(
              currentUser: _currentUser!,
              onLogout: () => setState(() => _currentUser = null),
            ),
    );
  }
}

// Widget dieu huong chinh voi Bottom Navigation Bar
class MainNavigation extends StatefulWidget {
  final AppUser currentUser;
  final VoidCallback onLogout;

  const MainNavigation({
    super.key,
    required this.currentUser,
    required this.onLogout,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Bien luu tru index cua tab hien tai
  int _currentIndex = 0;
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    final count = await DatabaseHelper.instance.getPendingChangeRequestCount(
      requestedBy: widget.currentUser.isAdmin ? null : widget.currentUser.id,
    );
    if (mounted) {
      setState(() => _pendingCount = count);
    }
  }

  // Danh sach cac man hinh tuong ung voi cac tab
  List<Widget> get _screens => [
    DashboardScreen(currentUser: widget.currentUser, onLogout: widget.onLogout),
    const BookingListScreen(),
    RoomListScreen(currentUser: widget.currentUser),
    CustomerListScreen(currentUser: widget.currentUser),
    _MoreMenuScreen(
      currentUser: widget.currentUser,
      onLogout: widget.onLogout,
      pendingCount: _pendingCount,
      onRefresh: _loadPendingCount,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.darkBlue.withOpacity(0.1),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppTheme.darkBlue),
            label: 'Tổng quan',
          ),
          const NavigationDestination(
            icon: Icon(Icons.book_online_outlined),
            selectedIcon: Icon(Icons.book_online, color: AppTheme.darkBlue),
            label: 'Đặt phòng',
          ),
          const NavigationDestination(
            icon: Icon(Icons.meeting_room_outlined),
            selectedIcon: Icon(Icons.meeting_room, color: AppTheme.darkBlue),
            label: 'Phòng',
          ),
          const NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: AppTheme.darkBlue),
            label: 'Khách',
          ),
          NavigationDestination(
            icon: _pendingCount > 0
                ? Badge(
                    label: Text('$_pendingCount'),
                    child: const Icon(Icons.menu),
                  )
                : const Icon(Icons.menu),
            selectedIcon: _pendingCount > 0
                ? Badge(
                    label: Text('$_pendingCount'),
                    child: const Icon(Icons.menu, color: AppTheme.darkBlue),
                  )
                : const Icon(Icons.menu, color: AppTheme.darkBlue),
            label: 'Thêm',
          ),
        ],
      ),
    );
  }
}

// Man hinh Menu tuy chon them (Lich su hoa don, Gioi thieu)
class _MoreMenuScreen extends StatelessWidget {
  final AppUser currentUser;
  final VoidCallback onLogout;
  final int pendingCount;
  final VoidCallback onRefresh;

  const _MoreMenuScreen({
    required this.currentUser,
    required this.onLogout,
    this.pendingCount = 0,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text(
          'THÊM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.darkBlue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.darkBlue.withOpacity(0.1),
                  child: Icon(
                    currentUser.isAdmin
                        ? Icons.admin_panel_settings
                        : Icons.badge_outlined,
                    color: AppTheme.darkBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBlue,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentUser.roleText,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Đăng xuất',
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.category_outlined,
            title: 'Quản lý Loại phòng & Giá',
            subtitle: 'Thêm, sửa, xóa loại phòng và thiết lập giá',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RoomTypeListScreen(currentUser: currentUser),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.fact_check_outlined,
            title: currentUser.isAdmin ? 'Duyệt đề xuất' : 'Đề xuất của tôi',
            subtitle: currentUser.isAdmin
                ? 'Chấp nhận hoặc từ chối đề xuất của nhân viên'
                : 'Theo dõi trạng thái đề xuất đã gửi',
            badgeCount: pendingCount,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ChangeRequestListScreen(currentUser: currentUser),
                ),
              );
              onRefresh();
            },
          ),
          if (currentUser.isAdmin) ...[
            const SizedBox(height: 12),
            _buildMenuTile(
              context,
              icon: Icons.manage_accounts_outlined,
              title: 'Tài khoản nhân viên',
              subtitle: 'Thêm, sửa, xóa tài khoản nhân viên',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmployeeAccountScreen(),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.receipt_long,
            title: 'Lịch sử hóa đơn',
            subtitle: 'Xem các hóa đơn đã thanh toán',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InvoiceListScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context,
            icon: Icons.info_outline,
            title: 'Giới thiệu dự án',
            subtitle: 'Thông tin về ứng dụng',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.darkBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.darkBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),
            if (badgeCount > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
