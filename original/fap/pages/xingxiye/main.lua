require "import"
使用公共lua文件("libs")
import "gongyong"
获取浏览器(0).getSettings().setUserAgentString(获取应用数据("手机UA"))
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    退子页面()
    return true
  end
end
去除加载进度条(nil)
状态栏颜色(窗体背景色)
传递数据=...
if 传递数据 then
  if 传递数据==1 then
    --应用栏标题.setText("免责声明")
    加载网页(nil,"file://"..activity.getLuaDir().."/disclaimer.html")
   elseif 传递数据==2 then
    --应用栏标题.setText("隐私政策")
    加载网页(nil,"file://"..activity.getLuaDir().."/privacy_policy.html")
   elseif 传递数据==3 then
    --应用栏标题.setText("用户协议")
    加载网页(nil,"file://"..activity.getLuaDir().."/user_agreement.html")
  end
 else
  加载网页(nil,"file://"..activity.getLuaDir().."/disclaimer.html")
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
end,nil,
function(_,view,webResourceRequest)
  --Url即将跳转事件(即将加载事件)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local 用户页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile'
  local MT论坛=url:match'^https://bbs.binmt.cc/$'
  local 开源地址=url:match'^https://wwi.lanzouo.com/b0d1pmq7a$'
  if 用户页 then
    进子页面("yonghu",{url})
    return true
   elseif MT论坛 or 开源地址 then
    浏览器打开(url)
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