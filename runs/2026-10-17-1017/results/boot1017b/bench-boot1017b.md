## boot1017b (2026-10-17T14:43:19Z)

boot1017b = boot1017a + NCCL_MAX_NCHANNELS=8. Screen: C1/C3/C6 + cold prefill 8K/32K on a fresh boot.

Prompt set `v1` (identical across boots), temperature 0, thinking off. Tokens from the server's usage block; TTFT = first token delta.

### Throughput by concurrency (8 categories; the counting ceiling is excluded)

| C | aggregate tok/s | per-stream tok/s | mean TTFT (s) |
|---|---|---|---|
| C1 | 46.37 | 52.0 | 0.341 |
| C3 | 93.75 | 35.71 | 0.401 |
| C6 | 147.23 | 28.9 | 0.493 |

### Per-stream tok/s by category

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 73.03 | 59.56 | 47.63 |
| json | 59.79 | 39.98 | 32.3 |
| narrative | 29.25 | 17.81 | 13.35 |
| prose | 35.94 | 24.12 | 17.89 |
| math | 61.89 | 45.55 | 35.19 |
| reasoning | 52.1 | 33.95 | 24.45 |
| summary | 30.95 | 21.04 | 16.8 |
| format | 73.02 | 43.7 | 43.56 |
| ceiling_count | 85.0 | 64.98 | 59.2 |

### Cold prefill (unique prefix)

| target | prompt tokens | TTFT (s) | prefill tok/s |
|---|---|---|---|
| 8000 | 11592 | 7.695 | 1506.4 |
| 32000 | 46810 | 31.607 | 1481.0 |
