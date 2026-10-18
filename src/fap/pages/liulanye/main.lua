require "import"
使用公共lua文件("libs")
import "gongyong"
应用栏标题.setText("浏览页").setVisibility(0)
应用栏标题.setEllipsize(TextUtils.TruncateAt.MARQUEE)--设置跑马灯属性
应用栏标题.setSelected(true)--设置选中状态
应用栏标题.setSingleLine(true)--设置单行显示
获取浏览器(0).getSettings().setUserAgentString(获取应用数据("手机UA"))
if 获取应用数据("跨域请求")=="true" then
  获取浏览器().getSettings().setAllowUniversalAccessFromFileURLs(true)
end
应用栏显示,点击次数=true,0
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    退子页面()
    return true
   elseif keyCode == KeyEvent.KEYCODE_VOLUME_UP and !应用栏显示
    or keyCode == KeyEvent.KEYCODE_VOLUME_DOWN and !应用栏显示 then
    点击次数=点击次数+1
    if 点击次数>1 then
      点击次数=0
      应用栏.setVisibility(View.VISIBLE)
      应用栏显示=true
    end
    return true
  end
end
传递数据,网页审查=...
if 传递数据 then
  if 传递数据=="GitHub移动工作台" then
    加载网页(nil,"file://"..activity.getLuaDir().."/GitHubYDGZT/index.html")
   else
    加载网页(nil,传递数据)
  end
  --[[if 传递数据:match"github.com" then
    print2"Github链接，如无法加载请尝试魔法访问"
  end]]
 else
  退子页面()
end
if 获取应用数据("显示悬浮按钮")=="true" and 网页审查 then
  显隐悬浮按钮()
end
左上角按钮().onClick=function(v)
  退子页面()
end;
右上角按钮(0,0).onClick=function(v)
  function 弹出菜单(v,样式)
    PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
    local popupMenu=PopupMenu(activity,v)
    local 主菜单=popupMenu.menu
    主菜单.add("网页查找")
    if 网页审查 then
      if 获取应用数据("网页审查") then
        主菜单.add("切换vConsole")
       else
        主菜单.add("切换Eruda")
      end
      if not 获取网址():find("^file://") then
        主菜单.add("普通模式")
      end
     else
      主菜单.add("网页审查")
    end
    if 获取应用数据("显示悬浮按钮")=="false" or 网页审查 then
      主菜单.add("网页刷新")
    end
    if not 获取网址():find("^file://") then
      主菜单.add("浏览器打开")
    end
    主菜单.add("复制链接")
    主菜单.add("全屏模式")
    主菜单.add("电脑模式")
    if 获取应用数据("隐藏应用栏")=="true" then
      主菜单.add("隐藏应用栏")
    end
    主菜单.add("退出页面")
    popupMenu.onMenuItemClick=function(item)
      switch item.title
       case "全屏模式"
        if 网页审查 then
          进子页面("liulanyeqp",{获取网址(),1})
         else
          进子页面("liulanyeqp",{获取网址()})
        end
        退出页面()
       case "电脑模式"
        if 网页审查 then
          进子页面("liulanyepc",{获取网址(),1})
         else
          进子页面("liulanyepc",{获取网址()})
        end
        退出页面()
       case "网页刷新"
        刷新网页()
       case "切换Eruda"
        存储应用数据("网页审查",1)
        刷新网页()
       case "切换vConsole"
        存储应用数据("网页审查",nil)
        刷新网页()
       case "普通模式"
        进子页面(nil,{获取网址()})
        退出页面()
       case "网页审查"
        进子页面(nil,{获取网址(),1})
        退出页面()
       case "网页查找"
        网页查找对话框()
       case "浏览器打开"
        浏览器打开(获取网址())
       case "复制链接"
        复制文本(获取网址())
       case "退出页面"
        退子页面()
       case "隐藏应用栏"
        隐藏控件对话框(item.title,function(v)
          应用栏.setVisibility(View.GONE)
          应用栏显示=false
        end)
      end
    end
    -- 显示弹出菜单
    popupMenu.show()
    popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
  end
  弹出菜单(v)
end;
--悬浮按钮点击事件
function onFloatingActionButtonClick(v)
  刷新网页()
end

页面事件处理(nil,--可填写页面，需开预加载
function(superCall,view,url,favicon)
  --页面开始加载事件
  if url:match("lanzou")
    or url:match('www%.123%w%w%w%.com') then
    屏蔽网页复制文本()
  end
end,
function(superCall,view,url)
  --页面加载结束事件
  if 获取应用数据("网页背景色")=="true" then
    加载Js([[document.body.style.backgroundColor = "]]..窗体背景色2..[[";]])
  end
  if 获取应用数据("显示FPS")=="true" then
    加载Js("Display_fps();")
  end
  if 获取应用数据("URL超链接")=="true" then
    加载Js([[url_clickable();]])
  end
  if url:match("lanzou")
    or url:match('www%.123%w%w%w%.com') then
    屏蔽网页复制文本()
  end
  if 网页审查 then
    if 获取应用数据("网页审查") then
      加载Js("eruda.init();")
     else
      加载Js("var vConsole = new window.VConsole();")
    end
  end
  if url:match("lanzou") then
    local jsCode = "_=()=>document.body.innerText;_()"--获取网页文字
    加载Js(jsCode, function(content)
      if content:match("请先开通会员") then
        进子页面("liulanyepc",{url})
        退出页面()
        print2"检测到无会员蓝奏云链接,自动切换电脑模式"
       elseif content:match("文件受密码保护，请输入密码继续下载") or content:match("获取.+的文件") then
        蓝奏云自动填写密码2("1234","https://xiyatu.lanzouq.com/b00hr7mm3a")
        蓝奏云自动填写密码2("xihan","https://xihan.lanzoub.com/b00crlof6h")
      end
    end)
  end
end,nil,
function(_,view,webResourceRequest)
  --Url即将跳转事件(即将加载事件)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  if not url:find("^https?://") and not url:find("^file://") and 获取网址():find("lanzou")
    or 获取网址():find(获取应用数据("拦截网址")) and not url:find(获取应用数据("拦截网址")) then--判断是否是跳转外部应用链接并进行设置功能
    return true
   elseif not url:find("^https?://") and not url:find("^file://") then--判断是否是跳转外部应用链接并进行设置功能

    local intent
    if url:find("^intent://") then
      local ok, obj = pcall(Intent.parseUri, url, 1)
      if ok and obj then intent = obj end
     else
      local ok, obj = pcall(Intent, Intent.ACTION_VIEW, Uri.parse(url))
      if ok and obj then intent = obj end
    end

    if intent then
      local pm = activity.getPackageManager()
      local component = intent.resolveActivity(pm)
      if component then
        local PackageManager = bindClass("android.content.pm.PackageManager")
        local appname = pm.getApplicationLabel(pm.getApplicationInfo(component.getPackageName(), PackageManager.GET_META_DATA))
        跳转应用对话框(appname, url, function()
          pcall(activity.startActivity, intent)
        end)
       else
        if url:find("^intent://") and intent.getStringExtra then
          local fallback = intent.getStringExtra("browser_fallback_url")
          if fallback and fallback ~= "" then
            view.loadUrl(fallback)
            return true
          end
        end
        print("没有用于打开的应用")
      end
     else
      print("没有用于打开的应用")
    end
    return true
  end
  return false
end,nil,nil,nil,nil)
单页文件上传影视解决(nil,--可填写页面，需开预加载
nil,
function(super,view,title)
  --获取到网页标题
  应用栏标题.setText(title)
  local cjson=require("cjson")
  local data=cjson.decode(获取应用数据("浏览历史"))
  table.insert(data,1,{PageName=activity.getLoader().getPageName(),Title=title,Text=view.getUrl()})
  local json=cjson.encode(data)
  存储应用数据("浏览历史",json)
end,nil,nil,nil,nil,nil,
function(superCall,view,progress)
  --页面加载进度
  view.parent.getChildAt(2).progress=progress
end,nil,nil,获取应用数据("旋转方式"),nil)
--单页文件上传影视解决(页面,网页JS执行超时,获取标题事件,获取到网页图标,网页提示框,网页确认框,网页输入框,控制台消息,页面加载进度,网页权限申请,网页定位权限,旋转方式,是否允许多选)
--旋转方式不填或填nil为跟随系统默认，1为自动旋转，2为限制横屏旋转,3为竖屏
--是否允许多选是部分网页可能会用上的多选文件上传，不填或填nil则是单选
--温馨提示：使用了该功能，网页监听的标题事件会失效，请使用这个功能的标题事件
if 获取应用数据("下载方式")=="true" then
  单页监听下载(nil,1,nil,"Mt论坛Lite/")
 else
  单页监听下载(nil)
end
单页监听禁长按(nil,
function(菜单)
  --菜单.remove("复制链接")
  菜单.remove("查看信息")
  菜单.remove("打开链接")
  --菜单.remove("分享链接")
  --菜单.remove("查看图片")
  --菜单.remove("保存图片")
  --菜单.remove("分享图片")
  return 菜单
end,nil)