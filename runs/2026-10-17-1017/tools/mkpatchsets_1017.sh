#!/bin/bash
# mkpatchsets_1017.sh: lever patch sets for the stock-weights 1017 lane, built from files already on this node.
#   dsv41-1017-fast     = dsv41-boot10 + speed-run Engram fast staging engram.py (dsv41-exl3-sr1, e84c7305)
#   dsv41-1017-roce     = dsv41-1017-fast + the 5 b12x RoCE vLLM files (dsv41-exl3-sr2roce)
#   dsv41-1017-roce-idx = dsv41-1017-roce + indexer prefill TP-split sparse_attn_indexer.py (dsv41-exl3-sr2roce, f87bc894)
set -e
P=$HOME/patches
B=$P/dsv41-boot10
for d in dsv41-1017-fast dsv41-1017-roce dsv41-1017-roce-idx; do mkdir -p $P/$d; done
for f in attention.py engram.py flashinfer_sparse.py model_state.py sparse_attn_indexer.py sparse_swa.py weight_utils.py mounts.txt; do cp -p $B/$f $P/dsv41-1017-fast/$f; done
cp -p $P/dsv41-exl3-sr1/engram.py $P/dsv41-1017-fast/engram.py
cp -p $P/dsv41-1017-fast/* $P/dsv41-1017-roce/
for f in b12x_roce_all_reduce.py cuda_communicator.py parallel_state.py envs.py gpu_worker.py; do
  cp -p $P/dsv41-exl3-sr2roce/$f $P/dsv41-1017-roce/$f
  grep "^$f " $P/dsv41-exl3-sr2roce/mounts.txt >> $P/dsv41-1017-roce/mounts.txt
done
cp -p $P/dsv41-1017-roce/* $P/dsv41-1017-roce-idx/
cp -p $P/dsv41-exl3-sr2roce/sparse_attn_indexer.py $P/dsv41-1017-roce-idx/sparse_attn_indexer.py
for d in dsv41-1017-fast dsv41-1017-roce dsv41-1017-roce-idx; do
  echo "$d $(cd $P/$d && md5sum * | cut -c1-8,33- | tr '\n' ' ')"
done
