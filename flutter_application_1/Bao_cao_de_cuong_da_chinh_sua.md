# ĐỀ CƯƠNG BÁO CÁO DỰ ÁN QUẢN LÝ KHÁCH SẠN

## Nhận xét và định hướng chỉnh sửa

- Đề cương ban đầu đã bao quát đúng các phần chính của một báo cáo dự án: giới thiệu, khảo sát, cơ sở lý thuyết, thiết kế dữ liệu, phân tích thiết kế, triển khai, giao diện, quản lý dự án và kết luận.
- Cần giảm trùng lặp giữa mục “Các kịch bản sử dụng” và “Đặc tả Use Case”; nên tách thành danh sách use case tổng quát và phần đặc tả chi tiết.
- Cần bổ sung bảng hóa đơn, cơ chế phân quyền Admin/Nhân viên, luồng đề xuất thay đổi dữ liệu và các giao dịch check-in/check-out vì đây là các chức năng quan trọng của ứng dụng hiện tại.
- Mục “Backend” nên đổi thành “Tầng xử lý nghiệp vụ và truy cập dữ liệu” vì dự án dùng Flutter/Dart với SQLite cục bộ, không có backend server độc lập.
- Chương giao diện nên gắn với kiểm thử và đánh giá để báo cáo thuyết phục hơn, không chỉ liệt kê màn hình.

## CHƯƠNG 1: GIỚI THIỆU

### 1.1 Đặt vấn đề

### 1.2 Lý do chọn đề tài

### 1.3 Mục tiêu của đề tài

- Xây dựng ứng dụng hỗ trợ quản lý hoạt động khách sạn.
- Hỗ trợ quản lý phòng, loại phòng, khách hàng, đặt phòng, nhận phòng, trả phòng và hóa đơn.
- Hỗ trợ phân quyền người dùng và cơ chế duyệt đề xuất thay đổi dữ liệu.
- Cung cấp dashboard thống kê tình trạng phòng, khách hàng và doanh thu.

### 1.4 Đối tượng nghiên cứu

- Quy trình nghiệp vụ quản lý khách sạn quy mô nhỏ và vừa.
- Ứng dụng di động/đa nền tảng phục vụ quản lý khách sạn.
- Cơ sở dữ liệu SQLite cục bộ trong ứng dụng Flutter.

### 1.5 Phạm vi nghiên cứu

- Phạm vi chức năng: quản lý phòng, loại phòng, khách hàng, đặt phòng, check-in, check-out, hóa đơn, tài khoản nhân viên, đề xuất thay đổi dữ liệu và thống kê cơ bản.
- Phạm vi người dùng: quản trị viên và nhân viên lễ tân.
- Phạm vi kỹ thuật: ứng dụng Flutter sử dụng Dart, SQLite và các thư viện hỗ trợ như sqflite, fl_chart, excel, file_picker.

### 1.6 Phương pháp nghiên cứu

#### 1.6.1 Phương pháp nghiên cứu tài liệu

#### 1.6.2 Phương pháp khảo sát nghiệp vụ

#### 1.6.3 Phương pháp phân tích và thiết kế hệ thống

#### 1.6.4 Phương pháp thực nghiệm xây dựng ứng dụng

#### 1.6.5 Phương pháp kiểm thử và đánh giá kết quả

## CHƯƠNG 2: KHẢO SÁT HIỆN TRẠNG VÀ CÁC GIẢI PHÁP LIÊN QUAN

### 2.1 Tổng quan nghiệp vụ quản lý khách sạn

### 2.2 Quy trình đặt phòng, nhận phòng, trả phòng và thanh toán

### 2.3 Ứng dụng công nghệ thông tin trong quản lý lưu trú

### 2.4 Khảo sát các hệ thống tương tự

- Traveloka Extranet.
- KiotViet Hotel.
- Các phần mềm PMS cho khách sạn.

### 2.5 Đánh giá ưu điểm và hạn chế của các hệ thống hiện có

#### 2.5.1 Ưu điểm

#### 2.5.2 Hạn chế

#### 2.5.3 Bài học kinh nghiệm rút ra

### 2.6 Đề xuất hướng giải quyết

- Xây dựng ứng dụng quản lý khách sạn chạy đa nền tảng.
- Sử dụng SQLite để lưu trữ dữ liệu cục bộ.
- Bổ sung phân quyền Admin/Nhân viên.
- Áp dụng cơ chế đề xuất và duyệt thay đổi dữ liệu nhằm hạn chế sai sót trong vận hành.

## CHƯƠNG 3: CƠ SỞ LÝ THUYẾT

### 3.1 Tổng quan về phát triển ứng dụng di động đa nền tảng

### 3.2 Framework Flutter và ngôn ngữ Dart

### 3.3 Kiến trúc ứng dụng Flutter

### 3.4 Quản lý trạng thái và điều hướng trong Flutter

### 3.5 Cơ sở dữ liệu SQLite trong thiết bị di động

### 3.6 Giao dịch dữ liệu và đảm bảo toàn vẹn dữ liệu

### 3.7 Phân quyền người dùng trong hệ thống quản lý

### 3.8 Trực quan hóa dữ liệu thống kê trong ứng dụng

## CHƯƠNG 4: PHÂN TÍCH VÀ THIẾT KẾ CƠ SỞ DỮ LIỆU

### 4.1 Phân tích yêu cầu lưu trữ dữ liệu

### 4.2 Danh sách thực thể chính

- Người dùng.
- Loại phòng.
- Phòng.
- Khách hàng.
- Đặt phòng.
- Hóa đơn.
- Đề xuất thay đổi dữ liệu.

### 4.3 Mô hình thực thể liên kết (ERD)

### 4.4 Lược đồ cơ sở dữ liệu chi tiết

#### 4.4.1 Bảng users

#### 4.4.2 Bảng room_types

#### 4.4.3 Bảng rooms

#### 4.4.4 Bảng customers

#### 4.4.5 Bảng bookings

#### 4.4.6 Bảng invoices

#### 4.4.7 Bảng change_requests

### 4.5 Ràng buộc khóa chính, khóa ngoại và dữ liệu duy nhất

### 4.6 Thiết kế giao dịch dữ liệu

- Giao dịch nhận phòng: cập nhật trạng thái đặt phòng và trạng thái phòng.
- Giao dịch trả phòng: cập nhật trạng thái đặt phòng, giải phóng phòng và tạo hóa đơn.
- Giao dịch duyệt đề xuất: áp dụng thay đổi dữ liệu và cập nhật trạng thái đề xuất.

### 4.7 Tối ưu truy vấn và đảm bảo toàn vẹn dữ liệu SQLite

## CHƯƠNG 5: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG

### 5.1 Yêu cầu chức năng

#### 5.1.1 Quản lý đăng nhập và phân quyền

#### 5.1.2 Quản lý tài khoản nhân viên

#### 5.1.3 Quản lý loại phòng và giá phòng

#### 5.1.4 Quản lý danh sách phòng

#### 5.1.5 Quản lý khách hàng

#### 5.1.6 Quản lý đặt phòng

#### 5.1.7 Nhận phòng, trả phòng và thanh toán

#### 5.1.8 Quản lý hóa đơn

#### 5.1.9 Quản lý đề xuất thay đổi dữ liệu

#### 5.1.10 Thống kê tổng quan và doanh thu

### 5.2 Yêu cầu phi chức năng

- Hiệu năng.
- Bảo mật.
- Tính dễ sử dụng.
- Khả năng mở rộng.
- Tính ổn định và toàn vẹn dữ liệu.

### 5.3 Ràng buộc của hệ thống

- Ứng dụng sử dụng dữ liệu SQLite cục bộ.
- Người dùng nhân viên không được trực tiếp thay đổi một số dữ liệu quan trọng nếu chưa được Admin duyệt.
- Dữ liệu đặt phòng, trả phòng và hóa đơn cần được xử lý nhất quán.

### 5.4 Tác nhân của hệ thống

#### 5.4.1 Admin

#### 5.4.2 Nhân viên lễ tân

#### 5.4.3 Cơ sở dữ liệu SQLite

### 5.5 Danh sách Use Case

- UC01: Đăng nhập.
- UC02: Đăng xuất.
- UC03: Xem dashboard tổng quan.
- UC04: Quản lý tài khoản nhân viên.
- UC05: Quản lý loại phòng.
- UC06: Quản lý phòng.
- UC07: Quản lý khách hàng.
- UC08: Tạo đặt phòng.
- UC09: Xem và lọc danh sách đặt phòng.
- UC10: Nhận phòng.
- UC11: Trả phòng và thanh toán.
- UC12: Hủy đặt phòng.
- UC13: Xem lịch sử hóa đơn.
- UC14: Tạo đề xuất thay đổi dữ liệu.
- UC15: Duyệt hoặc từ chối đề xuất.
- UC16: Theo dõi trạng thái đề xuất.

### 5.6 Biểu đồ Use Case tổng quát

### 5.7 Đặc tả Use Case chi tiết

#### 5.7.1 UC01 - Đăng nhập

#### 5.7.2 UC04 - Quản lý tài khoản nhân viên

#### 5.7.3 UC08 - Tạo đặt phòng

#### 5.7.4 UC10 - Nhận phòng

#### 5.7.5 UC11 - Trả phòng và thanh toán

#### 5.7.6 UC14 - Tạo đề xuất thay đổi dữ liệu

#### 5.7.7 UC15 - Duyệt hoặc từ chối đề xuất

### 5.8 Biểu đồ hoạt động

- Quy trình đăng nhập.
- Quy trình đặt phòng.
- Quy trình nhận phòng.
- Quy trình trả phòng và thanh toán.
- Quy trình tạo và duyệt đề xuất thay đổi dữ liệu.

### 5.9 Biểu đồ tuần tự

- Đăng nhập.
- Tạo đặt phòng.
- Trả phòng và tạo hóa đơn.
- Duyệt đề xuất thay đổi dữ liệu.

### 5.10 Biểu đồ lớp

### 5.11 Thiết kế kiến trúc tổng thể

- Tầng giao diện: các màn hình Flutter.
- Tầng xử lý nghiệp vụ: logic đăng nhập, đặt phòng, thanh toán, duyệt đề xuất.
- Tầng truy cập dữ liệu: DatabaseHelper và các model.
- Tầng lưu trữ: SQLite.

## CHƯƠNG 6: TRIỂN KHAI HỆ THỐNG

### 6.1 Môi trường và công cụ phát triển

- Flutter SDK.
- Dart.
- SQLite/sqflite.
- Visual Studio Code hoặc Android Studio.

### 6.2 Cấu trúc thư mục dự án

- lib/models: định nghĩa model dữ liệu.
- lib/database: xử lý kết nối và thao tác SQLite.
- lib/screens: các màn hình chức năng.
- lib/widgets: các widget tái sử dụng.

### 6.3 Triển khai giao diện Flutter

### 6.4 Triển khai tầng xử lý nghiệp vụ và truy cập dữ liệu

### 6.5 Triển khai đăng nhập và phân quyền

### 6.6 Triển khai quản lý phòng, loại phòng và khách hàng

### 6.7 Triển khai đặt phòng, nhận phòng, trả phòng và hóa đơn

### 6.8 Triển khai cơ chế đề xuất thay đổi dữ liệu

### 6.9 Triển khai dashboard và biểu đồ doanh thu

### 6.10 Tích hợp thư viện hỗ trợ

- sqflite, sqflite_common_ffi, sqlite3_flutter_libs.
- intl.
- fl_chart.
- excel.
- file_picker.

## CHƯƠNG 7: GIAO DIỆN, KIỂM THỬ VÀ ĐÁNH GIÁ HỆ THỐNG

### 7.1 Giao diện đăng nhập

### 7.2 Giao diện dashboard

### 7.3 Giao diện quản lý đặt phòng

### 7.4 Giao diện thêm đặt phòng

### 7.5 Giao diện quản lý phòng và loại phòng

### 7.6 Giao diện quản lý khách hàng

### 7.7 Giao diện trả phòng và thanh toán

### 7.8 Giao diện lịch sử hóa đơn

### 7.9 Giao diện quản lý tài khoản nhân viên

### 7.10 Giao diện danh sách đề xuất và duyệt đề xuất

### 7.11 Kế hoạch kiểm thử

#### 7.11.1 Kiểm thử chức năng đăng nhập

#### 7.11.2 Kiểm thử chức năng CRUD dữ liệu

#### 7.11.3 Kiểm thử quy trình đặt phòng, nhận phòng, trả phòng

#### 7.11.4 Kiểm thử phân quyền Admin/Nhân viên

#### 7.11.5 Kiểm thử cơ chế duyệt đề xuất

### 7.12 Kết quả kiểm thử

### 7.13 Đánh giá hiệu năng hệ thống

### 7.14 Đánh giá trải nghiệm người dùng

## CHƯƠNG 8: QUẢN LÝ DỰ ÁN VÀ ĐẠO ĐỨC NGHỀ NGHIỆP

### 8.1 Kế hoạch thực hiện dự án

### 8.2 Phân công công việc

### 8.3 Quản lý tiến độ và rủi ro

### 8.4 Đảm bảo làm việc nhóm hiệu quả

### 8.5 Các vấn đề đạo đức trong nghiên cứu và phát triển phần mềm

### 8.6 Bảo mật dữ liệu kinh doanh và dữ liệu khách hàng

### 8.7 Tác động xã hội của hệ thống

## CHƯƠNG 9: KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN

### 9.1 Kết quả đạt được

### 9.2 Hạn chế của hệ thống

### 9.3 Hướng phát triển trong tương lai

- Đồng bộ dữ liệu lên nền tảng đám mây.
- Tích hợp thanh toán trực tuyến.
- Bổ sung đặt phòng trực tuyến cho khách hàng.
- Bổ sung báo cáo doanh thu theo tháng, quý, năm.
- Tăng cường bảo mật mật khẩu và sao lưu dữ liệu.

## TÀI LIỆU THAM KHẢO

## PHỤ LỤC

### Phụ lục A: Một số màn hình chính của ứng dụng

### Phụ lục B: Kịch bản kiểm thử

### Phụ lục C: Hướng dẫn cài đặt và sử dụng ứng dụng
