import json
import time
from pathlib import Path

import numpy as np
import pandas as pd
from lightgbm import LGBMClassifier, early_stopping
from sklearn.metrics import (
    accuracy_score, f1_score, precision_score, recall_score, roc_auc_score
)
from sklearn.model_selection import train_test_split

dataset = Path("creditcard.csv")
if not dataset.exists():
    raise SystemExit("Chưa có creditcard.csv. Hãy tải dataset vào ~/ml-benchmark.")

start = time.perf_counter()
df = pd.read_csv(dataset)
load_seconds = time.perf_counter() - start

X = df.drop(columns=["Class"])
y = df["Class"]

X_train, X_remaining, y_train, y_remaining = train_test_split(
    X, y, test_size=0.3, stratify=y, random_state=42
)
X_valid, X_test, y_valid, y_test = train_test_split(
    X_remaining, y_remaining,
    test_size=2/3, stratify=y_remaining, random_state=42
)

model = LGBMClassifier(
    n_estimators=1000,
    learning_rate=0.05,
    random_state=42,
    n_jobs=2,
    verbosity=-1
)

start = time.perf_counter()
model.fit(
    X_train, y_train,
    eval_set=[(X_valid, y_valid)],
    eval_metric="auc",
    callbacks=[early_stopping(50, first_metric_only=True, verbose=False)]
)
training_seconds = time.perf_counter() - start

probabilities = model.predict_proba(X_test)[:, 1]
predictions = (probabilities >= 0.5).astype(int)

# Warm up before timing inference.
one_row = X_test.iloc[:1]
batch = X_test.iloc[:1000]
model.predict_proba(one_row)
model.predict_proba(batch)

single_times = []
for _ in range(100):
    start = time.perf_counter()
    model.predict_proba(one_row)
    single_times.append(time.perf_counter() - start)

batch_times = []
for _ in range(20):
    start = time.perf_counter()
    model.predict_proba(batch)
    batch_times.append(time.perf_counter() - start)

batch_seconds = float(np.median(batch_times))
result = {
    "rows": len(df),
    "train_rows": len(X_train),
    "validation_rows": len(X_valid),
    "test_rows": len(X_test),
    "load_data_seconds": load_seconds,
    "training_seconds": training_seconds,
    "best_iteration": model.best_iteration_,
    "auc_roc": roc_auc_score(y_test, probabilities),
    "accuracy": accuracy_score(y_test, predictions),
    "f1_score": f1_score(y_test, predictions, zero_division=0),
    "precision": precision_score(y_test, predictions, zero_division=0),
    "recall": recall_score(y_test, predictions, zero_division=0),
    "inference_latency_1_row_ms": float(np.median(single_times) * 1000),
    "inference_batch_rows": len(batch),
    "inference_1000_rows_seconds": batch_seconds,
    "inference_throughput_rows_per_second": len(batch) / batch_seconds,
    "decision_threshold": 0.5,
    "random_seed": 42
}

output = json.dumps(result, indent=2)
Path("benchmark_result.json").write_text(output + "\n", encoding="utf-8")
print(output)
print("\nĐã lưu benchmark_result.json")
