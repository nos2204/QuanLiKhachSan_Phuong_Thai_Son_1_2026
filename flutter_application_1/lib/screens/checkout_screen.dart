import 'package:flutter/material.dart';
import '../main.dart';
import '../models/booking.dart';
import '../database/database_helper.dart';

// Man hinh Tra phong va Thanh toan
class CheckoutScreen extends StatefulWidget {
  final Booking booking;
  const CheckoutScreen({super.key, required this.booking});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = 'cash';
  bool _isProcessing = false;

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

  // Ham xu ly tra phong, goi DatabaseHelper de cap nhat trang thai va luu Hoa don
  Future<void> _processCheckout() async {
    setState(() => _isProcessing = true);
    
    try {
      await DatabaseHelper.instance.checkOut(
        widget.booking.id!,
        widget.booking.roomId,
        widget.booking.totalAmount,
        _paymentMethod,
      );
      
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Thành công'),
              ],
            ),
            content: const Text('Đã trả phòng và lưu hóa đơn thành công!'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.darkBlue),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // close checkout screen
                },
                child: const Text('Hoàn tất', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text('TRẢ PHÒNG & THANH TOÁN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Receipt Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text('HÓA ĐƠN THANH TOÁN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkBlue)),
                  ),
                  const SizedBox(height: 24),
                  
                  // Customer Info
                  const Text('Khách hàng', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(widget.booking.customerName ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  
                  // Room Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Số phòng', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(widget.booking.roomNumber ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Loại phòng', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(widget.booking.roomTypeName ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Dates
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nhận phòng', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(widget.booking.checkInDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Trả phòng', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(widget.booking.checkOutDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(thickness: 2, color: Colors.grey),
                  ),
                  
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TỔNG CỘNG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(
                        _formatVND(widget.booking.totalAmount.toInt()),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppTheme.primaryGold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Nut bam chon phuong thuc thanh toan
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Phương thức thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PaymentMethodCard(
                    icon: Icons.money,
                    title: 'Tiền mặt',
                    isSelected: _paymentMethod == 'cash',
                    onTap: () => setState(() => _paymentMethod = 'cash'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PaymentMethodCard(
                    icon: Icons.credit_card,
                    title: 'Thẻ',
                    isSelected: _paymentMethod == 'card',
                    onTap: () => setState(() => _paymentMethod = 'card'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PaymentMethodCard(
                    icon: Icons.account_balance,
                    title: 'Chuyển khoản',
                    isSelected: _paymentMethod == 'transfer',
                    onTap: () => setState(() => _paymentMethod = 'transfer'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            if (_paymentMethod == 'transfer') ...[
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryGold, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('Quét mã QR để thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.darkBlue)),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://img.vietqr.io/image/MB-0855670748-compact.png?amount=${widget.booking.totalAmount.toInt()}&addInfo=Thanh%20toan%20phong%20${widget.booking.roomNumber}&accountName=NGUYEN%20VIET%20THAI',
                        height: 280,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: const Text('Không thể tải mã QR.\nVui lòng kiểm tra mạng.', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Chủ tài khoản: NGUYEN VIET THAI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const Text('Số tài khoản: 0855670748', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const Text('Ngân hàng: MB Bank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Nut bam Xac nhan thanh toan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isProcessing ? null : _processCheckout,
                child: _isProcessing 
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('XÁC NHẬN THANH TOÁN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({required this.icon, required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.darkBlue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.darkBlue : Colors.grey[300]!, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppTheme.darkBlue : Colors.grey, size: 32),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: isSelected ? AppTheme.darkBlue : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
