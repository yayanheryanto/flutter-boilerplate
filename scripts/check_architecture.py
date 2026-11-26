"""Cek aturan arsitektur di lib/ tanpa perlu Dart SDK.

Jalankan dari root project:  python3 scripts/check_architecture.py .
Memeriksa: (1) semua import/part package:emas & relatif menunjuk file yang ada,
(2) aturan dependensi antar lapisan & antar fitur (lihat README > Dependency Rule).
"""
import os
import re
import sys

root = sys.argv[1]
lib = os.path.join(root, "lib")
pkg_re = re.compile(r"^\s*(import|export|part)\s+['\"]package:emas/([^'\"]+)['\"]", re.M)
rel_re = re.compile(r"^\s*(import|export|part)\s+['\"]([^'\":]+)['\"]", re.M)

# Feature presentation code allowed to compose other features' presentation.
COMPOSERS = {"dashboard"}

problems = []
for dirpath, _, files in os.walk(lib):
    for f in files:
        if not f.endswith(".dart"):
            continue
        full = os.path.join(dirpath, f)
        rel = os.path.relpath(full, lib)
        src = open(full, encoding="utf-8").read()
        targets = []
        for _, t in pkg_re.findall(src):
            targets.append(t)
        for _, t in rel_re.findall(src):
            targets.append(os.path.normpath(os.path.join(os.path.dirname(rel), t)))
        for t in targets:
            if not os.path.exists(os.path.join(lib, t)):
                problems.append(f"MISSING  {rel} -> {t}")
        if rel.endswith((".g.dart", ".freezed.dart", "injection.config.dart")):
            continue
        parts = rel.split(os.sep)
        for t in targets:
            tp = t.split("/")
            if parts[0] == "core" and tp[0] in ("features", "shared", "app"):
                problems.append(f"RULE core->{tp[0]}  {rel} -> {t}")
            if parts[0] == "shared" and tp[0] in ("features", "app"):
                problems.append(f"RULE shared->{tp[0]}  {rel} -> {t}")
            if parts[0] == "features" and tp[0] == "app":
                problems.append(f"RULE features->app  {rel} -> {t}")
            if parts[0] == "features" and tp[0] == "features":
                feat, layer = parts[1], parts[2]
                tfeat, tlayer = tp[1], tp[2]
                if feat == tfeat:
                    if layer == "domain" and tlayer in ("data", "presentation"):
                        problems.append(f"RULE domain->{tlayer}  {rel} -> {t}")
                    if layer == "presentation" and tlayer == "data":
                        problems.append(f"RULE presentation->data  {rel} -> {t}")
                    if layer == "data" and tlayer == "presentation":
                        problems.append(f"RULE data->presentation  {rel} -> {t}")
                else:
                    if tlayer != "domain" and not (feat in COMPOSERS and layer == "presentation" and tlayer == "presentation"):
                        problems.append(f"RULE cross-feature {feat}/{layer} -> {tfeat}/{tlayer}  {rel}")
        if "/domain/" in rel and re.search(r"package:flutter/", src):
            problems.append(f"RULE domain imports flutter  {rel}")

print("\n".join(sorted(set(problems))) or "OK")
