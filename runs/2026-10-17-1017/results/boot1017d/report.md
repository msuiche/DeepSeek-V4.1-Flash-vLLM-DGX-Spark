## boot1017d (2026-10-17T15:12:12Z to 2026-10-17T15:15:03Z)

boot1017d = boot1017c + 128 Engram read threads (ENGRAM_THREADS=128). Screen: C1/C3/C6 + cold prefill 8K/32K on a fresh boot.

Prompt set `v1`, temperature 0, thinking off, streaming; one batch per cell (C streams released together). Short prompts (about 30-120 tokens), 150-256 token budgets.

### Decode: per-stream tok/s after the first token

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 78.1 | 61.5 | 53.9 |
| json | 59.2 | 43.7 | 33.0 |
| math | 52.9 | 47.1 | 38.3 |
| reasoning | 52.2 | 31.1 | 29.4 |
| format | 69.6 | 59.1 | 44.1 |
| summary | 33.1 | 24.2 | 17.6 |
| prose | 30.8 | 25.0 | 17.7 |
| narrative | 29.7 | 20.2 | 13.2 |
| counting (ceiling) | 82.7 | 69.3 | 46.6 |

### Aggregate throughput: tok/s across all streams (wall time, TTFT included)

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 72.3 | 167.7 | 290.1 |
| json | 49.5 | 107.8 | 162.0 |
| math | 48.2 | 128.2 | 209.2 |
| reasoning | 48.7 | 85.5 | 162.3 |
| format | 57.6 | 143.0 | 192.2 |
| summary | 29.1 | 58.1 | 74.8 |
| prose | 29.1 | 66.8 | 95.3 |
| narrative | 28.3 | 58.6 | 69.7 |
| counting (ceiling) | 76.6 | 192.7 | 261.2 |

### TTFT: mean time to first token (s)

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 0.22 | 0.30 | 0.34 |
| json | 0.29 | 0.35 | 0.39 |
| math | 0.39 | 0.37 | 0.37 |
| reasoning | 0.29 | 0.34 | 0.36 |
| format | 0.38 | 0.37 | 0.43 |
| summary | 0.47 | 0.65 | 0.94 |
| prose | 0.26 | 0.30 | 0.35 |
| narrative | 0.27 | 0.27 | 0.32 |
| counting (ceiling) | 0.24 | 0.25 | 0.38 |

### End-to-end per stream: tok/s over the whole request, TTFT included

| category | C1 | C3 | C6 |
|---|---|---|---|
| coding | 72.3 | 56.5 | 49.6 |
| json | 49.6 | 37.4 | 28.9 |
| math | 48.2 | 43.5 | 35.9 |
| reasoning | 48.7 | 29.7 | 28.1 |
| format | 57.6 | 49.3 | 37.6 |
| summary | 29.1 | 21.3 | 15.4 |
| prose | 29.1 | 23.7 | 17.0 |
| narrative | 28.3 | 19.7 | 13.0 |
| counting (ceiling) | 76.6 | 64.9 | 43.6 |

### Cold prefill (unique prompt, 1-token reply; TTFT = whole prefill)

| target | prompt tokens | TTFT (s) | prefill tok/s |
|---|---|---|---|
| 8K | 11,592 | 5.59 | 2,072 |
| 32K | 46,810 | 26.91 | 1,740 |
