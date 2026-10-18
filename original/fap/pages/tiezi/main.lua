require "import"
使用公共lua文件("libs")
import "gongyong"
import "android.webkit.CookieManager"
import "net.fusionapp.core.ui.fragment.WebInterface"
import "androidx.recyclerview.widget.*"
import "Function_bottom"
应用栏标题.setText("加载中...").setVisibility(0)
应用栏标题.setEllipsize(TextUtils.TruncateAt.MARQUEE)--设置跑马灯属性
应用栏标题.setSelected(true)--设置选中状态
应用栏标题.setSingleLine(true)--设置单行显示
获取浏览器(0).getSettings().setUserAgentString(获取应用数据("手机UA"))
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    退子页面()
    return true
  end
end
传递数据=...
if 传递数据 then
  加载网页(nil,传递数据)
 else
  退子页面()
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
    主菜单.add("网页审查")
    主菜单.add("添加收藏")
    主菜单.add("原网页菜单")
    if 获取应用数据("显示悬浮按钮")=="false" then
      主菜单.add("网页刷新")
    end
    主菜单.add("浏览器打开")
    主菜单.add("复制链接")
    主菜单.add("退出页面")
    popupMenu.onMenuItemClick=function(item)
      switch item.title
       case "网页查找"
        网页查找对话框()
       case "添加收藏"
        添加收藏对话框(获取浏览器(nil).title,获取浏览器(nil).url)
       case "原网页菜单"
        加载Js([[document.getElementsByClassName("comiis_share_key")[0].click();]])
       case "网页刷新"
        刷新网页()
       case "浏览器打开"
        浏览器打开(获取网址())
       case "复制链接"
        复制文本(获取网址())
       case "网页审查"
        进子页面(获取应用数据("默认浏览页"),{获取网址(),1})
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

编辑帖子触发=0
页面事件处理(nil,
function(superCall,view,url,favicon)
  --页面开始加载事件
  local 帖子=url:match'bbs%.binmt%.cc/thread%-.-%-.+'
  local 帖子2=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=.+'
  if 帖子 or 帖子2 then
    bottom.setVisibility(this.uiManager.viewPager.GONE)
    if 获取应用数据("显示悬浮按钮")=="true" then
      悬浮按钮.setVisibility(this.uiManager.viewPager.VISIBLE)
    end
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
  加载Js([[document.getElementsByClassName("comiis_lookfulltext_key")[0].click();]])
  加载Js([[
    document.getElementsByClassName("header_z")[1].setAttribute("onclick","JsHD_djsj_51754();"+document.getElementsByClassName("header_z")[1].getAttribute("onclick"));function JsHD_djsj_51754() {alert("关闭了回复");};
    document.getElementById("fastpostsubmit").setAttribute("onclick","JsHD_djsj_51754();"+document.getElementById("fastpostsubmit").getAttribute("onclick"));
    ]])
  if 获取应用数据("URL超链接")=="true" then
    加载Js([[url_clickable();]])
  end
  加载Js([[var obj=document.getElementsByClassName("f_d")[0];
    var obj2=document.getElementsByClassName("kmtit")[0];
    var patt = /#/;
     if (!patt.test(obj.innerHTML)) {
    obj.innerHTML=obj.innerHTML+'&nbsp;#<a href="'+obj2.attributes["href"].nodeValue+'">'+obj2.innerHTML+'</a>';
    }]])
  if 获取应用数据("自动上下页")=="true" then
    加载Js([[automatic_page_down();]])
  end
end,nil,
function(_,view,webResourceRequest)
  --Url即将跳转事件(即将加载事件)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local 登录跳转=url:match'bbs%.binmt%.cc/member%.php%?mod=logging&action=login'
  local 注册事件=url:match'bbs%.binmt%.cc/member%.php%?mod=register213&.-mobile=2'
  local 发帖子=url:match'bbs%.binmt%.cc/forum%.php%?mod=post&action=newthread&fid=%d+$'
  local 编辑帖子=url:match'bbs%.binmt%.cc/forum%.php%?mod=post&action=edit&fid=%d+&tid=%d+&pid=%d+&page=%d+'
  local 帖子=url:match'bbs%.binmt%.cc/thread%-.+%-.+%-.+%.html'
  local 帖子2=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=%d+$'
  local 正序帖=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=%d+&extra=page%%3D1&ordertype=2&mobile=2#comiis_allreplies'
  local 反序帖=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=%d+&extra=page%%3D1&ordertype=1&mobile=2#comiis_allreplies'
  local 反序帖2=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=%d+&extra=page%%3D1&ordertype=1&page=.+'
  local 板块=url:match'bbs%.binmt%.cc/forum%-.+%-.+%.html'
  local 板块2=url:match'bbs%.binmt%.cc/forum%.php%?mod=forumdisplay'
  local 个人页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=profile$'
  local 用户页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile'
  local 等级=url:match'bbs%.binmt%.cc/home%.php%?mod=spacecp&ac=usergroup'
  local MT论坛=url:match'^https://bbs.binmt.cc/'
  local 回复成功=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=.+&page=.+&extra=&mobile=.+#pid.+'
  local 点击图片=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=.+&aid=.+&from=album&page=1'
  local 图片返回=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=%d+&mobile=2#comiis_allreplies'
  local 标签=url:match'bbs%.binmt%.cc/misc%.php%?mod=tag&id=.+&type=thread&mobile=2'
  local 好友表=url:match'bbs%.binmt%.cc/space%-uid%-%d+%.html'
  local 打开QQ=url:match'wpa%.qq%.com/msgrd%?v=3&uin=%d+&site=.-&from=discuz&menu=yes'
  --https://bbs.binmt.cc/forum.php?mod=viewthread&tid=154167&mobile=2#comiis_allreplies
  --https://bbs.binmt.cc/forum.php?mod=viewthread&tid=156506&extra=page%3D1&ordertype=1&mobile=2#comiis_allreplies
  --复制文本(url)
  --local Lua代码运行=url:match'bbs%.binmt%.cc/LuaYx%%7C'
  if 登录跳转 then
    进子页面("denglu")
    return true
   elseif 注册事件 then
    print2"为防止一些错误判断，软件内禁止注册账号操作\n请自行前往浏览器进行操作"
    return true
   elseif 回复成功 then
    网页后退()
    task(300,function()
      刷新网页()
    end)
    return true
   elseif 等级 or 用户页 or 个人页 then
    进子页面("yonghu",{url})
    return true
   elseif 好友表 then
    return true
   elseif 板块 or 板块2 or 发帖子 then
    进子页面("bankuai",{url})
    return true
   elseif 编辑帖子 then
    if 编辑帖子触发==0 then
      编辑帖子触发=编辑帖子触发+1
      退出页面()
      进子页面("bankuai",{url})
    end
    return true
   elseif 正序帖 then
    帖子id=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=(%d+)&extra=page%%3D1&ordertype=2&mobile=2#comiis_allreplies'
    退出页面()
    进子页面("tiezi",{"https://bbs.binmt.cc/thread-"..帖子id.."-1-1.html"})
    return true
   elseif 反序帖 then
    帖子id=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=(%d+)&extra=page%%3D1&ordertype=1&mobile=2#comiis_allreplies'
    退出页面()
    进子页面("tiezi",{"https://bbs.binmt.cc/forum.php?mod=viewthread&tid="..帖子id.."&extra=page%3D1&ordertype=1&page=1"})
    return true
   elseif 反序帖2 then
    帖子id,帖子页数=传递数据:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=(%d+)&extra=page%%3D1&ordertype=1&page=(.+)'
    帖子id2,帖子页数2=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=(%d+)&extra=page%%3D1&ordertype=1&page=(.+)'
    if 获取应用数据("下一页重调用")=="true" then
      if 帖子id~=帖子id2 then
        进子页面("tiezi",{url})
        return true
       elseif 帖子id==帖子id2 and 帖子页数<帖子页数2 then
        进子页面("tiezi",{url})
        return true
       elseif 帖子id==帖子id2 and 帖子页数>帖子页数2 then
        退子页面()
        return true
      end
     else
      if 帖子id~=帖子id2 then
        进子页面("tiezi",{url})
        return true
      end
    end
   elseif 帖子 then
    帖子id,帖子页数=传递数据:match'bbs%.binmt%.cc/thread%-(.+)%-(.+)%-.+%.html'
    帖子id2,帖子页数2=url:match'bbs%.binmt%.cc/thread%-(.+)%-(.+)%-.+%.html'
    if 获取应用数据("下一页重调用")=="true" then
      if 帖子id~=帖子id2 then
        进子页面("tiezi",{url})
        return true
       elseif 帖子id==帖子id2 and 帖子页数<帖子页数2 then
        进子页面("tiezi",{url})
        return true
       elseif 帖子id==帖子id2 and 帖子页数>帖子页数2 then
        退子页面()
        return true
      end
     else
      if 帖子id~=帖子id2 then
        进子页面("tiezi",{url})
        return true
      end
    end
   elseif 点击图片 then
    进子页面("tiezi",{url})
    return true
   elseif 图片返回 then
    退子页面()
    return true
   elseif 帖子2 then
    帖子2id=url:match('bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=(%d+)$')
    --https://bbs.binmt.cc/forum.php?mod=viewthread&tid=156456
    --https://bbs.binmt.cc/thread-156456-2-1.html
    进子页面("tiezi",{"https://bbs.binmt.cc/thread-"..帖子2id.."-1-1.html"})
    return true
   elseif 标签 then
    进子页面("sousuo",{url})
    return true
    --[[elseif Lua代码运行 then
    local Lua代码=URL解码(url):match("LuaYx|(.+)")
    if Lua代码~=nil and Lua代码~="" then
      loadstring(Lua代码)()
    end
    return true]]
   elseif 打开QQ then
    QQ号=url:match'wpa%.qq%.com/msgrd%?v=3&uin=(%d+)&site=.-&from=discuz&menu=yes'
    url="mqqapi://card/show_pslcard?src_type=internal&version=1&uin="..QQ号.."&card_type=person&source=qrcode"
    local intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
    跳转应用对话框("QQ",url,function(v)
      local ok, err = pcall(activity.startActivity, intent)
      if not ok then
        print("启动失败: "..tostring(err))
      end
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
   elseif not MT论坛 then
    离开本站对话框(url)
    return true
  end
  return false
end)
function Load_next_page(url)
  if url then
    Http.get(url,登录参数,"utf-8",nil,function(code,content,cookie,header)
      if code==200 then
        local content=content:match'<div class="comiis_bodybox">(.+)<div class="bg_e b_t cl">' or content
        local content=content:match[[</script>
         (.+)<div class="comiis_fastpostbox comiis_showleftbox bg_e">]] or content
        加载Js([[Write_html(`]]..content..'`);')
       else
      end
    end)
  end
end
单页文件上传影视解决(nil,--可填写页面，需开预加载
nil,
function(super,view,title)
  --获取到网页标题
  应用栏标题.setText(title)
  local cjson=require("cjson")
  local data=cjson.decode(获取应用数据("帖子历史"))
  table.insert(data,1,{PageName=activity.getLoader().getPageName(),Title=title,Text=view.getUrl()})
  local json=cjson.encode(data)
  存储应用数据("帖子历史",json)
end,nil,
function(a,view,url,message,result)
  result.cancel()
  if message=="点击了回复" then
    if 获取应用数据("显示悬浮按钮")=="true" then
      悬浮按钮.setVisibility(this.uiManager.viewPager.GONE)
    end
    bottom.setVisibility(this.uiManager.viewPager.VISIBLE)
    return true
   elseif message=="关闭了回复" then
    bottom.setVisibility(this.uiManager.viewPager.GONE)
    if 获取应用数据("显示悬浮按钮")=="true" then
      悬浮按钮.setVisibility(this.uiManager.viewPager.VISIBLE)
    end
    return true
   elseif message:match'下一页：(.-)' then
    Load_next_page(message:match'下一页：(.+)')
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