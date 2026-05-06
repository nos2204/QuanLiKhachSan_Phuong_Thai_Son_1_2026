import 'package:flutter/material.dart';
import '../main.dart'; // AppTheme, Customer

class HotelManagementScreen extends StatefulWidget {
  const HotelManagementScreen({super.key});

  @override
  State<HotelManagementScreen> createState() => _HotelManagementScreenState();
}

class _HotelManagementScreenState extends State<HotelManagementScreen> {
  final List<Customer> _customerList = [
    Customer(name: 'Nguyễn Hoàng Sơn', id: '001xxx', roomAssigned: 'P102', price: 850000),
    Customer(name: 'Trần Văn Thái',     id: '002xxx', roomAssigned: 'P205', price: 1200000),
    Customer(name: 'Nguyễn Minh Phương',id: '003xxx', roomAssigned: 'P310', price: 650000),
  ];

  final List<String> _roomImages = [
    'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=200&q=80',
    'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=200&q=80',
    'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=200&q=80',
    'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=200&q=80',
    'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=200&q=80',
  ];

  final TextEditingController _nameController  = TextEditingController();
  final TextEditingController _idController    = TextEditingController();
  final TextEditingController _roomController  = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // ── Format VNĐ ────────────────────────────────────────────
  String _formatVND(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buf.write('.');
      buf.write(s[i]);
      count++;
    }
    return '${buf.toString().split('').reversed.join()} ₫';
  }

  int get _tongTien => _customerList.fold(0, (sum, c) => sum + c.price);

  void _showAddCustomerDialog() {
    _nameController.clear();
    _idController.clear();
    _roomController.clear();
    _priceController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Thêm Khách Hàng',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
              color: AppTheme.darkBlue),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_nameController,  'Tên khách',            Icons.person_outline),
            const SizedBox(height: 12),
            _buildTextField(_idController,    'Số CCCD',              Icons.badge_outlined),
            const SizedBox(height: 12),
            _buildTextField(_roomController,  'Số phòng (VD: P201)',  Icons.door_front_door_outlined),
            const SizedBox(height: 12),
            _buildTextField(_priceController, 'Giá phòng (₫/đêm)',   Icons.payments_outlined,
                inputType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.darkBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                final price = int.tryParse(
                  _priceController.text.replaceAll('.', '').replaceAll(',', ''),
                ) ?? 850000;
                setState(() {
                  _customerList.add(Customer(
                    name:         _nameController.text,
                    id:           _idController.text,
                    roomAssigned: _roomController.text,
                    price:        price,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon,
      {TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.darkBlue),
        prefixIcon: Icon(icon, size: 20, color: AppTheme.darkBlue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.darkBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      // ── AppBar ────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'DANH SÁCH THUÊ PHÒNG',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.2),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${_customerList.length} khách',
                  style: const TextStyle(color: Colors.white, fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Body ──────────────────────────────────────────────
      body: Column(
        children: [
          // Banner tổng tiền
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppTheme.darkBlue,
            child: Row(
              children: [
                const Icon(Icons.payments_outlined, size: 18, color: AppTheme.darkBlue),
                const SizedBox(width: 8),
                const Text('Tổng doanh thu:',
                    style: TextStyle(fontSize: 13, color: AppTheme.darkBlue)),
                const Spacer(),
                Text(
                  _formatVND(_tongTien),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkBlue,
                  ),
                ),
              ],
            ),
          ),

          // Danh sách
          Expanded(
            child: _customerList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hotel_outlined, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('Chưa có khách nào',
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade400)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    itemCount: _customerList.length,
                    itemBuilder: (context, index) {
                      final c = _customerList[index];
                      return _CustomerCard(
                        customer:  c,
                        imageUrl:  _roomImages[index % _roomImages.length],
                        formatVND: _formatVND,
                        onDelete:  () => setState(() => _customerList.removeAt(index)),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ── FAB ───────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.darkBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: _showAddCustomerDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Card khách hàng ───────────────────────────────────────────
class _CustomerCard extends StatelessWidget {
  final Customer customer;
  final String imageUrl;
  final String Function(int) formatVND;
  final VoidCallback onDelete;

  const _CustomerCard({
    required this.customer,
    required this.imageUrl,
    required this.formatVND,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black,
              blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // ── Ảnh phòng ────────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: Image.network(
              imageUrl,
              width: 100, height: 100, fit: BoxFit.cover,
              loadingBuilder: (ctx, child, prog) {
                if (prog == null) return child;
                return Container(
                  width: 100, height: 100, color: const Color(0xFFE8EDF5),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.darkBlue),
                  ),
                );
              },
              errorBuilder: (ctx, e, s) => Container(
                width: 100, height: 100, color: const Color(0xFFE8EDF5),
                child: const Icon(Icons.hotel, size: 36, color: AppTheme.darkBlue),
              ),
            ),
          ),

          // ── Thông tin ─────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên
                  Text(customer.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                          color: AppTheme.darkBlue)),
                  const SizedBox(height: 4),

                  // CCCD
                  Row(children: [
                    const Icon(Icons.badge_outlined, size: 14, color: Color(0xFF444444)),
                    const SizedBox(width: 4),
                    Text('CCCD: ${customer.id}',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF444444),
                            fontWeight: FontWeight.w500)),
                  ]),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      // Pill phòng
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppTheme.primaryGold),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.door_front_door_outlined,
                              size: 13, color: AppTheme.primaryGold),
                          const SizedBox(width: 5),
                          Text('Phòng ${customer.roomAssigned}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                  color: Color(0xFFB8941F))),
                        ]),
                      ),
                      const SizedBox(width: 8),

                      // Pill giá phòng
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFA5D6A7)),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.payments_outlined,
                              size: 13, color: Color(0xFF2E7D32)),
                          const SizedBox(width: 5),
                          Text(formatVND(customer.price),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32))),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Xóa ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}