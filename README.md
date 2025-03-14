# Legacy Keeper

**Legacy Keeper** là một ứng dụng di động quản lý thông tin dòng họ, tổ tiên, tài chính, sự kiện quan trọng và nhiều chức năng khác. Ứng dụng được thiết kế để duy trì kết nối, lưu giữ giá trị truyền thống và hỗ trợ quản lý các hoạt động gia đình một cách hiệu quả.

---

## 🚀 **Chức năng chính**

### 1. **Quản lý tổ tiên**
- Hiển thị thông tin tổ tiên và mối quan hệ trong gia đình.
- Thêm, chỉnh sửa và xóa thông tin cá nhân của từng thành viên.

### 2. **Cây gia phả**
- Trực quan hóa quan hệ dòng họ qua cây gia phả.
- Thêm hoặc cập nhật mối quan hệ trực tiếp trên cây.
- Hiển thị dạng bảng cho các thành viên

### 3. **Quản lý tài chính**
- **Quản lý thu:** Theo dõi và ghi nhận các khoản đóng góp.
- **Quản lý chi:** Theo dõi và phân loại chi tiêu.
- **Tổng quan tài chính:** Báo cáo thu, chi, và số dư minh bạch.

### 4. **Quản lý sự kiện**
- Ghi nhận và quản lý sự kiện quan trọng: Ngày giỗ, họp mặt, lễ kỷ niệm.
- Lưu trữ chi tiết sự kiện: ngày, giờ, địa điểm, mô tả và chi phí.
- Phân loại sự kiện theo danh mục.

### 5. **Cài đặt**
- **Thông tin cá nhân:** Cập nhật và quản lý thông tin của người dùng.
- **Quản lý người dùng:** Dành cho admin, hiển thị danh sách người dùng và quyền hạn.

---

## 📂 **Cấu trúc thư mục**

```plaintext
lib/
│
├── main.dart                          # Entry point của ứng dụng
│
├── models/                            # Chứa các mô hình dữ liệu (Models)
│   ├── ancestor_model.dart            # Mô hình dữ liệu tổ tiên
│   ├── annual_income_model.dart       # Mô hình dữ liệu thu nhập hàng năm
│   ├── event_model.dart               # Mô hình dữ liệu sự kiện
│   ├── expense_transaction_model.dart # Mô hình giao dịch chi tiêu
│   ├── family_member_model.dart       # Mô hình dữ liệu thành viên gia đình
│   └── user_model.dart                # Mô hình dữ liệu người dùng
│
├── providers/                         # State management với Provider
│   ├── ancestor_provider.dart         # Provider quản lý dữ liệu tổ tiên
│   ├── annual_income_provider.dart    # Provider quản lý thu nhập
│   ├── event_provider.dart            # Provider quản lý dữ liệu sự kiện
│   ├── expense_provider.dart          # Provider quản lý chi tiêu
│   ├── family_member_provider.dart    # Provider quản lý thành viên gia đình
│   ├── financial_report_provider.dart # Provider quản lý báo cáo tài chính
│   └── user_provider.dart             # Provider quản lý người dùng
│
├── screens/                           # Chứa các màn hình chính của ứng dụng
│   ├── access_denied_screen.dart      # Màn hình thông báo quyền truy cập bị từ chối
│   ├── add_ancestor_screen.dart       # Màn hình thêm mới tổ tiên
│   ├── add_event_screen.dart          # Màn hình thêm mới sự kiện
│   ├── add_family_member_screen.dart  # Màn hình thêm thành viên gia đình
│   ├── dashboard_screen.dart          # Màn hình tổng quan
│   ├── event_screen.dart              # Màn hình quản lý sự kiện
│   ├── expense_screen.dart            # Màn hình quản lý chi tiêu
│   ├── family_member_table_screen.dart# Màn hình danh sách thành viên
│   ├── family_tree_graph.dart         # Màn hình cây gia phả
│   ├── financial_management_screen.dart # Quản lý tài chính
│   ├── financial_report_screen.dart   # Báo cáo tài chính
│   ├── income_screen.dart             # Màn hình quản lý thu nhập
│   ├── login_screen.dart              # Màn hình đăng nhập
│   ├── profile_screen.dart            # Màn hình hồ sơ người dùng
│   ├── register_screen.dart           # Màn hình đăng ký tài khoản
│   ├── settings_screen.dart           # Màn hình cài đặt
│   ├── splash_screen.dart             # Màn hình khởi động
│   └── user_management_screen.dart    # Màn hình quản lý người dùng
│
├── widgets/                           # Chứa các widget tái sử dụng
│   ├── custom_button.dart             # Nút bấm tùy chỉnh
│   ├── custom_dialog.dart             # Hộp thoại tùy chỉnh
│   ├── custom_list_tile.dart          # Item danh sách tái sử dụng
│   ├── custom_table_cell.dart         # Ô bảng tùy chỉnh
│   ├── custom_text_field.dart         # Trường nhập liệu tùy chỉnh
│   ├── loading_indicator.dart         # Hiển thị trạng thái tải
│   └── role_based_widget.dart         # Widget hiển thị dựa trên vai trò
│
├── utils/                             # Chứa tiện ích và công cụ hỗ trợ
│   ├── constants.dart                 # Hằng số toàn cục (màu sắc, cấu hình)
│   ├── formatters.dart                # Định dạng ngày, giờ và dữ liệu
│   ├── permissions.dart               # Xử lý phân quyền người dùng
│   ├── themes.dart                    # Quản lý giao diện (theme)
│   └── validators.dart                # Hàm kiểm tra dữ liệu đầu vào
│
├── services/                          # Chứa các dịch vụ API/DB
│   ├── ancestor_service.dart          # Dịch vụ quản lý tổ tiên
│   ├── annual_income_service.dart     # Dịch vụ quản lý thu nhập
│   ├── event_service.dart             # Dịch vụ quản lý sự kiện
│   ├── expense_service.dart           # Dịch vụ quản lý chi tiêu
│   ├── family_member_service.dart     # Dịch vụ quản lý thành viên gia đình
│   ├── financial_report_service.dart  # Dịch vụ quản lý báo cáo tài chính
│   ├── firebase_auth_service.dart     # Dịch vụ xác thực Firebase
│   └── user_service.dart              # Dịch vụ quản lý người dùng
│
└── assets/                            # Thư mục tài nguyên
    ├── images/                        # Hình ảnh ứng dụng
    ├── fonts/                         # Font chữ tuỳ chỉnh
    └── localization/                  # Hỗ trợ đa ngôn ngữ
        ├── en.json                    # Ngôn ngữ tiếng Anh
        └── vi.json                    # Ngôn ngữ tiếng Việt

```


