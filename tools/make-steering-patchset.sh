#!/usr/bin/env bash
# make-steering-patchset.sh [BASE_PATCHSET] [OUT_NAME]
# Build $HOME/patches/<OUT_NAME> = <BASE_PATCHSET> + the GLP-steering model.py:
# the serving image's deepseek_v4_1 model file with tools/hotfix-dsv41-steering.py
# applied. Offline: no GPU, no server, no changes to the running lane.
#
# Serve steered afterwards (same on all four nodes, README "GLP steering"):
#   PATCH_NAME=<OUT_NAME> WEIGHTLESS_STEER_PATH=<host path to control.gguf> bash launch/boot_dsv41.sh
set -euo pipefail

BASE="${1:-dsv41-1017-fast}"
OUT="${2:-dsv41-glp}"
IMAGE="${IMAGE:-vllm-dsv41:overlay5}"
SITE="/usr/local/lib/python3.12/dist-packages/vllm"
REL="models/deepseek_v4_1/nvidia/model.py"
HERE="$(cd "$(dirname "$0")" && pwd)"

SRC="$HOME/patches/$BASE"
DST="$HOME/patches/$OUT"
[ -f "$SRC/mounts.txt" ] || { echo "base patch set $SRC has no mounts.txt (build it first)" >&2; exit 3; }
[ ! -e "$DST" ] || { echo "$DST already exists; remove it explicitly to rebuild" >&2; exit 3; }
mkdir -p "$DST"
cp -p "$SRC"/* "$DST"/

# The image's stock model file, patched offline. Extraction failure or a
# surprise file kills the build, not the boot.
docker run --rm --entrypoint cat "$IMAGE" "$SITE/$REL" > "$DST/model.py"
grep -q "class DeepseekV41ForCausalLM" "$DST/model.py" \
  || { echo "extracted $REL from $IMAGE looks wrong (no DeepseekV41ForCausalLM)" >&2; exit 3; }
WEIGHTLESS_STEERING_MODEL_PY="$DST/model.py" python3 "$HERE/hotfix-dsv41-steering.py"

# mounts.txt is "<file> <site-relative path>" per line; append ours once.
grep -q "^model.py " "$DST/mounts.txt" 2>/dev/null || echo "model.py $REL" >> "$DST/mounts.txt"

echo "patch set $DST ready: base $BASE + GLP steering ($REL, image $IMAGE)"
echo "serve steered: PATCH_NAME=$OUT WEIGHTLESS_STEER_PATH=<control.gguf> bash launch/boot_dsv41.sh"
