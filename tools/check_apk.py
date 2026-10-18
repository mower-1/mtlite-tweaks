# -*- coding: utf-8 -*-
"""校验 APK：版本号、签名、关键资源、对齐"""
import struct, sys, zipfile, hashlib, os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from build_apk import read_pool


def axml_attrs(data):
    ftype, fhdr, fsize = struct.unpack("<HHI", data[:8])
    assert ftype == 0x0003 and fsize == len(data), "manifest 头异常"
    pool = read_pool(data, fhdr)
    strings = pool["strings"]
    p = fhdr + struct.unpack("<I", data[fhdr + 4:fhdr + 8])[0]
    result = []
    depth = 0
    while p < len(data):
        ctype, chdr, csize = struct.unpack("<HHI", data[p:p + 8])
        if ctype == 0x0102:
            name = strings[struct.unpack("<I", data[p + 20:p + 24])[0]]
            acount = struct.unpack("<H", data[p + 28:p + 30])[0]
            astart = struct.unpack("<H", data[p + 24:p + 26])[0]
            a = p + chdr + astart
            d = {}
            for _ in range(acount):
                aname = strings[struct.unpack("<I", data[a + 4:a + 8])[0]]
                raw = struct.unpack("<i", data[a + 8:a + 12])[0]
                dtype = data[a + 15]
                val = struct.unpack("<I", data[a + 16:a + 20])[0]
                if dtype == 0x03:
                    d[aname] = strings[val]
                elif dtype == 0x12:
                    d[aname] = bool(val)
                elif dtype == 0x11:
                    d[aname] = val
                else:
                    d[aname] = val
                a += 20
            result.append((depth, name, d))
            depth += 1
        elif ctype == 0x0103:
            depth -= 1
        p += csize
    return result


def main(path):
    print("=" * 62)
    print("文件:", path, os.path.getsize(path), "bytes")
    z = zipfile.ZipFile(path)
    bad = z.testzip()
    print("ZIP 完整性:", "OK" if bad is None else ("损坏: " + bad))
    print("条目数:", len(z.infolist()))

    data = z.read("AndroidManifest.xml")
    el = axml_attrs(data)
    manifest = el[0][2]
    print("包名:", manifest.get("package"))
    print("versionCode:", manifest.get("versionCode"), " versionName:", manifest.get("versionName"))
    sdk = el[1][2]
    print("minSdkVersion:", sdk.get("minSdkVersion"), " targetSdkVersion:", sdk.get("targetSdkVersion"),
          " compileSdkVersion:", sdk.get("compileSdkVersion"))

    print("-" * 62)
    for n in ["resources.arsc", "assets/app.json", "assets/libs/tiezi_plus.lua",
              "assets/libs/gongyong.lua", "assets/pages/tiezi/main.lua", "assets/pages/shezhi/main.lua"]:
        try:
            i = z.getinfo(n)
            lnlen, lelen = struct.unpack("<HH", z.fp.read(0) or b"") if False else (0, 0)
            print("  %-30s method=%d size=%7d" % (n, i.compress_type, i.file_size))
        except KeyError:
            print("  %-30s 缺失!!" % n)

    # 计算真实数据偏移与对齐
    with open(path, "rb") as f:
        raw = f.read()
    for n in ["resources.arsc"]:
        i = z.getinfo(n)
        off = i.header_offset
        lnlen, lelen = struct.unpack("<HH", raw[off + 26:off + 30])
        dstart = off + 30 + lnlen + lelen
        print("  %s 数据偏移=%d  %%4=%d  (method=%d)" % (n, dstart, dstart % 4, i.compress_type))

    # 签名相关
    names = [n.filename for n in z.infolist()]
    print("META-INF:", [x for x in names if x.startswith("META-INF/")][:8])
    print("APK Signing Block:", "存在" if b"APK Sig Block 42" in raw else "不存在")
    print("=" * 62)


if __name__ == "__main__":
    main(sys.argv[1])
