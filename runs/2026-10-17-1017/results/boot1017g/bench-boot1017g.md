## boot1017g (2026-10-17T15:26:14Z)

boot1017g = boot1017d + b12x RoCE one-shot all-reduce/all-gather (image vllm-dsv41:exl3b-roce, 5 comm files) + indexer prefill TP-split + PYTORCH_CUDA_ALLOC_CONF=expandable_segments:False, all at once (repo final-best levers minus the EXL3-only pieces). 300K, DSpark k=5, served as deepseek-v4.1-flash and glm-5.3-flash. Full bench on a fresh boot.

Prompt set `v1` (identical across boots), temperature 0, thinking off. Tokens from the server's usage block; TTFT = first token delta.

### Throughput by concurrency (8 categories; the counting ceiling is excluded)

| C | aggregate tok/s | per-stream tok/s | mean TTFT (s) |
|---|---|---|---|
| C1 | 48.48 | 53.83 | 0.284 |
| C2 | 76.57 | 44.89 | 0.342 |
| C3 | 102.58 | 39.74 | 0.384 |
| C4 | 123.19 | 36.55 | 0.436 |
| C5 | 144.61 | 34.45 | 0.435 |
| C6 | 165.72 | 32.28 | 0.454 |

### Per-stream tok/s by category

| category | C1 | C2 | C3 | C4 | C5 | C6 |
|---|---|---|---|---|---|---|
| coding | 76.28 | 68.63 | 61.02 | 60.96 | 54.35 | 51.53 |
| json | 63.16 | 52.83 | 41.61 | 38.1 | 32.77 | 35.15 |
| narrative | 31.69 | 23.19 | 20.8 | 17.43 | 14.92 | 13.5 |
| prose | 36.08 | 27.5 | 24.67 | 23.23 | 19.2 | 18.45 |
| math | 56.23 | 52.96 | 52.39 | 44.67 | 45.25 | 40.11 |
| reasoning | 55.63 | 41.1 | 35.21 | 33.03 | 30.32 | 30.52 |
| summary | 35.79 | 30.84 | 24.16 | 20.97 | 19.25 | 19.25 |
| format | 75.78 | 62.08 | 58.08 | 54.01 | 59.53 | 49.77 |
| ceiling_count | 87.13 | 85.47 | 78.01 | 68.29 | 67.73 | 64.02 |

### Cold prefill (unique prefix)

| target | prompt tokens | TTFT (s) | prefill tok/s |
|---|---|---|---|
| 2000 | 2950 | 1.55 | 1902.8 |
| 8000 | 11592 | 5.986 | 1936.5 |
| 32000 | 46810 | 21.334 | 2194.1 |
| 64000 | 93335 | 42.411 | 2200.7 |
