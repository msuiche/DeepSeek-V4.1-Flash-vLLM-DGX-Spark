## boot1017a (2026-10-17T14:24:20Z to 2026-10-17T14:31:41Z)

boot1017a: boot 10 recipe (vllm-dsv41:overlay5, patch set dsv41-boot10, DSpark k=5, CUDA graphs FULL_AND_PIECEWISE, Engram on disk + node-local rows on the workers, 300K, gmu 0.80, vision 4 images + tools, thinking off) on DeepSeek-V4.1-Flash-1017, served as deepseek-v4.1-flash and glm-5.3-flash. KV pool 1,316,807 tokens. GPU clocks as found.

Prompt set `v1`, temperature 0, thinking off, streaming; one batch per cell (C streams released together). Short prompts (about 30-120 tokens), 150-256 token budgets.

### Decode: per-stream tok/s after the first token

| category | C1 | C2 | C3 | C4 | C5 | C6 |
|---|---|---|---|---|---|---|
| coding | 70.4 | 47.7 | 45.2 | 51.8 | 42.0 | 38.2 |
| json | 52.8 | 31.9 | 32.5 | 32.6 | 32.8 | 24.0 |
| math | 62.9 | 53.9 | 43.0 | 41.7 | 30.0 | 32.1 |
| reasoning | 46.3 | 40.1 | 30.4 | 31.4 | 24.5 | 22.5 |
| format | 49.2 | 58.9 | 49.1 | 42.4 | 39.2 | 39.4 |
| summary | 31.3 | 26.4 | 17.6 | 19.0 | 18.6 | 15.8 |
| prose | 28.0 | 28.6 | 22.4 | 16.4 | 18.3 | 17.3 |
| narrative | 31.4 | 17.8 | 19.3 | 15.6 | 13.8 | 12.2 |
| counting (ceiling) | 61.5 | 65.3 | 67.7 | 49.5 | 59.1 | 52.0 |

### Aggregate throughput: tok/s across all streams (wall time, TTFT included)

| category | C1 | C2 | C3 | C4 | C5 | C6 |
|---|---|---|---|---|---|---|
| coding | 65.3 | 85.5 | 119.4 | 187.3 | 185.3 | 206.5 |
| json | 44.2 | 52.0 | 80.3 | 109.6 | 132.5 | 115.9 |
| math | 57.3 | 79.7 | 116.0 | 150.9 | 137.8 | 174.3 |
| reasoning | 43.1 | 72.8 | 80.8 | 112.6 | 111.6 | 118.4 |
| format | 41.4 | 91.4 | 121.2 | 128.7 | 153.4 | 181.9 |
| summary | 27.9 | 45.8 | 46.0 | 54.5 | 64.0 | 71.5 |
| prose | 26.0 | 50.4 | 60.2 | 56.7 | 81.1 | 97.0 |
| narrative | 29.9 | 32.5 | 51.1 | 56.3 | 58.9 | 67.1 |
| counting (ceiling) | 56.8 | 121.9 | 186.9 | 185.0 | 273.9 | 290.0 |

### TTFT: mean time to first token (s)

| category | C1 | C2 | C3 | C4 | C5 | C6 |
|---|---|---|---|---|---|---|
| coding | 0.24 | 0.44 | 0.49 | 0.39 | 0.44 | 0.46 |
| json | 0.33 | 0.50 | 0.54 | 0.49 | 0.45 | 0.56 |
| math | 0.33 | 0.36 | 0.40 | 0.43 | 0.46 | 0.47 |
| reasoning | 0.34 | 0.35 | 0.40 | 0.44 | 0.58 | 0.43 |
| format | 0.48 | 0.40 | 0.44 | 0.47 | 0.46 | 0.50 |
| summary | 0.60 | 0.64 | 1.03 | 1.15 | 0.95 | 1.40 |
| prose | 0.36 | 0.38 | 0.31 | 0.43 | 0.37 | 0.36 |
| narrative | 0.29 | 0.42 | 0.36 | 0.42 | 0.39 | 0.37 |
| counting (ceiling) | 0.34 | 0.27 | 0.32 | 0.36 | 0.33 | 0.36 |

### End-to-end per stream: tok/s over the whole request, TTFT included

| category | C1 | C2 | C3 | C4 | C5 | C6 |
|---|---|---|---|---|---|---|
| coding | 65.3 | 43.3 | 40.8 | 47.2 | 38.6 | 35.3 |
| json | 44.2 | 27.0 | 27.1 | 27.7 | 28.1 | 20.9 |
| math | 57.3 | 48.2 | 39.8 | 38.4 | 28.2 | 30.0 |
| reasoning | 43.1 | 37.7 | 28.8 | 29.5 | 23.0 | 21.6 |
| format | 41.4 | 48.9 | 40.9 | 36.2 | 33.9 | 33.6 |
| summary | 27.9 | 23.5 | 15.7 | 16.2 | 16.1 | 13.3 |
| prose | 26.0 | 26.5 | 21.4 | 15.7 | 17.5 | 16.6 |
| narrative | 29.9 | 17.1 | 18.6 | 15.0 | 13.4 | 11.9 |
| counting (ceiling) | 56.8 | 61.0 | 62.4 | 46.3 | 54.8 | 48.4 |

### Cold prefill (unique prompt, 1-token reply; TTFT = whole prefill)

| target | prompt tokens | TTFT (s) | prefill tok/s |
|---|---|---|---|
| 2K | 2,950 | 2.17 | 1,359 |
| 8K | 11,592 | 8.93 | 1,299 |
| 32K | 46,810 | 38.46 | 1,217 |
| 64K | 93,335 | 69.89 | 1,335 |
