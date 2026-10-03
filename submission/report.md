1. Tôi triển khai trên AWS, region us-east-1, EC2 t3.small (CPU); commit nguồn ban đầu: 55539f67d7c78b43afe334a2ec3271c4bfdbbe2d. Tôi dùng t3.small thay t3.medium vì giới hạn Free Tier của tài khoản.
2. Dataset Credit Card Fraud Detection có 284.807 dòng, chia stratified train/validation/test khoảng 70/10/20%, tương ứng 199.364/28.481/56.962 dòng, seed 42.
3. Load dữ liệu mất 2,3912 giây; training LightGBM mất 2,2925 giây; best iteration là 3, sử dụng early stopping trên validation.
4. Test AUC-ROC đạt 0,869775; Accuracy 0,999105; F1 0,727273; Precision 0,772727; Recall 0,686869 tại ngưỡng 0,5. Accuracy cao do dữ liệu mất cân bằng; F1/Recall cho thấy mô hình vẫn bỏ sót giao dịch gian lận.
5. Latency 1 dòng là 1,1563 ms; batch 1.000 dòng mất 0,001455 giây, throughput khoảng 687.214 dòng/giây. Số đo lấy median sau warm-up, 100 lần đo một dòng và 20 lần đo batch, không bao gồm network hoặc đọc CSV.
6. Log tài nguyên sau benchmark lúc 16:01:50 ngày 03/10/2026 (UTC+7) ghi nhận CPU idle 100%, RAM dùng 285,4 MiB/tổng 1.910,5 MiB; ens5 RX 9.178.399.476 byte, TX 7.251.643 byte (tổng tích lũy từ khi máy chạy, không riêng benchmark). Đây không phải mức tài nguyên cao nhất trong training.
7. Ảnh AWS Bills tháng 10/2026 được chụp lúc 16:52:35 ngày 03/10/2026 (UTC+7), hiển thị No data và Estimated grand total USD 0.00; chưa đủ dữ liệu để xác nhận chi phí thực tế của EC2, NAT Gateway, ALB và EBS.
8. Đã tải benchmark.py, benchmark_result.json và resource_usage.txt về laptop. Chưa destroy tài nguyên vì còn cần chụp ảnh Network/Billing; sẽ bổ sung bằng chứng cleanup sau khi terraform destroy hoàn tất và state rỗng.

