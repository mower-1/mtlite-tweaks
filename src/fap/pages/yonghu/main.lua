require "import"
使用公共lua文件("libs")
import "gongyong"
import "pm_plus"
应用栏标题.setText("用户页").setVisibility(0)
应用栏标题.setEllipsize(TextUtils.TruncateAt.MARQUEE)--设置跑马灯属性
应用栏标题.setSelected(true)--设置选中状态
应用栏标题.setSingleLine(true)--设置单行显示
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
    if 获取网址():match('bbs%.binmt%.cc/home%.php%?mod=space&uid=%d+&do=profile') then
      主菜单.add("原网页菜单")
    end
    if 获取网址():match('bbs%.binmt%.cc/home%.php%?mod=space&do=pm&subop=view&touid=.+') then
      主菜单.add("历史信息")
    end
    主菜单.add("浏览器打开")
    主菜单.add("复制链接")
    主菜单.add("电脑版网页")
    主菜单.add("退出页面")
    popupMenu.onMenuItemClick=function(item)
      switch item.title
       case "网页查找"
        网页查找对话框()
       case "原网页菜单"
        --https://bbs.binmt.cc/home.php?mod=space&uid=139934&do=profile
        --https://bbs.binmt.cc/home.php?mod=space&do=profile
        加载Js([[document.getElementById("comiis_menu_tr").click();]])
       case "历史信息"
        local packagej=获取网址():match'uid=(.+)&' or 获取网址():match'touid=(.+)'
        if packagej then
          加载网页(nil,"https://bbs.binmt.cc/home.php?mod=space&do=pm&subop=view&touid="..packagej.."&viewall=1")
         else
          print("暂无历史消息")
        end
       case "网页审查"
        进子页面(获取应用数据("默认浏览页"),{获取网址(),1})
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
  if 获取应用数据("URL超链接")=="true" then
    加载Js([[url_clickable();]])
  end
  view.evaluateJavascript([[document.getElementById("comiis_foot_memu").setAttribute("style","display:block");]],function end)
  local 历史信息=url:match'bbs%.binmt%.cc/home.php%?mod=space&do=pm&subop=view&touid=.+&'
  local 消息=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=pm&subop=view&touid=.+'
  local packageName2_1=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=thread&view=me&type=.+'
  local 个人页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=profile$'
  local 用户页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile$'
  local 用户刷新页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile&view=me&from=space'
  local 帖子页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=thread&view=me&from=space'
  local 帖子页2=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=thread&view=me&order=dateline&from=space&page=%d+$'
  local 帖子回复=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=thread&view=me&type=reply&from=space'
  local 粉丝=url:match'bbs%.binmt%.cc/home%.php%?mod=follow&do=follower&uid=%d+$'
  if 消息 and !历史信息 then
    view.evaluateJavascript([[document.getElementsByClassName("flex")[0].innerHTML
]],function(a)
      应用栏标题.Text=(a:match('                    (.-).u003C').."("..a:match('">%((.+)%)')..") - MT论坛") or "获取失败"
      --copy(html转义(a))--"\n稻草人Q比\u003Cfontclass=\"f14\">(离线)\u003C/font>\t\t\t\n"
    end)
   elseif 消息 or packageName2_1 then
    view.evaluateJavascript('document.getElementById("comiis_foot_memu").setAttribute("style","display:none");',function end)
   elseif 用户页 or 个人页 or 用户刷新页 then
    view.evaluateJavascript([[document.getElementsByClassName("fyy")[0].innerHTML]],function(a)
      应用栏标题.Text=a:match("\"(.-)\"").."的个人资料 - MT论坛" or "个人中心 - MT论坛"
    end)
   elseif 帖子页 or 帖子页2 then
    view.evaluateJavascript([[document.getElementsByClassName("fyy")[0].innerHTML]],function(a)
      应用栏标题.Text=a:match("\"(.-)\"").."的帖子 - MT论坛" or "个人中心 - MT论坛"
    end)
   elseif 帖子回复 then
    view.evaluateJavascript([[document.getElementsByClassName("fyy")[0].innerHTML]],function(a)
      应用栏标题.Text=a:match("\"(.-)\"").."的回复 - MT论坛" or "个人中心 - MT论坛"
    end)
   elseif 粉丝 then
    view.evaluateJavascript([[document.getElementsByClassName("fyy")[0].innerHTML]],function(a)
      if a~="null" then
        应用栏标题.Text=a:match("\"(.-)\"").."的粉丝 - MT论坛" or "个人中心 - MT论坛"
      end
    end)
  end
  --私信页 + 私信发送结果页：触发“发送太快”限制后自动等待重发（带倒计时悬浮窗，可取消）
  local 私信相关 = url and (url:match('mod=space&do=pm') or url:match('mod=spacecp&ac=pm'))
  if 私信相关 then
    local 注入成功,注入错误=pcall(注入私信增强)
    if not 注入成功 then
      print("私信增强注入失败："..tostring(注入错误))
    end
  end
end,nil,
function(_,view,webResourceRequest)
  --Url即将跳转事件(即将加载事件)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local 登录跳转=url:match'bbs%.binmt%.cc/member%.php%?mod=logging&action=login'
  local 帖子=url:match'bbs%.binmt%.cc/thread%-.+%-.+%-.+%.html'
  local 发帖子=url:match'bbs%.binmt%.cc/forum%.php%?mod=post&action=newthread&fid=%d+$'
  local 板块=url:match'bbs%.binmt%.cc/forum%-.+%-.+%.html'
  local MT论坛=url:match'^https://bbs.binmt.cc/'
  local 个人页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=profile$'
  local 用户页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile$'
  local 资料修改=url:match'bbs%.binmt%.cc/home%.php%?mod=spacecp$'
  local 签名修改=url:match'bbs%.binmt%.cc/home%.php%?mod=spacecp&ac=profile&op=info'
  local 背景板=url:match'bbs%.binmt%.cc/plugin%.php%?id=comiis_app_homestyle&mobile=2'
  local 打招呼=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=friend&.+mobile=2'
  local 打招呼2=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile&mobile=2'
  local 打招呼3=url:match'bbs%.binmt%.cc/%?mobile=2$'
  local 帖子页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=thread&view=me&type=thread&from=space'
  local 打开QQ=url:match'wpa%.qq%.com/msgrd%?v=3&uin=%d+&site=.-&menu=yes&from=discuz'
  local 历史删除=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=pm&filter=privatepm&mobile=2'
  if 登录跳转 then
    进子页面("denglu")
    return true
   elseif 帖子页 then
    用户id=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=(.+)&do=thread&view=me&type=thread&from=space'
    加载网页(nil,"https://bbs.binmt.cc/home.php?mod=space&uid="..用户id.."&do=thread&view=me&from=space")
    return true
   elseif 背景板 then
    进子页面("zhuye/beijingtu")
    return true
   elseif 资料修改 or 签名修改 then
    print2"请返回主页进行资料修改操作"
    return true
   elseif 打招呼 or 打招呼2 or 打招呼3 or 历史删除 then
    if 网页是否可前进后退数(-2) then
      网页前进后退数(-2)
     else
      网页后退()
    end
    task(300,function()
      刷新网页()
    end)
    return true
   elseif 帖子 then
    进子页面("tiezi",{url})
    return true
   elseif 板块 or 发帖子 then
    进子页面("bankuai",{url})
    return true
   elseif 用户页 or 个人页 then
    进子页面("yonghu",{url})
    return true
   elseif 打开QQ then
    QQ号=url:match'wpa%.qq%.com/msgrd%?v=3&uin=(%d+)&site=.-&menu=yes&from=discuz'
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
单页文件上传影视解决(nil,--可填写页面，需开预加载
nil,
function(super,view,title)
  --获取到网页标题
  应用栏标题.setText(title)
end,nil,function(a,view,url,message,result)
  --网页提示框：私信增强的内部消息（__MLITE_PM_*）在这里拦下，不弹给用户
  if 私信处理消息(message) then
    result.cancel()
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