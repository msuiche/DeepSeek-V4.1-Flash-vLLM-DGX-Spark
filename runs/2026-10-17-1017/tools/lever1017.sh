#!/bin/bash
# lever1017.sh N [MODE] [NOTES] (root on Reddie): restore_1017.sh N, then bench1017.sh bootN MODE (default screen).
N=$1; M=${2:-screen}; O=/var/tmp/restore-run-$N.out
bash /root/restore_1017.sh $N > $O 2>&1; rc=$?
if [ $rc = 0 ]; then bash /root/bench1017.sh boot$N $M "$3"; echo "LEVER $N BENCH DONE $(date -u +%T)" >> $O
else echo "LEVER $N RESTORE FAILED rc=$rc $(date -u +%T)" >> $O; fi
