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
├── main.dart                      # Điểm vào chính của ứng dụng
├── legacy_keeper_app.dart         # MultiProvider và cấu hình chính
├── screens/                       # Tất cả các màn hình UI
│   ├── login_screen.dart          # Đăng nhập
│   ├── register_screen.dart       # Đăng ký
│   ├── dashboard_screen.dart      # Dashboard chính
│   ├── settings_screen.dart       # Cài đặt
│   ├── personal_info_screen.dart  # Thông tin cá nhân
│   ├── user_management_screen.dart# Quản lý người dùng
│   ├── family_tree_graph.dart     # Cây gia phả
│   ├── financial_management_screen.dart # Quản lý tài chính
│   ├── event_screen.dart          # Quản lý sự kiện
├── widgets/                       # Widget tùy chỉnh
│   ├── custom_button.dart         # Nút bấm tùy chỉnh
│   ├── custom_text_field.dart     # Ô nhập liệu tùy chỉnh
│   ├── custom_picker.dart         # Picker cho danh mục/vai trò
├── models/                        # Dữ liệu (Models)
│   ├── user_model.dart            # Người dùng
│   ├── event_model.dart           # Sự kiện
│   ├── finance_model.dart         # Tài chính
│   ├── ancestor_model.dart        # Tổ tiên
├── providers/                     # Quản lý trạng thái
│   ├── user_provider.dart         # Trạng thái người dùng
│   ├── event_provider.dart        # Trạng thái sự kiện
│   ├── ancestor_provider.dart     # Trạng thái tổ tiên
│   ├── contribution_provider.dart # Quản lý thu
│   ├── expense_provider.dart      # Quản lý chi
│   ├── financial_overview_provider.dart # Tổng quan tài chính
├── services/                      # Logic backend
│   ├── firebase_auth_service.dart # Tích hợp Firebase Authentication
│   ├── user_service.dart          # Quản lý thông tin người dùng
│   ├── event_service.dart         # Quản lý thông tin sự kiện
│   ├── finance_service.dart       # Quản lý thu chi
├── utils/                         # Tiện ích
│   ├── constants.dart             # Hằng số sử dụng
│   ├── validators.dart            # Kiểm tra tính hợp lệ đầu vào
│   ├── themes.dart                # Theme và giao diện
├── assets/                        # Tài nguyên tĩnh
│   ├── images/                    # Hình ảnh sử dụng
│   ├── icons/                     # Icon
```

