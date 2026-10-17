# Boot log, 2026-10-17 (UTC)

- 13:55 download of `deepseek-ai/DeepSeek-V4.1-Flash-1017` to Reddie `/var/tmp/models` at 433 GiB (`HF_HUB_DISABLE_XET=1`); 14:02:33 done. 83 files, every size equal to the Hugging Face API listing, 510.31 GB, no `.incomplete` files.
- `config.json`, index and tokenizer sha256-identical to the September release; all 48 shards new.
- 14:01-14:03 `vllm-dsv41:overlay5` + `vllm-dsv41:exl3b-roce` saved on Bluey and loaded on Spark4 + Asusi (10.0 GB tar, 18 s load). Base 38 layers identical to Reddie's build; the top 8 layers differ by build timestamp (separate builds of the same script, as on boot 10).
- 14:03-14:10 node-local Engram rows, one worker at a time at 400 MB/s: Spark4 done 14:05:42, Asusi 14:07:54, Bluey 14:10:09; each verified 8,008 rows, 0 mismatches.
- 14:10:26 the previous serving stack stopped (containers kept); 116 GiB available on each node.
- **1017a** (boot 10 recipe): kick 14:11:33, gate PASS (fp16 burn 89.9 / 87.2 / 87.0 / 88.0 TFLOPS at 2171-2184 MHz), all four launched 14:12:16, serving 14:23:25 (712 s). Weights 231.5 s, draft 48.0 s, 81.58 GiB model memory per rank, KV 1,316,807. MemAvailable dipped to about 5 GiB during the load and again during KV sizing / autotune (one FlashInfer runtime JIT, `trtllm_utils`, built fine), 8-9 GiB serving. Postcheck pass; full bench 14:24-14:31.
- **1017b** (+ NCCL 8 channels): kick 14:32:24, serving 14:43:04 (642 s), KV 1,291,500, screen done 14:46:21.
- **1017c** (+ Engram fast staging): kick 14:47:00, serving 14:57:59 (659 s), KV 1,455,239, screen done 15:01:08.
- **1017d** (+ 128 Engram read threads): kick 15:01:31, serving 15:11:58 (627 s), KV 1,382,505, screen done 15:15:03.
- **1017g** (+ b12x RoCE all-reduce / all-gather, indexer TP-split, `expandable_segments:False`): kick 15:15:31, gate PASS (88.7 / 84.3 / 89.5 / 86.6 TFLOPS), all four launched 15:16:29, serving 15:26:00 (629 s). Weights 232.3 s, 81.69 GiB per rank, KV 7.36 GiB = 1,523,740 tokens. Postcheck pass, full bench 15:26-15:31, vision and tools 7/7.
- Deaths: none.
