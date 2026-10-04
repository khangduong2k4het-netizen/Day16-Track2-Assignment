#!/usr/bin/env bash
set -euo pipefail
repo=/mnt/c/Users/khang/Downloads/gitlabVin/Day16-Track2-DuongDatKhang-2A202602624-Assignment
infra="$HOME/labs/Day16-Track2-DuongDatKhang-2A202602624-Assignment/terraform"
cd "$infra"
export AWS_PROFILE=ai-lab AWS_DEFAULT_REGION=us-east-1 AWS_PAGER=""
aws ec2 describe-instances --query 'Reservations[].Instances[].{Id:InstanceId,State:State.Name,Type:InstanceType,Private:PrivateIpAddress,Tags:Tags}' --output json > "$repo/submission/ec2-status.json"
ssh -F ssh_config -o BatchMode=yes -o ConnectTimeout=20 lab-cpu 'cd ~/ml-benchmark; date -Is; hostname; echo "$ . .venv/bin/activate && python3 benchmark.py"; . .venv/bin/activate; python3 benchmark.py' | tee "$repo/submission/benchmark-output.txt"
scp -F ssh_config lab-cpu:ml-benchmark/benchmark_result.json "$repo/submission/benchmark_result.json"
ssh -F ssh_config -o BatchMode=yes lab-cpu 'date -Is; hostname; echo "$ top -b -n 1"; top -b -n 1 | head -20; echo "$ free -h"; free -h; echo "$ ip -s link"; ip -s link' > "$repo/submission/resource_usage.txt"
aws ce get-cost-and-usage --time-period Start=2026-10-01,End=2026-10-05 --granularity DAILY --metrics UnblendedCost --group-by Type=DIMENSION,Key=SERVICE --output json > "$repo/submission/aws-costs.json" 2> "$repo/submission/aws-costs-error.txt" || true
