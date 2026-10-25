require "import"
使用公共lua文件("libs")
import "gongyong"
import "tiezi_plus"
import "pm_plus"
if !获取应用数据("娱乐功能") then
  功能开启计数=1
end
软件名,版本名,版本号=打印应用信息(获取包名())
--[[
1-标题(分割线)
2-仅标题设置
3-双标题设置
4-仅标题开关设置
5-双标题开关设置
]]
设置列表 = {
  { __type = 1, title = "主题" },
  { __type = 3, subtitle = "主题模式", message = "设置软件的主题配色" },
  { __type = 5, subtitle = "圆角对话框", message = "原生主题圆角对话框(较新系统有效)", status = { Checked = 获取应用数据("圆角对话框") == "true" } },
  { __type = 5, subtitle = "网页背景色", message = "设置网页背景适配软件窗体颜色", status = { Checked = 获取应用数据("网页背景色") == "true" } },
  { __type = 6},
  { __type = 1, title = "应用" },
  { __type = 3, subtitle = "拓展功能", message = "不常用的拓展功能设置" },
  { __type = 3, subtitle = "检测原版更新", message = "检测原作者 Mt论坛Lite 的新版本" },
  { __type = 3, subtitle = "检测改版更新", message = "检测重置版的新版本（简库资源网）" },
  { __type = 3, subtitle = "提取Cookie", message = "查看 / 复制论坛登录 Cookie" },
  { __type = 3, subtitle = "已缓存的帖子", message = 已缓存数量文本() },
  --{ __type = 3, subtitle = "查看更新", message = "查看本软件下载链接" },
  { __type = 6},
  { __type = 1, title = "快捷" },
  { __type = 3, subtitle = "编辑菜单", message = "编辑快捷菜单排序及添加" },
  { __type = 5, subtitle = "自动签到", message = "打开软件自动签到", status = { Checked = 获取应用数据("自动签到") == "true" } },
  { __type = 6},
  { __type = 1, title = "Js" },
  { __type = 5, subtitle = "URL超链接", message = "将帖子/空间(私聊)内容中的链接自动设置超链接", status = { Checked = 获取应用数据("URL超链接") == "true" } },
  { __type = 5, subtitle = "自动上下页", message = "帖子中自动加载上一页、下一页评论", status = { Checked = 获取应用数据("自动上下页") == "true" } },
  { __type = 3, subtitle = "并行加载页数", message = 并行页数文本() },
  { __type = 5, subtitle = "回复可见自动回复", message = "检测到回复可见内容时弹窗询问是否自动回复", status = { Checked = 获取应用数据("回复可见自动回复") == "true" } },
  { __type = 3, subtitle = "自动回复内容", message = "当前：" .. (获取应用数据("自动回复内容") or "看看隐藏") },
  { __type = 5, subtitle = "评论屏蔽", message = "楼层内容命中屏蔽词时隐藏整条楼层", status = { Checked = 获取应用数据("评论屏蔽") == "true" } },
  { __type = 3, subtitle = "评论屏蔽词", message = 屏蔽词数量文本() },
  { __type = 5, subtitle = "私信限速自动重发", message = "每条私信发完即开始计时，窗口内的发送自动排队到点补发", status = { Checked = 获取应用数据("私信限速自动重发") == "true" } },
  { __type = 3, subtitle = "限速等待秒数", message = 私信等待文本() },
  { __type = 5, subtitle = "显示FPS", message = "在网页左上角显示FPS帧率", status = { Checked = 获取应用数据("显示FPS") == "true" } },
  { __type = 5, subtitle = "下拉刷新", message = "帖子页用下拉手势刷新，隐藏右下角刷新按钮", status = { Checked = 获取应用数据("下拉刷新") == "true" } },
  { __type = 6},
  { __type = 1, title = "其他" },
  --{ __type = 3, subtitle = "检测修复", message = "如部分功能报错可尝试该功能" },
  { __type = 3, subtitle = "清理缓存", message = "清理软件缓存垃圾" },
  { __type = 2, subtitle = "关于软件" },
}
-- 找到"下一页重调用"的位置，然后在其后插入新项
if 获取应用数据("娱乐功能") then
  for i, v in ipairs(设置列表) do
    if v.title == "其他" then
      table.insert(设置列表, i + 1, { __type = 3, subtitle = "娱乐功能", message = "一些乱七八糟的东西" })
      break
    end
  end
end
拓展列表 = {
  { __type = 1, title = "自定义UA(若无必要谨慎修改)" },
  { __type = 3, subtitle = "手机UA", message = 获取应用数据("手机UA")},
  { __type = 3, subtitle = "电脑UA", message = 获取应用数据("电脑UA") },
  { __type = 6},
  { __type = 1, title = "网页" },
  { __type = 3, subtitle = "默认浏览页", message = "修改SS搜索或调用打开默认进入的浏览页" },
  { __type = 5, subtitle = "下载方式", message = "开启后为软件内下载", status = { Checked = 获取应用数据("下载方式") == "true" } },
  { __type = 3, subtitle = "旋转方式", message = "浏览页网页视频全屏的旋转方式" },
  { __type = 5, subtitle = "下一页重调用", message = "点击帖子下一页后，将再次调用页面进行打开", status = { Checked = 获取应用数据("下一页重调用") == "true" } },
  { __type = 6},
  { __type = 1, title = "控件" },
  { __type = 5, subtitle = "隐藏应用栏", message = "开关部分页面隐藏应用栏选项", status = { Checked = 获取应用数据("隐藏应用栏") == "true" } },
  { __type = 5, subtitle = "显示悬浮按钮", message = "设置部分页面悬浮按钮是否显示", status = { Checked = 获取应用数据("显示悬浮按钮") == "true" } },
  { __type = 6},
  { __type = 1, title = "其他" },
  { __type = 5, subtitle = "http抓包请求", message = "开启后软件内抓包远程请求不会无响应", status = { Checked = 获取应用数据("http抓包请求") == "true" } },
  { __type = 5, subtitle = "跨域请求", message = "开启后本地网页可以运行的跨域请求", status = { Checked = 获取应用数据("跨域请求") == "true" } },
  { __type = 5, subtitle = "跳转动画", message = "开关进退子页面的动画", status = { Checked = 获取应用数据("跳转动画") == "true" } },
}
娱乐列表 = {
  { __type = 1, title = "模块相关" },
  { __type = 3, subtitle = "LSPatch", message = "经第三方修改安卓15可用的LSPatch" },
  { __type = 3, subtitle = "算法助手", message = "一款非常好用的APK调试工具" },
  { __type = 3, subtitle = "Layout Inspect", message = "作者：Flash丶光芒(147964)--布局定位模块" },
  { __type = 6},
  { __type = 1, title = "APK相关" },
  { __type = 3, subtitle = "ProxyPin", message = "开源免费抓包工具" },
  --{ __type = 3, subtitle = "SRPatch", message = "作者：零星0523(128487)--apk签名安全测试" },
  { __type = 3, subtitle = "PrintLog", message = "作者：逗比_滑稽(48894)--日志工具" },
  { __type = 3, subtitle = "编码工具箱", message = "作者：逗比_滑稽(48894)" },
  { __type = 6},
  { __type = 1, title = "网页工具" },
  { __type = 3, subtitle = "GitHub移动工作台", message = "作者：杜丹君(3905)" },
  { __type = 6},
  { __type = 1, title = "其他内容" },
  { __type = 3, subtitle = "MT语法高亮", message = "作者：是果宝呐(126939)" },
  { __type = 6},
  { __type = 1, title = "投稿建议" },
  { __type = 3, subtitle = "论坛投稿", message = "投稿功能或实用内容，禁引流广告破解资源内容" },
}
if !获取应用数据("小广告") then
  table.insert(娱乐列表, { __type = 3, subtitle = "免费领流量卡", message = "凑不要脸的小广告，长按该项可永久隐藏" })
end
ExternalCacheDir = activity.getExternalCacheDir().toString()
ExternalFilesDir = activity.getExternalFilesDir(nil).toString()
DataDir = activity.getDataDir().toString()
清理项 = {
  {text = "应用崩溃记录", dir = ExternalFilesDir.."/crash"},
  {text = "视频播放缓存", dir = ExternalCacheDir.."/exo-video-cache"},
  {text = "图片加载缓存", dir = DataDir.."/cache/image_manager_disk_cache"},
  {text = "WebView 存储数据", dir = DataDir.."/app_webview"},
  {text = "WebView 缓存信息", dir = DataDir.."/cache/WebView"},
  {text = "下载的文件", dir = DataDir.."/cache/download"},
  {text = "安装包缓存", dir = ExternalCacheDir.."/share"},
}
传递数据,参数2=...
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    if 参数2==nil and 应用栏标题.text=="设置" then
      退出程序()
      进子页面("zhuye")
     else
      退子页面()
    end
    return true
  end
end
if 传递数据 then
  应用栏标题.setText(传递数据).setVisibility(0)
  if 传递数据=="清理缓存" then
    清理缓存(清理项,1)
   elseif 传递数据=="拓展功能" then
    function isMobileUAExact(ua)
      ua = ua or ""
      local lowerUA = ua:lower()
      -- 检查是否有明确的移动设备标识
      if lowerUA:find("mobile", 1, true) then
        return true
      end
      -- Android 设备（排除平板，平板通常没有 Mobile 标识）
      if lowerUA:find("android", 1, true) and not lowerUA:find("tablet", 1, true) then
        return true
      end
      -- iOS 设备
      if lowerUA:find("iphone", 1, true) or lowerUA:find("ipod", 1, true) then
        return true
      end
      -- 其他移动设备
      local mobileDevices = {
        "blackberry",
        "windows phone",
        "iemobile",
        "opera mini",
        "symbian"
      }
      for _, device in ipairs(mobileDevices) do
        if lowerUA:find(device, 1, true) then
          return true
        end
      end
      return false
    end
    function isDesktopUAExact(ua)
      ua = ua or ""
      local lowerUA = ua:lower()
      -- 电脑系统标识
      if lowerUA:find("windows nt", 1, true) or
        lowerUA:find("macintosh", 1, true) or
        lowerUA:find("mac os", 1, true) or
        lowerUA:find("x11", 1, true) then
        -- 确保不是移动设备
        if not isMobileUAExact(ua) then
          return true
        end
      end
      -- Linux 桌面（排除 Android）
      if lowerUA:find("linux", 1, true) and
        not lowerUA:find("android", 1, true) and
        not lowerUA:find("mobile", 1, true) then
        return true
      end
      return false
    end
    简易设置功能布局(拓展列表,
    function(title,item)
      switch(title) do
       case "手机UA"
        local 当前UA=获取应用数据(title)
        通用编辑框功能("自定义"..title,当前UA,
        "确定","取消","重置",
        function()
          --if isMobileUAExact(edit_text.text) then
          存储应用数据(title,edit_text.text)
          item.message=获取应用数据(title)
          dialog.dismiss()
          --else
          --print"请检查UA是否填写正确"
          --end
        end,nil,
        function()
          存储应用数据(title,"Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36")
          item.message=获取应用数据(title)
          dialog.dismiss()
        end)
       case "电脑UA"
        local 当前UA=获取应用数据(title)
        通用编辑框功能("自定义"..title,当前UA,
        "确定","取消","重置",
        function()
          --if isDesktopUAExact(edit_text.text) then
          存储应用数据(title,edit_text.text)
          item.message=获取应用数据(title)
          dialog.dismiss()
          --else
          --print"请检查UA是否填写正确"
          --end
        end,nil,
        function()
          存储应用数据(title,"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36")
          item.message=获取应用数据(title)
          dialog.dismiss()
        end)
       case "默认浏览页"
        浏览数据=获取应用数据("默认浏览页")
        浏览列表={"手机页","电脑页","全屏页"}
        浏览页名={"liulanye","liulanyepc","liulanyeqp"}
        function 浏览列表索引()
          if 浏览数据 then
            if 浏览数据=="liulanye" then
              return 0
             elseif 浏览数据=="liulanyepc" then
              return 1
             elseif 浏览数据=="liulanyeqp" then
              return 2
            end
           else
            return 0
          end
        end
        浏览列表索引2=浏览列表索引()
        浏览对话框=AlertDialog.Builder(this)
        .setSingleChoiceItems(浏览列表,浏览列表索引2,{onClick=function(v,p)
            存储应用数据("默认浏览页",浏览页名[p+1])
            --单选对话框.dismiss()--关闭
          end})
        .show()
       case "旋转方式"
        旋转数据=获取应用数据("旋转方式")
        旋转列表={"跟随系统","自动旋转","横屏旋转"}
        旋转序号={nil,1,2}
        function 旋转列表索引()--需要使用数据判断功能
          if 旋转数据 then
            return 旋转数据
           else
            return 0
          end
        end
        旋转列表索引2=旋转列表索引()
        旋转对话框=AlertDialog.Builder(this)
        .setSingleChoiceItems(旋转列表,旋转列表索引2,{onClick=function(v,p)
            存储应用数据("旋转方式",旋转序号[p+1])
            --单选对话框.dismiss()--关闭
          end})
        .show()
       case "下一页重调用"
        if 获取应用数据("自动上下页")=="true" then
          item.status.Checked = false
          存储应用数据("下一页重调用","false")
          print2("自动上下页和下一页重调用之间只能开启一个")
        end
      end
    end,
    function(title)
      switch(title) do
       case "手机UA"
        通用编辑框功能("拦截网址",获取应用数据("拦截网址"),
        "确定","取消","重置",
        function()
          if edit_text.text~="" then
            存储应用数据("拦截网址",edit_text.text)
            dialog.dismiss()
           else
            print"不可为空"
          end
        end,nil,
        function()
          存储应用数据("拦截网址","example.com")
          dialog.dismiss()
        end)
      end
    end)
   elseif 传递数据=="娱乐功能" then
    简易设置功能布局(娱乐列表,
    function(title,item)
      switch(title) do
       case "LSPatch"
        LSP列表={"LSPatch(JingMatrix)","LSPatch(希涵)"}
        LSP对话框=AlertDialog.Builder(this)
        .setSingleChoiceItems(LSP列表,-1,{onClick=function(v,p)
            if LSP列表[p+1]=="LSPatch(JingMatrix)" then
              进子页面(获取应用数据("默认浏览页"),{"https://github.com/JingMatrix/LSPatch"})
             elseif LSP列表[p+1]=="LSPatch(希涵)" then
              进子页面(获取应用数据("默认浏览页"),{"https://xihan.lanzoub.com/b00crlof6h"})
            end
          end})
        .show();
       case "算法助手"
        算法列表={"算法助手","算法助手Pro","免root使用教程"}
        算法对话框=AlertDialog.Builder(this)
        .setSingleChoiceItems(算法列表,-1,{onClick=function(v,p)
            if 算法列表[p+1]=="算法助手" then
              进子页面(获取应用数据("默认浏览页"),{"https://www.123pan.com/s/7G8aTd-OhT4H.html"})
              print("提取码:YA5t")
              复制文本("YA5t")
             elseif 算法列表[p+1]=="算法助手Pro" then
              进子页面(获取应用数据("默认浏览页"),{"https://www.123pan.com/s/7G8aTd-bKH4H"})
             elseif 算法列表[p+1]=="免root使用教程" then
              进子页面("tiezi",{"https://bbs.binmt.cc/thread-155609-1-1.html"})
            end
          end})
        .show();
       case "ProxyPin"
        进子页面(获取应用数据("默认浏览页"),{"https://github.com/wanghongenpin/proxypin"})
       case "Layout Inspect"
        进子页面(获取应用数据("默认浏览页"),{"https://flass.lanzout.com/s/Layout-Inspect"})
       case "PrintLog"
        进子页面("tiezi",{"https://bbs.binmt.cc/thread-156650-1-1.html"})
       case "SRPatch"
        进子页面(获取应用数据("默认浏览页"),{"https://srpatch.cc/"})
       case "编码工具箱"
        进子页面(获取应用数据("默认浏览页"),{"https://www.123pan.com/s/1YjA-YjOEd.html"})
       case "MT语法高亮"
        进子页面(获取应用数据("默认浏览页"),{"https://github.com/guobao2333/MT-syntax-highlight"})
       case "GitHub移动工作台"
        进子页面("liulanye",{title,1})
        --[[工作台列表={"本地版","在线版"}
        工作台对话框=AlertDialog.Builder(this)
        .setSingleChoiceItems(工作台列表,-1,{onClick=function(v,p)
            if 工作台列表[p+1]=="本地版" then
              进子页面("liulanye",{title,1})
             else
              进子页面("liulanye",{"https://ksx.rjdsq.xyz/GK/"})
            end
          end})
        .show();]]
       case "论坛投稿"
        进子页面("yonghu",{"https://bbs.binmt.cc/home.php?mod=space&do=pm&subop=view&touid=142711"})
       case "免费领流量卡"
        进子页面("liulanye",{"https://172.lot-ml.com/ProductEn/index/2afe80abb66de5b9"})
      end
    end,
    function(title)
      switch(title) do
       case "免费领流量卡"
        local 广告对话框=AlertDialog.Builder(activity)
        .setTitle("是否隐藏小广告？")
        .setPositiveButton("否",nil)
        .setNegativeButton("是",{onClick=function(v)
            存储应用数据("小广告",1)
            进子页面("shezhi",{"娱乐功能"})
            退出页面()
            print"已永久隐藏"
          end})
        .show()
      end
    end)
   else
    简易设置功能布局(设置列表,
    function(title,item)
      switch(title) do
       case "自动回复内容"
        通用编辑框功能("自动回复内容",获取应用数据("自动回复内容") or "看看隐藏",
        "确定","取消","重置",
        function()
          local 文本=tostring(edit_text.text or "")
          if 文本=="" then
            文本="看看隐藏"
          end
          存储应用数据("自动回复内容",文本)
          item.message="当前："..文本
          dialog.dismiss()
          刷新设置列表()
        end,nil,
        function()
          存储应用数据("自动回复内容","看看隐藏")
          item.message="当前：看看隐藏"
          dialog.dismiss()
          刷新设置列表()
        end)
       case "并行加载页数"
        local 页数选项 = { "1 页（省流）", "2 页（推荐）", "3 页", "4 页（最快）" }
        local 页数对话框 = AlertDialog.Builder(activity)
        .setTitle("并行加载页数")
        .setSingleChoiceItems(页数选项, 初始化并行页数() - 1, { onClick = function(v, p)
            存储应用数据("并行加载页数", tostring(p + 1))
            item.message = 并行页数文本()
            刷新设置列表()
            v.dismiss()
          end })
        .setNegativeButton("取消", nil)
        .show()
       case "评论屏蔽词"
        屏蔽词编辑对话框(function(数量文本)
          item.message=数量文本
          刷新设置列表()
          if #屏蔽词列表()>0 then
            print("已保存 "..#屏蔽词列表().." 个自定义屏蔽词\n重新进入帖子后生效")
           else
            print("自定义屏蔽词已清空（内置词仍然生效）")
          end
        end)
       case "评论屏蔽"
        if item.status.Checked then
          local 数量=#屏蔽词列表()
          if 数量==0 then
            print2("还没有屏蔽词\n请点击“评论屏蔽词”添加")
           else
            print("评论屏蔽已开启\n当前 "..数量.." 个屏蔽词")
          end
        end
       case "私信限速自动重发"
        if item.status.Checked then
          print("已开启\n发送成功后开始倒计时，窗口内再点发送会自动排队到点补发")
         else
          print("已关闭\n发送被限速后需要自己等一会儿再发")
        end
       case "限速等待秒数"
        local 秒数选项 = { "10 秒", "16 秒（推荐）", "20 秒", "30 秒", "45 秒" }
        local 秒数表 = { 10, 16, 20, 30, 45 }
        local 当前秒 = 私信等待秒数()
        local 当前项 = 2
        for i=1,#秒数表 do
          if 秒数表[i]==当前秒 then 当前项=i end
        end
        AlertDialog.Builder(activity)
        .setTitle("限速等待秒数（固定，不自动翻倍）")
        .setSingleChoiceItems(秒数选项, 当前项 - 1, { onClick = function(v, p)
            存储应用数据("私信限速等待秒数", tostring(秒数表[p + 1]))
            item.message = 私信等待文本()
            刷新设置列表()
            v.dismiss()
          end })
        .setNegativeButton("取消", nil)
        .show()
       case "回复可见自动回复"
        if item.status.Checked and 获取应用数据("登录参数")==nil then
          print2("当前未登录\n自动回复可能会失败")
        end
       case "编辑菜单"
        编辑快捷菜单对话框()
       case "提取Cookie"
        提取Cookie对话框()
       case "已缓存的帖子"
        进子页面("huancun")
       case "下拉刷新"
        if item.status.Checked then
          print("已开启\n帖子页拉到顶部继续下拉即刷新，右下角刷新按钮会隐藏")
         else
          print("已关闭\n恢复右下角刷新按钮")
        end
       case "检测原版更新"
        if 获取包名()=="net.fusionapp" then
          软件名="Mt论坛Lite重制版"
        end
        加载对话框 = ProgressDialog(this)
        加载对话框.setProgressStyle(ProgressDialog.STYLE_SPINNER)
        加载对话框.setMessage("远程文档正在努力加载中...")
        加载对话框.setCancelable(true)
        加载对话框.setCanceledOnTouchOutside(false)
        加载对话框.show()
        Http.get("https://kawangya.github.io/fullbackup/update.txt",function(code,content)
          加载对话框.hide()
          if code~=200 then
            无网框=AlertDialog.Builder(this)--普通对话框
            .setMessage("网络异常"..code.."，请检测网络是否开启或尝试使用魔法。\n\n注：更新文档与更新文件存储于GitHub，如无法加载或下载请尝试使用魔法。")
            .setPositiveButton("知道了",nil)
            .setNeutralButton("查看更新",nil)
            .show()
            无网框.findViewById(android.R.id.message).setTextIsSelectable(true)--文字可复制
            无网框.getButton(AlertDialog.BUTTON3).onClick=function()
              进子页面(获取应用数据("默认浏览页"),{"https://xiyatu.lanzouq.com/b00hr7mm3a"})
            end
            return true
           elseif not content:match(软件名..":.-;") then
            无名框=AlertDialog.Builder(this)--普通对话框
            .setMessage("未找到有效版本数据，可能是GitHub更新延迟或未更新文档，请稍后再试。\n\n注：更新文档与更新文件存储于GitHub，如无法加载或下载请尝试使用魔法。")
            .setPositiveButton("知道了",nil)
            .setNeutralButton("查看更新",nil)
            .show()
            无名框.findViewById(android.R.id.message).setTextIsSelectable(true)--文字可复制
            无名框.getButton(AlertDialog.BUTTON3).onClick=function()
              进子页面(获取应用数据("默认浏览页"),{"https://xiyatu.lanzouq.com/b00hr7mm3a"})
            end
            return true
          end
          新版本=content:match(软件名..":(.-);")
          下载链接="https://kawangya.github.io/fullbackup/"..软件名.."_"..新版本..".apk"
          if 版本号比较(版本名,新版本)<0 then
            --按数值比较：本地比服务器旧才提示，避免重置版被误报"发现新版本"
            更新框=AlertDialog.Builder(this)--普通对话框
            .setMessage("发现新版本："..软件名.."_"..新版本.."\n\n注：更新文档与更新文件存储于GitHub，如无法加载或下载请尝试使用魔法。")
            .setPositiveButton("更新",nil)
            .setNegativeButton("下次再说",nil)
            .setNeutralButton("查看更新",nil)
            .show()
            更新框.findViewById(android.R.id.message).setTextIsSelectable(true)--文字可复制
            更新框.getButton(AlertDialog.BUTTON1).onClick=function()
              --浏览器打开(下载链接)
              进子页面(获取应用数据("默认浏览页"),{下载链接})
            end
            更新框.getButton(AlertDialog.BUTTON3).onClick=function()
              进子页面(获取应用数据("默认浏览页"),{"https://xiyatu.lanzouq.com/b00hr7mm3a"})
            end
           else
            更新框2=AlertDialog.Builder(this)--普通对话框
            .setMessage("当前已是最新版，无需进行更新。\n\n注：更新文档与更新文件存储于GitHub，如无法加载或下载请尝试使用魔法。")
            .setPositiveButton("知道了",nil)
            .setNegativeButton("重新下载",nil)
            .setNeutralButton("查看更新",nil)
            .show()
            更新框2.findViewById(android.R.id.message).setTextIsSelectable(true)--文字可复制
            更新框2.getButton(AlertDialog.BUTTON2).onClick=function()
              --浏览器打开(下载链接)
              进子页面(获取应用数据("默认浏览页"),{下载链接})
            end
            更新框2.getButton(AlertDialog.BUTTON3).onClick=function()
              进子页面(获取应用数据("默认浏览页"),{"https://xiyatu.lanzouq.com/b00hr7mm3a"})
            end
          end
        end)
       case "检测改版更新"
        加载对话框 = ProgressDialog(this)
        加载对话框.setProgressStyle(ProgressDialog.STYLE_SPINNER)
        加载对话框.setMessage("正在检查重置版更新...")
        加载对话框.setCancelable(true)
        加载对话框.show()
        Http.get("https://www.jiankuapp.com/app/detail?id=566",function(code,content)
          加载对话框.hide()
          if code~=200 then
            print2("网络异常 "..code.."\n简库资源网暂时无法访问，请稍后再试")
            return
          end
          local 新版本=content:match("版本%s*v?([%d%.]+)")
          if not 新版本 then
            print2("未解析到版本号\n页面结构可能变化，请直接到简库资源网查看")
            return
          end
          if 版本号比较(版本名,新版本)<0 then
            更新框=AlertDialog.Builder(this)
            .setMessage("发现重置版新版本："..新版本.."\n\n当前版本："..tostring(版本名).."\n\n下载页在简库资源网，下载线路指向 GitHub Releases。")
            .setPositiveButton("打开下载页",nil)
            .setNegativeButton("下次再说",nil)
            .show()
            更新框.getButton(AlertDialog.BUTTON1).onClick=function()
              进子页面(获取应用数据("默认浏览页"),{"https://www.jiankuapp.com/app/detail?id=566"})
            end
           else
            print2("当前已是最新版（"..tostring(版本名).."）")
          end
        end)
       case "查看更新"
        进子页面(获取应用数据("默认浏览页"),{"https://xiyatu.lanzouq.com/b00hr7mm3a"})
       case "娱乐功能"
        进子页面("shezhi",{"娱乐功能"})
       case "拓展功能"
        进子页面("shezhi",{"拓展功能"})
       case "清理缓存"
        --print "温馨提示：非必要勿清理WebView的数据"
        进子页面("shezhi",{"清理缓存"})
       case "自动签到"
        if !获取应用数据("签到参数") then
          存储应用数据(title,"false")
          item.status.Checked = false
          进子页面("qiandao")
          print2("当前账号签到数据为空，请先配置\n点击签到后，将会自动获取")
        end
       case "自动上下页"
        if 获取应用数据("下一页重调用")=="true" then
          item.status.Checked = false
          存储应用数据("自动上下页","false")
          print2("自动上下页和下一页重调用之间只能开启一个")
        end
       case "主题模式"
        主题数据=获取应用数据("主题模式")
        主题列表={"跟随系统","亮色","暗色"}
        主题序号={1,2,3}
        function 主题列表索引()--需要使用数据判断功能
          if 主题数据 then
            if 主题数据==1 then
              return 0
             elseif 主题数据==2 then
              return 1
             elseif 主题数据==3 then
              return 2
            end
           else
            return 0
          end
        end
        主题列表索引2=主题列表索引()
        主题对话框=AlertDialog.Builder(this)
        .setSingleChoiceItems(主题列表,主题列表索引2,{onClick=function(v,p)
            存储应用数据("主题模式",主题序号[p+1])
            --单选对话框.dismiss()--关闭
          end})
        .setOnDismissListener(function()
          if 获取应用数据("主题模式")~=主题数据 then
            if 获取应用数据("主题模式")==2 then
              if 获取应用数据("圆角对话框")=="true" then
                设置页切换主题(false,"ThemeBright")
               else
                设置页切换主题(false,"ThemePuliang")
              end
             elseif 获取应用数据("主题模式")==3 then
              if 获取应用数据("圆角对话框")=="true" then
                设置页切换主题(true,"ThemeDark")
               else
                设置页切换主题(true,"ThemePuan")
              end
             elseif 获取应用数据("主题模式")==1 then
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
              设置页切换主题(系统主题状态(),跟随主题名)
            end
          end
        end)
        .show()
       case "圆角对话框"
        if 获取应用数据("主题模式")==1 then
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
          设置页切换主题(系统主题状态(),跟随主题名)
         elseif 获取应用数据("主题模式")==2 then
          if 获取应用数据("圆角对话框")=="true" then
            设置页切换主题(false,"ThemeBright")
           else
            设置页切换主题(false,"ThemePuliang")
          end
         elseif 获取应用数据("主题模式")==3 then
          if 获取应用数据("圆角对话框")=="true" then
            设置页切换主题(true,"ThemeDark")
           else
            设置页切换主题(true,"ThemePuan")
          end
        end
       case "检测修复"
        print2"已尝试检测修复\n若仍然报错请尝试清理应用数据"
        if 获取应用数据("http抓包请求")~="false" and 获取应用数据("http抓包请求")~="true" then
          存储应用数据("http抓包请求","false")
        end
        if 获取应用数据("跨域请求")~="false" and 获取应用数据("跨域请求")~="true" then
          存储应用数据("跨域请求","false")
        end
        if 获取应用数据("显示FPS")~="false" and 获取应用数据("显示FPS")~="true" then
          存储应用数据("显示FPS","false")
        end
        if 获取应用数据("URL超链接")~="false" and 获取应用数据("URL超链接")~="true" then
          存储应用数据("URL超链接","true")
        end
        if 获取应用数据("自动上下页")~="false" and 获取应用数据("自动上下页")~="true" then
          存储应用数据("自动上下页","false")
        end
        if 获取应用数据("自动签到")~="false" and 获取应用数据("自动签到")~="true" then
          存储应用数据("自动签到","false")
        end
        if 获取应用数据("下一页重调用")~="false" and 获取应用数据("下一页重调用")~="true" then
          存储应用数据("下一页重调用","false")
        end
        if 获取应用数据("跳转动画")~="false" and 获取应用数据("跳转动画")~="true" then
          存储应用数据("跳转动画","false")
        end
        if 获取应用数据("下载方式")~="false" and 获取应用数据("下载方式")~="true" then
          存储应用数据("下载方式","true")
        end
        if 获取应用数据("网页背景色")~="false" and 获取应用数据("网页背景色")~="true" then
          存储应用数据("网页背景色","true")
        end
        if 获取应用数据("默认浏览页")~="liulanye" and 获取应用数据("默认浏览页")~="liulanyepc" and 获取应用数据("默认浏览页")~="liulanyeqp" then
          存储应用数据("默认浏览页","liulanye")
        end
        if 获取应用数据("显示悬浮按钮")~="false" and 获取应用数据("显示悬浮按钮")~="true" then
          存储应用数据("显示悬浮按钮","true")
        end
        if 获取应用数据("隐藏应用栏")~="false" and 获取应用数据("隐藏应用栏")~="true" then
          存储应用数据("隐藏应用栏","false")
        end
        if 获取应用数据("旋转方式")~=nil and 获取应用数据("旋转方式")~=1 and 获取应用数据("旋转方式")~=2 then
          存储应用数据("旋转方式",nil)
        end
        if 获取应用数据("主题模式")~=3 and 获取应用数据("主题模式")~=1 and 获取应用数据("主题模式")~=2 then
          存储应用数据("主题模式",1)
        end
        if 获取应用数据("圆角对话框")~="false" and 获取应用数据("圆角对话框")~="true" then
          if Build.VERSION.SDK_INT<34 then
            存储应用数据("圆角对话框","false")
           else
            存储应用数据("圆角对话框","true")
          end
        end
        if 获取应用数据("拦截网址")==nil then
          存储应用数据("拦截网址","example.com")
        end
       case "关于软件"
        签名通过,签名未通过="通过 ",""
        if 软件名=="Mt论坛Lite"
          or 软件名=="Mt论坛Lite重制版" then
          签名通过=签名通过.."软件名 "
         else
          签名未通过=签名未通过.."软件名 "
        end
        if 获取包名()=="com.JFH.bbs.binmt.cc.lite"
          or 获取包名()=="com.JFH.bbs.binmt.cc.lite.g"
          or 获取包名()=="io.github.kawangya.mtforumlite"
          or 获取包名()=="io.github.kawangya.mtforumlite.g" then
          签名通过=签名通过.."包名 "
         else
          签名未通过=签名未通过.."包名 "
        end
        if 获取应用证书HASH码()==1397924203 then
          签名通过=签名通过.."HASH "
         else
          签名未通过=签名未通过.."HASH "
        end
        if 获取应用证书CRC32码()==1652156465 then
          签名通过=签名通过.."CRC32 "
         else
          签名未通过=签名未通过.."CRC32 "
        end
        if 获取应用证书哈希值("MD5",获取包名(),false)=="2C1CCBDC911386AE894951C9FBC45EBF" then
          签名通过=签名通过.."MD "
         else
          签名未通过=签名未通过.."MD "
        end
        if 获取应用证书哈希值("SHA1",获取包名(),false)=="237F56D9DF437B5BF5D0676B2D58E7096A8C52F8" then
          签名通过=签名通过.."SHA1 "
         else
          签名未通过=签名未通过.."SHA1 "
        end
        if 获取应用证书哈希值("SHA256",获取包名(),false)=="9BBAC9C6C0DF9FF9EA968E1041AD8D128865819CA20E4CF0406EC2B018FA7FD1" then
          签名通过=签名通过.."SHA256 "
         else
          签名未通过=签名未通过.."SHA256 "
        end
        关于应用文本 = SpannableStringBuilder("《用户协议》 | 《隐私政策》 | 《免责声明》")
        --复制文本(tostring(关于应用文本.length()))
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            进子页面("xingxiye",{3})
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),0,6,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            进子页面("xingxiye",{2})
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),9,15,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            进子页面("xingxiye",{1})
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),18,24,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\n\n本软件二改于Mt论坛Lite，原版已开源，如有兴趣可点击下方链接前往查看。")
        关于应用文本.append("\n开源地址：https://wwi.lanzouo.com/b0d1pmq7a")
        关于应用文本.setSpan(ForegroundColorSpan(转换颜色值("#FFFF0000")),26,63,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.setSpan(URLSpan("https://wwi.lanzouo.com/b0d1pmq7a"),69,102,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\n三改开源地址：https://github.com/mower-1/mtlite-tweaks")
        关于应用文本.setSpan(URLSpan("https://github.com/mower-1/mtlite-tweaks"),110,150,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\n\n开发者：")
        关于应用文本.append("\n原-小白·马(飞)")
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            联系QQ2(3070320289)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),157,166,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\n现-月牙鸣")
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            进子页面("yonghu",{"https://bbs.binmt.cc/home.php?mod=space&uid=142711&do=profile"})
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),167,172,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\n三改-割草机Mow")
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            进子页面("yonghu",{"https://bbs.binmt.cc/home.php?mod=space&uid=153405&do=profile"})
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),173,182,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\n\n贡献者：")
        关于应用文本.append("\nFusionApp")
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            加QQ群(107828217)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),189,198,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("本软件开发工具")
        关于应用文本.setSpan(SuperscriptSpan(),198,205,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.setSpan(RelativeSizeSpan(0.7),198,205,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\nAdam·Eva")--1252237203
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),206,214,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("提供了许多技术上的帮助及开源项目")
        关于应用文本.setSpan(SuperscriptSpan(),214,230,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.setSpan(RelativeSizeSpan(0.7),214,230,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\njies辰")--1584645350
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),231,236,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("提供了许多技术上的帮助及开源项目")
        关于应用文本.setSpan(SuperscriptSpan(),236,252,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.setSpan(RelativeSizeSpan(0.7),236,252,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\nkamihitoe")--3357212590
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),253,262,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("提供了许多技术上的帮助及开源项目")
        关于应用文本.setSpan(SuperscriptSpan(),262,278,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.setSpan(RelativeSizeSpan(0.7),262,278,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\ndingyi")--2187778735
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),279,285,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("提供了许多开源项目")
        关于应用文本.setSpan(SuperscriptSpan(),285,294,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.setSpan(RelativeSizeSpan(0.7),285,294,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\n壹影")--203455278
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),295,297,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("提供了网页可视化修改并生成js的JsHD调试器工具")
        关于应用文本.setSpan(SuperscriptSpan(),297,322,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.setSpan(RelativeSizeSpan(0.7),297,322,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\n\nMT官方信息：")
        关于应用文本.append("\nMT官网：mt2.cn")
        关于应用文本.setSpan(URLSpan("https://mt2.cn/"),337,343,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\nMT小店：shop.mt2.cn")
        关于应用文本.setSpan(URLSpan("https://shop.mt2.cn/"),349,360,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\nMT论坛：bbs.binmt.cc")
        关于应用文本.setSpan(URLSpan("https://bbs.binmt.cc/"),366,378,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\nQQ频道：hpt52ikey6")
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            调用QQ打开链接(Base64编码("https://pd.qq.com/s/9j0h8egwp"))
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),384,394,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\nQQ公测群：592479528")
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            加QQ群(592479528)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),401,410,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\nQQ群1：307817058")
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            加QQ群(307817058)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),416,425,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\nQQ群2：252233891")
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            加QQ群(252233891)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),431,440,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\nQQ群3：487244392")
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            加QQ群(487244392)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),446,455,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\nQQ群4：837411169")
        关于应用文本.setSpan(ClickableSpan({
          onClick=function(view)
            加QQ群(837411169)
          end,
          updateDrawState=function(ds)
            ds.setColor(强调色) --设置颜色
            ds.setUnderlineText(false) --去掉下划线
          end
        }),461,470,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        关于应用文本.append("\n\n"..签名未通过)
        关于应用=AlertDialog.Builder(this)
        .setTitle("关于软件")
        .setMessage(关于应用文本)
        --.setCancelable(false)
        .setPositiveButton("知道了",nil)
        .setNeutralButton("帮助",{onClick=function(v)
            帮助列表={"关于调用","关于搜索","关于娱乐功能","关于隐藏功能"}
            帮助对话框=AlertDialog.Builder(this)
            .setSingleChoiceItems(帮助列表,-1,{onClick=function(v,p)
                if 帮助列表[p+1]=="关于搜索" then
                  搜索提示=AlertDialog.Builder(this)--普通对话框
                  .setTitle("搜索提示")
                  .setMessage([[内容 = MT论坛搜索
SS+内容 = 搜索引擎搜索
SS+链接 = 打开链接
SS+路径 = 打开本地文件
YH+用户id = 打开用户主页
TZ+帖子id = 打开帖子
TZ+(帖子id-页数) = 打开帖子指定页数]])
                  .show()
                  搜索提示.findViewById(android.R.id.message).setTextIsSelectable(true)
                 elseif 帮助列表[p+1]=="关于调用" then
                  调用提示=AlertDialog.Builder(this)--普通对话框
                  .setTitle("调用提示")
                  .setMessage([[软件支持系统设置默认浏览器(需手动)
支持添加特定链接打开(需手动且暂时只支持帖子链接)
支持使用fusion://或mtforumlite://两个URL scheme进行调用打开

目前已处理调用功能：链接，本地文件，搜索(search/)]])
                  .show()
                  调用提示.findViewById(android.R.id.message).setTextIsSelectable(true)
                 elseif 帮助列表[p+1]=="关于娱乐功能" then
                  娱乐提示=AlertDialog.Builder(this)--普通对话框
                  .setTitle("娱乐功能提示")
                  .setMessage([[娱乐功能本质是将我认为有用的东西放在一起，正所谓我觉得有用你不一定觉得，所以默认隐藏。

开启方式：长按三次设置页的“关于”
关闭方式：长按设置页的“娱乐功能”]])
                  .show()
                  娱乐提示.findViewById(android.R.id.message).setTextIsSelectable(true)
                 elseif 帮助列表[p+1]=="关于隐藏功能" then
                  娱乐提示=AlertDialog.Builder(this)--普通对话框
                  .setTitle("隐藏功能提示")
                  .setMessage([[在更新Mt论坛Lite重置版的过程中也加入了部分隐藏功能，此类功能由于技术不足无法做到绝对可用所以隐藏且未提。

例如：
①设置-->拓展功能-->手机UA(长按)，可填写拦截网址(仅限手机页)，加这个主要是看影视网站防误触广告的，但我发现这个拦不了动态广告，所以隐藏在长按选项中了。
②非会员蓝奏云链接自动跳PC页，在帖子分享中点击蓝奏云链接或主页搜索框中输入SS+蓝奏云链接进入浏览页自动判断是否为非会员蓝奏云链接，当然点快了会报错。
③板块&发帖页长按悬浮按钮可禁用返回键，也是个无用功能。]])
                  .show()
                  娱乐提示.findViewById(android.R.id.message).setTextIsSelectable(true)
                end
              end})
            .show();
          end})
        .show()
        --超链接&点击事件允许点击
        关于应用.findViewById(android.R.id.message).setTextIsSelectable(true)--文字可复制
        关于应用.findViewById(android.R.id.message).setMovementMethod(LinkMovementMethod.getInstance())
      end
    end,
    function(title,item)--长按事件
      switch(title) do
       case "关于软件"
        if !获取应用数据("娱乐功能") then
          if 功能开启计数==3 then
            存储应用数据("娱乐功能",1)
            进子页面("shezhi",{"设置",1})
            退出页面()
            print"已显示娱乐功能"
           else
            功能开启计数=功能开启计数+1
          end
        end
       case "娱乐功能"
        local 娱乐功能对话框=AlertDialog.Builder(activity)
        .setTitle("是否隐藏娱乐功能？")
        .setPositiveButton("否",nil)
        .setNegativeButton("是",{onClick=function(v)
            存储应用数据("娱乐功能",nil)
            存储应用数据("小广告",nil)
            进子页面("shezhi",{"设置",1})
            退出页面()
            print"已隐藏娱乐功能"
          end})
        .show()
       case "编辑菜单"
        local 重置菜单对话框=AlertDialog.Builder(activity)
        .setTitle("是否重置快捷菜单？")
        .setPositiveButton("否",nil)
        .setNegativeButton("是",{onClick=function(v)
            local cjson=require("cjson")
            local json=cjson.encode(默认快捷菜单表)
            存储应用数据("快捷菜单",json)
            print"重置成功"
          end})
        .show()
      end
    end)
  end
 else
  应用栏标题.setText("清理缓存").setVisibility(0)
  清理缓存(清理项,1)
  --退子页面()
end
左上角按钮().onClick=function(v)
  if 参数2==nil and 应用栏标题.text=="设置" then
    退出程序()
    进子页面("zhuye")
   else
    退子页面()
  end
end;
