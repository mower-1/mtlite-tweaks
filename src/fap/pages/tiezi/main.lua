require "import"
使用公共lua文件("libs")
import "gongyong"
import "android.webkit.CookieManager"
import "net.fusionapp.core.ui.fragment.WebInterface"
import "androidx.recyclerview.widget.*"
import "Function_bottom"
import "tiezi_plus"
--回复可见 / 评论屏蔽 会话内状态（同一页面刷新不会重置）
本地已提示tid=nil
本地自动回复tid=nil
function 当前帖子标识()
  local 链接=获取网址() or ""
  local tid=链接:match("thread%-(%d+)") or 链接:match("tid=(%d+)")
  return tid or 链接
end
--读到的缓存页置真，下一次页面加载完成事件直接跳过，避免增强脚本在缓存页里乱跑
缓存阅读中=false
--异步取当前整页 HTML（含已加载的评论），经 cjson 还原成 Lua 字符串
function 抓取网页HTML(浏览器,回调)
  pcall(function()
    浏览器.evaluateJavascript("(function(){return document.documentElement.outerHTML;})()",
      luajava.createProxy("android.webkit.ValueCallback",{onReceiveValue=function(v)
        local 成功,html=pcall(function() return require("cjson").decode(tostring(v)) end)
        回调(成功 and html or nil)
      end}))
  end)
end
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
--「下拉刷新」开启时隐藏刷新按钮（悬浮按钮），改用下拉手势；菜单里保留「网页刷新」兜底
local function 显示刷新按钮()
  return 获取应用数据("显示悬浮按钮")~="false" and 获取应用数据("下拉刷新")~="true"
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
    主菜单.add("缓存帖子")
    主菜单.add("原网页菜单")
    if not 显示刷新按钮() then
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
       case "添加收藏"
        添加收藏对话框(获取浏览器(nil).title,获取浏览器(nil).url)
       case "缓存帖子"
        local 浏览器=获取浏览器(0)
        抓取网页HTML(浏览器,function(html)
          if not html then
            print("缓存失败：无法读取页面内容")
            return
          end
          local ok=pcall(写入帖子缓存,当前帖子标识(),
            tostring(浏览器.getTitle() or ""),获取网址() or "",html)
          if ok then
            print2("已缓存当前帖子\n含已加载到页面里的评论，可在 设置→已缓存的帖子 查看")
           else
            print("缓存失败：写入文件出错")
          end
        end)
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

编辑帖子触发=0
页面事件处理(nil,
function(superCall,view,url,favicon)
  --页面开始加载事件
  local 帖子=url:match'bbs%.binmt%.cc/thread%-.-%-.+'
  local 帖子2=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=.+'
  if 帖子 or 帖子2 then
    bottom.setVisibility(this.uiManager.viewPager.GONE)
    if 显示刷新按钮() then
      悬浮按钮.setVisibility(this.uiManager.viewPager.VISIBLE)
     else
      悬浮按钮.setVisibility(this.uiManager.viewPager.GONE)
    end
  end
end,
function(superCall,view,url)
  --页面加载结束事件
  if 缓存阅读中 then
    --这一页是我们加载的本地缓存，跳过全部注入
    缓存阅读中=false
    return
  end
  local 页面标题=tostring(view.getTitle() or "")
  local 是帖子=url:match'bbs%.binmt%.cc/thread%-.-%-.+' or url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=.+'
  if 是帖子 and 页面标题:find("提示信息",1,true)==1 then
    --帖子被删 / 审核中 / 无权限：Discuz 的提示信息错误页，尝试改显本地缓存
    local 缓存=读取帖子缓存(当前帖子标识())
    local html=缓存 and 读缓存HTML(缓存)
    if html then
      缓存阅读中=true
      view.loadDataWithBaseURL("https://bbs.binmt.cc/",html,"text/html","utf-8",nil)
      pcall(function() 悬浮按钮.setVisibility(悬浮按钮.GONE) end)
      print2("原帖已删除或无法访问\n已显示本地缓存（"..缓存.time.."）")
    end
    return
  end
  if 是帖子 and 当前帖子标识() then
    --自动缓存：每次成功打开帖子都静默存一份，删帖前就已备好
    抓取网页HTML(view,function(html)
      if html then
        pcall(写入帖子缓存,当前帖子标识(),
          页面标题~="" and 页面标题 or ("帖子"..tostring(当前帖子标识())),
          tostring(url),html)
      end
    end)
  end
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
  --自动上下页改由 增强脚本 接管（预加载 + 并行抓取）
  --注入 回复可见检测 / 评论屏蔽 / 自动上下页 脚本
  local 注入成功,注入错误=pcall(注入帖子增强)
  if not 注入成功 then
    print("增强脚本注入失败："..tostring(注入错误))
  end
  --下拉刷新：内容跟随手指下移（阻尼 1/2），松手超过阈值才刷新；走 alert 通知原生
  if 获取应用数据("下拉刷新")=="true" then
    加载Js([[
      (function(){
        if (window.__mlitePTR) return; window.__mlitePTR = 1;
        var TH = 120, MAX = 160;
        var sy = 0, on = false, dy = 0, tip = null;
        function ensureTip(){
          if (tip) return tip;
          tip = document.createElement('div');
          tip.style.cssText = 'position:fixed;top:12px;left:50%;transform:translateX(-50%);'
            + 'z-index:2147483000;padding:6px 16px;border-radius:18px;background:rgba(0,0,0,0.55);'
            + 'color:#fff;font-size:13px;line-height:1.4;pointer-events:none;'
            + 'transition:opacity .15s;opacity:0;white-space:nowrap;';
          document.documentElement.appendChild(tip);
          return tip;
        }
        function setPull(d, ready){
          document.body.style.transition = 'none';
          document.body.style.transform = d > 0 ? 'translateY(' + d + 'px)' : '';
          var t = ensureTip();
          t.textContent = ready ? '松开刷新' : '下拉刷新';
          t.style.opacity = d > 0 ? '1' : '0';
        }
        function reset(){
          document.body.style.transition = 'transform .25s';
          document.body.style.transform = '';
          if (tip) tip.style.opacity = '0';
        }
        document.addEventListener('touchstart', function(e){
          if (e.touches.length !== 1) { on = false; return; }
          sy = e.touches[0].clientY;
          on = (window.pageYOffset <= 0);
        }, {passive: true});
        document.addEventListener('touchmove', function(e){
          if (!on) return;
          if (e.touches.length !== 1) { on = false; reset(); return; }
          var raw = e.touches[0].clientY - sy;
          if (raw < 0 || window.pageYOffset > 0) { on = false; reset(); return; }
          dy = Math.min(raw / 2, MAX);
          setPull(dy, raw >= TH);
        }, {passive: true});
        document.addEventListener('touchend', function(){
          if (!on) return;
          on = false;
          var go = dy >= TH / 2;
          dy = 0;
          reset();
          if (go) alert('__MLITE_PTR__');
        }, {passive: true});
        document.addEventListener('touchcancel', function(){
          on = false; dy = 0; reset();
        }, {passive: true});
      })();
    ]])
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
  local 用户名页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&username='
  local 空间页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=%d+$'
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
    --「@某人」/ 用户名链接在手机模板里是 space-uid-123.html。
    --原来这里直接 return true 把跳转吞掉了：既不请求也不提示，看着就像点不动
    local uid=url:match('space%-uid%-(%d+)%.html')
    if uid then
      进子页面("yonghu",{"https://bbs.binmt.cc/home.php?mod=space&uid="..uid.."&do=profile&mobile=2"})
    end
    return true
   elseif 用户名页 then
    进子页面("yonghu",{url})
    return true
   elseif 空间页 then
    local uid=url:match('mod=space&uid=(%d+)')
    if uid then
      进子页面("yonghu",{"https://bbs.binmt.cc/home.php?mod=space&uid="..uid.."&do=profile&mobile=2"})
    end
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
    if 显示刷新按钮() then
      悬浮按钮.setVisibility(this.uiManager.viewPager.GONE)
    end
    bottom.setVisibility(this.uiManager.viewPager.VISIBLE)
    return true
   elseif message=="关闭了回复" then
    bottom.setVisibility(this.uiManager.viewPager.GONE)
    if 显示刷新按钮() then
      悬浮按钮.setVisibility(this.uiManager.viewPager.VISIBLE)
     else
      悬浮按钮.setVisibility(this.uiManager.viewPager.GONE)
    end
    return true
   elseif message:match'下一页：(.-)' then
    Load_next_page(message:match'下一页：(.+)')
    --新评论页并入 DOM 后，顺手更新本地缓存
    task(2500,function()
      抓取网页HTML(view,function(html)
        if html then
          pcall(写入帖子缓存,当前帖子标识(),
            tostring(view.getTitle() or ""),获取网址() or "",html)
        end
      end)
    end)
    return true
   elseif message=="__MLITE_REPLYVISIBLE__" then
    --网页检测到回复可见内容
    local tid=当前帖子标识()
    if 获取应用数据("回复可见自动回复")=="false" then
      return true
    end
    if 本地已提示tid==tid then
      if 本地自动回复tid==tid then
        print2("自动回复可能未成功\n请手动回复后查看隐藏内容")
      end
      return true
    end
    本地已提示tid=tid
    local 成功,错误=pcall(回复可见对话框,tid)
    if not 成功 then
      print("回复弹窗异常："..tostring(错误))
    end
    return true
   elseif message=="__MLITE_REPLY_SUBMITTED__" then
    --自动回复已提交
    return true
   elseif message=="__MLITE_REPLY_NOFORM__" then
    print2("未找到回复框\n可能是未登录或本帖不可回复")
    return true
   elseif message=="__MLITE_REPLY_FAILED__" then
    print2("自动回复失败，请手动回复")
    return true
   elseif message:match("^__MLITE_USER__|") then
    --网页里点了「@某人」：打开对应的用户页
    local 负载=message:match("^__MLITE_USER__|(.*)$") or ""
    local uid,名字=负载:match("^(%d*)|(.*)$")
    if uid and uid~="" then
      进子页面("yonghu",{"https://bbs.binmt.cc/home.php?mod=space&uid="..uid.."&do=profile&mobile=2"})
     elseif 名字 and 名字~="" then
      进子页面("yonghu",{"https://bbs.binmt.cc/home.php?mod=space&username="..名字.."&do=profile&mobile=2"})
    end
    return true
   elseif message=="__MLITE_PTR__" then
    --下拉刷新手势触发
    刷新网页()
    return true
   elseif message:sub(1,8)=="__MLITE_" then
    --其余增强模块内部消息直接吞掉，避免被当作文本弹出
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