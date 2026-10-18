require "import"
使用公共lua文件("libs")
import "gongyong"
应用栏标题.setText("登录 - MT论坛").setVisibility(0)
if 获取应用数据("显示悬浮按钮")=="false" then
  显隐悬浮按钮(1)
  悬浮按钮.layoutParams.behavior=nil
end
获取浏览器(0).getSettings().setUserAgentString(获取应用数据("手机UA"))
加载网页(nil,"https://bbs.binmt.cc/member.php?mod=logging&action=login&mobile=2")
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    退子页面()
    return true
  end
end
传递数据=...
if 传递数据 and 传递数据:match("^https://ssl.ptlogin2.qq.com/") then
  加载网页(nil,传递数据)
end
function onMenuItemClick(title)
  switch(title) do
   case "警示"
    警示=AlertDialog.Builder(this)
    .setTitle("温馨提示")
    .setMessage([[①软件内支持QQ快捷登录，但前提是将Mt论坛Lite设置为系统默认浏览器
②账号密码登录时若页面提示非法请求，刷新网页即可
③软件内为防止错误判断禁止注册账号和找回密码此类操作，请自行前往浏览器操作]])
    .setPositiveButton("知道了",nil)
    .show()
  end
end
左上角按钮().onClick=function(v)
  退子页面()
end;
function onFloatingActionButtonClick(v)
  刷新网页()
end

页面事件处理(nil,--可填写页面，需开预加载
function(superCall,view,url,favicon)
  --页面开始加载事件
  if url=="https://bbs.binmt.cc/forum.php?mod=guide&view=hot&mobile=2" then
    local cookie=获取网页Cookie("https://bbs.binmt.cc/forum.php?mod=guide&view=hot&mobile=2")
    存储应用数据("登录参数",cookie)
    print2("登录成功")
    退出程序()
    进子页面("zhuye")
  end
end,
function(superCall,view,url)
  --页面加载结束事件
  if 获取应用数据("网页背景色")=="true" then
    加载Js([[document.body.style.backgroundColor = "]]..窗体背景色2..[[";]])
  end
end,
nil,
function(_,view,webResourceRequest)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local 注册事件=url:match'bbs%.binmt%.cc/member%.php%?mod=register213&.-mobile=2'
  local 找回密码=url:match'bbs%.binmt%.cc/member%.php%?mod=logging&action=login&lostpasswd=yes&mobile=2'
  local QQ登录=url:match'bbs%.binmt%.cc/connect%.php%?mod=login&op=init&referer=.+&statfrom=login_simple'
  if 注册事件 then
    print2"为防止一些错误判断，软件内禁止注册账号操作\n请自行前往浏览器进行操作"
    return true
   elseif 找回密码 then
    print2"为防止一些错误判断，软件内禁止找回密码操作\n请自行前往浏览器进行操作"
    return true
   elseif QQ登录 then
    --print2"软件内不支持QQ快捷登录"
   -- return true
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
        print("没有用于打开的应用")
      end
     else
      print("没有用于打开的应用")
    end
    return true
  end
  return false
end,
nil,nil,nil,nil)
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