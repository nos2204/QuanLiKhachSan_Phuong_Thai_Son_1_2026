import 'package:flutter/material.dart';
import '../main.dart';
import '../models/booking.dart';
import '../database/database_helper.dart';
import 'booking_form_screen.dart';
import 'checkout_screen.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text('QUẢN LÝ ĐẶT PHÒNG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primaryGold,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppTheme.primaryGold,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Đã đặt'),
            Tab(text: 'Đang ở'),
            Tab(text: 'Đã trả'),
            Tab(text: 'Đã hủy'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BookingListTab(statusFilter: null),
          BookingListTab(statusFilter: 'booked'),
          BookingListTab(statusFilter: 'checkedIn'),
          BookingListTab(statusFilter: 'checkedOut'),
          BookingListTab(statusFilter: 'cancelled'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryGold,
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingFormScreen()));
          // Refresh list can be triggered by ValueNotifier or just letting users pull to refresh.
          // In TabView it's tricky to call setState on child, pull-to-refresh is better.
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class BookingListTab extends StatefulWidget {
  final String? statusFilter;
  const BookingListTab({super.key, this.statusFilter});

  @override
  State<BookingListTab> createState() => _BookingListTabState();
}

class _BookingListTabState extends State<BookingListTab> {
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final bookings = await DatabaseHelper.instance.getAllBookings(statusFilter: widget.statusFilter);
    if (mounted) {
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    }
  }

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
      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryGold));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppTheme.primaryGold,
      child: _bookings.isEmpty
        ? ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              const Center(child: Text('Không có đơn đặt phòng nào.', style: TextStyle(color: Colors.grey, fontSize: 16))),
            ],
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _bookings.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final booking = _bookings[index];
              
              Color statusColor;
              switch (booking.status.name) {
                case 'booked': statusColor = Colors.blue; break;
                case 'checkedIn': statusColor = Colors.green; break;
                case 'checkedOut': statusColor = Colors.grey; break;
                case 'cancelled': statusColor = Colors.red; break;
                default: statusColor = Colors.blue;
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(booking.customerName ?? 'Khách', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
                            child: Text(booking.statusText, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    // Body
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.bgGray,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              children: [
                                Text(booking.roomNumber ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.darkBlue)),
                                Text(booking.roomTypeName ?? '', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.login, size: 16, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text('Vào: ${booking.checkInDate}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.logout, size: 16, color: Colors.red),
                                    const SizedBox(width: 4),
                                    Text('Ra: ${booking.checkOutDate}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tổng: ${_formatVND(booking.totalAmount.toInt())}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGold, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Actions
                    if (booking.status == BookingStatus.booked || booking.status == BookingStatus.checkedIn)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey[200]!)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (booking.status == BookingStatus.booked) ...[
                              TextButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Hủy đặt phòng'),
                                      content: const Text('Bạn có chắc muốn hủy đơn đặt phòng này?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Không')),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await DatabaseHelper.instance.updateBookingStatus(booking.id!, BookingStatus.cancelled);
                                            _loadData();
                                          },
                                          child: const Text('Hủy phòng', style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text('Hủy', style: TextStyle(color: Colors.red)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                onPressed: () async {
                                  await DatabaseHelper.instance.checkIn(booking.id!, booking.roomId);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã nhận phòng thành công!')));
                                  _loadData();
                                },
                                child: const Text('Nhận phòng', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                            if (booking.status == BookingStatus.checkedIn)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGold),
                                onPressed: () async {
                                  await Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen(booking: booking)));
                                  _loadData();
                                },
                                child: const Text('Trả phòng & Thanh toán', style: TextStyle(color: Colors.white)),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
