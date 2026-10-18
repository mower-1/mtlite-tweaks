require "import"
使用公共lua文件("libs")
import "gongyong"
import "Function_bottom"
应用栏标题.setText("加载中...").setVisibility(0)
应用栏标题.setEllipsize(TextUtils.TruncateAt.MARQUEE)--设置跑马灯属性
应用栏标题.setSelected(true)--设置选中状态
应用栏标题.setSingleLine(true)--设置单行显示
if 获取应用数据("显示悬浮按钮")=="false" then
  显隐悬浮按钮(1)
  悬浮按钮.layoutParams.behavior=nil
end
获取浏览器(0).getSettings().setUserAgentString(获取应用数据("手机UA"))
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    if 获取应用数据("发帖锁屏") then
      -- 拦截返回键（不退出）
      print"屏幕已锁定\n请长按悬浮按钮进行解锁"
     else
      退子页面()
    end
    return true
  end
end

传递数据=...
if 传递数据 then
  加载网页(nil,传递数据)
 else
  退子页面()
end
function 判断帖子(input)
  if type(input) ~= "string" then
    return false
  end
  return input:match("^%d+%-%d+$") ~= nil
end
function 判断用户(input)
  if type(input) ~= "string" then
    return false
  end
  return input:match("^%d+$") ~= nil
end
--[=[搜索事件
function onSearchEvent(keyword)
  if keyword:match("^SS") then
    local keyword=keyword:match("^SS(.+)") or ""
    if keyword:match("^(https?://[%w-_%.%?%.:/%+=&]+)") then
      进子页面("liulanye",{keyword})
     else
      进子页面("sousuo",{keyword,"SS"})
    end
   elseif keyword:match("^YH") then
    local keyword=keyword:match("^YH(.+)") or ""
    if 判断用户(keyword) then
      进子页面("yonghu",{"https://bbs.binmt.cc/home.php?mod=space&uid="..keyword.."&do=profile"})
     else
      print2"当前搜索模式：打开用户主页\n搜索内容中包含数字以外内容，无法前往"
    end
    return true
   elseif keyword:match("^TZ") then
    local keyword=keyword:match("^TZ(.+)") or ""
    if 判断帖子(keyword) then
      进子页面("tiezi",{"https://bbs.binmt.cc/thread-"..keyword.."-1.html"})
     elseif 判断用户(keyword) then
      进子页面("tiezi",{"https://bbs.binmt.cc/thread-"..keyword.."-1-1.html"})
     else
      print2"当前搜索模式：打开帖子\n搜索内容中包含数字以外内容，无法前往"
    end
    return true
   else
    进子页面("sousuo",{keyword})
  end
end
搜索栏.setHint("请输入关键词进行搜索...")
搜索栏.onClick=function(v)--控件点击事件
  if !获取应用数据("搜索提示") then
    搜索提示=AlertDialog.Builder(this)--普通对话框
    .setTitle("搜索提示")
    .setMessage([[内容 = MT论坛搜索
SS+内容 = 搜索引擎搜索
SS+链接 = 打开链接
YH+用户id = 打开用户主页
TZ+帖子id = 打开帖子
TZ+(帖子id-页数) = 打开帖子指定页数

注：
①点击对话框外部任意位置即可关闭对话框
②该对话框只会在您第一次点击搜索框时显示一次]])
    .setOnDismissListener(function()
      存储应用数据("搜索提示",1)
    end)
    .show()
    搜索提示.findViewById(android.R.id.message).setTextIsSelectable(true)
  end
end;
搜索栏.setHint("请输入关键词进行搜索...")
]=]
function onMenuItemClick(title)
  switch(title) do
   case "刷新"
    刷新网页()
  end
end
左上角按钮().onClick=function(v)
  退子页面()
end;
右上角按钮(0,1).onClick=function(v)
  function 弹出菜单(v,样式)
    PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
    local popupMenu=PopupMenu(activity,v)
    local 主菜单=popupMenu.menu
    主菜单.add("网页查找")
    主菜单.add("网页审查")
    if 获取网址():match('bbs%.binmt%.cc/forum%-.+%-.+%.html') then
      主菜单.add("高级筛选")
    end
    主菜单.add("浏览器打开")
    主菜单.add("复制链接")
    主菜单.add("电脑版网页")
    主菜单.add("退出页面")
    popupMenu.onMenuItemClick=function(item)
      switch item.title
       case "网页查找"
        网页查找对话框()
       case "高级筛选"
        加载Js([[document.getElementsByClassName("comiis_font kmxiao")[0].click();]])
       case "浏览器打开"
        浏览器打开(获取网址())
       case "复制链接"
        复制文本(获取网址())
       case "网页审查"
        进子页面(获取应用数据("默认浏览页"),{获取网址(),1})
       case "电脑版网页"
         打开电脑版网页()
       case "退出页面"
        退子页面()
      end
    end
    -- 显示弹出菜单
    popupMenu.show()
    popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
  end
  弹出菜单(v)
end;
function onFloatingActionButtonClick(v)
  加载Js([[document.querySelector("div.header_y .comiis_font").click();]])
end
悬浮按钮.onLongClick=function(v)
  local isLocked = 获取应用数据("发帖锁屏")
  存储应用数据("发帖锁屏", not isLocked)
  if not isLocked then
    print"屏幕锁定"
   else
    print"屏幕解锁"
  end
  return true
end;

绑定=0
页面事件处理(nil,
function(superCall,view,url,favicon)
  --页面开始加载事件
  local 发帖=url:match'bbs%.binmt%.cc/forum.+'
  if 发帖 then
    bottom.setVisibility(this.uiManager.viewPager.GONE)
    悬浮按钮.setVisibility(this.uiManager.viewPager.VISIBLE)
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
  --[[function getBitmapFromView(v)
      local Bitmap = luajava.bindClass "android.graphics.Bitmap"
      local Canvas = luajava.bindClass "android.graphics.Canvas"
      local Color = luajava.bindClass "android.graphics.Color"
      local b = Bitmap.createBitmap(v.getWidth(), v.getHeight(), Bitmap.Config.RGB_565);
      local c = Canvas(b);
      v.layout(v.getLeft(), v.getTop(), v.getRight(), v.getBottom());
      local bgDrawable = v.getBackground();
      if (bgDrawable ~= null) then
        bgDrawable.draw(c);
       else
        c.drawColor(Color.WHITE);
        v.draw(c);
      end
      return b;
    end
    local Color = luajava.bindClass "android.graphics.Color"
    local bitmap = getBitmapFromView(view)
    local color=bitmap.getPixel(1,1)
    import "android.graphics.drawable.ColorDrawable"
    this.uiManager.appBarLayout.setBackgroundDrawable(ColorDrawable(color))
    activity.window.statusBarColor=color
    bitmap.recycle()]]
end,nil,
function(_,view,webResourceRequest)
  --Url即将跳转事件(即将加载事件)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local 登录跳转=url:match'bbs%.binmt%.cc/member%.php%?mod=logging&action=login'
  local 需绑定=url:match'bbs%.binmt%.cc/home%.php%?mod=spacecp&ac=plugin&id=comiis_sms:comiis_setup&mobile=2'
  local 帖子=url:match'bbs%.binmt%.cc/thread%-.+%-.+%-.+%.html$'
  local 新发贴=url:match'bbs%.binmt%.cc/thread%-.+%-.+%-.+%.html%?mobile=2'
  local 编辑贴=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=%d+&page=%d+&extra=&mobile=%d+#pid%d+'
  local 删除跳转=url:match'bbs%.binmt%.cc/forum%.php%?mod=forumdisplay&fid=.+&mobile=2'
  local 个人页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=profile$'
  local 用户页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile'
  local 发帖成功=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=.+&page=.+&extra=&mobile=.+#pid.+'
  --https://bbs.binmt.cc/forum.php?mod=viewthread&tid=156697&page=1&extra=&mobile=2#pid10200979
  --print(url)
  --复制文本(url)
  if 登录跳转 then
    进子页面("denglu")
    return true
   elseif 需绑定 then
    if 绑定>0 then
      print2"请返回主页绑定手机号后使用"
     else
      绑定=绑定+1
    end
    return true
   elseif 发帖成功 then
    进子页面("tiezi",{url})
    if 网页是否可前进后退数(-1) then
      网页前进后退数(-1)
      task(300,function()
        刷新网页()
      end)
     else
      --网页后退()
      退出页面()
    end
    return true
   elseif 新发贴 then
    退出页面()
    进子页面("tiezi",{url})
    return true
   elseif 帖子 then
    进子页面("tiezi",{url})
    return true
   elseif 用户页 or 个人页 then
    进子页面("yonghu",{url})
    return true
   elseif 删除跳转 then
    退子页面()
    return true
   elseif not url:find("^https?://") and not url:find("^file://") then
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
        print("没有用于打开的应用")
      end
     else
      print("没有用于打开的应用")
    end
    return true
  end
  return false
end)
单页文件上传影视解决(nil,--可填写页面，需开预加载
nil,
function(super,view,title)
  --获取到网页标题
  应用栏标题.setText(title)
end,nil,
function(a,view,url,message,result)
  result.cancel()
  if message=="点击了回复" then
    悬浮按钮.setVisibility(this.uiManager.viewPager.GONE)
    bottom.setVisibility(this.uiManager.viewPager.VISIBLE)
    return true
   elseif message=="关闭了回复" then
    bottom.setVisibility(this.uiManager.viewPager.GONE)
    悬浮按钮.setVisibility(this.uiManager.viewPager.VISIBLE)
    return true
   else
    print(message)
    return true
  end
end,nil,nil,nil,
function(superCall,view,progress)
  --页面加载进度
  view.parent.getChildAt(2).progress=progress
end,nil,nil,nil,nil)
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