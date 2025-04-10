🚀 Hướng Dẫn Làm Việc Nhóm trên Git
🌱 Quy tắc đặt tên nhánh
Khi tạo nhánh mới, hãy đặt tên theo công thức:

kotlin
Copy
Edit
what-you-want/name-fun
🔹 Ví dụ:
feature/new-login-ui → Tạo UI mới cho màn hình đăng nhập
fix/avatar-loading → Sửa lỗi tải ảnh đại diện
update/home-screen-layout → Cập nhật giao diện trang chủ
🔄 Quy trình làm việc (Workflow)
1️⃣ Tạo nhánh mới

sh
Copy
Edit
git checkout -b what-you-want/name-fun
2️⃣ Code và commit thường xuyên

sh
Copy
Edit
git add .
git commit -m "Mô tả ngắn về thay đổi"
3️⃣ Push code lên repository

sh
Copy
Edit
git push origin what-you-want/name-fun
4️⃣ Tạo Pull Request (PR)

Sau khi hoàn thành, tạo Pull Request để merge code vào nhánh chính (main hoặc develop).
PR cần có mô tả ngắn gọn về thay đổi để dễ review.
5️⃣ Review & Merge

Một thành viên khác sẽ kiểm tra và approve PR trước khi merge vào dự án.
📌 Lưu ý:

Luôn cập nhật nhánh chính trước khi bắt đầu code (git pull origin main)
Không commit trực tiếp vào main
Nếu có xung đột khi merge, hãy tự giải quyết trước khi yêu cầu review

-> Nếu chưa hiểu thì vào tên nhánh xem và làm theo (Quy tắc đặt lên hàng đầu)
