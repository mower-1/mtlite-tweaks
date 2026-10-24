# Mt论坛Lite 增强补丁（1.7.6）

给 **Fusion App** 工程「Mt论坛Lite 重制版 1.7」加的一批功能。

仓库里同时放了**原版 1.7 的工程源码**（`original/`）和**改好的 1.7.6 源码**（`src/`），
外加逐文件补丁与构建脚本；[Releases](https://github.com/mower-1/mtlite-tweaks/releases) 里有可直接安装的 APK。

合入后版本号为 **1.7.6**（`versionCode` 保持 7 不变），方便与原版共存识别。
所有改动都写在工程内部的 Lua 与注入 JS 里，不碰 dex。

---

## 功能

| 功能 | 在哪儿 | 说明 |
|---|---|---|
| 回复可见自动回复 | 设置 → Js | 帖子出现「回复可见」时询问是否自动回一句，回复内容可改；三重条件判定，不会误报普通帖子 |
| 评论屏蔽 | 设置 → Js | 命中屏蔽词隐藏整条楼层；支持一行一条正则；内置词表首次运行预置进输入框；超过 10 字不屏蔽；楼主帖与「回复别人」的楼层豁免 |
| 自动上下页（重写） | 设置 → Js | 滚动到底自动加载下一页，页码 / 上下页按钮同步刷新；末页提示「已是最后一页」；单页帖不会空转 |
| 私信限速自动重发 | 设置 → Js | 每条私信发完即开始计时（默认 16 秒），窗口内的发送自动排队、到点补发；倒计时卡片画在网页里；自动补发不吃掉你正在打的草稿；发完自动刷新消息列表 |
| 电脑版网页 | 任意页面右上角 ⋮ | 用现成的「浏览页PC」打开当前页的电脑版（沿用「拓展功能 → 电脑UA」）；`mobile=2` 自动换成 `mobile=no`；「手机模式」= 关掉电脑版页面回到原页面 |
| 弹层里的快捷菜单 | 自动生效 | 点某楼的「回复」弹出的小窗，底部也会出现加粗 / 斜体 / 下划线…。**事件驱动**（钩回复请求），没有轮询 |
| 修：侧边栏「请登录 / 登录失效」 | 自动生效 | 原版判登录依赖装饰 cookie、昵称靠跨行正则，登录了也一直显示未登录。现在只认 `_auth` cookie |
| 修：`@某人` 点了没反应 | 自动生效 | 原版路由把 `space-uid-123.html` 直接 `return true` 吞掉，连请求都不发。现在打开用户页，纯文本 `/ javascript:;` 形式的 @ 也能点 |
| 修：回复时概率闪退 | 自动生效 | 内置的旧版 androidx ViewPager 在多指触摸、弹窗打断之后，会用已经失效的 pointerId 调 `getX()`，抛 `IllegalArgumentException: invalid pointerIndex -1` 直接崩。页面容器只装一张视图，本来就不需要左右滑动，现已关闭它的用户滑动，触摸事件不再走这条路径 |
| 修：回复时闪退（续，1.7.6） | 自动生效 | 快捷菜单栏原来是一整个 RecyclerView（`LuaRecyclerAdapter`），底栏默认 GONE、回复时切成可见，会在这一帧重建全部 ViewHolder，适配器偶尔拿到失效的 LuaTable 或把布局当 LuaFunction 强转，抛 `Inconsistency detected` / `ClassCastException`。这一栏只有十来个固定按钮，已改为 `HorizontalScrollView` + 普通 `LinearLayout`，不再经过适配器 |
| 提取Cookie | 设置 → 应用 | 弹窗展示论坛当前 Cookie（含登录态），标注字符数，可一键复制；未登录时提示先登录 |
| 下拉刷新 | 设置 → Js | 开启后帖子页在顶部继续下拉即刷新，右下角刷新按钮隐藏；关闭则恢复按钮。⋮ 菜单里的「网页刷新」保留兜底 |
| 帖子缓存 | 自动生效 | 打开的帖子自动存一份整页 HTML（含已加载的评论，上限 50 篇）；帖子被删后再打开会自动落到本地缓存并提示。⋮ 菜单可手动「缓存帖子」；管理入口在 设置 → 应用 → 已缓存的帖子 |

---

## 目录结构

```
.
├── original/fap/            ← 原版 1.7 的工程源码（未改动，用来对比 / 打补丁）
├── src/
│   ├── fap/                 ← 1.7.6 的工程源码（已改好，可直接打包）
│   └── fam/                 ← 功能模块（mtforumlite.lua 等，原版未改动）
├── patches/                 ← 相对原版 1.7 的逐文件 unified diff（15 个文件）
├── tools/
│   ├── rebuild.py           ← 一条命令出包（fap → apk → 签名 → 自检）
│   ├── build_fap.py         ← 打 .fap（zip）
│   ├── build_apk.py         ← 改 versionName + 替换 assets + 重打包
│   ├── check_apk.py         ← 读版本号 / 对齐 / 完整性
│   ├── apply_patches.py     ← 把 patches/ 套到任意 1.7 工程上
│   ├── Sign.java            ← apksig 签名（V1+V2+V3）
│   └── Verify.java          ← 验签
├── docs/
│   ├── 修改总结.md           ← 每处改动的**位置 + 原因**（含 38 条踩坑记录）
│   └── 移植指南.md           ← 把功能搬到别的版本时的步骤与验收用例
├── base/                    ← 自备原版 APK 放这里（.gitignore 已忽略）
├── build/                   ← 产物（已忽略）
├── LICENSE
└── README.md
```

---

## 准备

1. 原版「Mt论坛Lite 重制版 1.7」的 **APK**，放到 `base/Mt论坛Lite重制版_1.7.apk`
   （或者用环境变量 `BASE_APK` 指到任意位置）。
2. Python 3.8+，Java（只在签名时需要）。

---

## 构建

改完源码，一条命令出包（fap → 未签名 APK → 签名 → 自检）：

```bash
python tools/rebuild.py
#    → dist/mtlite-1.7.6.fap
#    → dist/mtlite-1.7.6.apk   （已签名，检查通过）
```

| 需要的东西 | 放哪儿 |
|---|---|
| 原版 APK（底包） | `base/` 下任意 `.apk`，或环境变量 `BASE_APK` |
| keystore | 环境变量 `KEYSTORE`，或仓库上一级的 `mtsign/*.p12`（自动找） |
| keystore 口令 | 运行时输入，或环境变量 `KS_PASS`；别名用 `KS_ALIAS`，默认取文件名 |
| `apksig.jar` | `tools/apksig.jar`，或环境变量 `APKSIG_JAR`（可从 Android SDK `build-tools/*/lib/` 拷） |

只想出到未签名包：`python tools/rebuild.py --no-sign`。

分步做也可以：

```bash
# 1) 打 fap（其实就是一个 zip，app.json 在最前）
python tools/build_fap.py
#    → build/Mt论坛Lite重制版_<app.json 里的版本号>.fap

# 2) 打 APK：改二进制 AndroidManifest 里的 versionName、替换 assets 里的工程文件
python tools/build_apk.py
#    → build/unsigned.apk

# 3) 签名（先自己生成一个 keystore）
keytool -genkeypair -v -keystore mykey.p12 -storetype PKCS12 \
        -alias mykey -keyalg RSA -keysize 2048 -validity 10000
javac -cp apksig.jar tools/Sign.java
java -cp "apksig.jar:tools" Sign build/unsigned.apk build/app.apk mykey.p12 你的密码 mykey 你的密码
#    Windows 下把 "apksig.jar:tools" 写成 "apksig.jar;tools"

# 4) 校验
python tools/check_apk.py build/app.apk
java -cp "apksig.jar:tools" Verify build/app.apk
```

`apksig.jar` 不随仓库分发，从任意一个 Android SDK 的 `build-tools/*/lib/apksig.jar` 拷一份，
或者从 Maven 取 `com.android.tools.build:apksig`。

---

## 只想搬到自己的版本？用补丁

如果不想用整份工程，而是把这批功能合到你自己改过的 1.7 上：

```bash
# 在目标工程目录（里面应该有 app.json、libs/、pages/ ...）
python /path/to/tools/apply_patches.py /path/to/patches .
```

脚本按上下文逐块匹配，**支持 ±40 行偏移**（所以文件行号变了也能套上），失败会明确报哪一段没对上，
方便你手动合。之所以不用 `git apply`：Windows 上 `core.autocrlf=true` 会把补丁写回成 CRLF，
而这个工程里的文件行尾并不统一。

> 补丁共 15 个文件：`app.json` + 12 个改过的 lua + 2 个新增 lua（`libs/pm_plus.lua`、`libs/tiezi_plus.lua`）。
> 移植要点和验收用例见 [`docs/移植指南.md`](docs/移植指南.md)。

---

## 设置项

进 **设置 → Js**：

| 项 | 默认 | 说明 |
|---|---|---|
| 回复可见自动回复 | 开 | |
| 自动回复内容 | `看看隐藏` | |
| 评论屏蔽 | 开 | |
| 评论屏蔽词 | 一行一条，含正则 | 内置词表只在首次运行预置一次，随便删 |
| 并行加载页数 | 3 | 自动上下页预取的页数 |
| 私信限速自动重发 | 开 | |
| 限速等待秒数 | **16** | 可选 10 / 16 / 20 / 30 / 45；服务端实际限制比这个长时会被拒，弹窗提示后手动重发 |
| 下拉刷新 | 关 | 帖子页改用下拉手势刷新，隐藏右下角刷新按钮 |

「电脑版网页」在 版块 / 搜索 / 签到 / 帖子 / 个人中心 / 主页 / 精华 这 7 个页面的 ⋮ 菜单里。

---

## 已知限制

- **私信冷却时间服务端不会告诉你**，用的是设置里的固定秒数。设短了会被拒（不会自动翻倍，弹窗说明后点「重发」），设长了只是白等。
- 私信倒计时卡片画在网页里，只在「个人中心」相关页面显示；切到别的页面会消失，回到私信页会重新画（队列存在本地，自动发送照常）。
- 电脑版页面下，帖子页的「回复可见自动回复 / 评论屏蔽」不生效（那些选择器是手机模板的），属于预期。
- 论坛改模板可能导致解析失败。这类情况代码会退化成「保持原状」而不是报错，但需要按 `docs/修改总结.md` 里的选择器表重新对一遍。

---

## 免责声明

仅供学习交流。原 App 及其源码（`original/`）版权归原作者所有（包名 `io.github.kawangya.mtforumlite`），
`src/`、`patches/`、`tools/`、`docs/` 里的整理与修改以 MIT 发布。
使用前请遵守论坛的用户协议。

如果这个仓库对你有帮助，欢迎把改法搬到你自己的工程里；发现论坛模板变了导致功能失效，欢迎提 issue 附上页面结构。
