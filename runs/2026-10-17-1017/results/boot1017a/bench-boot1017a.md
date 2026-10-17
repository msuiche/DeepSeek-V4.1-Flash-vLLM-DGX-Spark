## boot1017a (2026-10-17T14:24:20Z)

boot1017a: boot 10 recipe (vllm-dsv41:overlay5, patch set dsv41-boot10, DSpark k=5, CUDA graphs FULL_AND_PIECEWISE, Engram on disk + node-local rows on the workers, 300K, gmu 0.80, vision 4 images + tools, thinking off) on DeepSeek-V4.1-Flash-1017, served as deepseek-v4.1-flash and glm-5.3-flash. KV pool 1,316,807 tokens. GPU clocks as found.

Prompt set `v1` (identical across boots), temperature 0, thinking off. Tokens from the server's usage block; TTFT = first token delta.

### Throughput by concurrency (8 categories; the counting ceiling is excluded)

| C | aggregate tok/s | per-stream tok/s | mean TTFT (s) |
|---|---|---|---|
| C1 | 41.88 | 46.54 | 0.371 |
| C2 | 63.76 | 38.16 | 0.438 |
| C3 | 84.38 | 32.43 | 0.497 |
| C4 | 107.08 | 31.37 | 0.528 |
| C5 | 115.57 | 27.41 | 0.511 |
| C6 | 129.08 | 25.2 | 0.571 |

### Per-stream tok/s by category

| category | C1 | C2 | C3 | C4 | C5 | C6 |
|---|---|---|---|---|---|---|
| coding | 70.44 | 47.71 | 45.16 | 51.82 | 41.98 | 38.23 |
| json | 52.76 | 31.89 | 32.53 | 32.6 | 32.76 | 24.02 |
| narrative | 31.41 | 17.81 | 19.3 | 15.59 | 13.78 | 12.2 |
| prose | 27.95 | 28.57 | 22.42 | 16.45 | 18.34 | 17.32 |
| math | 62.95 | 53.95 | 42.96 | 41.7 | 30.04 | 32.13 |
| reasoning | 46.25 | 40.1 | 30.4 | 31.42 | 24.53 | 22.49 |
| summary | 31.34 | 26.37 | 17.57 | 18.96 | 18.58 | 15.78 |
| format | 49.21 | 58.89 | 49.08 | 42.4 | 39.24 | 39.4 |
| ceiling_count | 61.55 | 65.25 | 67.68 | 49.5 | 59.11 | 51.99 |

### Cold prefill (unique prefix)

| target | prompt tokens | TTFT (s) | prefill tok/s |
|---|---|---|---|
| 2000 | 2950 | 2.171 | 1358.7 |
| 8000 | 11592 | 8.926 | 1298.7 |
| 32000 | 46810 | 38.457 | 1217.2 |
| 64000 | 93335 | 69.892 | 1335.4 |
