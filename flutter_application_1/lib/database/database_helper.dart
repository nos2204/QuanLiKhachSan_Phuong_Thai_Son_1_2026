import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/app_user.dart';
import '../models/room_type.dart';
import '../models/room.dart';
import '../models/customer.dart';
import '../models/booking.dart';
import '../models/invoice.dart';
import '../models/change_request.dart';

// Lop quan ly Database dung mau Singleton de dam bao chi co 1 ket noi DB
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hotel_management.db');
    await _createAuthAndApprovalTables(_database!);
    return _database!;
  }

  // Khoi tao va mo ket noi toi file SQLite
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createAuthAndApprovalTables(db);
    }
  }

  // Tao cac bang (tables) khi database duoc khoi tao lan dau tien
  Future _createDB(Database db, int version) async {
    // Tao bang loai phong (room_types)
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
    await db.insert('room_types', {
      'name': 'Standard',
      'base_price': 500000,
      'description': 'Phòng tiêu chuẩn, đầy đủ tiện nghi cơ bản',
    });
    await db.insert('room_types', {
      'name': 'Deluxe',
      'base_price': 800000,
      'description': 'Phòng cao cấp, view đẹp, tiện nghi hiện đại',
    });
    await db.insert('room_types', {
      'name': 'VIP',
      'base_price': 1500000,
      'description': 'Phòng VIP, không gian rộng rãi, dịch vụ đặc biệt',
    });
    await db.insert('room_types', {
      'name': 'Suite',
      'base_price': 3000000,
      'description': 'Phòng Suite, đẳng cấp 5 sao, phòng khách riêng',
    });

    // Seed sample rooms
    final rooms = [
      {
        'room_number': 'P101',
        'room_type_id': 1,
        'floor': 1,
        'status': 'available',
        'description': '',
      },
      {
        'room_number': 'P102',
        'room_type_id': 1,
        'floor': 1,
        'status': 'available',
        'description': '',
      },
      {
        'room_number': 'P103',
        'room_type_id': 2,
        'floor': 1,
        'status': 'available',
        'description': '',
      },
      {
        'room_number': 'P201',
        'room_type_id': 2,
        'floor': 2,
        'status': 'available',
        'description': '',
      },
      {
        'room_number': 'P202',
        'room_type_id': 2,
        'floor': 2,
        'status': 'available',
        'description': '',
      },
      {
        'room_number': 'P203',
        'room_type_id': 3,
        'floor': 2,
        'status': 'available',
        'description': '',
      },
      {
        'room_number': 'P301',
        'room_type_id': 3,
        'floor': 3,
        'status': 'available',
        'description': '',
      },
      {
        'room_number': 'P302',
        'room_type_id': 4,
        'floor': 3,
        'status': 'available',
        'description': '',
      },
      {
        'room_number': 'P303',
        'room_type_id': 4,
        'floor': 3,
        'status': 'maintenance',
        'description': 'Đang sửa chữa',
      },
      {
        'room_number': 'P401',
        'room_type_id': 4,
        'floor': 4,
        'status': 'available',
        'description': 'Penthouse',
      },
    ];
    for (final room in rooms) {
      await db.insert('rooms', room);
    }

    // Seed sample customers
    final now = DateTime.now().toIso8601String();
    await db.insert('customers', {
      'full_name': 'Nguyễn Văn A',
      'phone': '0901234567',
      'id_card': '001234567890',
      'email': 'nguyenvana@gmail.com',
      'address': 'Hà Nội',
      'created_at': now,
    });
    await db.insert('customers', {
      'full_name': 'Trần Thị B',
      'phone': '0912345678',
      'id_card': '002345678901',
      'email': 'tranthib@gmail.com',
      'address': 'TP.HCM',
      'created_at': now,
    });
    await db.insert('customers', {
      'full_name': 'Lê Hoàng C',
      'phone': '0923456789',
      'id_card': '003456789012',
      'email': '',
      'address': 'Đà Nẵng',
      'created_at': now,
    });
  }

  // ── ROOM TYPES ─────────────────────────────────────
  Future<void> _createAuthAndApprovalTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL,
        role TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS change_requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type TEXT NOT NULL,
        action TEXT NOT NULL,
        entity_id INTEGER,
        payload TEXT NOT NULL,
        requested_by INTEGER NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        note TEXT DEFAULT '',
        admin_note TEXT DEFAULT '',
        created_at TEXT NOT NULL,
        resolved_at TEXT,
        FOREIGN KEY (requested_by) REFERENCES users(id)
      )
    ''');

    final adminCountResult = await db.rawQuery(
      "SELECT COUNT(*) as count FROM users WHERE role = 'admin'",
    );
    final adminCount = adminCountResult.first['count'] as int;
    if (adminCount == 0) {
      await db.insert('users', {
        'username': 'admin',
        'password': 'admin123',
        'full_name': 'Quan tri vien',
        'role': AppUserRole.admin.name,
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // AUTH AND USERS
  Future<AppUser?> login(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ? AND is_active = 1',
      whereArgs: [username.trim(), password],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return AppUser.fromMap(result.first);
  }

  Future<List<AppUser>> getEmployeeUsers() async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'role = ?',
      whereArgs: [AppUserRole.staff.name],
      orderBy: 'full_name',
    );
    return result.map((map) => AppUser.fromMap(map)).toList();
  }

  Future<int> insertEmployeeUser({
    required String username,
    required String password,
    required String fullName,
  }) async {
    final db = await database;
    return await db.insert('users', {
      'username': username.trim(),
      'password': password,
      'full_name': fullName.trim(),
      'role': AppUserRole.staff.name,
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> updateEmployeeUser(AppUser user, {String? password}) async {
    final db = await database;
    final values = user.toMap()
      ..remove('id')
      ..remove('created_at');
    if (password != null && password.isNotEmpty) {
      values['password'] = password;
    }
    return await db.update(
      'users',
      values,
      where: 'id = ? AND role = ?',
      whereArgs: [user.id, AppUserRole.staff.name],
    );
  }

  Future<int> deleteEmployeeUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ? AND role = ?',
      whereArgs: [id, AppUserRole.staff.name],
    );
  }

  Future<List<RoomType>> getAllRoomTypes() async {
    final db = await database;
    final result = await db.query('room_types');
    return result.map((map) => RoomType.fromMap(map)).toList();
  }

  Future<int> insertRoomType(RoomType type) async {
    final db = await database;
    return await db.insert('room_types', type.toMap()..remove('id'));
  }

  Future<int> updateRoomType(RoomType type) async {
    final db = await database;
    return await db.update(
      'room_types',
      type.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [type.id],
    );
  }

  Future<int> deleteRoomType(int id) async {
    final db = await database;
    final roomsCountResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM rooms WHERE room_type_id = ?',
      [id],
    );
    final count = roomsCountResult.first['count'] as int;
    if (count > 0) {
      throw Exception(
        'Không thể xóa loại phòng này vì đang có phòng sử dụng nó.',
      );
    }
    return await db.delete('room_types', where: 'id = ?', whereArgs: [id]);
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
    final result = await db.rawQuery(
      '''
      SELECT r.*, rt.name as type_name, rt.base_price
      FROM rooms r
      LEFT JOIN room_types rt ON r.room_type_id = rt.id
      WHERE r.status = ?
      ORDER BY r.room_number
    ''',
      [status],
    );
    return result.map((map) => Room.fromMap(map)).toList();
  }

  Future<int> insertRoom(Room room) async {
    final db = await database;
    return await db.insert('rooms', room.toMap()..remove('id'));
  }

  Future<int> updateRoom(Room room) async {
    final db = await database;
    return await db.update(
      'rooms',
      room.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [room.id],
    );
  }

  Future<int> updateRoomStatus(int roomId, RoomStatus status) async {
    final db = await database;
    return await db.update(
      'rooms',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [roomId],
    );
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
    final result = await db.query(
      'customers',
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
    return await db.update(
      'customers',
      customer.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
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
    final result = await db.rawQuery(
      '''
      SELECT b.*, c.full_name as customer_name, c.phone as customer_phone, c.id_card as customer_id_card,
             r.room_number, rt.name as type_name, rt.base_price
      FROM bookings b
      LEFT JOIN customers c ON b.customer_id = c.id
      LEFT JOIN rooms r ON b.room_id = r.id
      LEFT JOIN room_types rt ON r.room_type_id = rt.id
      WHERE b.id = ?
    ''',
      [id],
    );
    if (result.isEmpty) return null;
    return Booking.fromMap(result.first);
  }

  Future<int> insertBooking(Booking booking) async {
    final db = await database;
    return await db.insert('bookings', booking.toMap()..remove('id'));
  }

  Future<int> updateBookingStatus(int bookingId, BookingStatus status) async {
    final db = await database;
    return await db.update(
      'bookings',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [bookingId],
    );
  }

  Future<int> updateBooking(Booking booking) async {
    final db = await database;
    return await db.update(
      'bookings',
      booking.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [booking.id],
    );
  }

  // Xu ly nhan phong (Check-in): Cap nhat trang thai dat phong va trang thai phong bang Transaction
  Future<void> checkIn(int bookingId, int roomId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update(
        'bookings',
        {'status': BookingStatus.checkedIn.name},
        where: 'id = ?',
        whereArgs: [bookingId],
      );
      await txn.update(
        'rooms',
        {'status': RoomStatus.occupied.name},
        where: 'id = ?',
        whereArgs: [roomId],
      );
    });
  }

  // Xu ly tra phong (Check-out): Cap nhat trang thai, giai phong phong va tao hoa don (Invoice) bang Transaction
  Future<int> checkOut(
    int bookingId,
    int roomId,
    double totalAmount,
    String paymentMethod,
  ) async {
    final db = await database;
    int invoiceId = 0;
    final now = DateTime.now().toIso8601String();
    await db.transaction((txn) async {
      await txn.update(
        'bookings',
        {
          'status': BookingStatus.checkedOut.name,
          'check_out_date': now.substring(0, 10),
        },
        where: 'id = ?',
        whereArgs: [bookingId],
      );
      await txn.update(
        'rooms',
        {'status': RoomStatus.available.name},
        where: 'id = ?',
        whereArgs: [roomId],
      );
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

  // Lay so lieu thong ke tong quan cho man hinh Dashboard
  Future<Map<String, dynamic>> getDashboardStats() async {
    final db = await database;

    final totalRooms =
        (await db.rawQuery(
              'SELECT COUNT(*) as count FROM rooms',
            )).first['count']
            as int;
    final availableRooms =
        (await db.rawQuery(
              "SELECT COUNT(*) as count FROM rooms WHERE status = 'available'",
            )).first['count']
            as int;
    final occupiedRooms =
        (await db.rawQuery(
              "SELECT COUNT(*) as count FROM rooms WHERE status = 'occupied'",
            )).first['count']
            as int;
    final maintenanceRooms =
        (await db.rawQuery(
              "SELECT COUNT(*) as count FROM rooms WHERE status = 'maintenance'",
            )).first['count']
            as int;
    final totalCustomers =
        (await db.rawQuery(
              'SELECT COUNT(*) as count FROM customers',
            )).first['count']
            as int;
    final activeBookings =
        (await db.rawQuery(
              "SELECT COUNT(*) as count FROM bookings WHERE status = 'checkedIn'",
            )).first['count']
            as int;
    final revenueResult = await db.rawQuery(
      'SELECT COALESCE(SUM(total_amount), 0) as total FROM invoices',
    );
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

  // Lay du lieu doanh thu 7 ngay gan nhat de ve bieu do
  Future<List<Map<String, dynamic>>> getRevenueLast7Days() async {
    final db = await database;
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 6));
    final startDateStr = sevenDaysAgo.toIso8601String().substring(0, 10);

    final result = await db.rawQuery(
      '''
      SELECT substr(paid_at, 1, 10) as date, SUM(total_amount) as total
      FROM invoices
      WHERE substr(paid_at, 1, 10) >= ?
      GROUP BY substr(paid_at, 1, 10)
      ORDER BY date ASC
    ''',
      [startDateStr],
    );

    List<Map<String, dynamic>> finalData = [];
    for (int i = 0; i < 7; i++) {
      final date = sevenDaysAgo.add(Duration(days: i));
      final dateStr = date.toIso8601String().substring(0, 10);

      final row = result.firstWhere(
        (element) => element['date'] == dateStr,
        orElse: () => {'date': dateStr, 'total': 0.0},
      );
      finalData.add({
        'date': dateStr,
        'dayLabel': '${date.day}/${date.month}',
        'total': (row['total'] as num).toDouble(),
      });
    }
    return finalData;
  }

  // CHANGE REQUESTS
  Future<int> createChangeRequest({
    required ChangeEntityType entityType,
    required ChangeAction action,
    int? entityId,
    required Map<String, dynamic> payload,
    required int requestedBy,
    String note = '',
  }) async {
    final db = await database;
    return await db.insert('change_requests', {
      'entity_type': changeEntityTypeToDb(entityType),
      'action': action.name,
      'entity_id': entityId,
      'payload': jsonEncode(payload),
      'requested_by': requestedBy,
      'status': ChangeRequestStatus.pending.name,
      'note': note,
      'admin_note': '',
      'created_at': DateTime.now().toIso8601String(),
      'resolved_at': null,
    });
  }

  Future<List<ChangeRequest>> getChangeRequests({
    int? requestedBy,
    bool pendingOnly = false,
  }) async {
    final db = await database;
    final whereParts = <String>[];
    final whereArgs = <Object?>[];

    if (requestedBy != null) {
      whereParts.add('cr.requested_by = ?');
      whereArgs.add(requestedBy);
    }
    if (pendingOnly) {
      whereParts.add('cr.status = ?');
      whereArgs.add(ChangeRequestStatus.pending.name);
    }

    final whereClause = whereParts.isEmpty
        ? ''
        : 'WHERE ${whereParts.join(' AND ')}';
    final result = await db.rawQuery('''
      SELECT cr.*, u.full_name as requester_name, u.username as requester_username
      FROM change_requests cr
      LEFT JOIN users u ON cr.requested_by = u.id
      $whereClause
      ORDER BY cr.created_at DESC
    ''', whereArgs);

    return result.map((map) => ChangeRequest.fromMap(map)).toList();
  }

  Future<int> getPendingChangeRequestCount({int? requestedBy}) async {
    final db = await database;
    final whereParts = <String>['status = ?'];
    final whereArgs = <Object?>[ChangeRequestStatus.pending.name];
    if (requestedBy != null) {
      whereParts.add('requested_by = ?');
      whereArgs.add(requestedBy);
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM change_requests WHERE ${whereParts.join(' AND ')}',
      whereArgs,
    );
    return result.first['count'] as int;
  }

  Future<void> approveChangeRequest(int requestId, int adminId) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      final rows = await txn.query(
        'change_requests',
        where: 'id = ? AND status = ?',
        whereArgs: [requestId, ChangeRequestStatus.pending.name],
        limit: 1,
      );
      if (rows.isEmpty) {
        throw Exception('Đề xuất không tồn tại hoặc đã được xử lý.');
      }

      final request = ChangeRequest.fromMap(rows.first);
      final payload = Map<String, dynamic>.from(request.payloadMap)
        ..remove('id');

      int requireEntityId() {
        final entityId = request.entityId;
        if (entityId == null) {
          throw Exception('Đề xuất thiếu mã dữ liệu cần xử lý.');
        }
        return entityId;
      }

      switch (request.entityType) {
        case ChangeEntityType.room:
          await _applyRoomChange(txn, request, payload, requireEntityId);
          break;
        case ChangeEntityType.roomType:
          await _applyRoomTypeChange(txn, request, payload, requireEntityId);
          break;
        case ChangeEntityType.customer:
          await _applyCustomerChange(txn, request, payload, requireEntityId);
          break;
      }

      await txn.update(
        'change_requests',
        {
          'status': ChangeRequestStatus.approved.name,
          'admin_note': 'Admin #$adminId đã duyệt',
          'resolved_at': now,
        },
        where: 'id = ?',
        whereArgs: [requestId],
      );
    });
  }

  Future<void> _applyRoomChange(
    Transaction txn,
    ChangeRequest request,
    Map<String, dynamic> payload,
    int Function() requireEntityId,
  ) async {
    switch (request.action) {
      case ChangeAction.create:
        await txn.insert('rooms', payload);
        break;
      case ChangeAction.update:
        await txn.update(
          'rooms',
          payload,
          where: 'id = ?',
          whereArgs: [requireEntityId()],
        );
        break;
      case ChangeAction.delete:
        await txn.delete(
          'rooms',
          where: 'id = ?',
          whereArgs: [requireEntityId()],
        );
        break;
    }
  }

  Future<void> _applyRoomTypeChange(
    Transaction txn,
    ChangeRequest request,
    Map<String, dynamic> payload,
    int Function() requireEntityId,
  ) async {
    switch (request.action) {
      case ChangeAction.create:
        await txn.insert('room_types', payload);
        break;
      case ChangeAction.update:
        await txn.update(
          'room_types',
          payload,
          where: 'id = ?',
          whereArgs: [requireEntityId()],
        );
        break;
      case ChangeAction.delete:
        final entityId = requireEntityId();
        final roomsCountResult = await txn.rawQuery(
          'SELECT COUNT(*) as count FROM rooms WHERE room_type_id = ?',
          [entityId],
        );
        final count = roomsCountResult.first['count'] as int;
        if (count > 0) {
          throw Exception('Không thể xóa loại phòng vì đang có phòng sử dụng.');
        }
        await txn.delete('room_types', where: 'id = ?', whereArgs: [entityId]);
        break;
    }
  }

  Future<void> _applyCustomerChange(
    Transaction txn,
    ChangeRequest request,
    Map<String, dynamic> payload,
    int Function() requireEntityId,
  ) async {
    switch (request.action) {
      case ChangeAction.create:
        await txn.insert('customers', payload);
        break;
      case ChangeAction.update:
        await txn.update(
          'customers',
          payload,
          where: 'id = ?',
          whereArgs: [requireEntityId()],
        );
        break;
      case ChangeAction.delete:
        await txn.delete(
          'customers',
          where: 'id = ?',
          whereArgs: [requireEntityId()],
        );
        break;
    }
  }

  Future<int> rejectChangeRequest(
    int requestId, {
    String adminNote = '',
  }) async {
    final db = await database;
    return await db.update(
      'change_requests',
      {
        'status': ChangeRequestStatus.rejected.name,
        'admin_note': adminNote,
        'resolved_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ? AND status = ?',
      whereArgs: [requestId, ChangeRequestStatus.pending.name],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}
