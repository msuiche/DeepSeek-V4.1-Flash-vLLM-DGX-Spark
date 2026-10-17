## boot1017c (2026-10-17T14:58:13Z to 2026-10-17T15:01:08Z)

boot1017c = boot1017b + Engram fast staging (patch set dsv41-1017-fast, DSV41_ENGRAM_FAST=1). Screen: C1/C3/C6 + cold prefill 8K/32K on a fresh boot.

Prompt set `v1`, temperature 0, thinking off, streaming; one batch per cell (C streams released together). Short prompts (about 30-120 tokens), 150-256 token budgets.

### Decode: per-stream tok/s after the first token

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 79.1 | 60.5 | 51.3 |
| json | 43.5 | 41.5 | 30.3 |
| math | 59.1 | 46.9 | 37.1 |
| reasoning | 49.4 | 29.5 | 27.8 |
| format | 67.1 | 48.1 | 41.1 |
| summary | 34.7 | 22.5 | 17.6 |
| prose | 34.5 | 24.6 | 19.0 |
| narrative | 25.2 | 16.4 | 14.2 |
| counting (ceiling) | 83.4 | 73.5 | 58.7 |

### Aggregate throughput: tok/s across all streams (wall time, TTFT included)

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 71.6 | 165.7 | 272.6 |
| json | 38.2 | 101.4 | 146.4 |
| math | 54.7 | 127.7 | 203.2 |
| reasoning | 46.9 | 81.0 | 154.9 |
| format | 57.3 | 116.3 | 199.1 |
| summary | 31.2 | 48.6 | 79.7 |
| prose | 32.3 | 68.7 | 97.5 |
| narrative | 23.9 | 45.5 | 73.8 |
| counting (ceiling) | 77.3 | 205.0 | 318.6 |

### TTFT: mean time to first token (s)

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 0.28 | 0.30 | 0.39 |
| json | 0.29 | 0.36 | 0.39 |
| math | 0.29 | 0.34 | 0.37 |
| reasoning | 0.24 | 0.33 | 0.37 |
| format | 0.32 | 0.38 | 0.59 |
| summary | 0.44 | 0.78 | 0.94 |
| prose | 0.26 | 0.28 | 0.31 |
| narrative | 0.38 | 0.31 | 0.33 |
| counting (ceiling) | 0.24 | 0.26 | 0.42 |

### End-to-end per stream: tok/s over the whole request, TTFT included

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 71.6 | 55.8 | 46.8 |
| json | 38.2 | 35.6 | 26.8 |
| math | 54.7 | 43.7 | 34.9 |
| reasoning | 46.9 | 28.3 | 26.6 |
| format | 57.4 | 41.6 | 33.6 |
| summary | 31.2 | 19.1 | 15.6 |
| prose | 32.3 | 23.4 | 18.3 |
| narrative | 23.9 | 16.0 | 13.8 |
| counting (ceiling) | 77.3 | 68.4 | 53.3 |

### Cold prefill (unique prompt, 1-token reply; TTFT = whole prefill)

| target | prompt tokens | TTFT (s) | prefill tok/s |
|---|---|---|---|
| 8K | 11,592 | 6.61 | 1,755 |
| 32K | 46,810 | 25.75 | 1,818 |
