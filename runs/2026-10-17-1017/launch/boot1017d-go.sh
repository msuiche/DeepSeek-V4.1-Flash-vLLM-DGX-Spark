#!/bin/bash
# boot1017d: stacked levers on top of boot1017a (one change per boot, listed at the bottom).
# boot1017a = boot 10 exactly (vllm-dsv41:overlay5, patch set dsv41-boot10, DSpark k=5, CUDA graphs FULL_AND_PIECEWISE,
#   vision + tools on, thinking off, 300K, gmu 0.80, node-local Engram rows on the workers) with the model swapped:
#   DeepSeek-V4.1-Flash-1017 (config.json, index and tokenizer byte-identical to the release; all 48 shards new),
#   Engram rows from /var/tmp/engram-local/DeepSeek-V4.1-Flash-1017, served as deepseek-v4.1-flash AND glm-5.3-flash.
#   EXP_NAME stays boot10 so the compile / JIT caches are reused.
export EXP_NAME=boot10 IMAGE=vllm-dsv41:overlay5 PATCH_NAME=dsv41-boot10 ENGRAM_LOCAL=1 GMU=0.80 MAXLEN=300000 SEQS=8 EAGER=0 CUDAGRAPH_MODE=FULL_AND_PIECEWISE SPEC=dspark SPEC_K=5 ENGRAM_DISK=1 TEXT_ONLY=0 THINKING=false PARSERS=1 RUST_FE=0
export MODEL_DIR=DeepSeek-V4.1-Flash-1017 ENGRAM_LOCAL_HOST=/var/tmp/engram-local/DeepSeek-V4.1-Flash-1017 SERVED_NAMES="deepseek-v4.1-flash glm-5.3-flash"
export NCCL_EXTRA="-e MAX_JOBS=2 -e FLASHINFER_NVCC_THREADS=1 -e VLLM_USE_FLASHINFER_SAMPLER=0 -e TILELANG_CACHE_DIR=/cache/tilelang -e TRITON_CACHE_DIR=/cache/triton"
export VLLM_EXTRA='--block-size 128 --limit-mm-per-prompt {"image":4} --mm-processor-cache-gb 1'
# ---- boot1017b vs boot1017a: + NCCL_MAX_NCHANNELS=8 (speed run E01, bot-lab-21)
export NCCL_EXTRA="$NCCL_EXTRA -e NCCL_MAX_NCHANNELS=8"
# ---- boot1017c vs boot1017b: + Engram fast staging (speed run E02: patch set dsv41-1017-fast = dsv41-boot10 + sr1 engram.py, DSV41_ENGRAM_FAST=1)
export PATCH_NAME=dsv41-1017-fast
export NCCL_EXTRA="$NCCL_EXTRA -e DSV41_ENGRAM_FAST=1"
# ---- boot1017d vs boot1017c: + 128 Engram read threads (speed run E09)
export ENGRAM_THREADS=128
echo "boot1017d go $(date -u +%FT%TZ) model=$MODEL_DIR names=[$SERVED_NAMES] image=$IMAGE patch=$PATCH_NAME threads=${ENGRAM_THREADS:-32} extra=[$NCCL_EXTRA] gmu=$GMU maxlen=$MAXLEN seqs=$SEQS spec=$SPEC k=$SPEC_K eager=$EAGER cg=$CUDAGRAPH_MODE"
bash $HOME/boot_dsv41_1017.sh
echo "boot_dsv41 exit=$? $(date -u +%FT%TZ)"
