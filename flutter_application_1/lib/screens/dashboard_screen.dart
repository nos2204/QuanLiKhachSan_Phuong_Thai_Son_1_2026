import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../main.dart';
import '../database/database_helper.dart';
import '../models/app_user.dart';
import '../models/booking.dart';
import '../widgets/stat_card.dart';
import 'booking_form_screen.dart';
import 'room_list_screen.dart';

// Man hinh Tong quan (Dashboard) hien thi cac thong ke va thao tac nhanh
class DashboardScreen extends StatefulWidget {
  final AppUser currentUser;
  final VoidCallback onLogout;

  const DashboardScreen({
    super.key,
    required this.currentUser,
    required this.onLogout,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _revenueData = [];
  List<Booking> _recentBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Ham tai du lieu tu database len man hinh
  Future<void> _loadData() async {
    final stats = await DatabaseHelper.instance.getDashboardStats();
    final revenue = await DatabaseHelper.instance.getRevenueLast7Days();
    final bookings = await DatabaseHelper.instance.getAllBookings();

    if (mounted) {
      setState(() {
        _stats = stats;
        _revenueData = revenue;
        _recentBookings = bookings.take(5).toList();
        _isLoading = false;
      });
    }
  }

  // Ham format tien te hien thi (them dau cham phan cach hang nghin va chu 'd')
  String _formatVND(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buf.write('.');
      buf.write(s[i]);
      count++;
    }
    return '${buf.toString().split('').reversed.join()}đ';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryGold),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppTheme.primaryGold,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Phan Header cua man hinh (Loi chao va background gradient)
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.darkBlue, Color(0xFF00509E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin chào,',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Quản lý Khách sạn',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.hotel,
                        color: AppTheme.primaryGold,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
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
                      widget.currentUser.isAdmin
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
                          widget.currentUser.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBlue,
                          ),
                        ),
                        Text(
                          widget.currentUser.roleText,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Đăng xuất',
                    onPressed: widget.onLogout,
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tổng quan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
                ),
                const SizedBox(height: 16),

                // Grid hien thi 4 the thong ke (Phong, Phong trong, Dang thue, Doanh thu)
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StatCard(
                      icon: Icons.meeting_room,
                      title: 'Tổng số phòng',
                      value: '${_stats['totalRooms'] ?? 0}',
                      color: Colors.blue,
                    ),
                    StatCard(
                      icon: Icons.check_circle_outline,
                      title: 'Phòng trống',
                      value: '${_stats['availableRooms'] ?? 0}',
                      color: Colors.green,
                    ),
                    StatCard(
                      icon: Icons.people_outline,
                      title: 'Đang thuê',
                      value: '${_stats['occupiedRooms'] ?? 0}',
                      color: Colors.orange,
                    ),
                    StatCard(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Doanh thu',
                      value: _formatVND((_stats['totalRevenue'] ?? 0).toInt()),
                      color: AppTheme.primaryGold,
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.build_circle_outlined,
                        title: 'Bảo trì',
                        value: '${_stats['maintenanceRooms'] ?? 0}',
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        icon: Icons.supervisor_account,
                        title: 'Tổng khách',
                        value: '${_stats['totalCustomers'] ?? 0}',
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Revenue Chart
                const Text(
                  'Doanh thu 7 ngày qua',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRevenueChart(),

                const SizedBox(height: 32),

                // Khu vuc thao tac nhanh (Dat phong, Xem phong)
                const Text(
                  'Thao tác nhanh',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BookingFormScreen(),
                            ),
                          );
                          _loadData(); // Refresh after return
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Đặt phòng',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.darkBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Note: Main navigation usually handles this,
                          // but for quick action we might navigate or change tab.
                          // Here we just push the screen.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoomListScreen(
                                currentUser: widget.currentUser,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.search,
                          color: AppTheme.darkBlue,
                        ),
                        label: const Text(
                          'Xem phòng',
                          style: TextStyle(color: AppTheme.darkBlue),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppTheme.darkBlue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Recent Bookings
                const Text(
                  'Đặt phòng gần đây',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
                ),
                const SizedBox(height: 16),
                if (_recentBookings.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Chưa có đặt phòng nào.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recentBookings.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final booking = _recentBookings[index];
                      Color statusColor;
                      switch (booking.status.name) {
                        case 'booked':
                          statusColor = Colors.blue;
                          break;
                        case 'checkedIn':
                          statusColor = Colors.green;
                          break;
                        case 'checkedOut':
                          statusColor = Colors.grey;
                          break;
                        case 'cancelled':
                          statusColor = Colors.red;
                          break;
                        default:
                          statusColor = Colors.blue;
                      }

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
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
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.bookmark, color: statusColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.customerName ?? 'Khách hàng',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Phòng: ${booking.roomNumber ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    booking.statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatVND(booking.totalAmount.toInt()),
                                  style: const TextStyle(
                                    color: AppTheme.primaryGold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Ham ve bieu do doanh thu 7 ngay gan nhat bang thu vien fl_chart
  Widget _buildRevenueChart() {
    if (_revenueData.isEmpty) return const SizedBox.shrink();

    List<FlSpot> spots = [];
    double maxY = 0;

    for (int i = 0; i < _revenueData.length; i++) {
      double total = _revenueData[i]['total'] / 1000000; // Show in millions
      if (total > maxY) maxY = total;
      spots.add(FlSpot(i.toDouble(), total));
    }

    maxY = maxY > 0 ? maxY * 1.2 : 10;

    return Container(
      height: 250,
      padding: const EdgeInsets.only(top: 24, bottom: 12, left: 12, right: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}M',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < _revenueData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _revenueData[index]['dayLabel'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppTheme.primaryGold,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primaryGold.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
