require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
使用公共lua文件("libs")
import "gongyong"
获取浏览器(0).getSettings().setUserAgentString(获取应用数据("手机UA"))
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    退子页面()
    return true
  end
end
传递数据=...
if 传递数据 then
  应用栏标题.setText("精华推荐 - MT论坛").setVisibility(0)
  加载网页(nil,"https://bbs.binmt.cc/page-2.html")
 else
  应用栏标题.setText("排行榜 - MT论坛").setVisibility(0)
  加载网页(nil,"https://bbs.binmt.cc/misc.php?mod=ranklist&type=member&view=credit&mobile=2")
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
    if 获取应用数据("显示悬浮按钮")=="false" then
      主菜单.add("网页刷新")
    end
    主菜单.add("浏览器打开")
    主菜单.add("复制链接")
    主菜单.add("电脑版网页")
    主菜单.add("退出页面")
    popupMenu.onMenuItemClick=function(item)
      switch item.title
       case "网页查找"
        网页查找对话框()
       case "网页刷新"
        刷新网页()
       case "浏览器打开"
        浏览器打开(获取网址())
       case "复制链接"
        复制文本(获取网址())
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
  刷新网页()
end
页面事件处理(nil,
function(superCall,view,url,favicon)
  --页面开始加载事件
end,
function(superCall,view,url)
  --页面加载结束事件
  if 获取应用数据("网页背景色")=="true" then
    加载Js([[document.body.style.backgroundColor = "]]..窗体背景色2..[[";]])
  end
  if 获取应用数据("显示FPS")=="true" then
    加载Js("Display_fps();")
  end
end,nil,
function(_,view,webResourceRequest)
  --Url即将跳转事件(即将加载事件)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local 帖子=url:match'bbs%.binmt%.cc/thread%-.+%-.+%-.+%.html'
  local 个人页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=profile$'
  local 用户页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile'
  if 帖子 then
    进子页面("tiezi",{url})
    return true
   elseif 用户页 or 个人页 then
    进子页面("yonghu",{url})
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
nil,nil,nil,nil,nil,nil,nil,
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