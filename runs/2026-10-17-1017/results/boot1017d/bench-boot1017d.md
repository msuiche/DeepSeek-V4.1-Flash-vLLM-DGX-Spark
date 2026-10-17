## boot1017d (2026-10-17T15:12:12Z)

boot1017d = boot1017c + 128 Engram read threads (ENGRAM_THREADS=128). Screen: C1/C3/C6 + cold prefill 8K/32K on a fresh boot.

Prompt set `v1` (identical across boots), temperature 0, thinking off. Tokens from the server's usage block; TTFT = first token delta.

### Throughput by concurrency (8 categories; the counting ceiling is excluded)

| C | aggregate tok/s | per-stream tok/s | mean TTFT (s) |
|---|---|---|---|
| C1 | 45.34 | 50.69 | 0.322 |
| C3 | 101.96 | 38.98 | 0.369 |
| C6 | 156.97 | 30.91 | 0.436 |

### Per-stream tok/s by category

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 78.08 | 61.47 | 53.9 |
| json | 59.21 | 43.67 | 33.04 |
| narrative | 29.66 | 20.23 | 13.25 |
| prose | 30.78 | 24.99 | 17.71 |
| math | 52.9 | 47.13 | 38.29 |
| reasoning | 52.19 | 31.08 | 29.39 |
| summary | 33.15 | 24.17 | 17.62 |
| format | 69.57 | 59.1 | 44.12 |
| ceiling_count | 82.71 | 69.32 | 46.57 |

### Cold prefill (unique prefix)

| target | prompt tokens | TTFT (s) | prefill tok/s |
|---|---|---|---|
| 8000 | 11592 | 5.595 | 2071.9 |
| 32000 | 46810 | 26.905 | 1739.8 |
