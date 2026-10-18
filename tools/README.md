# tools

| 脚本 | 作用 |
|---|---|
| `rebuild.py` | 一条命令出包：fap → 未签名 APK → 签名 → 自检。日常改完代码跑这个就行 |
| `build_fap.py` | 把 `src/fap` 打成 `.fap`（就是 zip，`app.json` 排最前，与原工程一致） |
| `build_apk.py` | 以原版 APK 为底：改二进制 `AndroidManifest.xml` 里的 versionName → 替换 `assets/` 下的工程文件 → 重打包（`resources.arsc` 保持 STORED + 4 字节对齐） |
| `check_apk.py` | 读 APK 的包名 / versionCode / versionName / minSdk，检查对齐与 zip 完整性 |
| `apply_patches.py` | 把 `patches/*.patch` 按上下文套到任意 1.7 工程上（±40 行偏移，失败会指出哪段没对上） |
| `Sign.java` | 用 apksig 库签 V1+V2+V3，`setAlignmentPreserved(true)`，签完自动验签 |
| `Verify.java` | 单独验签 |

## 日常出包

```bash
python tools/rebuild.py
```

自动完成：读 `src/fap/app.json` 的版本号 → 打 fap → 调 `build_apk.py` → 用 keystore 签 V1+V2+V3 → 跑 `check_apk.py`，
产物落在 `dist/mtlite-<版本>.apk`。口令交互输入（也可用 `KS_PASS`），keystore 默认找上一级的 `mtsign/*.p12`。

## 准备原版 APK

```
base/Mt论坛Lite重制版_1.7.apk      # 或 export BASE_APK=/path/to/xxx.apk
```

`build_apk.py` 会断言 `versionName` 字符串在 manifest 字符串池里**唯一**（原版是 `1.7`），
所以底包必须是没有改过版本名的原版。

## 生成自己的 keystore

作者的签名文件不在仓库里（也不该在），自己生成一个即可：

```bash
keytool -genkeypair -v -keystore mykey.p12 -storetype PKCS12 \
        -alias mykey -keyalg RSA -keysize 2048 -validity 10000
```

## 取 apksig.jar

Android SDK 里就有：`$ANDROID_HOME/build-tools/<版本>/lib/apksig.jar`。
没有 SDK 就从 Maven 取 `com.android.tools.build:apksig`。

## 签名

```bash
javac -cp apksig.jar Sign.java
# Windows
java -cp "apksig.jar;." Sign build/unsigned.apk build/app.apk mykey.p12 你的密码 mykey 你的密码
# Linux / macOS / Git Bash
java -cp "apksig.jar:." Sign build/unsigned.apk build/app.apk mykey.p12 你的密码 mykey 你的密码
```

换成自己的签名后**不能覆盖安装原版**，要先卸载。

## apply_patches.py

```bash
python tools/apply_patches.py patches/ <目标工程目录>
```

- 目标目录里应该有 `app.json`、`libs/`、`pages/` 这一层（也就是 fap 解包后的根）。
- 补丁按「上下文行」匹配，不是按行号，所以目标文件被你自己改过、行号漂了也能套上。
- 有任何一个补丁套不上会打印 `✗ 文件名: 第 N 段对不上，附近内容应为：...` 并以非 0 退出，
  这时照提示手动合那一段就行。
- 之所以不用 `git apply`：Windows 默认 `core.autocrlf=true`，git 会把结果写成 CRLF，
  而这个工程里的文件行尾并不统一（原版就有混合）。

## 出包后自检

```bash
python tools/check_apk.py build/app.apk
```

关注四项：

1. `versionName` = 1.7.5、`versionCode` = 7
2. `resources.arsc` 的**数据偏移 % 4 == 0**（Android 11+ 会因此装不上）
3. `zip 完整性: OK`
4. `APK Signing Block: 存在`
