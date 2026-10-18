# -*- coding: utf-8 -*-
"""
把 patches/ 里的 unified diff 套到一个 1.7 工程目录上。

用法：
    python tools/apply_patches.py patches/  <目标工程目录>

为什么不用 `git apply`：
  - Windows 默认 core.autocrlf=true，git 会把结果写成 CRLF，而这个工程里的文件行尾并不统一；
  - 这里的工程文件被改过行号也很常见，需要按上下文找位置（本脚本支持 ±40 行偏移）。
"""
import os
import sys


def parse_patch(text):
    """返回 (旧路径, 新路径, [hunk...])，hunk = {'old':(start,len), 'new':(start,len), 'lines':[(tag,text)]}"""
    old_path = new_path = None
    hunks = []
    cur = None
    for raw in text.splitlines():
        line = raw.rstrip("\r")
        if line.startswith("--- "):
            old_path = line[4:].strip()
            continue
        if line.startswith("+++ "):
            new_path = line[4:].strip()
            continue
        if line.startswith("@@"):
            # @@ -a,b +c,d @@
            body = line[2:].split("@@")[0].strip()
            try:
                left, right = body.split(" ")
                o = left[1:]
                n = right[1:]
                ostart = int(o.split(",")[0])
                olen = int(o.split(",")[1]) if "," in o else 1
                nstart = int(n.split(",")[0])
                nlen = int(n.split(",")[1]) if "," in n else 1
            except Exception:
                raise SystemExit("看不懂的 hunk 头：%s" % line)
            cur = {"old": (ostart, olen), "new": (nstart, nlen), "lines": []}
            hunks.append(cur)
            continue
        if cur is None:
            continue
        if line.startswith("\\"):          # \ No newline at end of file
            continue
        if not line:
            # difflib 生成的补丁里，空行也可能是上下文行（被剥掉了前缀空格）
            cur["lines"].append((" ", ""))
            continue
        tag, body = line[0], line[1:]
        if tag not in " -+":
            continue
        cur["lines"].append((tag, body))
    return old_path, new_path, hunks


def clean_path(p):
    if p is None:
        return None
    p = p.strip()
    if p == "/dev/null":
        return None
    if p.startswith(("a/", "b/")):
        p = p[2:]
    return p


def apply_hunks(lines, hunks, label):
    delta = 0
    for h in hunks:
        old_seq = [t for tag, t in h["lines"] if tag in " -"]
        new_seq = [t for tag, t in h["lines"] if tag in " +"]
        want = max(0, h["old"][0] - 1 + delta)
        pos = -1
        span = 40
        lo = max(0, want - span)
        hi = min(len(lines) - len(old_seq) + 1, want + span + 1)
        for p in range(lo, max(lo, hi)):
            if lines[p:p + len(old_seq)] == old_seq:
                pos = p
                break
        if pos < 0:                                    # 窗口内没找到就全文件搜
            for p in range(0, len(lines) - len(old_seq) + 1):
                if lines[p:p + len(old_seq)] == old_seq:
                    pos = p
                    break
        if pos < 0:
            hint = old_seq[0][:60] if old_seq else "(空)"
            return False, "%s: 第 %s 段对不上，附近内容应为：%s" % (
                label, h["old"][0], hint)
        lines[pos:pos + len(old_seq)] = new_seq
        delta += len(new_seq) - len(old_seq)
    return True, ""


def main():
    if len(sys.argv) < 3:
        raise SystemExit(__doc__)
    patch_dir, target = sys.argv[1], sys.argv[2]
    if not os.path.isdir(patch_dir):
        raise SystemExit("补丁目录不存在：%s" % patch_dir)
    if not os.path.isdir(target):
        raise SystemExit("目标目录不存在：%s" % target)

    names = sorted(n for n in os.listdir(patch_dir) if n.endswith(".patch"))
    ok = 0
    for name in names:
        text = open(os.path.join(patch_dir, name), encoding="utf-8").read()
        old_path, new_path, hunks = parse_patch(text)
        rel = clean_path(new_path) or clean_path(old_path)
        if not rel:
            print("跳过（读不出路径）：%s" % name)
            continue
        # 兼容 Windows 反斜杠
        dst = os.path.join(target, rel.replace("/", os.sep))
        exists = os.path.exists(dst)
        if exists:
            src = open(dst, encoding="utf-8", newline="").read().replace("\r\n", "\n")
            trailing = src.endswith("\n")
            lines = src.split("\n")
            if trailing:
                lines = lines[:-1]
        else:
            trailing = True
            lines = []

        good, why = apply_hunks(lines, hunks, name)
        if not good:
            print("✗", why)
            continue
        out = "\n".join(lines) + ("\n" if trailing else "")
        os.makedirs(os.path.dirname(dst) or ".", exist_ok=True)
        with open(dst, "w", encoding="utf-8", newline="") as f:
            f.write(out)
        print("✓ %s %s" % ("新建" if not exists else "修改", rel))
        ok += 1

    print("-" * 50)
    print("完成 %d/%d 个文件" % (ok, len(names)))
    if ok != len(names):
        sys.exit(1)


if __name__ == "__main__":
    main()
