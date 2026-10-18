# -*- coding: utf-8 -*-
"""
一条命令出包：fap → 未签名 APK → 签名 → 自检。

用法：
    python tools/rebuild.py                 # 版本号取 src/fap/app.json
    python tools/rebuild.py --no-sign       # 只出到 unsigned.apk
    python tools/rebuild.py -o D:/out       # 指定输出目录（默认 dist/）

需要：
    base/ 里有一份原版 APK（或用环境变量 BASE_APK 指定）
    keystore：环境变量 KEYSTORE 指定，否则自动找 ../mtsign/*.p12
    口令：环境变量 KS_PASS，否则交互式输入
    apksig.jar：tools/apksig.jar，或环境变量 APKSIG_JAR
"""
import getpass
import glob
import json
import os
import shutil
import subprocess
import sys
import zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "src", "fap")
TOOLS = os.path.join(ROOT, "tools")


def log(msg):
    print(msg, flush=True)


def find_base_apk():
    env = os.environ.get("BASE_APK")
    if env:
        return env
    cand = sorted(glob.glob(os.path.join(ROOT, "base", "*.apk")))
    if cand:
        return cand[0]
    raise SystemExit("找不到原版 APK：放一份到 base/ 下，或设环境变量 BASE_APK 指过去。")


def find_keystore():
    env = os.environ.get("KEYSTORE")
    if env:
        return env
    for pat in (os.path.join(ROOT, "*.p12"), os.path.join(os.path.dirname(ROOT), "mtsign", "*.p12")):
        cand = sorted(glob.glob(pat))
        if cand:
            return cand[0]
    raise SystemExit("找不到 keystore：设环境变量 KEYSTORE，或把 .p12 放到仓库上一级的 mtsign/ 里。")


def find_apksig():
    env = os.environ.get("APKSIG_JAR")
    if env and os.path.exists(env):
        return env
    for p in (os.path.join(TOOLS, "apksig.jar"),
              os.path.join(os.path.dirname(ROOT), "Mt论坛Lite重置版源码", "_apk", "tools", "apksig.jar")):
        if os.path.exists(p):
            return p
    raise SystemExit("找不到 apksig.jar：从 Android SDK 的 build-tools/*/lib/ 拷一份到 tools/，"
                     "或设环境变量 APKSIG_JAR。")


def run(cmd, secret=None, **kw):
    shown = ["***" if (secret and a == secret) else a for a in cmd]
    log("$ " + " ".join(shown))
    r = subprocess.run(cmd, **kw)
    if r.returncode != 0:
        raise SystemExit("命令失败，退出码 %d" % r.returncode)


def build_fap(version, outdir):
    entries = []
    for dirpath, dirnames, filenames in os.walk(SRC):
        dirnames.sort()
        for fn in sorted(filenames):
            full = os.path.join(dirpath, fn)
            entries.append((os.path.relpath(full, SRC).replace("\\", "/"), full))
    entries.sort(key=lambda x: (0 if x[0] == "app.json" else 1, x[0]))
    out = os.path.join(outdir, "mtlite-%s.fap" % version)
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
        for rel, full in entries:
            z.write(full, rel)
    log("fap  → %s  (%d 字节, %d 个文件)" % (out, os.path.getsize(out), len(entries)))
    return out


def main():
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

    args = sys.argv[1:]
    outdir = os.path.join(ROOT, "dist")
    if "-o" in args:
        outdir = args[args.index("-o") + 1]
    no_sign = "--no-sign" in args
    os.makedirs(outdir, exist_ok=True)

    app = json.load(open(os.path.join(SRC, "app.json"), encoding="utf-8"))
    version = app.get("versionName", "unknown")
    log("版本 %s（versionCode %s）" % (version, app.get("versionCode")))

    # 1) fap
    build_fap(version, outdir)

    # 2) APK
    base = find_base_apk()
    env = dict(os.environ, BASE_APK=base)
    log("底包 %s" % base)
    run([sys.executable, os.path.join(TOOLS, "build_apk.py")], env=env, cwd=ROOT)

    unsigned = os.path.join(ROOT, "build", "unsigned.apk")
    if not os.path.exists(unsigned):
        raise SystemExit("没找到 %s" % unsigned)
    if no_sign:
        dst = os.path.join(outdir, "mtlite-%s-unsigned.apk" % version)
        shutil.copy2(unsigned, dst)
        log("未签名 → %s" % dst)
        return

    # 3) 签名
    apksig = find_apksig()
    ks = find_keystore()
    alias = os.environ.get("KS_ALIAS") or os.path.splitext(os.path.basename(ks))[0]
    pw = os.environ.get("KS_PASS") or getpass.getpass("keystore 口令（%s，别名 %s）: " % (os.path.basename(ks), alias))

    cls = os.path.join(ROOT, "build", "signcls")
    os.makedirs(cls, exist_ok=True)
    run(["javac", "-cp", apksig, "-d", cls, os.path.join(TOOLS, "Sign.java")],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    signed = os.path.join(outdir, "mtlite-%s.apk" % version)
    run(["java", "-cp", apksig + os.pathsep + cls, "Sign", unsigned, signed, ks, pw, alias, pw], secret=pw)

    # 4) 自检
    run([sys.executable, os.path.join(TOOLS, "check_apk.py"), signed], cwd=ROOT)

    import hashlib
    data = open(signed, "rb").read()
    log("")
    log("产物  %s" % signed)
    log("大小  %d 字节" % len(data))
    log("MD5   %s" % hashlib.md5(data).hexdigest())
    log("SHA256 %s" % hashlib.sha256(data).hexdigest())


if __name__ == "__main__":
    main()
