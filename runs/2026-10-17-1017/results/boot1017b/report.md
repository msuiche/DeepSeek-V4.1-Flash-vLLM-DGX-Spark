## boot1017b (2026-10-17T14:43:19Z to 2026-10-17T14:46:21Z)

boot1017b = boot1017a + NCCL_MAX_NCHANNELS=8. Screen: C1/C3/C6 + cold prefill 8K/32K on a fresh boot.

Prompt set `v1`, temperature 0, thinking off, streaming; one batch per cell (C streams released together). Short prompts (about 30-120 tokens), 150-256 token budgets.

### Decode: per-stream tok/s after the first token

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 73.0 | 59.6 | 47.6 |
| json | 59.8 | 40.0 | 32.3 |
| math | 61.9 | 45.6 | 35.2 |
| reasoning | 52.1 | 34.0 | 24.4 |
| format | 73.0 | 43.7 | 43.6 |
| summary | 30.9 | 21.0 | 16.8 |
| prose | 35.9 | 24.1 | 17.9 |
| narrative | 29.3 | 17.8 | 13.3 |
| counting (ceiling) | 85.0 | 65.0 | 59.2 |

### Aggregate throughput: tok/s across all streams (wall time, TTFT included)

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 66.5 | 163.1 | 253.0 |
| json | 49.1 | 97.6 | 153.8 |
| math | 57.0 | 123.9 | 190.6 |
| reasoning | 48.5 | 90.7 | 131.2 |
| format | 61.6 | 103.6 | 208.4 |
| summary | 26.7 | 55.6 | 72.1 |
| prose | 33.7 | 65.1 | 94.2 |
| narrative | 27.9 | 50.5 | 74.6 |
| counting (ceiling) | 78.7 | 181.1 | 331.4 |

### TTFT: mean time to first token (s)

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 0.28 | 0.30 | 0.37 |
| json | 0.32 | 0.36 | 0.41 |
| math | 0.30 | 0.35 | 0.41 |
| reasoning | 0.30 | 0.35 | 0.53 |
| format | 0.32 | 0.51 | 0.45 |
| summary | 0.67 | 0.75 | 1.13 |
| prose | 0.26 | 0.28 | 0.31 |
| narrative | 0.28 | 0.30 | 0.33 |
| counting (ceiling) | 0.24 | 0.26 | 0.30 |

### End-to-end per stream: tok/s over the whole request, TTFT included

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 66.5 | 54.9 | 44.0 |
| json | 49.1 | 34.4 | 28.2 |
| math | 57.0 | 42.3 | 33.0 |
| reasoning | 48.5 | 32.2 | 23.1 |
| format | 61.6 | 36.3 | 36.9 |
| summary | 26.7 | 19.1 | 14.6 |
| prose | 33.7 | 23.0 | 17.2 |
| narrative | 27.9 | 17.3 | 13.0 |
| counting (ceiling) | 78.7 | 60.9 | 55.3 |

### Cold prefill (unique prompt, 1-token reply; TTFT = whole prefill)

| target | prompt tokens | TTFT (s) | prefill tok/s |
|---|---|---|---|
| 8K | 11,592 | 7.70 | 1,506 |
| 32K | 46,810 | 31.61 | 1,481 |
