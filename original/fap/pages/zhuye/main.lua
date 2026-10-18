require "import"
使用公共lua文件("libs")
import "gongyong"
if !判断是否有该权限("android.permission.WRITE_EXTERNAL_STORAGE") then
  进子页面("main")
  退出页面()
end
应用栏标题.setText("Mt论坛Lite").setVisibility(0)
应用栏子标题.setText("更好的浏览体验").setVisibility(0)
if 应用主题状态() then
  侧滑栏标题.setText("请点击刷新").setTextColor(主文本色)
  侧滑栏子标题.setText("登录后更精彩...").setTextColor(主文本色)
 else
  侧滑栏标题.setText("请点击刷新").setTextColor(窗体背景色)
  侧滑栏子标题.setText("登录后更精彩...").setTextColor(窗体背景色)
end
获取浏览器(0).getSettings().setUserAgentString(获取应用数据("手机UA"))
获取浏览器(1).getSettings().setUserAgentString(获取应用数据("手机UA"))
获取浏览器(2).getSettings().setUserAgentString(获取应用数据("手机UA"))
获取浏览器(3).getSettings().setUserAgentString(获取应用数据("手机UA"))
加载网页(1,"https://bbs.binmt.cc/forum.php?mod=guide&view=hot&mobile=2")
加载网页(2,"https://bbs.binmt.cc/forum.php?forumlist=1")
加载网页(3,"https://bbs.binmt.cc/forum.php?mod=guide&view=newthread&index=1")
加载网页(4,"https://bbs.binmt.cc/home.php?mod=space&do=profile&mycenter=1")
local lastBackPressTime = 0
local EXIT_PROMPT_INTERVAL = 3
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    if this.uiManager.drawerLayout and this.uiManager.drawerLayout.isDrawerOpen(3) then
      this.uiManager.drawerLayout.closeDrawer(3)
     else
      local now = os.time()
      if now - lastBackPressTime < EXIT_PROMPT_INTERVAL then
        退出程序()
       else
        lastBackPressTime = now
        print("再按一次返回键退出")
      end
    end
    return true
  end
end
--登录参数
function 使用登录参数登录()
  cookie=获取网页Cookie("https://bbs.binmt.cc/")
  if cookie then
    local cookie1,cookie2=cookie:match'cQWy_.+_comiis_homestyleid_u(.-)=.+%%2A(.-);'
    if cookie1 or cookie2 then
      import "com.bumptech.glide.Glide"
      local url="https://bbs.binmt.cc/source/plugin/comiis_app_homestyle/image/home_bg/"..cookie2
      Glide.with(activity).load(url).into(侧滑栏壁纸)
      local url="https://bbs.binmt.cc/uc_server/avatar.php?uid="..cookie1.."&size=middle&ts="..math.random(000,999)
      Glide.with(activity).load(url).into(侧滑栏头像)
      Http.get("https://bbs.binmt.cc/forum.php?mod=guide&view=hot&mobile=2",cookie,"utf-8",nil,function(code,content,cookie,header)
        if code==200 then
          local content=content:match('class="sidenv_edit">(.-)class="sidenv_li">')
          if content then
            local maintext,Lv,title,point=content:match('<p><span class=".-">(.-)</span><span class=".-">(.-)</span></p>.+<p class=".-"><span class=".-">(.-)</span><span class=".-">(.-)</span></p>')
            侧滑栏标题.text=maintext
            侧滑栏子标题.text=title.." "..Lv.." "..point
           else
            print2("登陆失效，请重新登录")
            存储应用数据("登录参数",nil)
          end
        end
      end)
      存储应用数据("登录参数",cookie)
     else
      print2("登陆失效，请重新登录")
      存储应用数据("登录参数",nil)
      local sj=os.date("%H")
      if(sj < "12") then
        侧滑栏标题.setText("早上好!请登录")
       elseif(sj >="12" && sj < "14") then
        侧滑栏标题.setText("中午好!请登录")
       elseif(sj >= "14" && sj < "18") then
        侧滑栏标题.setText("下午好!请登录")
       elseif(sj >= "18") then
        侧滑栏标题.setText("晚上好!请登录")
      end
    end
   else
    print2("登陆失效，请重新登录")
    存储应用数据("登录参数",nil)
    local sj=os.date("%H")
    if(sj < "12") then
      侧滑栏标题.setText("早上好!请登录")
     elseif(sj >="12" && sj < "14") then
      侧滑栏标题.setText("中午好!请登录")
     elseif(sj >= "14" && sj < "18") then
      侧滑栏标题.setText("下午好!请登录")
     elseif(sj >= "18") then
      侧滑栏标题.setText("晚上好!请登录")
    end
  end
end
if 获取应用数据("自动签到") == "true" and tonumber(os.date("%d")) ~= tonumber(获取应用数据("签到日期")) and 登录参数 then
  Http.get("https://bbs.binmt.cc/plugin.php?id=k_misign:sign&operation=qiandao&format=text&formhash="..获取应用数据("签到参数"),登录参数,"utf-8",nil,function(code,content,cookie,header)
    if code==200 then
      local content=content:match('%[CDATA%[(.-)%]%]')
      --print(content)
      if content == "今日已签" then
        存储应用数据("签到日期",os.date("%d"))
       elseif content == "已签到" then
        print2("自动签到成功")
        存储应用数据("签到日期",os.date("%d"))
       elseif content == "签到失败" then
        进子页面("qiandao",{1})
        print2("自动签到失败\n请手动点击签到或者重新登录")
       else
        进子页面("qiandao",{1})
        print2("自动签到失败\n请手动点击签到或者重新登录")
      end
    end
  end)
end
--[[if 登录参数 then
  使用登录参数登录()
 else
  local sj=os.date("%H")
  if(sj < "12") then
    侧滑栏标题.setText("早上好!请登录")
   elseif(sj >="12" && sj < "14") then
    侧滑栏标题.setText("中午好!请登录")
   elseif(sj >= "14" && sj < "18") then
    侧滑栏标题.setText("下午好!请登录")
   elseif(sj >= "18") then
    侧滑栏标题.setText("晚上好!请登录")
  end
end]]
侧滑栏标题.onClick=function()--点击事件
  if 登录参数 then
    if 侧滑栏标题.text=="请点击刷新" then
      使用登录参数登录()
     else
      跳转指示器页(3)
      开关侧滑栏(1)
      加载网页(4,"https://bbs.binmt.cc/plugin.php?id=nimba_rename&mobile=2")
    end
   else
    进子页面("denglu")
  end
end;
侧滑栏子标题.onClick=function()--点击事件
  if 登录参数 then
    跳转指示器页(3)
    开关侧滑栏(1)
    加载网页(4,"https://bbs.binmt.cc/home.php?mod=spacecp&ac=credit")
   else
    进子页面("denglu")
  end
end;
侧滑栏头像.onClick=function()
  if 登录参数 then
    --activity.startFusionActivity("Changetheavatar")
    --print2("更改后需重新登陆")
    头像列表={"手机页面修改头像","电脑页面修改头像"}
    头像对话框=AlertDialog.Builder(this)
    .setSingleChoiceItems(头像列表,-1,{onClick=function(v,p)
        if 头像列表[p+1]=="手机页面修改头像" then
          跳转指示器页(3)
          开关侧滑栏(1)
          加载网页(4,"https://bbs.binmt.cc/home.php?mod=space&do=profile&set=comiis&mycenter=1")
          头像对话框.dismiss()--关闭
         else
          进子页面("zhuye/touxiang")
        end
      end})
    .show()
   else
    使用登录参数登录()
  end
end;
侧滑栏壁纸.onClick=function()
  if 登录参数 then
    进子页面("zhuye/beijingtu")
    print2("更改后需重新登陆")
   else
    使用登录参数登录()
  end
end;
function onDrawerListItemClick(data, recyclerView, listIndex, itemIndex)
  local listData = data.get(listIndex);
  local itemData = listData.get(itemIndex);
  local itemTitle = itemData.getTitle();
  switch(itemTitle) do
   case "首页"
    跳转指示器页(0)
    开关侧滑栏(1)
   case "社区"
    跳转指示器页(1)
    开关侧滑栏(1)
   case "导读"
    跳转指示器页(2)
    开关侧滑栏(1)
   case "我的"
    跳转指示器页(3)
    开关侧滑栏(1)
   case "签到"
    进子页面("qiandao")
   case "排行"
    进子页面("zhuye/jinghua")
   case "标签"
    进子页面("sousuo")
    --圈子https://bbs.binmt.cc/group.php?mod=index&mobile=2
   case "推广"
    跳转指示器页(3)
    开关侧滑栏(1)
    加载网页(4,"https://bbs.binmt.cc/home.php?mod=spacecp&ac=promotion")
   case "设置"
    进子页面("shezhi",{itemTitle,1})
   case "小黑屋"
    进子页面("zhuye/xiaoheiwu")
   case "当前在线"
    进子页面("zhuye/zaixian")
  end
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
--搜索事件
function onSearchEvent(keyword)
  if keyword:match("^SS") then
    local keyword=keyword:match("^SS(.+)") or ""
    if keyword:match("^(https?://[%w-_%.%?%.:/%+=&]+)") then
      进子页面(获取应用数据("默认浏览页"),{keyword})
      return true
     elseif keyword:match("/storage/emulated/0/.+.html") or keyword:match("/storage/emulated/0/.+.mht") or keyword:match("/storage/emulated/0/.+.txt") or keyword:match("/storage/emulated/0/.+.json") or keyword:match("/storage/emulated/0/.+.mp4") or keyword:match("/storage/emulated/0/.+.mp3") or keyword:match("/storage/emulated/0/.+.jpg") or keyword:match("/storage/emulated/0/.+.jpeg") or keyword:match("/storage/emulated/0/.+.png") or keyword:match("/storage/emulated/0/.+.gif") then
      if File(keyword).exists() then
        进子页面(获取应用数据("默认浏览页"),{keyword,1})
       else
        print2("路径错误或文件不存在")
      end
      return true
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
SS+路径 = 打开本地文件
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
双击返回顶部=0
标题栏.onClick=function(v)--控件点击事件
  双击返回顶部=双击返回顶部+1
  if 双击返回顶部>1 then
    返回网页顶部()
    双击返回顶部=0
  end
end;
右上角按钮(0,1).onClick=function(v)
  function 弹出菜单(v)
    PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
    local popupMenu=PopupMenu(activity,v)
    local 主菜单=popupMenu.menu
    主菜单.add("登录账户")
    if 登录参数 then
      主菜单.add("登出账户")
    end
    主菜单.add("网页查找")
    --if 获取应用数据("网址收藏")~="{}" then
    主菜单.add("帖子收藏")
    --end
    if 获取应用数据("帖子历史")~="{}" then
      主菜单.add("帖子历史")
    end
    if 获取应用数据("浏览历史")~="{}" then
      主菜单.add("浏览历史")
    end
    主菜单.add("下载管理")
    if 获取应用数据("显示悬浮按钮")=="false" then
      主菜单.add("网页刷新")
    end
    --主菜单.add("浏览器打开")
    --主菜单.add("复制链接")
    主菜单.add("退出软件")
    popupMenu.onMenuItemClick=function(item)
      switch item.title
       case "登录账户"
        进子页面("denglu")
       case "登出账户"
        存储应用数据("登录参数",nil)
        清除网页Cookie("https://bbs.binmt.cc/")
        进子页面()
        退出页面()
       case "网页查找"
        网页查找对话框()
       case "帖子收藏"
        历史收藏列表("帖子收藏","帖子收藏")
       case "帖子历史"
        历史收藏列表("帖子历史","帖子历史")
       case "浏览历史"
        历史收藏列表("浏览历史","浏览历史")
       case "下载管理"
        对话框文件管理器("/sdcard/Download/Mt论坛Lite")
       case "网页刷新"
        刷新网页()
       case "浏览器打开"
        浏览器打开(获取网址())
       case "复制链接"
        复制文本(获取网址())
       case "退出软件"
        退出程序()
      end
    end
    popupMenu.show()
    popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
  end
  弹出菜单(v)
end;
--悬浮按钮事件
function onFloatingActionButtonClick(v)
  刷新网页()
end
--[[
local cjson=require("cjson")
local 历史记录数量=cjson.decode(获取应用数据("历史记录"))
local 网址收藏数量=cjson.decode(获取应用数据("网址收藏"))
if #历史记录数量 > 500 then

end
]]
function messagePrompt(view)
  view.evaluateJavascript([[document.querySelector('.myinfo_tip.bg_del.f_f').textContent;
    ]],function(t)
    if t ~= "" and t ~= nil and t ~= "null" and t ~= '""' then
      if 浏览页指示器标题(3).text ~= "我的" then return end
      local text = ("("..((t:gsub('"',"")):gsub(" ",""))..")")
      if text ~= "" and 浏览页指示器标题(3) then
        local 我的文字 = SpannableStringBuilder(浏览页指示器标题(3).getText())
        local start = 我的文字.length()
        我的文字.append(text)
        local ends = 我的文字.length()
        我的文字.setSpan(ForegroundColorSpan(0xffff0000), start, ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        我的文字.setSpan(SuperscriptSpan(), start, ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        我的文字.setSpan(RelativeSizeSpan(0.9), start, ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        浏览页指示器标题(3).setText(我的文字)
        --print2("您有"..tostring((t:gsub('"',"")):gsub(" ","")).."条新的消息！")
      end
     else
      浏览页指示器标题(3).setText("我的")
    end
    --print(t)
  end)
end
页面历史清除1,页面历史清除2,页面历史清除3,页面历史清除4=0,0,0,0
指示器点击事件(
function(v, pageIndex)--点击事件
  pcall(function()-- 安全跳转到指定页面
    跳转指示器页(pageIndex)
  end)
end,
function(v, pageIndex)--长按事件
  if pageIndex == 0 then
    加载网页(pageIndex+1,"https://bbs.binmt.cc/forum.php?mod=guide&view=hot&mobile=2")
    页面历史清除1=页面历史清除1+1
   elseif pageIndex == 1 then
    加载网页(pageIndex+1,"https://bbs.binmt.cc/forum.php?forumlist=1")
    页面历史清除2=页面历史清除2+1
   elseif pageIndex == 2 then
    加载网页(pageIndex+1,"https://bbs.binmt.cc/forum.php?mod=guide&view=newthread&index=1")
    页面历史清除3=页面历史清除3+1
   elseif pageIndex == 3 then
    加载网页(pageIndex+1,"https://bbs.binmt.cc/home.php?mod=space&do=profile&mycenter=1")
    页面历史清除4=页面历史清除4+1
  end
  return true
end)
页面事件处理(1,
function(superCall,view,url,favicon)--页面开始加载事件
end,
function(superCall,view,url)--页面加载结束事件
  if 登录参数 then
    使用登录参数登录()
   else
    local sj=os.date("%H")
    if(sj < "12") then
      侧滑栏标题.setText("早上好!请登录")
     elseif(sj >="12" && sj < "14") then
      侧滑栏标题.setText("中午好!请登录")
     elseif(sj >= "14" && sj < "18") then
      侧滑栏标题.setText("下午好!请登录")
     elseif(sj >= "18") then
      侧滑栏标题.setText("晚上好!请登录")
    end
  end
  if 获取应用数据("网页背景色")=="true" then
    view.evaluateJavascript([[document.body.style.backgroundColor = "]]..窗体背景色2..[[";]],function end)
  end
  if 获取应用数据("显示FPS")=="true" then
    view.evaluateJavascript("Display_fps();",function end)
  end
  if 页面历史清除1>0 then
    页面历史清除1=0
    view.clearHistory()
  end
end,nil,
function(_,view,webResourceRequest)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local 登录跳转=url:match'bbs%.binmt%.cc/member%.php%?mod=logging&action=login'
  local 帖子=url:match'bbs%.binmt%.cc/thread%-.+%-.+%-.+%.html'
  local 板块=url:match'bbs%.binmt%.cc/forum%-.+%-.+%.html'
  local 签到=url:match'bbs%.binmt%.cc/k_misign%-sign%.html'
  local 签到2=url:match'bbs%.binmt%.cc/plugin%.php%?id=k_misign:sign&mobile=2'
  local 积分商城=url:match'bbs%.binmt%.cc/keke_integralmall%-keke_integralmall%.html'
  local 精华帖子=url:match'bbs%.binmt%.cc/page%-2%.html'
  local 社区=url:match'bbs%.binmt%.cc/forum%.php%?forumlist=1'
  local 热帖=url:match'bbs%.binmt%.cc/forum%.php%?mod=guide&view=hot&index=1'
  local 个人页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=profile$'
  local 用户页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile'
  if 登录跳转 then
    进子页面("denglu")
    return true
   elseif 帖子 then
    进子页面("tiezi",{url})
    return true
   elseif 签到 or 签到2 then
    进子页面("qiandao")
    return true
   elseif 板块 then
    进子页面("bankuai",{url})
    return true
   elseif 用户页 or 个人页 then
    进子页面("yonghu",{url})
    return true
   elseif 积分商城 then
    进子页面("zhuye/beijingtu",{1})
    return true
   elseif 精华帖子 then
    进子页面("zhuye/jinghua",{1})
    return true
   elseif 社区 then
    跳转指示器页(1)
    return true
   elseif 热帖 then
    跳转指示器页(2)
    加载网页(3,url)
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
end,nil,nil,nil,nil)
页面事件处理(2,
function(superCall,view,url,favicon)--页面开始加载事件
end,
function(superCall,view,url)--页面加载结束事件
  if 获取应用数据("网页背景色")=="true" then
    view.evaluateJavascript([[document.body.style.backgroundColor = "]]..窗体背景色2..[[";]],function end)
  end
  if 获取应用数据("显示FPS")=="true" then
    view.evaluateJavascript("Display_fps();",function end)
  end
  if 页面历史清除2>0 then
    页面历史清除2=0
    view.clearHistory()
  end
end,nil,
function(_,view,webResourceRequest)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local 签到=url:match'bbs%.binmt%.cc/k_misign%-sign%.html'
  local 签到2=url:match'bbs%.binmt%.cc/plugin%.php%?id=k_misign:sign&mobile=2'
  local 板块=url:match'bbs%.binmt%.cc/forum%-.+%-.+%.html'
  if 签到 or 签到2 then
    进子页面("qiandao")
    return true
   elseif 板块 then
    进子页面("bankuai",{url})
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
end,nil,nil,nil,nil)
页面事件处理(3,
function(superCall,view,url,favicon)--页面开始加载事件
end,
function(superCall,view,url)--页面加载结束事件
  if 获取应用数据("网页背景色")=="true" then
    view.evaluateJavascript([[document.body.style.backgroundColor = "]]..窗体背景色2..[[";]],function end)
  end
  if 获取应用数据("显示FPS")=="true" then
    view.evaluateJavascript("Display_fps();",function end)
  end
  if 页面历史清除3>0 then
    页面历史清除3=0
    view.clearHistory()
  end
end,nil,
function(_,view,webResourceRequest)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local 登录跳转=url:match'bbs%.binmt%.cc/member%.php%?mod=logging&action=login'
  local 帖子=url:match'bbs%.binmt%.cc/thread%-.+%-.+%-.+%.html'
  local 板块=url:match'bbs%.binmt%.cc/forum%-.+%-.+%.html'
  local 个人页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=profile$'
  local 用户页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile'
  if 登录跳转 then
    进子页面("denglu")
    return true
   elseif 帖子 then
    进子页面("tiezi",{url})
    return true
   elseif 板块 then
    进子页面("bankuai",{url})
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
end,nil,nil,nil,nil)
页面事件处理(4,
function(superCall,view,url,favicon)--页面开始加载事件
end,
function(superCall,view,url)--页面加载结束事件
  if 获取应用数据("网页背景色")=="true" then
    view.evaluateJavascript([[document.body.style.backgroundColor = "]]..窗体背景色2..[[";]],function end)
  end
  if 获取应用数据("显示FPS")=="true" then
    view.evaluateJavascript("Display_fps();",function end)
  end
  if url=="https://bbs.binmt.cc/home.php?mod=space&do=profile&mycenter=1" then
    messagePrompt(view)
  end
  if 页面历史清除4>0 then
    页面历史清除4=0
    view.clearHistory()
  end
end,nil,
function(_,view,webResourceRequest)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local 登录跳转=url:match'bbs%.binmt%.cc/member%.php%?mod=logging&action=login'
  local 帖子=url:match'bbs%.binmt%.cc/thread%-.+%-.+%-.+%.html'
  local 帖子2=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=.+'
  local 回复帖=url:match'bbs%.binmt%.cc/forum%.php%?mod=redirect&goto=findpost&pid=.+&ptid=.+'
  local 回复贴2=url:match'bbs%.binmt%.cc/forum%.php%?mod=redirect&goto=findpost&ptid=.+&pid=.+'
  local 积分记录=url:match'bbs%.binmt%.cc/forum%.php%?mod=redirect&goto=findpost&pid=%d+$'
  local 板块=url:match'bbs%.binmt%.cc/forum%-.+%-.+%.html'
  local 个人页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=profile$'
  local 用户页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile'
  local 等级=url:match'bbs%.binmt%.cc/home%.php%?mod=spacecp&ac=usergroup'
  local 勋章=url:match'bbs%.binmt%.cc/home%.php%?mod=medal&action=log'
  local 消息=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=pm&subop=view&touid=.+'
  local 打招呼=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=friend&.+mobile=2'
  local 打招呼2=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=notice&view=interactive&mobile=2'
  local 系统提醒=url:match'bbs%.binmt%.cc/space%-uid%-%d+%.html'
  local 忽略打招呼=url:match'bbs%.binmt%.cc/home%.php%?mod=spacecp&ac=poke&op=ignore&uid=%d+&from=notice'

  if 登录跳转 then
    进子页面("denglu")
    跳转指示器页(0)
    return true
   elseif 帖子 then
    进子页面("tiezi",{url})
    return true
   elseif 打招呼 or 打招呼2 then
    if 网页是否可前进后退数(-2) then
      网页前进后退数(-2)
     else
      网页后退()
    end
    task(300,function()
      刷新网页()
    end)
    return true
   elseif 板块 then
    进子页面("bankuai",{url})
    return true
   elseif 用户页 or 个人页 or 等级 or 消息 or 勋章 then
    进子页面("yonghu",{url})
    return true
   elseif 积分记录 or 系统提醒 or 忽略打招呼 then
    --懒得判断
    return true
   elseif 回复帖 then
    帖子位置,帖子id=url:match'bbs%.binmt%.cc/forum%.php%?mod=redirect&goto=findpost&pid=(.+)&ptid=(.+)'
    进子页面("tiezi",{"https://bbs.binmt.cc/forum.php?mod=viewthread&tid="..帖子id.."&page=2&mobile=2#pid"..帖子位置})
    return true
   elseif 回复贴2 then
    帖子id,帖子位置=url:match'bbs%.binmt%.cc/forum%.php%?mod=redirect&goto=findpost&ptid=(.+)&pid=(.+)'
    进子页面("tiezi",{"https://bbs.binmt.cc/forum.php?mod=viewthread&tid="..帖子id.."&page=2&mobile=2#pid"..帖子位置})
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
end,nil,nil,nil,nil)
单页文件上传影视解决(4,
nil,nil,nil,nil,nil,nil,nil,
function(superCall,view,progress)
  --页面加载进度
  view.parent.getChildAt(2).progress=progress
end,nil,nil,nil,nil)
单页监听禁长按(1,
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
单页监听禁长按(2,
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
单页监听禁长按(3,
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
单页监听禁长按(4,
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