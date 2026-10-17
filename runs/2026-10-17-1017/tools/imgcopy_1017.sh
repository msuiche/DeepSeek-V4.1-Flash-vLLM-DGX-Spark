#!/bin/bash
# imgcopy_1017.sh (Bluey): save vllm-dsv41:overlay5 + exl3b-roce once, docker load on Spark4 + Asusi in parallel.
T=/var/tmp/dsv41-imgs-overlay5-exl3broce.tar
J="ssh -i $HOME/.ssh/id_ed25519_shared -o IdentitiesOnly=yes -o BatchMode=yes -o ConnectTimeout=15"
echo "start $(date -u +%T)"
docker save -o $T vllm-dsv41:overlay5 vllm-dsv41:exl3b-roce || { echo "SAVE FAILED"; exit 1; }
ls -la $T; echo "saved $(date -u +%T)"
( $J tonyspark4@192.168.192.4 "docker load" < $T > /var/tmp/imgload-spark4.log 2>&1; echo "spark4 load exit=$? $(date -u +%T)"; tail -3 /var/tmp/imgload-spark4.log ) &
( $J tonyspark3@192.168.192.3 "docker load" < $T > /var/tmp/imgload-asusi.log 2>&1; echo "asusi load exit=$? $(date -u +%T)"; tail -3 /var/tmp/imgload-asusi.log ) &
wait
for h in tonyspark4@192.168.192.4 tonyspark3@192.168.192.3; do
  $J $h 'sync; echo 1 | sudo -n tee /proc/sys/vm/drop_caches >/dev/null && echo "$(hostname) dropped"; docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep dsv41'
done
sync; echo 1 | sudo -n tee /proc/sys/vm/drop_caches >/dev/null && echo "bluey dropped"
echo "IMGCOPY DONE $(date -u +%T)"
