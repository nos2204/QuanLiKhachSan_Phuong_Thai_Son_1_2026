import '../customer.dart'; // Đảm bảo đường dẫn này trỏ đúng về file customer.dart của bạn
import 'generic_repository.dart';

// 1. Định nghĩa đối tượng thứ hai: Phòng khách sạn (Để làm bài tập lớn)
class Room {
  final int roomNo;       // Kiểu thuộc tính: Số nguyên (int)
  final String type;      // Kiểu thuộc tính: Chuỗi (String)
  final bool isCleaned;   // Kiểu thuộc tính: Logic (bool)

  Room({required this.roomNo, required this.type, required this.isCleaned});
}

class CustomerRepository extends GenericRepository<Customer> {
  
  List<String> getValidCustomerContacts() {
    final allCustomers = getAll(); 
    
    
    return allCustomers
        .where((customer) => customer.isValid())
        .map((customer) => " Gửi tới: ${customer.fullName} (${customer.phoneNumber}) - Đủ điều kiện nhận ưu đãi tuổi ${customer.age}")
        .toList();
  }
}

class RoomRepository extends GenericRepository<Room> {
  
  Map<String, dynamic> getRoomStatusDashboard() {
    final allRooms = getAll();
    final dirtyRooms = allRooms.where((room) => !room.isCleaned).map((r) => r.roomNo).toList();
    final cleanRoomsCount = allRooms.length - dirtyRooms.length;

    return {
      'totalRooms': allRooms.length,
      'availableCleanRooms': cleanRoomsCount,
      'alertUrgentCleanList': dirtyRooms,
    };
  }
}