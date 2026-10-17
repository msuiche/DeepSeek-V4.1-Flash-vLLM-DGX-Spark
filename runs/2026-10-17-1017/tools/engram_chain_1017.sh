#!/bin/bash
# engram_chain_1017.sh (Asusi): node-local Engram rows for DeepSeek-V4.1-Flash-1017, one worker at a time, 400 MB/s.
# Ranges = boot 10's (same engram_num_embeddings [384006168, 384016682], same TP4 layout).
J="ssh -i $HOME/.ssh/id_ed25519_shared -o IdentitiesOnly=yes -o BatchMode=yes -o ConnectTimeout=15"
S=/mnt/reddie-models/DeepSeek-V4.1-Flash-1017
D=/var/tmp/engram-local/DeepSeek-V4.1-Flash-1017
echo "start $(date -u +%T)"
$J tonyspark4@192.168.192.4 "python3 ~/engram_local.py $S $D 1:96000564:192001740 14:96003054:192007016 --mbps=400"; echo "spark4 exit=$? $(date -u +%T)"
python3 ~/engram_local.py $S $D 1:192001740:288003654 14:192007016:288011564 --mbps=400; echo "asusi exit=$? $(date -u +%T)"
$J tonyspark1@192.168.192.1 "python3 ~/engram_local.py $S $D 1:288003654:384006168 14:288011564:384016682 --mbps=400"; echo "bluey exit=$? $(date -u +%T)"
echo "ENGRAM CHAIN DONE $(date -u +%T)"
