# -*- coding: utf-8 -*-
"""
把 src/fap 打包成 Fusion App 的 .fap（本质就是一个 zip，app.json 放在最前）。

用法：
    python tools/build_fap.py [-o 输出路径]

默认输出 build/Mt论坛Lite重制版_<versionName>.fap，versionName 从 src/fap/app.json 读。
"""
import os, sys, json, zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "src", "fap")
BUILD = os.path.join(ROOT, "build")


def main():
    out = None
    argv = sys.argv[1:]
    if "-o" in argv:
        out = argv[argv.index("-o") + 1]
    if not out:
        ver = "1.7.5"
        try:
            ver = json.load(open(os.path.join(SRC, "app.json"), encoding="utf-8")).get("versionName", ver)
        except Exception:
            pass
        out = os.path.join(BUILD, "Mt论坛Lite重制版_%s.fap" % ver)
    os.makedirs(os.path.dirname(os.path.abspath(out)), exist_ok=True)

    entries = []
    for dirpath, dirnames, filenames in os.walk(SRC):
        dirnames.sort()
        for fn in sorted(filenames):
            full = os.path.join(dirpath, fn)
            rel = os.path.relpath(full, SRC).replace("\\", "/")
            entries.append((rel, full))

    # app.json 放最前，与原始工程一致
    entries.sort(key=lambda x: (0 if x[0] == "app.json" else 1, x[0]))

    tmp = out + ".tmp"
    with zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as z:
        for rel, full in entries:
            z.write(full, rel)
    os.replace(tmp, out)
    print("written:", out, os.path.getsize(out), "bytes,", len(entries), "entries")


if __name__ == "__main__":
    main()
