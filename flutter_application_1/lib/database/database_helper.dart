import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/room_type.dart';
import '../models/room.dart';
import '../models/customer.dart';
import '../models/booking.dart';
import '../models/invoice.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hotel_management.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Create room_types table
    await db.execute('''
      CREATE TABLE room_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        base_price REAL NOT NULL,
        description TEXT DEFAULT ''
      )
    ''');

    // Create rooms table
    await db.execute('''
      CREATE TABLE rooms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        room_number TEXT NOT NULL UNIQUE,
        room_type_id INTEGER NOT NULL,
        floor INTEGER NOT NULL,
        status TEXT NOT NULL DEFAULT 'available',
        description TEXT DEFAULT '',
        FOREIGN KEY (room_type_id) REFERENCES room_types(id)
      )
    ''');

    // Create customers table
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        phone TEXT NOT NULL,
        id_card TEXT NOT NULL UNIQUE,
        email TEXT DEFAULT '',
        address TEXT DEFAULT '',
        created_at TEXT NOT NULL
      )
    ''');

    // Create bookings table
    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        room_id INTEGER NOT NULL,
        check_in_date TEXT NOT NULL,
        check_out_date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'booked',
        total_amount REAL NOT NULL,
        note TEXT DEFAULT '',
        created_at TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES customers(id),
        FOREIGN KEY (room_id) REFERENCES rooms(id)
      )
    ''');

    // Create invoices table
    await db.execute('''
      CREATE TABLE invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        booking_id INTEGER NOT NULL,
        total_amount REAL NOT NULL,
        payment_method TEXT NOT NULL DEFAULT 'cash',
        paid_at TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (booking_id) REFERENCES bookings(id)
      )
    ''');

    // Seed room types
    await db.insert('room_types', {'name': 'Standard', 'base_price': 500000, 'description': 'Phòng tiêu chuẩn, đầy đủ tiện nghi cơ bản'});
    await db.insert('room_types', {'name': 'Deluxe', 'base_price': 800000, 'description': 'Phòng cao cấp, view đẹp, tiện nghi hiện đại'});
    await db.insert('room_types', {'name': 'VIP', 'base_price': 1500000, 'description': 'Phòng VIP, không gian rộng rãi, dịch vụ đặc biệt'});
    await db.insert('room_types', {'name': 'Suite', 'base_price': 3000000, 'description': 'Phòng Suite, đẳng cấp 5 sao, phòng khách riêng'});

    // Seed sample rooms
    final rooms = [
      {'room_number': 'P101', 'room_type_id': 1, 'floor': 1, 'status': 'available', 'description': ''},
      {'room_number': 'P102', 'room_type_id': 1, 'floor': 1, 'status': 'available', 'description': ''},
      {'room_number': 'P103', 'room_type_id': 2, 'floor': 1, 'status': 'available', 'description': ''},
      {'room_number': 'P201', 'room_type_id': 2, 'floor': 2, 'status': 'available', 'description': ''},
      {'room_number': 'P202', 'room_type_id': 2, 'floor': 2, 'status': 'available', 'description': ''},
      {'room_number': 'P203', 'room_type_id': 3, 'floor': 2, 'status': 'available', 'description': ''},
      {'room_number': 'P301', 'room_type_id': 3, 'floor': 3, 'status': 'available', 'description': ''},
      {'room_number': 'P302', 'room_type_id': 4, 'floor': 3, 'status': 'available', 'description': ''},
      {'room_number': 'P303', 'room_type_id': 4, 'floor': 3, 'status': 'maintenance', 'description': 'Đang sửa chữa'},
      {'room_number': 'P401', 'room_type_id': 4, 'floor': 4, 'status': 'available', 'description': 'Penthouse'},
    ];
    for (final room in rooms) {
      await db.insert('rooms', room);
    }

    // Seed sample customers
    final now = DateTime.now().toIso8601String();
    await db.insert('customers', {'full_name': 'Nguyễn Văn A', 'phone': '0901234567', 'id_card': '001234567890', 'email': 'nguyenvana@gmail.com', 'address': 'Hà Nội', 'created_at': now});
    await db.insert('customers', {'full_name': 'Trần Thị B', 'phone': '0912345678', 'id_card': '002345678901', 'email': 'tranthib@gmail.com', 'address': 'TP.HCM', 'created_at': now});
    await db.insert('customers', {'full_name': 'Lê Hoàng C', 'phone': '0923456789', 'id_card': '003456789012', 'email': '', 'address': 'Đà Nẵng', 'created_at': now});
  }

  // ── ROOM TYPES ─────────────────────────────────────
  Future<List<RoomType>> getAllRoomTypes() async {
    final db = await database;
    final result = await db.query('room_types');
    return result.map((map) => RoomType.fromMap(map)).toList();
  }

  // ── ROOMS ──────────────────────────────────────────
  Future<List<Room>> getAllRooms() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT r.*, rt.name as type_name, rt.base_price
      FROM rooms r
      LEFT JOIN room_types rt ON r.room_type_id = rt.id
      ORDER BY r.room_number
    ''');
    return result.map((map) => Room.fromMap(map)).toList();
  }

  Future<List<Room>> getAvailableRooms() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT r.*, rt.name as type_name, rt.base_price
      FROM rooms r
      LEFT JOIN room_types rt ON r.room_type_id = rt.id
      WHERE r.status = 'available'
      ORDER BY r.room_number
    ''');
    return result.map((map) => Room.fromMap(map)).toList();
  }

  Future<List<Room>> getRoomsByStatus(String status) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT r.*, rt.name as type_name, rt.base_price
      FROM rooms r
      LEFT JOIN room_types rt ON r.room_type_id = rt.id
      WHERE r.status = ?
      ORDER BY r.room_number
    ''', [status]);
    return result.map((map) => Room.fromMap(map)).toList();
  }

  Future<int> insertRoom(Room room) async {
    final db = await database;
    return await db.insert('rooms', room.toMap()..remove('id'));
  }

  Future<int> updateRoom(Room room) async {
    final db = await database;
    return await db.update('rooms', room.toMap()..remove('id'), where: 'id = ?', whereArgs: [room.id]);
  }

  Future<int> updateRoomStatus(int roomId, RoomStatus status) async {
    final db = await database;
    return await db.update('rooms', {'status': status.name}, where: 'id = ?', whereArgs: [roomId]);
  }

  Future<int> deleteRoom(int id) async {
    final db = await database;
    return await db.delete('rooms', where: 'id = ?', whereArgs: [id]);
  }

  // ── CUSTOMERS ──────────────────────────────────────
  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final result = await db.query('customers', orderBy: 'full_name');
    return result.map((map) => Customer.fromMap(map)).toList();
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final db = await database;
    final result = await db.query('customers',
      where: 'full_name LIKE ? OR phone LIKE ? OR id_card LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'full_name',
    );
    return result.map((map) => Customer.fromMap(map)).toList();
  }

  Future<int> insertCustomer(Customer customer) async {
    final db = await database;
    return await db.insert('customers', customer.toMap()..remove('id'));
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await database;
    return await db.update('customers', customer.toMap()..remove('id'), where: 'id = ?', whereArgs: [customer.id]);
  }

  Future<int> deleteCustomer(int id) async {
    final db = await database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  // ── BOOKINGS ───────────────────────────────────────
  Future<List<Booking>> getAllBookings({String? statusFilter}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];
    if (statusFilter != null && statusFilter.isNotEmpty) {
      whereClause = 'WHERE b.status = ?';
      whereArgs = [statusFilter];
    }
    final result = await db.rawQuery('''
      SELECT b.*, c.full_name as customer_name, c.phone as customer_phone, c.id_card as customer_id_card,
             r.room_number, rt.name as type_name, rt.base_price
      FROM bookings b
      LEFT JOIN customers c ON b.customer_id = c.id
      LEFT JOIN rooms r ON b.room_id = r.id
      LEFT JOIN room_types rt ON r.room_type_id = rt.id
      $whereClause
      ORDER BY b.created_at DESC
    ''', whereArgs);
    return result.map((map) => Booking.fromMap(map)).toList();
  }

  Future<Booking?> getBookingById(int id) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT b.*, c.full_name as customer_name, c.phone as customer_phone, c.id_card as customer_id_card,
             r.room_number, rt.name as type_name, rt.base_price
      FROM bookings b
      LEFT JOIN customers c ON b.customer_id = c.id
      LEFT JOIN rooms r ON b.room_id = r.id
      LEFT JOIN room_types rt ON r.room_type_id = rt.id
      WHERE b.id = ?
    ''', [id]);
    if (result.isEmpty) return null;
    return Booking.fromMap(result.first);
  }

  Future<int> insertBooking(Booking booking) async {
    final db = await database;
    return await db.insert('bookings', booking.toMap()..remove('id'));
  }

  Future<int> updateBookingStatus(int bookingId, BookingStatus status) async {
    final db = await database;
    return await db.update('bookings', {'status': status.name}, where: 'id = ?', whereArgs: [bookingId]);
  }

  Future<int> updateBooking(Booking booking) async {
    final db = await database;
    return await db.update('bookings', booking.toMap()..remove('id'), where: 'id = ?', whereArgs: [booking.id]);
  }

  // Check-in: update booking status + room status
  Future<void> checkIn(int bookingId, int roomId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update('bookings', {'status': BookingStatus.checkedIn.name}, where: 'id = ?', whereArgs: [bookingId]);
      await txn.update('rooms', {'status': RoomStatus.occupied.name}, where: 'id = ?', whereArgs: [roomId]);
    });
  }

  // Check-out: update booking + room + create invoice
  Future<int> checkOut(int bookingId, int roomId, double totalAmount, String paymentMethod) async {
    final db = await database;
    int invoiceId = 0;
    final now = DateTime.now().toIso8601String();
    await db.transaction((txn) async {
      await txn.update('bookings', {'status': BookingStatus.checkedOut.name, 'check_out_date': now.substring(0, 10)}, where: 'id = ?', whereArgs: [bookingId]);
      await txn.update('rooms', {'status': RoomStatus.available.name}, where: 'id = ?', whereArgs: [roomId]);
      invoiceId = await txn.insert('invoices', {
        'booking_id': bookingId,
        'total_amount': totalAmount,
        'payment_method': paymentMethod,
        'paid_at': now,
        'created_at': now,
      });
    });
    return invoiceId;
  }

  // ── INVOICES ───────────────────────────────────────
  Future<List<Invoice>> getAllInvoices() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT i.*, c.full_name as customer_name, r.room_number,
             b.check_in_date, b.check_out_date
      FROM invoices i
      LEFT JOIN bookings b ON i.booking_id = b.id
      LEFT JOIN customers c ON b.customer_id = c.id
      LEFT JOIN rooms r ON b.room_id = r.id
      ORDER BY i.created_at DESC
    ''');
    return result.map((map) => Invoice.fromMap(map)).toList();
  }

  // ── STATISTICS ─────────────────────────────────────
  Future<Map<String, dynamic>> getDashboardStats() async {
    final db = await database;
    
    final totalRooms = (await db.rawQuery('SELECT COUNT(*) as count FROM rooms')).first['count'] as int;
    final availableRooms = (await db.rawQuery("SELECT COUNT(*) as count FROM rooms WHERE status = 'available'")).first['count'] as int;
    final occupiedRooms = (await db.rawQuery("SELECT COUNT(*) as count FROM rooms WHERE status = 'occupied'")).first['count'] as int;
    final maintenanceRooms = (await db.rawQuery("SELECT COUNT(*) as count FROM rooms WHERE status = 'maintenance'")).first['count'] as int;
    final totalCustomers = (await db.rawQuery('SELECT COUNT(*) as count FROM customers')).first['count'] as int;
    final activeBookings = (await db.rawQuery("SELECT COUNT(*) as count FROM bookings WHERE status = 'checkedIn'")).first['count'] as int;
    final revenueResult = await db.rawQuery('SELECT COALESCE(SUM(total_amount), 0) as total FROM invoices');
    final totalRevenue = (revenueResult.first['total'] as num).toDouble();
    
    return {
      'totalRooms': totalRooms,
      'availableRooms': availableRooms,
      'occupiedRooms': occupiedRooms,
      'maintenanceRooms': maintenanceRooms,
      'totalCustomers': totalCustomers,
      'activeBookings': activeBookings,
      'totalRevenue': totalRevenue,
    };
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}
