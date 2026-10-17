## boot1017g (2026-10-17T15:26:14Z to 2026-10-17T15:31:52Z)

boot1017g = boot1017d + b12x RoCE one-shot all-reduce/all-gather (image vllm-dsv41:exl3b-roce, 5 comm files) + indexer prefill TP-split + PYTORCH_CUDA_ALLOC_CONF=expandable_segments:False, all at once (repo final-best levers minus the EXL3-only pieces). 300K, DSpark k=5, served as deepseek-v4.1-flash and glm-5.3-flash. Full bench on a fresh boot.

Prompt set `v1`, temperature 0, thinking off, streaming; one batch per cell (C streams released together). Short prompts (about 30-120 tokens), 150-256 token budgets.

### Decode: per-stream tok/s after the first token

| category | C1 | C2 | C3 | C4 | C5 | C6 |
|---|---|---|---|---|---|---|
| coding | 76.3 | 68.6 | 61.0 | 61.0 | 54.4 | 51.5 |
| json | 63.2 | 52.8 | 41.6 | 38.1 | 32.8 | 35.1 |
| math | 56.2 | 53.0 | 52.4 | 44.7 | 45.2 | 40.1 |
| reasoning | 55.6 | 41.1 | 35.2 | 33.0 | 30.3 | 30.5 |
| format | 75.8 | 62.1 | 58.1 | 54.0 | 59.5 | 49.8 |
| summary | 35.8 | 30.8 | 24.2 | 21.0 | 19.3 | 19.2 |
| prose | 36.1 | 27.5 | 24.7 | 23.2 | 19.2 | 18.5 |
| narrative | 31.7 | 23.2 | 20.8 | 17.4 | 14.9 | 13.5 |
| counting (ceiling) | 87.1 | 85.5 | 78.0 | 68.3 | 67.7 | 64.0 |

### Aggregate throughput: tok/s across all streams (wall time, TTFT included)

| category | C1 | C2 | C3 | C4 | C5 | C6 |
|---|---|---|---|---|---|---|
| coding | 71.5 | 123.4 | 164.5 | 215.8 | 239.2 | 276.2 |
| json | 52.0 | 84.4 | 102.1 | 128.3 | 132.0 | 167.0 |
| math | 51.7 | 93.8 | 143.3 | 159.3 | 204.6 | 217.6 |
| reasoning | 51.8 | 75.5 | 97.0 | 114.6 | 132.0 | 163.8 |
| format | 63.7 | 96.2 | 137.0 | 168.8 | 226.0 | 239.9 |
| summary | 32.8 | 48.4 | 52.7 | 59.2 | 73.0 | 86.4 |
| prose | 34.0 | 50.9 | 66.8 | 75.8 | 81.8 | 99.0 |
| narrative | 30.3 | 40.0 | 57.2 | 63.7 | 68.4 | 75.9 |
| counting (ceiling) | 81.2 | 157.9 | 216.7 | 253.2 | 315.3 | 355.9 |

### TTFT: mean time to first token (s)

| category | C1 | C2 | C3 | C4 | C5 | C6 |
|---|---|---|---|---|---|---|
| coding | 0.19 | 0.28 | 0.34 | 0.35 | 0.35 | 0.38 |
| json | 0.29 | 0.33 | 0.37 | 0.35 | 0.37 | 0.39 |
| math | 0.33 | 0.37 | 0.34 | 0.36 | 0.37 | 0.37 |
| reasoning | 0.28 | 0.32 | 0.34 | 0.49 | 0.52 | 0.54 |
| format | 0.32 | 0.35 | 0.36 | 0.40 | 0.41 | 0.42 |
| summary | 0.40 | 0.55 | 0.76 | 0.93 | 0.84 | 0.94 |
| prose | 0.23 | 0.26 | 0.27 | 0.30 | 0.31 | 0.29 |
| narrative | 0.23 | 0.28 | 0.29 | 0.31 | 0.32 | 0.30 |
| counting (ceiling) | 0.21 | 0.24 | 0.26 | 0.27 | 0.27 | 0.31 |

### End-to-end per stream: tok/s over the whole request, TTFT included

| category | C1 | C2 | C3 | C4 | C5 | C6 |
|---|---|---|---|---|---|---|
| coding | 71.5 | 62.8 | 55.5 | 55.3 | 49.9 | 47.1 |
| json | 52.1 | 44.2 | 35.5 | 33.2 | 28.9 | 30.5 |
| math | 51.7 | 48.5 | 48.3 | 41.6 | 42.0 | 37.5 |
| reasoning | 51.8 | 38.8 | 33.4 | 30.7 | 28.3 | 28.3 |
| format | 63.7 | 52.3 | 49.6 | 45.3 | 48.5 | 41.8 |
| summary | 32.8 | 27.1 | 21.1 | 17.9 | 16.8 | 16.5 |
| prose | 34.0 | 26.1 | 23.6 | 22.2 | 18.5 | 17.8 |
| narrative | 30.3 | 22.4 | 20.1 | 16.9 | 14.5 | 13.2 |
| counting (ceiling) | 81.3 | 79.0 | 72.3 | 63.7 | 63.1 | 59.4 |

### Cold prefill (unique prompt, 1-token reply; TTFT = whole prefill)

| target | prompt tokens | TTFT (s) | prefill tok/s |
|---|---|---|---|
| 2K | 2,950 | 1.55 | 1,903 |
| 8K | 11,592 | 5.99 | 1,936 |
| 32K | 46,810 | 21.33 | 2,194 |
| 64K | 93,335 | 42.41 | 2,201 |
