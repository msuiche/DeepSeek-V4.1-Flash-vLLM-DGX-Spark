## boot1017c (2026-10-17T14:58:13Z)

boot1017c = boot1017b + Engram fast staging (patch set dsv41-1017-fast, DSV41_ENGRAM_FAST=1). Screen: C1/C3/C6 + cold prefill 8K/32K on a fresh boot.

Prompt set `v1` (identical across boots), temperature 0, thinking off. Tokens from the server's usage block; TTFT = first token delta.

### Throughput by concurrency (8 categories; the counting ceiling is excluded)

| C | aggregate tok/s | per-stream tok/s | mean TTFT (s) |
|---|---|---|---|
| C1 | 44.51 | 49.07 | 0.311 |
| C3 | 94.37 | 36.25 | 0.383 |
| C6 | 153.39 | 29.79 | 0.461 |

### Per-stream tok/s by category

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 79.09 | 60.51 | 51.27 |
| json | 43.49 | 41.49 | 30.33 |
| narrative | 25.17 | 16.42 | 14.17 |
| prose | 34.53 | 24.57 | 18.97 |
| math | 59.13 | 46.91 | 37.15 |
| reasoning | 49.35 | 29.52 | 27.82 |
| summary | 34.71 | 22.52 | 17.59 |
| format | 67.07 | 48.06 | 41.05 |
| ceiling_count | 83.44 | 73.47 | 58.67 |

### Cold prefill (unique prefix)

| target | prompt tokens | TTFT (s) | prefill tok/s |
|---|---|---|---|
| 8000 | 11592 | 6.606 | 1754.8 |
| 32000 | 46810 | 25.748 | 1818.0 |
