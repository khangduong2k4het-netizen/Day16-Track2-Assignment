# Bộ nộp Lab 16 — AWS CPU

Dương Đạt Khang — 2A202602624. Benchmark chạy thực trên EC2 t3.small ngày 04/10/2026 lúc 09:24 (UTC+7).

| Thành phần | File |
| --- | --- |
| Script đã chạy | [benchmark.py](benchmark.py) |
| Metrics mới nhất | [benchmark_result.json](benchmark_result.json) |
| Output benchmark đầy đủ | [benchmark-output.txt](benchmark-output.txt) |
| CPU, RAM, Network sau benchmark | [resource_usage.txt](resource_usage.txt) |
| Báo cáo 8 dòng | [report.md](report.md) |
| Source Terraform và lockfile | [infra/](infra/) |
| Source đóng gói | [terraform-source.zip](terraform-source.zip) |
| Ảnh Network từ log SSH | [04-network-log.png](screenshots/04-network-log.png) |
| Ảnh output từ log SSH | [06-benchmark-log.png](screenshots/06-benchmark-log.png) |

Hai ảnh có hậu tố `-log` là ảnh trình bày log SSH thực tế từ file văn bản kèm theo, **không phải screenshot desktop**. Ảnh 01/02/03/05 lưu lần đo ngày 03/10; số liệu ngày 04/10 nằm trong JSON và log mới.

## Còn thiếu trước khi xác nhận hoàn tất

- Screenshot terminal trực tiếp chạy `python3 benchmark.py` và `ip -s link` nếu yêu cầu đúng screenshot.
- Billing cập nhật: ảnh 03/10 hiển thị No data; CLI Cost Explorer ngày 04/10 bị từ chối quyền `ce:GetCostAndUsage`. Chưa xác minh được chi phí thực tế, không suy luận chi phí bằng 0.
- Bằng chứng `terraform destroy` và state rỗng; hạ tầng vẫn chạy.

## Kết quả

| Metric | Giá trị |
| --- | ---: |
| Load dữ liệu | 2,523908 s |
| Training | 2,313301 s |
| Best iteration | 3 |
| AUC-ROC | 0,869775 |
| Accuracy | 0,999105 |
| F1 | 0,727273 |
| Precision | 0,772727 |
| Recall | 0,686869 |
| Latency 1 dòng | 1,174934 ms |
| Batch 1.000 dòng | 0,001484 s |
| Throughput | 673.835,83 dòng/s |

## Tái hiện

Trong infra/, tạo SSH key riêng (`ssh-keygen -t rsa -b 4096 -f lab-key`), cấu hình AWS profile của bạn, chạy `terraform init` rồi `terraform plan -var-file=lab-settings.example.tfvars`. Ví dụ này dùng luồng CPU chuẩn (`enable_gpu=false`, `cpu_instance_type=t3.small`).

Cấu hình thực đã triển khai dùng `enable_gpu=true`, `gpu_instance_type=t3.small`: chọn AMI Deep Learning và EBS 150 GiB nhưng máy vẫn chỉ có CPU. Không hoàn thành phụ lục GPU/vLLM. Cấu hình thực được ghi riêng trong `infra/deployed-settings.example.tfvars` để đối chiếu, không phải cấu hình CPU khuyến nghị.

Trên node, tạo venv, cài libgomp1 và các package lightgbm/scikit-learn/pandas/numpy/kaggle; tải dataset mlg-ulb/creditcardfraud, đặt creditcard.csv cạnh script, kích hoạt venv rồi chạy `python3 benchmark.py`.

Không nộp private key, credentials, dataset, Terraform state hoặc .terraform/. ZIP chỉ chứa source, lockfile và cấu hình ví dụ không có token.
