#!/bin/bash
# bench1017.sh LABEL [full|screen] [NOTES] (root on Reddie): v41bench.py against 127.0.0.1:8000.
#   full   = C1-C6, 8 categories + counting ceiling, cold prefill 2K/8K/32K/64K (the standard bench)
#   screen = C1/C3/C6 + cold prefill 8K/32K (the speed-run screen shape; one per fresh boot, before any full bench)
L=$1; M=${2:-full}; O=/var/tmp/boot-results/$L; mkdir -p $O
if [ "$M" = screen ]; then A="--levels 1,3,6 --prefill 8000,32000"; else A=""; fi
echo "bench $L $M start $(date -u +%FT%TZ)" > $O/bench.txt
python3 /root/v41bench.py --label $L --out $O $A --notes "${3:-}" >> $O/bench.txt 2>&1
echo "BENCH DONE rc=$? $(date -u +%FT%TZ)" >> $O/bench.txt
python3 /root/bench_report.py $O/bench-$L.json > $O/report.md 2>&1
chmod -R a+rX $O
