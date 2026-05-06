# App Quản Lý Khách Sạn
Dự án này là một ứng dụng quản lý khách sạn cơ bản được xây dựng bằng Flutter & Dart, tập trung vào việc quản lý phòng, khách hàng và quy trình đặt phòng thông qua các thao tác CRUD.

## Thành Phần Hệ Thống 
Hệ thống được thiết kế dựa trên 3 đối tượng cốt lõi:

Room (room.dart): Quản lý thông tin vật chất của khách sạn bao gồm số phòng, loại phòng, đơn giá và trạng thái (trống/đang ở).

Customer (customer.dart): Quản lý thông tin định danh của khách hàng như họ tên, số điện thoại và số CCCD.

Booking (booking.dart): Đối tượng nghiệp vụ kết nối Khách hàng với Phòng, quản lý ngày nhận phòng và tính toán tổng hóa đơn.
## Màu sắc: 
Sử dụng tông màu Navy Blue (#003366) cho Header và Vàng Gold (#D4AF37) cho các thành phần điều hướng đang hoạt động.

Layout: Cấu trúc khung xương (Scaffold) cố định giúp người dùng dễ dàng làm quen với giao diện dù ở bất kỳ màn hình nào.

Chức năng: Tích hợp bộ công cụ quản lý khách hàng (Thêm/Xóa) ngay trong tab Content.

 ## Chức Năng Các Màn Hình
Home (Trang chủ): Giới thiệu thương hiệu khách sạn với hình ảnh minh họa từ Network.

Content (Quản lý): Danh sách khách hàng thuê phòng, cho phép thêm mới hoặc xóa dữ liệu trực tiếp.

About (Thông tin): Chi tiết về các thành viên thực hiện dự án.

## Nguyễn Hoàng Sơn MSV:23010100 : Làm trang Content
## Nguyễn Minh phương MSV:	23010190: Làm trang About
## Nguyễn Việt Thái MSV: 23017239: Làm trang Home

