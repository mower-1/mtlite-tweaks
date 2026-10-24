import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
bindClass=luajava.bindClass
Intent = bindClass("android.content.Intent")
Uri = bindClass("android.net.Uri")
AlertDialog = bindClass("android.app.AlertDialog")
ProgressDialog = bindClass("android.app.ProgressDialog")
import "com.google.android.material.textfield.TextInputEditText"
import "com.google.android.material.textfield.TextInputLayout"
import "androidx.recyclerview.widget.*"
import "android.content.res.ColorStateList"
Spannable = bindClass("android.text.Spannable")
SpannableStringBuilder = bindClass("android.text.SpannableStringBuilder")
LinkMovementMethod = bindClass("android.text.method.LinkMovementMethod")
ForegroundColorSpan = bindClass("android.text.style.ForegroundColorSpan")
URLSpan = bindClass("android.text.style.URLSpan")
ClickableSpan = bindClass("android.text.style.ClickableSpan")
StyleSpan = bindClass("android.text.style.StyleSpan")
TextUtils = bindClass("android.text.TextUtils")
RelativeSizeSpan = bindClass "android.text.style.RelativeSizeSpan"
SubscriptSpan = bindClass("android.text.style.SubscriptSpan")
SuperscriptSpan = bindClass "android.text.style.SuperscriptSpan"
主色,强调色,主文本色,副文本色,窗体背景色=获取主题配色()--返回整数颜色值
主色2,强调色2,主文本色2,副文本色2,窗体背景色2=获取主题配色(1)--返回十六进制#
if !获取应用数据("http抓包请求") then
  存储应用数据("http抓包请求","false")
end
if 获取应用数据("http抓包请求")=="true" then
  忽略http请求证书错误(1)
end
if !获取应用数据("跨域请求") then
  存储应用数据("跨域请求","false")
end
--关闭页面左右滑动。本应用每个 ViewPager 只装一张视图，滑动本来没有作用；
--而内置的旧版 androidx ViewPager 在多指触摸、弹窗打断时，会用已经失效的 pointerId
--去调 getX()，抛 IllegalArgumentException: invalid pointerIndex -1，整个应用直接闪退。
--关掉之后 ViewPager 不再参与触摸事件分发，异常路径也就没有了。
pcall(function()
  local 页面容器=this and this.uiManager and this.uiManager.viewPager
  if 页面容器 and 页面容器.setUserInputEnabled then
    页面容器.setUserInputEnabled(false)
  end
end)
function print(内容)--底部
  自定义弹出(内容,nil,1,"15sp",强调色2,"13dp","18dp",fill,wrap,"50dp","0dp",主色2,nil,nil,330,nil)
end
function print2(内容)--中间
  自定义弹出(内容,nil,1,"15sp",强调色2,"13dp","18dp",fill,wrap,"50dp","0dp",主色2,nil,"中间")
end
function 进子页面(页面,参数)
  进入子页面(页面,参数)
  if 获取应用数据("跳转动画")=="true" then
    activity.overridePendingTransition(android_R.anim.fade_in,android_R.anim.fade_out)
  end
end
function 退子页面()
  退出页面()
  if 获取应用数据("跳转动画")=="true" then
    activity.overridePendingTransition(android_R.anim.fade_in,android_R.anim.fade_out)
  end
end
FusionUtil = bindClass("net.fusionapp.core.util.FusionUtil")
function 切换主题(开关,主题名)
  FusionUtil.changeTheme(activity.getLoader().getProjectDir().getAbsolutePath(), 主题名..".json")
  FusionUtil.setNightMode(开关)
  进子页面(nil,nil)
  退出页面()
end
function 设置页切换主题(开关,主题名)
  FusionUtil.changeTheme(activity.getLoader().getProjectDir().getAbsolutePath(), 主题名..".json")
  FusionUtil.setNightMode(开关)
  进子页面("shezhi",{"设置"})
  退出页面()
end
if !获取应用数据("显示FPS") then
  存储应用数据("显示FPS","false")
end
if !获取应用数据("URL超链接") then
  存储应用数据("URL超链接","true")
end
默认快捷菜单表 = {
  {text="加粗"},{text="斜体"},{text="下划线"},{text="删除线"},{text="文本背景色"},
  {text="颜色文字"},{text="彩色文字"},{text="字号文字"},{text="大小文字"},{text="混合文字"},
  {text="对齐文本"},{text="列表"},{text="表格"},{text="代码文本"},{text="引用文本"},{text="隐藏文本"},
  {text="URL 超链接"},{text="Email 超链接"},{text="网络图片"},
  {text="网络视频"},{text="水平线"},{text="联系QQ"}
}
if !获取应用数据("快捷菜单") then--Menulist
  --local data={{text="加粗"},{text="斜体"},{text="下划线"},{text="删除线"},{text="字号文字"},{text="颜色文字"},{text="彩色文字"},{text="URL 超链接"},{text="Email 超链接"},{text="网络图片"},{text="水平线"},{text="对齐文本"},{text="代码文本"},{text="引用文本"},{text="隐藏文本"},{text="网络视频"},{text="表格"},{text="列表"},{text="联系QQ"}}
  local cjson=require("cjson")
  local json=cjson.encode(默认快捷菜单表)
  存储应用数据("快捷菜单",json)
end
if !获取应用数据("帖子历史") then
  local data={}
  local cjson=require("cjson")
  local json=cjson.encode(data)
  存储应用数据("帖子收藏",json)
  存储应用数据("帖子历史",json)
  存储应用数据("浏览历史",json)
end
if !获取应用数据("自动上下页") then
  存储应用数据("自动上下页","false")
end
if !获取应用数据("回复可见自动回复") then
  存储应用数据("回复可见自动回复","true")
end
if !获取应用数据("自动回复内容") then
  存储应用数据("自动回复内容","看看隐藏")
end
if !获取应用数据("评论屏蔽") then
  存储应用数据("评论屏蔽","true")
end
-- 内置屏蔽词（作为一个正则整体写进“评论屏蔽词”，不需要的可以直接删掉）
function 内置屏蔽词列表()
  return {
    "康康看下","看一下","看一看","看下隐藏","看看隐藏","看看内容","看隐藏",
    "看着吧好东西","好东西","试用一下","超级喜欢",
    "感谢分享","感谢大佬分享","感谢楼主","感谢感谢","谢谢谢谢","谢谢分享",
    "学习学习","学习下","学习一下","膜拜大佬","大佬牛批","牛批牛批",
    "厉害厉害","太给力了","恭喜恭喜","支持下","支持一下",
    "论坛有你更美好","论坛有你更精彩","试试看吧","太棒了","太强了","太好了",
    "太强啦","太棒啦","拿走了","快快","大佬牛逼","大佬厉害","厉害了",
    "瞅瞅","学习","看看","试试","优秀","谢谢","大佬","测试","好的",
    "给力","来了","感谢","look","看下","不错","牛","厉害","路过",
  }
end

-- 内置词合并成一条正则（| 表示或，包含匹配，不是完全匹配）
function 内置屏蔽词正则()
  local 词表 = 内置屏蔽词列表()
  return table.concat(词表, "|")
end

-- 版本号：以后改了内置词就加一，升级时会自动替换旧的内置正则
function 内置屏蔽词版本()
  return "3"
end

-- 预置：把内置正则写进屏蔽词设置。旧版本写进去的那一条会被换掉，用户自己的词保留
if 获取应用数据("屏蔽词预置") ~= 内置屏蔽词版本() then
  local 现有 = 获取应用数据("评论屏蔽词") or ""
  local 保留 = {}
  for 行 in 现有:gmatch("[^\r\n]+") do
    local 干净 = 行:gsub("^%s+", ""):gsub("%s+$", "")
    -- 每版内置正则都以“康康看下|”开头，据此把旧的那条丢掉
    if 干净 ~= "" and not 干净:find("^康康看下|", 1) then
      table.insert(保留, 行)
    end
  end
  table.insert(保留, 内置屏蔽词正则())
  存储应用数据("评论屏蔽词", table.concat(保留, "\n"))
  存储应用数据("屏蔽词预置", 内置屏蔽词版本())
end

if !获取应用数据("并行加载页数") then
  存储应用数据("并行加载页数","2")
end
if !获取应用数据("私信限速自动重发") then
  存储应用数据("私信限速自动重发","true")
end
if !获取应用数据("私信限速等待秒数") then
  存储应用数据("私信限速等待秒数","16")
end
-- 旧默认值 15 秒统一提到 16 秒（只迁移一次）
if 获取应用数据("私信秒数版本")~="16" then
  if 获取应用数据("私信限速等待秒数")=="15" then
    存储应用数据("私信限速等待秒数","16")
  end
  存储应用数据("私信秒数版本","16")
end
if !获取应用数据("自动签到") then
  存储应用数据("自动签到","false")
end
if !获取应用数据("下一页重调用") then
  存储应用数据("下一页重调用","false")
end
if !获取应用数据("跳转动画") then
  存储应用数据("跳转动画","false")
end
if !获取应用数据("下载方式") then
  存储应用数据("下载方式","true")
end
if !获取应用数据("主题模式") then
  存储应用数据("主题模式",1)
end
if !获取应用数据("圆角对话框") then
  if Build.VERSION.SDK_INT<34 then
    存储应用数据("圆角对话框","false")
    if 系统主题状态() then
      跟随主题名="ThemePuan"
     else
      跟随主题名="ThemePuliang"
    end
    切换主题(系统主题状态(),跟随主题名)
   else
    存储应用数据("圆角对话框","true")
  end
end
if !获取应用数据("网页背景色") then
  存储应用数据("网页背景色","true")
end
if !获取应用数据("拦截网址") then
  存储应用数据("拦截网址","example.com")
end
if !获取应用数据("手机UA") then
  存储应用数据("手机UA","Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36")
end
if !获取应用数据("电脑UA") then
  存储应用数据("电脑UA","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36")
end

-- ============================ 电脑版网页 ============================
-- 页面右上角三个点 → 电脑版网页：用现成的「浏览页PC」打开当前地址。
-- 那个页面的 UA 就是 拓展功能 → 电脑UA，界面也沿用它的（全屏/手机模式/网页审查都在它的菜单里）。
-- 注意：手机版地址大多带 mobile=2，会强制触屏模板，得换成 mobile=no 才能真正出电脑版。

function 电脑版网址(链接)
  local u = tostring(链接 or "")
  if u == "" then return u end
  if u:find("[?&]mobile=2") then
    return (u:gsub("([?&])mobile=2", "%1mobile=no"))
  end
  return u
end

function 手机版网址(链接)
  local u = tostring(链接 or "")
  if u == "" then return u end
  return (u:gsub("([?&])mobile=no", "%1mobile=2"))
end

-- 论坛可能把「用电脑版」记在 cookie 里（名字里含 mobile），不清掉的话
-- 就算 URL 改回 mobile=2、UA 换回手机，服务端照样给电脑版模板。
function 重置手机版Cookie()
  pcall(function()
    local CookieManager = luajava.bindClass("android.webkit.CookieManager")
    local 管理器 = CookieManager.getInstance()
    local 地址 = "https://bbs.binmt.cc/"
    local 原 = 管理器.getCookie(地址) or ""
    for kv in 原:gmatch("[^;]+") do
      local 名 = kv:match("^%s*([^=]+)=")
      if 名 and 名:lower():find("mobile") then
        管理器.setCookie(地址, 名 .. "=; path=/; max-age=0")
      end
    end
  end)
end

--判断两个地址是不是同一页（忽略 mobile 参数和 # 锚点，用来判断「有没有翻到别的页面」）
function 同一网页(甲, 乙)
  local function 规范(u)
    u = tostring(u or "")
    u = u:gsub("#.*$", "")
    u = u:gsub("([?&])mobile=[^&]*", "")
    u = u:gsub("%?&", "?")
    u = u:gsub("&&", "&")
    u = u:gsub("[?&]+$", "")
    u = u:gsub("^http://", "https://")
    return u
  end
  local a, b = 规范(甲), 规范(乙)
  if a == "" or b == "" then return false end
  return a == b
end

--用 App 自己的页面打开一个手机版地址（帖子/板块/用户页/登录/签到），能接手就返回 true
function 用手机版页面打开(链接)
  local u = tostring(链接 or "")
  if u == "" or u:find("^file://") then return false end
  local 帖子 = u:match("thread%-%d+%-%d+%-%d+%.html") or u:find("mod=viewthread") or u:find("[?&]tid=%d+")
  local 板块 = u:match("forum%-%d+%-%d+%.html") or u:find("mod=forumdisplay")
  local 登录 = u:find("member%.php%?mod=logging") or u:find("mod=logging&action=login")
  local 签到 = u:find("k_misign")
  local 用户 = u:find("mod=space&uid=") or u:find("mod=space&do=profile")
  if 登录 then
    进子页面("denglu")
    退出页面()
    return true
  end
  if 帖子 then
    进子页面("tiezi", {u})
    退出页面()
    return true
  end
  if 板块 then
    进子页面("bankuai", {u})
    退出页面()
    return true
  end
  if 签到 then
    进子页面("qiandao")
    退出页面()
    return true
  end
  if 用户 then
    进子页面("yonghu", {u})
    退出页面()
    return true
  end
  return false
end

function 打开电脑版网页(链接)
  local u = tostring(链接 or 获取网址() or "")
  if u == "" then u = "https://bbs.binmt.cc/" end
  if u:find("^file://") then
    print("本地页面没有电脑版")
    return
  end
  --「首页（导读-热帖）」和「社区列表」在电脑版没有对应页面：
  --直接拿原地址进电脑版会落到导读页，统一改成论坛首页 forum.php
  local 主机 = u:match("^(https?://[^/]+)") or "https://bbs.binmt.cc"
  if u:find("view=hot") or u:find("forumlist=1") then
    u = 主机 .. "/forum.php"
  end
  进子页面("liulanyepc",{电脑版网址(u)})
end
if !获取应用数据("默认浏览页") then
  存储应用数据("默认浏览页","liulanye")
end
if !获取应用数据("隐藏应用栏") then
  存储应用数据("隐藏应用栏","false")
end
if !获取应用数据("显示悬浮按钮") then
  存储应用数据("显示悬浮按钮","true")
end
if 获取应用数据("圆角对话框")=="true" then
  if 应用主题状态() then
    activity.setTheme(android.R.style.Theme_DeviceDefault);
    --activity.setTheme(android.R.style.Theme_Holo);
   else
    activity.setTheme(android.R.style.Theme_DeviceDefault_Light);
    --activity.setTheme(android.R.style.Theme_Holo_Light);
  end
 else
  if 应用主题状态() then
    activity.setTheme(R.style.Theme_AppCompat);
    --activity.setTheme(R.style.Theme_MaterialComponents);
   else
    activity.setTheme(R.style.Theme_AppCompat_Light);
    --activity.setTheme(R.style.Theme_MaterialComponents_Light);
  end
end
if 获取应用数据("主题模式")==1 then
  if 应用主题状态()~=系统主题状态() then
    if 获取应用数据("圆角对话框")=="true" then
      if 系统主题状态() then
        跟随主题名="ThemeDark"
       else
        跟随主题名="ThemeBright"
      end
     else
      if 系统主题状态() then
        跟随主题名="ThemePuan"
       else
        跟随主题名="ThemePuliang"
      end
    end
    切换主题(系统主题状态(),跟随主题名)
  end
end
if !获取应用数据("登录参数") then
  登录参数=nil
 else
  登录参数=获取应用数据("登录参数")
end
if 悬浮按钮 then
  if 获取应用数据("显示悬浮按钮")=="true" then
    显隐悬浮按钮(1)
    悬浮按钮.layoutParams.behavior=nil
  end
end
if 侧滑栏标题 then
  设置控件圆角(获取侧滑栏(), {0, 100, 100, 0}, 窗体背景色)
end
function 隐藏控件对话框(控件名,funa)
  if 获取应用数据(控件名.."1") then
    funa()
   else
    隐藏控件=AlertDialog.Builder(activity)
    .setTitle("即将"..控件名)
    .setMessage("隐藏后点击任意音量键两次即可恢复。")
    .setPositiveButton("确定",{onClick=function(v)
        funa()
        存储应用数据(控件名.."1",1)
      end})
    .setNegativeButton("取消",nil)
    .show()
    隐藏控件.findViewById(android.R.id.message).setTextIsSelectable(true)
  end
end
function 跳转应用对话框(应用名,url,funa)
  跳转文本 = SpannableStringBuilder("网页请求打开"..应用名.."，请注意您的帐号和财产安全。\n\n链接：")
  local start = 跳转文本.length()
  跳转文本.append(url)
  local ends = 跳转文本.length()
  跳转文本.setSpan(URLSpan(url),start,ends,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
  跳转对话框=AlertDialog.Builder(this)--普通对话框
  .setTitle("网页请求打开")
  .setMessage(跳转文本)
  .setPositiveButton("打开",{onClick=funa})
  .setNegativeButton("取消",nil)
  .show()
  跳转对话框.findViewById(android.R.id.message).setTextIsSelectable(true)
  跳转对话框.findViewById(android.R.id.message).setMovementMethod(LinkMovementMethod.getInstance())
end
function 离开本站对话框(url)
  离开文本 = SpannableStringBuilder("您即将离开Mt论坛，请注意您的帐号和财产安全。\n\n链接：")
  local start = 离开文本.length()
  离开文本.append(url)
  local ends = 离开文本.length()
  离开文本.setSpan(URLSpan(url),start,ends,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
  离开对话框=AlertDialog.Builder(this)--普通对话框
  .setTitle("即将离开本站")
  .setMessage(离开文本)
  .setPositiveButton("继续访问",{onClick=function(v)
      进子页面(获取应用数据("默认浏览页"),{url})
    end})
  .setNegativeButton("取消",nil)
  .setNeutralButton("复制链接",{onClick=function(v)
      复制文本(url)
    end})
  .show()
  离开对话框.findViewById(android.R.id.message).setTextIsSelectable(true)
  离开对话框.findViewById(android.R.id.message).setMovementMethod(LinkMovementMethod.getInstance())
end
function 通用编辑框功能(bt,bt0,bt1,bt2,bt3,funa,funb,func)
  if funa==nil then
    funa=function() dialog.dismiss() end
  end
  if funb==nil then
    funb=function() dialog.dismiss() end
  end
  if func==nil then
    func=function() dialog.dismiss() end
  end
  view_table={
    LinearLayout,
    layout_width="match",
    layout_height="match",
    orientation=1,
    {
      TextInputLayout,
      id="input_layout",
      layout_height="wrap",
      layout_marginLeft="20dp",
      layout_marginRight="20dp",
      layout_width="match",
      --hint="请输入需要编解码/加解密的内容",--设置输入框提示文本
      {
        TextInputEditText,
        id="edit_text",
        text=bt0,
        layout_height="wrap",
        layout_width="match",
      },
    },
  }
  dialog=AlertDialog.Builder(activity)
  .setTitle(bt)
  .setView(loadlayout(view_table))
  .setPositiveButton(bt1,nil)
  .setNegativeButton(bt2,nil)
  .setNeutralButton(bt3,nil)
  .show()
  dialog.getButton(AlertDialog.BUTTON1).onClick=funa
  dialog.getButton(AlertDialog.BUTTON2).onClick=funb
  dialog.getButton(AlertDialog.BUTTON3).onClick=func
end
function 网页查找对话框()
  local view_table={
    LinearLayout,
    layout_width="match",
    layout_height="match",
    orientation=1,
    {
      TextInputLayout,
      id="input_layout",
      layout_marginLeft="20dp",
      layout_marginRight="20dp",
      layout_height="wrap",
      layout_width="match",
      hint="请关键词进行查找...",--设置输入框提示文本
      {
        TextInputEditText,
        id="edit_text",
        singleLine=true;--设置单行输入，禁止换行
        layout_height="wrap",
        layout_width="match",
      },
    },
  }
  local 网页查找=AlertDialog.Builder(activity)
  .setTitle("网页查找")
  .setView(loadlayout(view_table))
  .setPositiveButton("下一个",nil)
  .setNegativeButton("取消",nil)
  .setOnDismissListener(function()
    页内查找("")
  end)
  .show()
  网页查找.getButton(AlertDialog.BUTTON1).onClick=function()
    页内查找(edit_text.text)
  end
  local window =网页查找.getWindow()
  local lp =window.getAttributes()
  lp.alpha = 0.9
  local lp = window.getAttributes();
  lp.dimAmount=0.0
  window.setAttributes(lp);
end
function 添加收藏对话框(内容1,内容2)
  local view_table={
    LinearLayout,
    layout_width="match",
    layout_height="match",
    orientation=1,
    {
      TextInputLayout,
      id="input_layout",
      layout_marginLeft="20dp",
      layout_marginRight="20dp",
      layout_height="wrap",
      layout_width="match",
      hint="标题",--设置输入框提示文本
      {
        TextInputEditText,
        id="edit_text",
        text=内容1,
        singleLine=true;--设置单行输入，禁止换行
        layout_height="wrap",
        layout_width="match",
      },
    },
    {
      TextInputLayout,
      id="input_layout2",
      layout_marginLeft="20dp",
      layout_marginRight="20dp",
      layout_height="wrap",
      layout_width="match",
      hint="网址",--设置输入框提示文本
      {
        TextInputEditText,
        id="edit_text2",
        text=内容2,
        singleLine=true;--设置单行输入，禁止换行
        layout_height="wrap",
        layout_width="match",
      },
    },
  }
  local 添加收藏=AlertDialog.Builder(activity)
  .setTitle("添加收藏")
  .setView(loadlayout(view_table))
  .setPositiveButton("确定",{onClick=function()
      if edit_text.text~="" and edit_text2.text~="" then
        local cjson=require("cjson")
        local data=cjson.decode(获取应用数据("帖子收藏"))
        table.insert(data,1,{PageName=activity.getLoader().getPageName(),Title=edit_text.text,Text=edit_text2.text})
        local json=cjson.encode(data)
        存储应用数据("帖子收藏",json)
        print("添加成功")
       else
        print("参数nil,添加失败")
      end
    end})
  .setNegativeButton("取消",nil)
  .show()
end
function table.unique(t,bArray,mainKey)
  local check = {}
  local n = {}
  local idx = 1
  for k, v in pairs(t) do
    local judgeKey = v
    if mainKey then
      judgeKey = v[mainKey] or v
    end
    if not check[judgeKey] then
      if bArray then
        n[idx] = v
        idx = idx + 1
       else
        n[k] = v
      end
      check[judgeKey] = true
    end
  end
  return n
end
import "java.io.File"--导入File类
function 历史收藏列表(标题,存储名)
  local view_table=
  {
    LinearLayout,
    layout_width="match",
    layout_height="match",
    orientation=1,
    {
      RecyclerView,
      id="recycler_view",
      layout_width="match",
      layout_height="wrap",
      paddingLeft='15dp';--布局内左距
      paddingRight='15dp';--布局内右距
      paddingTop='10dp';--布局内顶距
    },
  }
  local cjson=require("cjson")
  local data=cjson.decode(获取应用数据(存储名))
  dialog=AlertDialog.Builder(activity)
  .setTitle(标题.."("..tostring(#data)..")")
  .setView(loadlayout(view_table))
  .setPositiveButton("确定",nil)
  .setNegativeButton("清空",{onClick=function()
      local data={}
      local cjson=require("cjson")
      local json=cjson.encode(data)
      存储应用数据(存储名,json)
      print("清除成功")
    end})
  .setNeutralButton("导入/导出",nil)
  .show()
  dialog.getButton(AlertDialog.BUTTON3).onClick=function(v)
    function 导入导出菜单(v)
      PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
      local popupMenu=PopupMenu(activity,v)
      local 主菜单=popupMenu.menu
      主菜单.add("说明")
      主菜单.add("导入")
      主菜单.add("导出")
      popupMenu.onMenuItemClick=function(item)
        switch item.title
         case "说明"
          路径="/sdcard/Download/Mt论坛Lite/"..标题..".txt"
          命名=AlertDialog.Builder(this)--普通对话框
          .setTitle("导入/导出说明")
          .setMessage([[①由于不太会写文件方面的事件，所以这里采取的是固定路径文件导出导入
②为防止不必要的报错，导出文件做了加密处理，导入只能导入导出的加密文件。

]]..标题..[[文件导出导入路径：
]]..路径)
          .setPositiveButton("知道了",nil)
          .setOnDismissListener(function()
            存储应用数据("导入导出",1)
          end)
          .show()
          命名.findViewById(android.R.id.message).setTextIsSelectable(true)--文字可复制
         case "导入"
          if 获取应用数据("导入导出") then
            路径="/sdcard/Download/Mt论坛Lite/"..标题..".txt"
            if File(路径).exists() then
              存储应用数据(存储名,ChaCha20解密("mtforumlite",读取文本(路径)))
              print"导入成功"
              dialog.hide()
             else
              print("请将文件放置于 Download/Mt论坛Lite 文件夹内，并重命名为"..标题..".txt")
            end
           else
            print"请先查看说明"
          end
         case "导出"
          if 获取应用数据("导入导出") then
            路径="/sdcard/Download/Mt论坛Lite/"..标题..".txt"
            写入文本(路径,ChaCha20加密("mtforumlite",获取应用数据(存储名)))
            print("导出位置：/sdcard/Download/Mt论坛Lite/"..标题..".txt")
           else
            print"请先查看说明"
          end
        end
      end
      -- 显示弹出菜单
      popupMenu.show()
      -- 配置背景颜色(只适合只有主菜单)
      popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
    end
    导入导出菜单(v)
  end
  local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
  local list_item={
    LinearLayout,
    layout_width="match",
    layout_height="wrap",
    {
      MaterialCardView,
      id="card",
      layout_width="match",
      layout_height="wrap",
      cardElevation="0dp",--卡片阴影强度
      radius="0dp",--卡片圆角幅度
      {
        LinearLayout,
        layout_width="match",
        layout_height="wrap",
        padding="10dp",
        Orientation=1,
        backgroundColor=窗体背景色,
        {
          TextView,
          id="Title",
          textSize="14sp",
          textStyle="bold",
          textColor=主文本色,
        },
        {
          TextView,
          id="Text",
          ellipsize="end",
          singleLine=true;--设置单行输入
          textColor=副文本色,
          textSize="10sp",
          layout_marginTop="2dp",
        },
      },
    },
  }
  recycler_view.layoutManager=LinearLayoutManager(activity)
  local data=table.unique(data,true,"Text")
  存储应用数据(存储名,cjson.encode(data))
  local adapter=LuaRecyclerAdapter(activity,data,list_item)
  adapter.clickViewId="card"
  adapter.onItemClick=function(adapter,itemView,view,pos)
    --简单获取到当前item的Data表
    local itemData = adapter.Data[pos+1]
    if itemData.Text:find("^file://") then
      进子页面(itemData.PageName,{itemData.Text,1})
     else
      进子页面(itemData.PageName,{itemData.Text})
    end
  end
  adapter.onItemLongClick=function(adapter,itemView,view,pos)
    local itemData = adapter.Data[pos+1]
    function 弹出菜单(v)
      PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
      local popupMenu=PopupMenu(activity,v)
      local 主菜单=popupMenu.menu
      主菜单.setOptionalIconsVisible(true)--无多主菜单需e设置显示图标
      主菜单.add("复制标题").setIcon(R.drawable.abc_ic_menu_copy_mtrl_am_alpha).setIconTintList(ColorStateList.valueOf(强调色))
      主菜单.add("复制链接").setIcon(R.drawable.abc_ic_menu_copy_mtrl_am_alpha).setIconTintList(ColorStateList.valueOf(强调色))
      if 存储名~="帖子收藏" and (itemData.Text):find("bbs.binmt.cc") then
        主菜单.add("添加收藏").setIcon(R.drawable.ic_save_white_24).setIconTintList(ColorStateList.valueOf(强调色))
      end
      主菜单.add("删除记录").setIcon(R.drawable.ic_delete_24dp).setIconTintList(ColorStateList.valueOf(强调色))
      popupMenu.onMenuItemClick=function(item)
        switch item.title
         case "添加收藏"
          local cjson=require("cjson")
          local data=cjson.decode(获取应用数据("帖子收藏"))
          table.insert(data,1,{PageName=(itemData.PageName),Title=(itemData.Title),Text=(itemData.Text)})
          local json=cjson.encode(data)
          存储应用数据("帖子收藏",json)
          print("添加成功")
         case "复制标题"
          复制文本(itemData.Title)
          print("已复制到剪贴板")
         case "复制链接"
          复制文本(itemData.Text)
          print("已复制到剪贴板")
         case "删除记录"
          recycler_view.getAdapter().remove(pos)
          local cjson=require("cjson")
          local data=cjson.decode(获取应用数据(存储名))
          table.remove(data,pos+1)
          local json=cjson.encode(data)
          存储应用数据(存储名,json)
        end
      end
      popupMenu.show()
      popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
    end
    弹出菜单(view)
    return true
  end
  recycler_view.adapter=adapter
end

--提取论坛 Cookie（含登录态）。弹窗展示，可一键复制。
function 提取Cookie对话框()
  local CookieManager=bindClass("android.webkit.CookieManager")
  local cookie=tostring(CookieManager.getInstance().getCookie("https://bbs.binmt.cc/") or "")
  if cookie=="" then
    print2("没有取到 Cookie\n请先在软件里登录一次")
    return
  end
  local 布局={
    ScrollView,
    layout_width="fill",
    layout_height="fill",
    {
      TextView,
      layout_width="fill",
      layout_height="wrap",
      padding="20dp",
      textSize="12sp",
      textColor=主文本色,
      Text=cookie,
      id="Cookie文本框",
    },
  }
  local 对话框视图=loadlayout(布局)
  Cookie文本框.setTextIsSelectable(true)
  AlertDialog.Builder(this)
  .setTitle("Cookie（"..cookie:len().." 字符）")
  .setView(对话框视图)
  .setPositiveButton("复制",{onClick=function()
    复制文本(cookie)
    print("已复制 "..cookie:len().." 个字符")
  end})
  .setNegativeButton("关闭",nil)
  .show()
end

-- ===== 帖子本地缓存 =====
--存整页渲染后的 HTML（含已加载的评论），键为 tid，上限 50 篇，超出自动删最旧的。
--帖子被删后打开会命中「提示信息」错误页，此时自动改显本地缓存。
帖子缓存目录=activity.getExternalFilesDir(nil).toString().."/postcache"
function 帖子缓存表()
  local cjson=require("cjson")
  local t=cjson.decode(获取应用数据("帖子缓存表") or "[]")
  return t or {}
end
function 保存帖子缓存表(t)
  local cjson=require("cjson")
  存储应用数据("帖子缓存表",cjson.encode(t))
end
function 读取帖子缓存(tid)
  for _,v in ipairs(帖子缓存表()) do
    if tostring(v.tid)==tostring(tid) then return v end
  end
end
function 读缓存HTML(v)
  if not (v and v.file) then return nil end
  local f=io.open(v.file,"r")
  if not f then return nil end
  local html=f:read("*a")
  f:close()
  if html=="" then return nil end
  return html
end
function 写入帖子缓存(tid,标题,url,html)
  local 成功,错误=pcall(function()
    local File=bindClass("java.io.File")
    local 目录=File(帖子缓存目录)
    if not 目录.exists() then 目录.mkdirs() end
    --打标记：缓存页里的增强脚本全部跳过，避免弹自动回复之类
    html=html:gsub("<head>","<head><script>window.__MLITE_CACHE__=1;</script>",1)
    local 文件=File(目录,"tid_"..tid..".html")
    local f=io.open(文件.toString(),"w")
    f:write(html)
    f:close()
    local 新表={}
    for _,v in ipairs(帖子缓存表()) do
      if tostring(v.tid)~=tostring(tid) then table.insert(新表,v) end
    end
    table.insert(新表,1,{tid=tid,title=标题,url=url,time=os.date("%Y-%m-%d %H:%M"),file=文件.toString()})
    while #新表>50 do
      local 旧=table.remove(新表)
      pcall(function() os.remove(旧.file) end)
    end
    保存帖子缓存表(新表)
  end)
  return 成功,错误
end
function 已缓存数量文本()
  return "当前 "..#帖子缓存表().." 篇（上限 50 篇，超出自动删最旧的）"
end
function 已缓存帖子对话框()
  local t=帖子缓存表()
  if #t==0 then
    print2("还没有缓存\n在帖子页 ⋮ 菜单点「缓存帖子」即可保存当前页面")
    return
  end
  local 标题s={}
  for i,v in ipairs(t) do
    标题s[i]=(v.title or ("帖子"..v.tid)).."\n"..v.time
  end
  AlertDialog.Builder(this)
  .setTitle("已缓存的帖子（"..#t.."）")
  .setItems(标题s,{onClick=function(v,p)
    进子页面("tiezi",{t[p+1].url})
  end})
  .setNeutralButton("清空",{onClick=function(v)
    for _,x in ipairs(t) do pcall(function() os.remove(x.file) end) end
    保存帖子缓存表({})
    print("已清空全部帖子缓存")
  end})
  .setNegativeButton("关闭",nil)
  .show()
end

function 编辑快捷菜单对话框()
  import "com.google.android.flexbox.*"
  import "androidx.recyclerview.widget.*"
  import "com.google.android.material.chip.Chip"
  local view_table=
  {
    LinearLayout,
    layout_width="match",
    layout_height="match",
    orientation=1,
    {
      RecyclerView,
      id="recycler_view",
      layout_width="match",
      layout_height="wrap",
      padding="10dp"
    }
  }
  local cjson=require("cjson")
  local data=cjson.decode(获取应用数据("快捷菜单"))
  --设置列表布局
  local list_item={
    LinearLayout,
    layout_width="wrap",
    layout_height="wrap",
    {
      Chip;
      layout_width="wrap";
      layout_height="wrap";
      layout_marginLeft='3dp';--布局左距
      layout_marginRight='3dp';--布局右距
      id="text",
      TextSize="15";
      TextColor=colorTextPrimary;
    };
  }
  local dialog=AlertDialog.Builder(activity)
  .setTitle("快捷菜单编辑排序")
  .setView(loadlayout(view_table))
  .setPositiveButton("保存",{onClick=function(v)
      local cjson=require("cjson")
      local json=cjson.encode(recycler_view.getAdapter().Data)
      存储应用数据("快捷菜单",json)
      print("保存成功")
    end})
  .setNegativeButton("取消",{onClick=function(v)
      local cjson=require("cjson")
      local json=cjson.encode(recycler_view.getAdapter().Data)
      local texts = {}
      local texts2 = {}
      for text in json:gmatch('"text":"([^"]+)"') do
        table.insert(texts, text)
      end
      for text in 获取应用数据("快捷菜单"):gmatch('"text":"([^"]+)"') do
        table.insert(texts2, text)
      end
      -- 按顺序一起打印所有文本
      local allTexts = table.concat(texts, ", ")
      local allTexts2 = table.concat(texts2, ", ")
      if allTexts~=allTexts2 then
        local dialog=AlertDialog.Builder(activity)
        .setTitle("温馨提示")
        .setMessage("列表发生改变，是否需要保存？")
        .setPositiveButton("是",{onClick=function(v)
            存储应用数据("快捷菜单",json)
            print("保存成功")
          end})
        .setNegativeButton("否",nil)
        .show()
      end
    end})
  .setNeutralButton("添加快捷项",nil)
  .setOnCancelListener(function()
    local cjson=require("cjson")
    local json=cjson.encode(recycler_view.getAdapter().Data)
    local texts = {}
    local texts2 = {}
    for text in json:gmatch('"text":"([^"]+)"') do
      table.insert(texts, text)
    end
    for text in 获取应用数据("快捷菜单"):gmatch('"text":"([^"]+)"') do
      table.insert(texts2, text)
    end
    -- 按顺序一起打印所有文本
    local allTexts = table.concat(texts, ", ")
    local allTexts2 = table.concat(texts2, ", ")
    if allTexts~=allTexts2 then
      local dialog=AlertDialog.Builder(activity)
      .setTitle("温馨提示")
      .setMessage("列表发生改变，是否需要保存？")
      .setPositiveButton("是",{onClick=function(v)
          存储应用数据("快捷菜单",json)
          print("保存成功")
        end})
      .setNegativeButton("否",nil)
      .show()
    end
  end)--监听对话框取消
  .show()
  local flexboxLayoutManager = ExetendFlexboxLayoutManager(this);
  --主轴为水平方向，起点在左端
  flexboxLayoutManager.setFlexDirection(FlexDirection.ROW);
  --按正常方向换行
  flexboxLayoutManager.setFlexWrap(FlexWrap.WRAP);
  --定义项目在副轴轴上如何对齐
  flexboxLayoutManager.setAlignItems(AlignItems.CENTER);
  --多个轴对齐方式
  flexboxLayoutManager.setJustifyContent(JustifyContent.FLEX_START);
  --设置最大显示行
  --flexboxLayoutManager.setMaxLine(2)
  recycler_view.setLayoutManager(flexboxLayoutManager);
  local adapt=LuaRecyclerAdapter(activity,data,list_item)
  adapt.clickViewId="text"
  adapt.onItemClick=function(
    adapter,--适配器对象
    itemView,--项目布局对象
    view,--点击的控件对象
    pos--点击的位置索引
    )
    ColorStateList = bindClass("android.content.res.ColorStateList")
    PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
    local popupMenu=PopupMenu(activity,view)
    local 主菜单=popupMenu.menu
    主菜单.setOptionalIconsVisible(true)--无多主菜单需e设置显示图标
    if pos~=0 then
      主菜单.add("左移").setIcon(R.drawable.material_ic_keyboard_arrow_left_black_24dp).setIconTintList(ColorStateList.valueOf(强调色))
    end
    if adapter.getItemCount()-1 ~= pos then
      主菜单.add("右移").setIcon(R.drawable.abc_ic_go_search_api_material).setIconTintList(ColorStateList.valueOf(强调色))
    end
    if adapter.Data[pos+1].Content then
      主菜单.add("删除").setIcon(R.drawable.ic_delete_24dp).setIconTintList(ColorStateList.valueOf(强调色))
    end
    -- 处理菜单项点击事件
    popupMenu.onMenuItemClick=function(item)
      switch item.title
       case "左移"
        local itemData = adapter.Data[pos+1]
        adapter.remove(pos)
        adapter.insert(pos-1,itemData)
        adapter.notifyDataSetChanged()
       case "右移"
        local itemData = adapter.Data[pos+1]
        adapter.remove(pos)
        adapter.insert(pos+1,itemData)
        adapter.notifyDataSetChanged()
       case "删除"
        adapter.remove(pos)
      end
    end
    -- 显示弹出菜单
    popupMenu.show()
    popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
  end
  recycler_view.adapter=adapt
  dialog.getButton(AlertDialog.BUTTON3).onClick=function()
    local TextInputLayout = luajava.bindClass "com.google.android.material.textfield.TextInputLayout"
    local TextInputEditText = luajava.bindClass "com.google.android.material.textfield.TextInputEditText"
    local view_table=
    {LinearLayout,
      layout_width="match",
      layout_height="match",
      orientation=1,
      {TextInputLayout,
        id="input_layout",
        layout_height="wrap",
        layout_marginLeft="20dp",
        layout_marginRight="20dp",
        --suffixText="后缀文本",
        --error="错误提示",
        counterEnabled="true",
        counterMaxLength="6",
        layout_width="match",
        hint="请输入标题",--设置输入框提示文本
        {TextInputEditText,
          id="edit_text",
          singleLine=true;--设置单行输入，禁止换行
          layout_height="wrap",
          layout_width="match",
        },
      },
      {TextInputLayout,
        id="input_layout2",
        layout_height="wrap",
        layout_marginLeft="20dp",
        layout_marginRight="20dp",
        --suffixText="后缀文本",
        --error="错误提示",
        layout_width="match",
        hint="请输入内容",--设置输入框提示文本
        {TextInputEditText,
          id="edit_text2",
          layout_height="wrap",
          layout_width="match",
        },
      },
    }
    local dialog=AlertDialog.Builder(activity)
    .setTitle("添加快捷项")
    .setView(loadlayout(view_table))
    .setPositiveButton("确定",nil)
    .setNegativeButton("取消",nil)
    .setNeutralButton("功能说明",nil)
    .show()
    task(100,function()
      local Context = luajava.bindClass "android.content.Context"
      import "android.view.inputmethod.InputMethodManager"
      edit_text.getContext().getSystemService(Context.INPUT_METHOD_SERVICE).toggleSoftInput(0,InputMethodManager.HIDE_NOT_ALWAYS)
      edit_text.requestFocus()
    end)
    dialog.getButton(AlertDialog.BUTTON1).onClick=function()
      local txt=edit_text.text
      local txt2=edit_text2.text
      if txt=="" then
        input_layout.setError("不可为空")
       elseif txt2=="" then
        input_layout2.setError("不可为空")
       else
        local data=adapt.Data
        table.insert(data,1,{text=txt,Content=txt2})
        adapt.notifyDataSetChanged()
        dialog.hide()
      end
    end
    dialog.getButton(AlertDialog.BUTTON3).onClick=function()
      local dialog=AlertDialog.Builder(activity)
      .setTitle("添加说明")
      .setMessage("该功能可添加一个快捷回复按钮。\n该功能要求标题不可超过六个字，长按可删除(默认功能不可删除)。")
      .setPositiveButton("确定",nil)
      .show()
    end
    edit_text.addTextChangedListener{
      onTextChanged=function()
        --事件
        if edit_text.text=="" then
          input_layout.setError("不可为空")
         elseif input_layout.getEditText().getText().length() > input_layout.getCounterMaxLength() then
          input_layout.setError("不得超过六位")
         else
          input_layout.setError(null)
        end
      end}
    edit_text2.addTextChangedListener{
      onTextChanged=function()
        if edit_text2.text=="" then
          input_layout2.setError("不可为空")
         else
          input_layout2.setError(null)
        end
      end}
  end
end