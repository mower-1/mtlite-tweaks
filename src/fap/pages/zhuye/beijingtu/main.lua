require "import"
使用公共lua文件("libs")
import "gongyong"
if 获取应用数据("显示悬浮按钮")=="false" then
  显隐悬浮按钮(1)
  悬浮按钮.layoutParams.behavior=nil
end
获取浏览器(0).getSettings().setUserAgentString(获取应用数据("手机UA"))
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    退子页面()
    return true
  end
end
传递数据=...
if 传递数据 then
  应用栏标题.setText("积分商城 - MT论坛").setVisibility(0)
  加载网页(nil,"https://bbs.binmt.cc/keke_integralmall-keke_integralmall.html")
 else
  应用栏标题.setText("更改背景图片 - MT论坛").setVisibility(0)
  加载网页(nil,"https://bbs.binmt.cc/plugin.php?id=comiis_app_homestyle&mobile=2")
end
左上角按钮().onClick=function(v)
  退子页面()
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
  local 登录跳转=url:match'bbs%.binmt%.cc/member%.php%?mod=logging&action=login'
  local 退出登录=url:match'bbs%.binmt%.cc/member%.php%?mod=logging&action=logout&formhash=.+&mobile=2'
  local 我的页面=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile&mycenter=1'
  local 推广页=url:match'bbs%.binmt%.cc/home%.php%?mod=spacecp&ac=promotion'
  local 首页=url:match'bbs%.binmt%.cc/forum%.php%?mod=guide&view=hot'
  local 社区=url:match'bbs%.binmt%.cc/forum%.php%?forumlist=1'
  local 导读=url:match'bbs%.binmt%.cc/forum%.php%?mod=guide&view=newthread&index=1'
  local 签到=url:match'bbs%.binmt%.cc/k_misign%-sign%.html'
  local 排行=url:match'bbs%.binmt%.cc/misc%.php%?mod=ranklist&type=member&view=credit&mobile=2'
  local 标签=url:match'bbs%.binmt%.cc/misc%.php%?mod=tag&mobile=2'
  local 搜索=url:match'bbs%.binmt%.cc/search%.php%?mod=forum&mobile=2'
  local 好友页=url:match'bbs%.binmt%.cc/space%-uid%-.+%.html'
  local 再逛逛=url:match'bbs%.binmt%.cc/plugin%.php%?id=keke_integralmall:view&tid=%d+$'
  if 登录跳转 then
    进子页面("denglu")
    print2"请登录后再修改"
    return true
   elseif 我的页面 or 推广页 or 退出登录 or 好友页 or 首页
    or 社区 or 导读 or 签到 or 排行 or 标签 or 搜索 then
    return true
   elseif 再逛逛 then
    网页后退()
    task(300,function()
      刷新网页()
    end)
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