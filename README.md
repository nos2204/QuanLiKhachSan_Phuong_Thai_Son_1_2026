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
1. PROJECT USER STORIES – HỆ THỐNG QUẢN LÝ KHÁCH SẠN
Tác nhân 1: Quản lý khách sạn
US01 - Đăng nhập hệ thống

Là một quản lý khách sạn, tôi muốn đăng nhập vào hệ thống để thực hiện các chức năng quản trị.

US02 - Quản lý phòng

Là một quản lý khách sạn, tôi muốn thêm, sửa và xóa thông tin phòng để cập nhật dữ liệu phòng trong khách sạn.

US03 - Quản lý loại phòng

Là một quản lý khách sạn, tôi muốn quản lý các loại phòng để phân loại dịch vụ và giá phòng.

US04 - Quản lý nhân viên

Là một quản lý khách sạn, tôi muốn quản lý thông tin nhân viên để theo dõi và phân công công việc.

US05 - Quản lý khách thuê

Là một quản lý khách sạn, tôi muốn xem và quản lý thông tin khách thuê để phục vụ công tác quản lý.

US06 - Quản lý hóa đơn

Là một quản lý khách sạn, tôi muốn xem và kiểm tra các hóa đơn thanh toán để theo dõi doanh thu.

US07 - Xem báo cáo doanh thu

Là một quản lý khách sạn, tôi muốn xem báo cáo doanh thu theo ngày, tháng và năm để đánh giá hiệu quả kinh doanh.

US08 - Xem thống kê phòng

Là một quản lý khách sạn, tôi muốn xem thống kê số lượng phòng đang sử dụng, phòng trống và phòng bảo trì để quản lý khách sạn hiệu quả.

Tác nhân 2: Nhân viên lễ tân
US09 - Đăng nhập hệ thống

Là một nhân viên lễ tân, tôi muốn đăng nhập vào hệ thống để thực hiện các nghiệp vụ hàng ngày.

US10 - Tiếp nhận khách thuê

Là một nhân viên lễ tân, tôi muốn nhập thông tin khách thuê để lưu trữ hồ sơ khách hàng.

US11 - Kiểm tra tình trạng phòng

Là một nhân viên lễ tân, tôi muốn xem danh sách phòng và trạng thái phòng để tư vấn cho khách.

US12 - Lập phiếu thuê phòng

Là một nhân viên lễ tân, tôi muốn tạo phiếu thuê phòng để ghi nhận việc khách sử dụng phòng.

US13 - Thực hiện nhận phòng (Check-in)

Là một nhân viên lễ tân, tôi muốn thực hiện thủ tục nhận phòng để khách bắt đầu lưu trú.

US14 - Thực hiện trả phòng (Check-out)

Là một nhân viên lễ tân, tôi muốn thực hiện thủ tục trả phòng để kết thúc thời gian lưu trú của khách.

US15 - Lập hóa đơn thanh toán

Là một nhân viên lễ tân, tôi muốn tạo hóa đơn thanh toán để khách hoàn tất chi phí lưu trú.

US16 - Tìm kiếm khách thuê

Là một nhân viên lễ tân, tôi muốn tìm kiếm thông tin khách thuê để phục vụ việc tra cứu nhanh chóng.

US17 - Cập nhật thông tin khách thuê

Là một nhân viên lễ tân, tôi muốn chỉnh sửa thông tin khách thuê khi có thay đổi.

Tác nhân 3: Hệ thống
US18 - Lưu trữ dữ liệu

Là một hệ thống, tôi cần lưu trữ thông tin phòng, khách thuê, nhân viên và hóa đơn để phục vụ quản lý.

US19 - Cập nhật trạng thái phòng

Là một hệ thống, tôi muốn tự động cập nhật trạng thái phòng khi khách nhận hoặc trả phòng.

US20 - Tính tiền thuê phòng

Là một hệ thống, tôi muốn tự động tính tiền thuê phòng dựa trên số ngày lưu trú và loại phòng.

US21 - Quản lý phân quyền

Là một hệ thống, tôi muốn phân quyền người dùng theo vai trò quản lý hoặc lễ tân để đảm bảo an toàn dữ liệu.

US22 - Tạo báo cáo thống kê

Là một hệ thống, tôi muốn tổng hợp dữ liệu để tạo báo cáo doanh thu và tình trạng sử dụng phòng.

US23 - Bảo mật đăng nhập

Là một hệ thống, tôi muốn xác thực tài khoản người dùng để đảm bảo chỉ người có quyền mới được truy cập hệ thống.
