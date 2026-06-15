import 'package:flutter/material.dart';
import '../main.dart';
import '../models/invoice.dart';
import '../database/database_helper.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  List<Invoice> _invoices = [];
  bool _isLoading = true;
  double _totalRevenue = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final invoices = await DatabaseHelper.instance.getAllInvoices();
    double total = 0;
    for (var inv in invoices) {
      total += inv.totalAmount;
    }
    
    if (mounted) {
      setState(() {
        _invoices = invoices;
        _totalRevenue = total;
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

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final date = DateTime.parse(isoString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString.split('T')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text('LỊCH SỬ HÓA ĐƠN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng doanh thu', style: TextStyle(fontSize: 18, color: AppTheme.darkBlue, fontWeight: FontWeight.bold)),
                Text(
                  _formatVND(_totalRevenue.toInt()),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryGold),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryGold))
              : RefreshIndicator(
                  onRefresh: _loadData,
                  color: AppTheme.primaryGold,
                  child: _invoices.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                          const Center(child: Text('Chưa có hóa đơn nào.', style: TextStyle(color: Colors.grey, fontSize: 16))),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _invoices.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final invoice = _invoices[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Mã HĐ: HD-${invoice.id.toString().padLeft(4, '0')}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppTheme.cream,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          invoice.paymentMethodText,
                                          style: const TextStyle(color: AppTheme.darkBlue, fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.person_outline, size: 20, color: AppTheme.darkBlue),
                                      const SizedBox(width: 8),
                                      Text(invoice.customerName ?? 'Khách lẻ', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.meeting_room_outlined, size: 20, color: AppTheme.darkBlue),
                                      const SizedBox(width: 8),
                                      Text('Phòng: ${invoice.roomNumber ?? 'N/A'}'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today_outlined, size: 20, color: AppTheme.darkBlue),
                                      const SizedBox(width: 8),
                                      Text('${invoice.checkInDate} - ${invoice.checkOutDate}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 20, color: AppTheme.darkBlue),
                                      const SizedBox(width: 8),
                                      Text('Thanh toán: ${_formatDate(invoice.paidAt)}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text('Tổng cộng: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(
                                        _formatVND(invoice.totalAmount.toInt()),
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                ),
          ),
        ],
      ),
    );
  }
}
