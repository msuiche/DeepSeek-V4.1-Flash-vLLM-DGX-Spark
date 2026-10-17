#!/usr/bin/env python3
"""screencmp.py REF.json RUN.json [RUN2.json ...]: screen cells (C1/C3/C6 aggregate + per-stream, C1 per category, cold prefill 8K/32K)."""
import json, statistics as st, sys
CATS = ["coding", "json", "math", "reasoning", "format", "summary", "prose", "narrative"]
def load(p):
    d = json.load(open(p)); r = {"label": d["label"]}
    for c in (1, 3, 6):
        bs = [b for b in d["batches"] if b["c"] == c and b["category"] in CATS]
        if bs:
            r[f"C{c} agg"] = st.mean(b["agg_tok_s"] for b in bs)
            r[f"C{c} per"] = st.mean(b["per_stream_tok_s"] for b in bs if b["per_stream_tok_s"])
    for cat in CATS:
        b = next((b for b in d["batches"] if b["c"] == 1 and b["category"] == cat), None)
        if b: r[f"C1 {cat}"] = b["per_stream_tok_s"]
    for p in d.get("prefill", []):
        if p["target"] in (8000, 32000): r[f"prefill {p['target']//1000}K"] = p["prefill_tok_s"]
    return r
runs = [load(p) for p in sys.argv[1:]]
keys = [k for k in runs[0] if k != "label"]
print("| cell | " + " | ".join(r["label"] for r in runs) + " |")
print("|---|" + "---|" * len(runs))
for k in keys:
    ref = runs[0].get(k); row = []
    for i, r in enumerate(runs):
        v = r.get(k)
        if v is None: row.append(""); continue
        s = f"{v:.1f}"
        if i and ref: s += f" ({(v / ref - 1) * 100:+.0f}%)"
        row.append(s)
    print(f"| {k} | " + " | ".join(row) + " |")
