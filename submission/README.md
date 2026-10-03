# Bộ nộp Lab 16 (AWS CPU)

Kết quả thực đo nằm trong benchmark_result.json; mã đã chạy trên EC2 là benchmark.py. resource_usage.txt là log sau benchmark. report.md ghi rõ phần đã xác minh và phần còn thiếu.

## Còn cần hoàn thành trước khi nộp

- Chụp Network trên EC2 và lưu screenshots/04-network.png.
- Đã có screenshots/05-aws-billing.png nhưng AWS Bills đang hiển thị No data; cần kiểm tra lại khi dữ liệu chi phí cập nhật.
- Chạy terraform destroy từ đúng thư mục WSL đã apply; xác minh terraform state list rỗng và kiểm tra tài nguyên lab trên AWS. Lưu log cleanup và cập nhật dòng 8 của report.md.
- Bổ sung ảnh toàn bộ output khi chạy python3 benchmark.py; ảnh 01-benchmark.png hiện chỉ thể hiện nội dung JSON metrics.
- Nộp link GitHub theo LMS. Repo hiện tại có tên khác tên gợi ý của CP5; cần đối chiếu quy định lớp trước khi đổi tên repo.

## Tái hiện

Trong infra/, tạo SSH key lab-key/lab-key.pub riêng, cấu hình AWS profile rồi dùng các giá trị trong lab-settings.example.tfvars (ví dụ terraform plan -var-file=lab-settings.example.tfvars). Không dùng key cũ của người nộp.

Trên máy CPU, cài Python venv, libgomp1 và lightgbm/scikit-learn/pandas/numpy/kaggle; tải creditcard.csv vào cùng thư mục benchmark.py rồi chạy python benchmark.py. Không kèm dataset/credentials trong bộ nộp.

Không nộp private key, Terraform state, .terraform/, AWS/Hugging Face/Kaggle credentials. Chỉ source Terraform và lockfile được sao chép vào infra/.

