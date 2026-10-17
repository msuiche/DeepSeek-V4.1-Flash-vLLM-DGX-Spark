# DeepSeek-V4.1-Flash-1017 on 4x DGX Spark (TP4), 2026-10-17

`deepseek-ai/DeepSeek-V4.1-Flash-1017` came out on 2026-10-17. We swapped it into the same four Sparks that run boot 10. Then we stacked the 2026-09-14 speed-run levers that don't depend on the EXL3 pack.

**Status: serving since 15:26 UTC on `boot1017g`.**
- Context: 300K.
- KV pool: **1,523,740 tokens** (5.08x at 300K).
- DSpark k=5, CUDA graphs FULL_AND_PIECEWISE.
- Vision (4 images) and tool calling are on. Thinking is off by default.
- No boot died today.

## The checkpoint

The 1017 release keeps the same layout as the September release; only the weights changed:
- **Identical to the release** (by Hugging Face sha256): `config.json`, `model.safetensors.index.json`, `tokenizer.json`, `tokenizer_config.json`, `encoding/` and `inference/`.
- **New:** all 48 safetensors shards, including the two Engram tables (shards 47/48). So the node-local Engram copies had to be rebuilt.
- Same 510.3 GB, `model_type deepseek_v41`, FP8 32x32 blocks with FP4 experts, and `engram_num_embeddings [384006168, 384016682]`. Boot 10's Engram row ranges apply unchanged.
- No `chat_template.jinja` ships with 1017. vLLM's `deepseek_v41` tokenizer mode uses its bundled encoder, so nothing is needed.

## What changed vs boot 10

Only the launch inputs changed ([launch-diff-vs-boot10.diff](launch-diff-vs-boot10.diff)):
- **`launch/dsv41-tp4-1017.sh`** = `launch/dsv41-tp4.sh` plus two knobs:
  - `MODEL_DIR` (default `DeepSeek-V4.1-Flash-1017`);
  - `SERVED_NAMES` (space-separated, so one endpoint can answer to two model ids).
- **`launch/boot_dsv41_1017.sh`** = `launch/boot_dsv41.sh`. It also forwards `MODEL_DIR`, `ENGRAM_LOCAL_HOST` and `SERVED_NAMES`, and calls the launcher above.
- **`launch/boot1017a-go.sh`** = boot 10's knobs, pointed at the 1017 folder and `/var/tmp/engram-local/DeepSeek-V4.1-Flash-1017`.
- **Images:** `vllm-dsv41:overlay5` (boot 10) and `vllm-dsv41:exl3b-roce` (for the RoCE all-reduce). Both were loaded onto Spark4 and Asusi from Bluey (`tools/imgcopy_1017.sh`).
- **Engram rows:** node-local copies for ranks 1-3 (`tools/engram_chain_1017.sh`, `engram_local.py` at 400 MB/s, ~47 GiB per worker). Each copy was verified: 8,008 rows checked, 0 mismatches.

## Boots (one change per boot through d, then the remaining levers together)

Cells are 8-category means. 1017a and 1017g ran the full bench; b, c and d ran the screen (C1/C3/C6 plus cold prefill at 8K/32K). Every run was the first bench on a fresh boot, so no prompt hit the prefix cache.

| boot | change | KV pool (300K) | C1 agg | C3 agg | C6 agg | prefill 8K | prefill 32K |
|---|---|---|---|---|---|---|---|
| 1017a | boot 10 recipe on the 1017 weights | 1,316,807 | 41.9 | 84.4 | 129.1 | 1,299 | 1,217 |
| 1017b | + `NCCL_MAX_NCHANNELS=8` | 1,291,500 | 46.4 | 93.8 | 147.2 | 1,506 | 1,481 |
| 1017c | + Engram fast staging (`DSV41_ENGRAM_FAST=1`) | 1,455,239 | 44.5 | 94.4 | 153.4 | 1,755 | 1,818 |
| 1017d | + 128 Engram read threads | 1,382,505 | 45.3 | 102.0 | 157.0 | 2,072 | 1,740 |
| **1017g** | + b12x RoCE one-shot all-reduce/all-gather, indexer prefill TP-split, `expandable_segments:False` | **1,523,740** | **48.5** | **102.6** | **165.7** | **1,937** | **2,194** |

- The 500K step (`boot1017h-go.sh`) was prepared but not booted: this deployment stays at 300K.
- SEQS 16 from the 09-19 run was not applied.
- Left out because they only apply to the EXL3 pack:
  - the cuda-exl3 GLU clamp (`exl3b-roce-lim`);
  - the EXL3 MoE files;
  - virtual heads.

## Serving config (`boot1017g`), full bench

Prompt set v1, temperature 0, thinking off, streaming. Tokens are counted from the server's usage block.

| | boot 10 (2026-09-10) | 1017a (boot 10 recipe) | **1017g (serving)** | speed run final-best (EXL3 pack, 09-14) |
|---|---|---|---|---|
| C1 aggregate tok/s | 38.0 | 41.9 | **48.5** | 58.3 |
| C2 | 64.3 | 63.8 | **76.6** | 96.0 |
| C3 | 78.7 | 84.4 | **102.6** | 128.3 |
| C4 | 85.7 | 107.1 | **123.2** | 152.4 |
| C5 | 114.2 | 115.6 | **144.6** | 171.1 |
| C6 | 131.9 | 129.1 | **165.7** | 190.0 |
| C1 per-stream | 43.1 | 46.5 | **53.8** | 63.7 |
| TTFT C1 / C6 (s) | 0.44 / 0.50 | 0.37 / 0.57 | **0.28 / 0.45** | 0.22 / 0.40 |
| Cold prefill, 2,950 tokens | 902 | 1,359 | **1,903** | 1,836 |
| Cold prefill, 11,592 tokens | 1,027 | 1,299 | **1,937** | 1,997 |
| Cold prefill, 46,810 tokens | 1,539 | 1,217 | **2,194** | 2,014 |
| Cold prefill, 93,335 tokens | 1,194 | 1,335 | **2,201** | 2,032 |
| KV pool | 1,070,168 | 1,316,807 | **1,523,740** | 3,757,748 |

**Per-stream C1 by category (tok/s, one request at a time, after the first token):**

| category | boot 10 | 1017a | **1017g** | speed run final-best (EXL3) |
|---|---|---|---|---|
| code | 73.8 | 70.4 | **76.3** | 85.2 |
| format (Markdown table) | 55.4 | 49.2 | **75.8** | 85.8 |
| JSON | 52.1 | 52.8 | **63.2** | 65.0 |
| math | 50.9 | 63.0 | **56.2** | 87.9 |
| reasoning | 37.8 | 46.2 | **55.6** | 72.8 |
| prose | 24.4 | 27.9 | **36.1** | 41.0 |
| summary | 25.7 | 31.3 | **35.8** | 36.0 |
| narrative | 24.9 | 31.4 | **31.7** | 36.3 |
| counting (peak ceiling only, max draft acceptance) | 62.2 | 61.5 | 87.1 | 112.9 |

- **Reading the per-category rows:**
  - Single C1 cells move about 15% between runs. JSON at C1 went 59.8 -> 43.5 -> 59.2 across boots b, c and d with no related change.
  - Math is the one category below 1017a. Read the aggregates.
- **Why the EXL3 lane is still faster at decode:**
  - Its 3.5 bpw experts are 245 GB against the release's 296 GB, so each token reads about 17% fewer bytes.
  - Its KV pool is larger because the weights are 12-25 GiB smaller per Spark.
  - On stock 1017 weights, prefill now matches or beats it.
- **DSpark acceptance on 1017**, measured over the whole 1017a bench:
  - 53.0% of drafted tokens accepted (22,543 of 42,570), a mean of 3.65 tokens per step (maximum 6 at k=5).
  - Code and counting windows run 5.2-5.7 tokens per step; prose windows run 2.2-2.6.
  - The draft is the checkpoint's own 97 DSpark tensors.

Detailed tables: [results/boot1017g/report-vs-boot10.md](results/boot1017g/report-vs-boot10.md), [results/boot1017g/report-vs-speedrun-final-best.md](results/boot1017g/report-vs-speedrun-final-best.md).

**Checks on `boot1017g`:**
- vision and tools 7/7 ([results/boot1017g/vision-tools.txt](results/boot1017g/vision-tools.txt));
- count-to-100 correct;
- every worker logs `read from node-local /engram-local`;
- RoCEnante all-reduce and all-gather live, with NCCL as the fallback above 2 MB;
- `DSV41_INDEXER_TP_SPLIT on`;
- 11-13 GiB available per node while serving, after the bench (1017a: 8-9 GiB).

## 69-scenario tool eval (`boot1017g`, thinking off)

The same `2wild-model-eval/run_eval.py` command as boot 10 (`EVAL_THINKING=off`, `--timeout 300`), run against the live endpoint ([results/eval69](results/eval69/eval69-boot1017g.md)):

| | boot 10 (09-10) | **1017g** |
|---|---|---|
| Quality | 98.6 (136/138) | **98.6 (136/138)** |
| Pass / partial / fail | 67 / 2 / 0 | **67 / 2 / 0** |
| Responsiveness (median turn) | 94.3 (1,620 ms) | **96.0 (1,287 ms)** |
| Deployability | 97.3 | **97.8** |
| tok/s during the suite | 41.6 | **43.0** |

The two partials are the same in both runs:
- TC-44: a reasonable guess without confirming intent.
- TC-67: guessed a ticker without resolving the pronoun.

## How to run it

On Reddie as root:

```bash
bash /root/restore_1017.sh 1017g     # serving config (about 11 min to serving)
bash /root/restore_1017.sh 1017a     # boot 10 recipe on the 1017 weights
```

`restore_1017.sh` does the following:
1. `launch.sh` stops `vllm_dsv41` on all four nodes, head first, and saves the logs.
2. `prelaunch-1017.sh` gates the launch. It refuses to launch when:
   - another serving stack still holds the GPUs;
   - a worker lacks the 1017 NFS model or its node-local 1017 Engram copy;
   - a staged launcher or patch differs from Reddie's;
   - an image is missing;
   - a GPU burns under 50 TFLOPS.
   It reads the patch set and image from the go script.
3. Worker-first fan-out from Asusi.
4. Polls until the head logs `Application startup complete`.
5. Runs `postcheck1017.sh`: Engram path per rank, KV pool, served names, count, code, a tool call and an image.

Benchmarks:
- full bench: `bash /root/bench1017.sh <label> full`;
- screen: `bash /root/bench1017.sh <label> screen`;
- boot plus screen: `bash /root/lever1017.sh <N> [screen|full]`.

**Patch sets** (`tools/mkpatchsets_1017.sh` builds them from files already on each node; md5s identical on all four):

| set | contents |
|---|---|
| `dsv41-1017-fast` | `dsv41-boot10` with the speed-run `engram.py` (e84c7305) |
| `dsv41-1017-roce` | + `b12x_roce_all_reduce.py`, `cuda_communicator.py`, `parallel_state.py`, `envs.py`, `gpu_worker.py` (from `dsv41-exl3-sr2roce`) |
| `dsv41-1017-roce-idx` | + `sparse_attn_indexer.py` with the indexer TP-split (f87bc894) |

Rollbacks without a rebuild:
- `VLLM_ENABLE_ROCE_ALLREDUCE=0`
- `DSV41_INDEXER_TP_SPLIT=0`
- `DSV41_ENGRAM_FAST=0`

## Files

- `launch/`: the launcher, the fan-out and the go scripts `boot1017a` to `boot1017h`. Each go script lists its one change at the bottom.
- `tools/`: the restore, gate, postcheck, bench and lever scripts, the image copy, the Engram chain, the patch-set builder and `screencmp.py`.
- `results/eval69/`: the 69-scenario scorecard, the run script and the log.
- `results/boot1017{a,b,c,d,g}/`: bench JSON and markdown, reports, postcheck, restore log and head log. `boot1017g` also has `args.json`, `env.txt` and `vision-tools.txt`.
- [BOOTLOG.md](BOOTLOG.md): timestamps for every step.

## Credits

The levers are the same as in the 2026-09-14 speed run:
- **bot-lab-21:** the `NCCL_MAX_NCHANNELS=8` measurement.
- **Jason @original-el8 and Luke Alonso @lukealonso** (local-inference-lab/b12x): the RoCEnante one-shot RoCE collectives and their vLLM integration.
- **ecohash-co and hyudryu:** the `expandable_segments` finding (issue #2). koldfrontier's caveat from issue #9 does not apply here, because decode all-reduces run on the RoCE path.
- **DeepSeek:** the 1017 checkpoint.
- **vLLM team:** `dsv41-feat`.
