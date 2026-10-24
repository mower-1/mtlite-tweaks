# -*- coding: utf-8 -*-
"""
从原版 APK 重新构建：
1. 二进制 AndroidManifest.xml 里 versionName 改为 1.7.5（versionCode 不动）
2. 替换 assets 下的工程文件（保持 .fap 同步）
3. 重新打包为未签名 APK（resources.arsc 保持 STORED + 4 字节对齐）
"""
import struct, zlib, os, sys, json

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))      # 仓库根目录
SRC = os.path.join(ROOT, "src", "fap")                                  # 已修改的工程
# 原版 APK 需要自己放进来（版权原因不随仓库分发）：
#   base/Mt论坛Lite重制版_1.7.apk 或 环境变量 BASE_APK 指定
OLD_APK = os.environ.get("BASE_APK") or os.path.join(ROOT, "base", "Mt论坛Lite重制版_1.7.apk")
NEW_APK = os.path.join(ROOT, "build", "unsigned.apk")

NEW_VERSION_NAME = json.load(open(os.path.join(SRC, "app.json"), encoding="utf-8")).get("versionName", "1.7.5")

# ---------------- 二进制 XML 字符串池 ----------------

def read_pool(data, p):
    ctype, chdr, csize = struct.unpack("<HHI", data[p:p + 8])
    assert ctype == 0x0001, "不是字符串池 chunk"
    strcount, stylecount, flags, strstart, stystart = struct.unpack("<IIIII", data[p + 8:p + 28])
    utf8 = bool(flags & 0x100)
    offs = struct.unpack("<%dI" % strcount, data[p + 28:p + 28 + 4 * strcount])
    base = p + strstart
    out = []
    for o in offs:
        q = base + o
        if utf8:
            n = data[q]; q += 1
            if n & 0x80:
                n = ((n & 0x7F) << 8) | data[q]; q += 1
            l = data[q]; q += 1
            if l & 0x80:
                l = ((l & 0x7F) << 8) | data[q]; q += 1
            out.append(data[q:q + l].decode("utf-8"))
        else:
            l = struct.unpack("<H", data[q:q + 2])[0]; q += 2
            if l & 0x8000:
                l2 = struct.unpack("<H", data[q:q + 2])[0]; q += 2
                l = ((l & 0x7FFF) << 16) | l2
            out.append(data[q:q + 2 * l].decode("utf-16le"))
    return dict(ctype=ctype, chdr=chdr, csize=csize, strcount=strcount,
                stylecount=stylecount, flags=flags, strstart=strstart,
                stystart=stystart, strings=out, utf8=utf8)


def enc_len(n):
    if n > 0x7F:
        return bytes([((n >> 8) & 0x7F) | 0x80, n & 0xFF])
    return bytes([n])


def write_pool(meta):
    strings = meta["strings"]
    if meta["utf8"]:
        body = bytearray()
        offs = []
        for s in strings:
            offs.append(len(body))
            b = s.encode("utf-8")
            body += enc_len(len(s.encode("utf-16-le")) // 2)
            body += enc_len(len(b))
            body += b + b"\x00"
    else:
        body = bytearray()
        offs = []
        for s in strings:
            offs.append(len(body))
            u = s.encode("utf-16le")
            body += enc_len(len(u) // 2) if len(u) // 2 > 0x7FFF else struct.pack("<H", len(u) // 2)
            body += u + b"\x00\x00"
    while len(body) % 4:
        body += b"\x00"
    n = len(strings)
    stylecount = meta["stylecount"]
    data_start = 28 + 4 * n + 4 * stylecount
    chunk_size = data_start + len(body)
    chunk = struct.pack("<HHI", 0x0001, 28, chunk_size)
    chunk += struct.pack("<IIIII", n, stylecount, meta["flags"], data_start,
                         0 if stylecount == 0 else meta["stystart"])
    chunk += struct.pack("<%dI" % n, *offs)
    chunk += bytes(body)
    return chunk


def patch_manifest(data, old, new):
    ftype, fhdr, fsize = struct.unpack("<HHI", data[:8])
    assert ftype == 0x0003, "不是二进制 XML"
    p = fhdr
    meta = read_pool(data, p)
    assert meta["strings"].count(old) == 1, "versionName 字符串不唯一：%s" % meta["strings"].count(old)
    idx = meta["strings"].index(old)
    meta["strings"][idx] = new
    pool = write_pool(meta)
    tail = data[p + meta["csize"]:]
    total = fhdr + len(pool) + len(tail)
    out = struct.pack("<HHI", ftype, fhdr, total) + pool + tail
    assert len(out) == total
    return out, idx


# ---------------- 二进制 XML 遍历（仅用于校验） ----------------

def walk_axml(data):
    """返回 (标签列表, 属性字典列表)，用于确认补丁后的结构完好"""
    ftype, fhdr, fsize = struct.unpack("<HHI", data[:8])
    assert ftype == 0x0003 and fsize == len(data)
    p = fhdr + struct.unpack("<I", data[fhdr + 4:fhdr + 8])[0]   # 跳过字符串池 chunk
    assert p % 4 == 0
    tags, attrs, depth = [], [], 0
    while p < len(data):
        ctype, chdr, csize = struct.unpack("<HHI", data[p:p + 8])
        if ctype == 0x0102:  # START_ELEMENT
            ns, name = struct.unpack("<iI", data[p + 16:p + 24])
            acount = struct.unpack("<H", data[p + 28:p + 30])[0]
            astart = struct.unpack("<H", data[p + 24:p + 26])[0]
            tags.append((depth, name))
            a = p + chdr + astart
            d = {}
            for _ in range(acount):
                ans, aname, araw = struct.unpack("<iII", data[a:a + 12])
                dtype = data[a + 15]
                val = struct.unpack("<I", data[a + 16:a + 20])[0]
                d[aname] = (dtype, val, araw)
                a += 20
            attrs.append(d)
            depth += 1
        elif ctype == 0x0103:  # END_ELEMENT
            depth -= 1
        p += csize
        if ctype == 0x0100:  # 字符串池（第一个已跳过）
            pass
    return tags, attrs


# ---------------- ZIP 读写 ----------------

def zip_entries(path):
    """读原始 APK 的中央目录，返回 [(name, method, crc, csize, usize, raw_bytes)]"""
    f = open(path, "rb")
    data = f.read()
    # 找 EOCD
    i = data.rfind(b"PK\x05\x06")
    assert i > 0
    cnt, cdsize, cdoff = struct.unpack("<HII", data[i + 10:i + 20])
    p = cdoff
    out = []
    for _ in range(cnt):
        assert data[p:p + 4] == b"PK\x01\x02"
        (ver_made, ver_need, flags, method, mtime, mdate, crc, csize, usize,
         nlen, elen, clen, disk, iattr, eattr, off) = struct.unpack("<HHHHHHIIIHHHHHII", data[p + 4:p + 46])
        name = data[p + 46:p + 46 + nlen].decode("utf-8")
        # 本地头里的 extra 长度可能与中央目录不同，按本地头取数据位置
        lnlen, lelen = struct.unpack("<HH", data[off + 26:off + 30])
        dstart = off + 30 + lnlen + lelen
        raw = data[dstart:dstart + csize]
        out.append((name, method, crc, csize, usize, raw))
        p += 46 + nlen + elen + clen
    f.close()
    return out


def deflate(raw):
    co = zlib.compressobj(9, zlib.DEFLATED, -15)
    return co.compress(raw) + co.flush()


def write_zip(entries, path):
    """entries: [(name, method, crc, usize, payload, is_raw)]"""
    fh = open(path, "wb")
    central = []
    offset = 0
    now = (0, 0x21)  # 1980-01-01 的 dos time/date，保持可复现
    for name, method, crc, usize, payload, is_raw in entries:
        nb = name.encode("utf-8")
        if method == 0:
            # STORED：数据区 4 字节对齐（Android R+ 要求 resources.arsc 满足）
            base = offset + 30 + len(nb)
            pad = (-base) % 4
            extra = b""
            if pad:
                if pad < 4:
                    pad += 4
                extra = struct.pack("<HH", 0xD935, pad - 4) + b"\x00" * (pad - 4)
            assert len(extra) == pad
        else:
            extra = b""
        csize = len(payload) if method == 0 else len(payload)
        lh = struct.pack("<IHHHHHIIIHH", 0x04034B50, 20, 0, method, now[0], now[1],
                         crc, csize, usize, len(nb), len(extra))
        fh.write(lh)
        fh.write(nb)
        fh.write(extra)
        fh.write(payload)
        central.append((nb, method, crc, csize, usize, extra, offset))
        offset += len(lh) + len(nb) + len(extra) + csize
    cd_off = offset
    for nb, method, crc, csize, usize, extra, off in central:
        fh.write(struct.pack("<IHHHHHHIIIHHHHHII", 0x02014B50, 20, 20, 0, method,
                             now[0], now[1], crc, csize, usize, len(nb), len(extra),
                             0, 0, 0, 0, off))
        fh.write(nb)
        fh.write(extra)
        offset += 46 + len(nb) + len(extra)
    fh.write(struct.pack("<IHHHHIIH", 0x06054B50, 0, 0, len(central), len(central),
                         offset - cd_off, cd_off, 0))
    fh.close()


def main():
    os.makedirs(os.path.dirname(NEW_APK), exist_ok=True)
    if not os.path.exists(OLD_APK):
        raise SystemExit("找不到原版 APK：%s\n请把自己的 Mt论坛Lite重制版_1.7.apk 放到 base/ 下，"
                         "或用环境变量 BASE_APK 指定路径。" % OLD_APK)
    src = zip_entries(OLD_APK)
    print("原始条目数:", len(src))

    # 需要替换 / 新增的文件（APK 内路径 -> 本地路径）
    repl = {
        "assets/libs/gongyong.lua": os.path.join(SRC, "libs/gongyong.lua"),
        "assets/libs/Function_bottom.lua": os.path.join(SRC, "libs/Function_bottom.lua"),
        "assets/libs/tiezi_plus.lua": os.path.join(SRC, "libs/tiezi_plus.lua"),
        "assets/libs/pm_plus.lua": os.path.join(SRC, "libs/pm_plus.lua"),
        "assets/pages/tiezi/main.lua": os.path.join(SRC, "pages/tiezi/main.lua"),
        "assets/pages/shezhi/main.lua": os.path.join(SRC, "pages/shezhi/main.lua"),
        "assets/pages/yonghu/main.lua": os.path.join(SRC, "pages/yonghu/main.lua"),
        # 「电脑版网页」菜单：入口页 + 电脑版页面
        "assets/pages/bankuai/main.lua": os.path.join(SRC, "pages/bankuai/main.lua"),
        "assets/pages/qiandao/main.lua": os.path.join(SRC, "pages/qiandao/main.lua"),
        "assets/pages/sousuo/main.lua": os.path.join(SRC, "pages/sousuo/main.lua"),
        "assets/pages/zhuye/main.lua": os.path.join(SRC, "pages/zhuye/main.lua"),
        "assets/pages/zhuye/jinghua/main.lua": os.path.join(SRC, "pages/zhuye/jinghua/main.lua"),
        "assets/pages/liulanyepc/main.lua": os.path.join(SRC, "pages/liulanyepc/main.lua"),
        "assets/pages/liulanyeqp/main.lua": os.path.join(SRC, "pages/liulanyeqp/main.lua"),
    }
    # 原版 APK 里没有、需要新增的 lua（紧跟 gongyong 插入）
    new_libs = ["assets/libs/tiezi_plus.lua", "assets/libs/pm_plus.lua"]
    # 原版 APK 里没有、需要新增的页面（紧跟 shezhi 页面插入）
    new_pages = ["assets/pages/huancun/main.lua"]
    # app.json 里的 versionName 同步（versionCode 不变）
    app = json.load(open(os.path.join(SRC, "app.json"), encoding="utf-8"))
    app["versionName"] = NEW_VERSION_NAME
    app_json = json.dumps(app, ensure_ascii=False, separators=(",", ":")).encode("utf-8")

    out = []
    inserted = False
    for name, method, crc, csize, usize, raw in src:
        if name == "AndroidManifest.xml":
            data = zlib.decompress(raw, -15) if method == 8 else raw
            patched, idx = patch_manifest(data, "1.7", NEW_VERSION_NAME)
            tags, attrs = walk_axml(patched)
            assert len(tags) > 5, "manifest 结构异常"
            print("manifest: versionName 字符串 index=%d, %d -> %d bytes, 元素数=%d"
                  % (idx, len(data), len(patched), len(tags)))
            print("manifest 标签顺序前 6 个:", [t[1] for t in tags[:6]])
            out.append((name, 8, zlib.crc32(patched) & 0xFFFFFFFF, len(patched), deflate(patched), False))
        elif name == "assets/app.json":
            out.append((name, 8, zlib.crc32(app_json) & 0xFFFFFFFF, len(app_json), deflate(app_json), False))
        elif name in repl:
            data = open(repl[name], "rb").read()
            out.append((name, 8, zlib.crc32(data) & 0xFFFFFFFF, len(data), deflate(data), False))
            if name == "assets/libs/gongyong.lua" and not inserted:
                # 新文件紧跟 gongyong
                for nf in new_libs:
                    p = os.path.join(SRC, "libs", os.path.basename(nf))
                    d = open(p, "rb").read()
                    out.append((nf, 8, zlib.crc32(d) & 0xFFFFFFFF, len(d), deflate(d), False))
                inserted = True
            elif name == "assets/pages/shezhi/main.lua":
                # 新页面紧跟 shezhi
                for nf in new_pages:
                    rel = nf[len("assets/"):]
                    d = open(os.path.join(SRC, rel), "rb").read()
                    out.append((nf, 8, zlib.crc32(d) & 0xFFFFFFFF, len(d), deflate(d), False))
        else:
            out.append((name, method, crc, usize,
                        raw if method == 0 else raw, True))
    assert inserted, "未插入新 lib"
    # 去掉重复的 tiezi_plus（上面分支里既 replace 又 insert 的情况不会发生，这里再保险一次）
    seen = set(); dedup = []
    for e in out:
        if e[0] in seen:
            continue
        seen.add(e[0]); dedup.append(e)

    write_zip(dedup, NEW_APK)
    print("已生成:", NEW_APK, os.path.getsize(NEW_APK), "bytes,", len(dedup), "entries")

    # 打印关键条目对齐情况
    import zipfile
    z = zipfile.ZipFile(NEW_APK)
    for i in z.infolist():
        if i.filename in ("resources.arsc", "AndroidManifest.xml", "classes.dex", "assets/libs/tiezi_plus.lua"):
            data = z.read(i.filename)
            print("  %-32s method=%d off=%d off%%4=%d size=%d" %
                  (i.filename, i.compress_type, i.header_offset, i.header_offset % 4, len(data)))
    print("zip 完整性:", "OK" if z.testzip() is None else "损坏")


if __name__ == "__main__":
    main()
