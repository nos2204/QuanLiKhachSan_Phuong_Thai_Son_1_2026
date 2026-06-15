App Quản Lý Khách Sạn
Dự án này là một ứng dụng quản lý khách sạn cơ bản được xây dựng bằng Flutter & Dart, tập trung vào việc quản lý phòng, khách hàng và quy trình đặt phòng thông qua các thao tác CRUD. 
Cách chạy: flutter run -d web-server --web-port=3000

Thành Phần Hệ Thống
Hệ thống được thiết kế dựa trên 3 đối tượng cốt lõi:

Room (room.dart): Quản lý thông tin vật chất của khách sạn bao gồm số phòng, loại phòng, đơn giá và trạng thái (trống/đang ở).

Customer (customer.dart): Quản lý thông tin định danh của khách hàng như họ tên, số điện thoại và số CCCD.

Booking (booking.dart): Đối tượng nghiệp vụ kết nối Khách hàng với Phòng, quản lý ngày nhận phòng và tính toán tổng hóa đơn.

Màu sắc:
Sử dụng tông màu Navy Blue (#003366) cho Header và Vàng Gold (#D4AF37) cho các thành phần điều hướng đang hoạt động.

Layout: Cấu trúc khung xương (Scaffold) cố định giúp người dùng dễ dàng làm quen với giao diện dù ở bất kỳ màn hình nào.

Chức năng: Tích hợp bộ công cụ quản lý khách hàng (Thêm/Xóa) ngay trong tab Content.

Chức Năng Các Màn Hình
Home (Trang chủ): Giới thiệu thương hiệu khách sạn với hình ảnh minh họa từ Network.

Content (Quản lý): Danh sách khách hàng thuê phòng, cho phép thêm mới hoặc xóa dữ liệu trực tiếp.

About (Thông tin): Chi tiết về các thành viên thực hiện dự án.

Nguyễn Hoàng Sơn MSV:23010100 : Làm trang Content
Nguyễn Minh phương MSV: 23010190: Làm trang About
Nguyễn Việt Thái MSV: 23017239: Làm trang Home

USER STORIES - HỆ THỐNG ĐẶT PHÒNG KHÁCH SẠN
Vai trò 1: Khách hàng (Customer)
US01 - Đăng ký tài khoản

Là một khách hàng, tôi muốn đăng ký tài khoản bằng email và mật khẩu để có thể sử dụng hệ thống đặt phòng.

US02 - Đăng nhập hệ thống

Là một khách hàng, tôi muốn đăng nhập vào hệ thống để quản lý thông tin cá nhân và các đơn đặt phòng của mình.

US03 - Xem danh sách phòng

Là một khách hàng, tôi muốn xem danh sách các phòng hiện có để lựa chọn phòng phù hợp với nhu cầu.

US04 - Xem chi tiết phòng

Là một khách hàng, tôi muốn xem thông tin chi tiết của phòng như giá, loại phòng, hình ảnh và tiện nghi để đưa ra quyết định đặt phòng.

US05 - Tìm kiếm phòng

Là một khách hàng, tôi muốn tìm kiếm phòng theo loại phòng hoặc mức giá để tiết kiệm thời gian lựa chọn.

US06 - Đặt phòng

Là một khách hàng, tôi muốn chọn ngày nhận phòng và ngày trả phòng để thực hiện đặt phòng.

US07 - Thanh toán

Là một khách hàng, tôi muốn thanh toán chi phí đặt phòng để hoàn tất quá trình đặt phòng.

US08 - Xem lịch sử đặt phòng

Là một khách hàng, tôi muốn xem lại các đơn đặt phòng đã thực hiện để quản lý lịch sử giao dịch.

US09 - Hủy đặt phòng

Là một khách hàng, tôi muốn hủy đơn đặt phòng khi không còn nhu cầu sử dụng.

US10 - Cập nhật thông tin cá nhân

Là một khách hàng, tôi muốn chỉnh sửa thông tin cá nhân để đảm bảo dữ liệu luôn chính xác.

US11 - Đánh giá phòng

Là một khách hàng, tôi muốn đánh giá chất lượng phòng sau khi sử dụng để chia sẻ trải nghiệm với những khách hàng khác.

Vai trò 2: Quản trị viên (Admin)
US12 - Đăng nhập quản trị

Là một quản trị viên, tôi muốn đăng nhập vào hệ thống quản trị để thực hiện các chức năng quản lý.

US13 - Quản lý phòng

Là một quản trị viên, tôi muốn thêm, sửa và xóa thông tin phòng để cập nhật tình trạng hoạt động của khách sạn.

US14 - Quản lý khách hàng

Là một quản trị viên, tôi muốn xem danh sách khách hàng để quản lý người sử dụng hệ thống.

US15 - Quản lý đơn đặt phòng

Là một quản trị viên, tôi muốn theo dõi và quản lý các đơn đặt phòng để kiểm soát tình trạng phòng.

US16 - Quản lý thanh toán

Là một quản trị viên, tôi muốn xem thông tin thanh toán của khách hàng để kiểm tra các giao dịch.

US17 - Xem thống kê doanh thu

Là một quản trị viên, tôi muốn xem báo cáo doanh thu để đánh giá hiệu quả kinh doanh của khách sạn.

US18 - Xem thống kê đặt phòng

Là một quản trị viên, tôi muốn xem số lượng phòng được đặt theo thời gian để hỗ trợ việc ra quyết định quản lý.

US19 - Quản lý đánh giá

Là một quản trị viên, tôi muốn quản lý các đánh giá của khách hàng để đảm bảo nội dung phù hợp.

Vai trò 3: Hệ thống
US20 - Lưu trữ dữ liệu

Là một hệ thống, tôi cần lưu trữ dữ liệu người dùng, phòng, đơn đặt phòng và thanh toán trên Firebase để đảm bảo dữ liệu luôn sẵn sàng.

US21 - Xác thực người dùng

Là một hệ thống, tôi cần xác thực thông tin đăng nhập bằng Firebase Authentication để đảm bảo an toàn thông tin.

US22 - Gửi thông báo

Là một hệ thống, tôi muốn gửi thông báo khi khách hàng đặt phòng thành công hoặc hủy phòng để người dùng nắm được trạng thái giao dịch.