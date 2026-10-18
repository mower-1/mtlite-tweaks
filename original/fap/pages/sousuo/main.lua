require "import"
使用公共lua文件("libs")
import "gongyong"
应用栏标题.setText("搜索：").setVisibility(0)
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
function 引擎搜索设置()
  local view_table={
    LinearLayout,
    layout_width="match",
    layout_height="match",
    orientation=1,
    {
      TextInputLayout,
      id="input_layout",
      layout_marginLeft="20dp",
      layout_marginRight="20dp",
      layout_height="wrap",
      layout_width="match",
      hint="请输入搜索引擎，搜索内容使用%s代替",--设置输入框提示文本
      {
        TextInputEditText,
        id="edit_text",
        text=获取应用数据("搜索引擎") or "",
        singleLine=true;--设置单行输入，禁止换行
        layout_height="wrap",
        layout_width="match",
      },
    },
  }
  local 搜索引擎=AlertDialog.Builder(activity)
  .setTitle("自定义搜索引擎")
  .setView(loadlayout(view_table))
  --.setCancelable(false)--禁止使用返回按键
  .setPositiveButton("保存",nil)
  .setNegativeButton("取消",nil)
  .setNeutralButton("示例",nil)
  .setOnDismissListener(function()
    if not 获取应用数据("搜索引擎") then
      引擎搜索设置()
      print2"首次使用，请先设置搜索引擎"
    end
  end)
  .show()
  搜索引擎.getButton(AlertDialog.BUTTON1).onClick=function()--不会关闭对话框按钮
    input_layout.setError(nil)
    if edit_text.text~="" then
      --print(edit_text.text)
      if edit_text.text:find("%%s") and edit_text.text:match("^(https?://[%w-_%.%?%.:/%+=&]+)") then
        存储应用数据("搜索引擎",edit_text.text)
        搜索引擎.hide()
        加载网页(nil,string.format(获取应用数据("搜索引擎"),搜索栏.text.." site:bbs.binmt.cc"))
       else
        input_layout.setError("链接不全或无%s，请检查链接！")
      end
     else
      input_layout.setError("不可为空！")
    end
  end
  搜索引擎.getButton(AlertDialog.BUTTON3).onClick=function()--不会关闭对话框按钮
    搜索示例=AlertDialog.Builder(this)--普通对话框
    .setTitle("搜索引擎示例")
    .setMessage([[谷歌：https://www.google.com/search?q=%s
必应：https://bing.com/search?q=%s
DuckDuckGo：https://duckduckgo.com/&q=%s
360：https://m.so.com/s?q=%s]])
    .setPositiveButton("知道了",nil)
    .show()
    搜索示例.findViewById(android.R.id.message).setTextIsSelectable(true)
  end
end
传递数据,判断数据=...
if 传递数据 then
  搜索栏.setText(传递数据)
  if 判断数据 then
    应用栏标题.setText("搜索："..传递数据)
    if 获取应用数据("搜索引擎") then
      加载网页(nil,string.format(获取应用数据("搜索引擎"),传递数据.." site:bbs.binmt.cc"))
     else
      引擎搜索设置()
      print2"首次使用，请先设置搜索引擎"
    end
   else
    if 传递数据:match("^https?://bbs%.binmt%.cc/misc%.php%?") then
      应用栏标题.setText("标签 - MT论坛")
      加载网页(nil,传递数据)
     else
      应用栏标题.setText("搜索："..传递数据)
      加载网页(nil,"https://bbs.binmt.cc/search.php?mod=forum&srchtxt="..传递数据.."&searchsubmit=yes")
    end
  end
 else
  应用栏标题.setText("标签 - MT论坛")
  加载网页(nil,"https://bbs.binmt.cc/misc.php?mod=tag&mobile=2")
end
清除历史=0
function onSearchEvent(keyword)
  清除历史=清除历史+1
  应用栏标题.setText("搜索："..keyword)
  if 判断数据 then
    加载网页(nil,string.format(获取应用数据("搜索引擎"),keyword.." site:bbs.binmt.cc"))
   else
    加载网页(nil,"https://bbs.binmt.cc/search.php?mod=forum&srchtxt="..keyword.."&searchsubmit=yes")
  end
end
搜索栏.setHint("请输入关键词进行搜索...")
左上角按钮().onClick=function(v)
  退子页面()
end;
右上角按钮(0,1).onClick=function(v)
  function 弹出菜单(v,样式)
    PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
    local popupMenu=PopupMenu(activity,v)
    local 主菜单=popupMenu.menu
    if 判断数据 then
      主菜单.add("切换Mt搜索")
      主菜单.add("编辑搜索引擎")
     else
      主菜单.add("切换引擎搜索")
      主菜单.add("搜索用户")
    end
    主菜单.add("网页查找")
    if 获取应用数据("显示悬浮按钮")=="false" then
      主菜单.add("网页刷新")
    end
    主菜单.add("浏览器打开")
    主菜单.add("复制链接")
    主菜单.add("退出页面")
    popupMenu.onMenuItemClick=function(item)
      switch item.title
       case "搜索用户"
        if 搜索栏.Text=="" then
          print2("请在搜索框中输入后使用")
         else
          加载网页(nil,"https://bbs.binmt.cc/home.php?mod=spacecp&ac=search&username="..搜索栏.Text.."&searchsubmit=yes&mobile=2")
        end
       case "切换引擎搜索"
        退出页面()
        进子页面("sousuo",{搜索栏.Text,"S"})
       case "切换Mt搜索"
        退出页面()
        进子页面("sousuo",{搜索栏.Text})
       case "编辑搜索引擎"
        引擎搜索设置()
       case "网页查找"
        网页查找对话框()
       case "网页刷新"
        刷新网页()
       case "浏览器打开"
        浏览器打开(获取网址())
       case "复制链接"
        复制文本(获取网址())
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

function 判断域名(url)
  -- 移除协议头和路径部分
  local domain = string.match(url, "://([^/]+)")
  if domain then
    -- 移除端口号（如果存在）
    domain = string.match(domain, "([^:]+)")
    -- 移除www前缀（可选）
    domain = string.gsub(domain, "^www%.", "")
    return domain
  end
  return nil
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
  if 清除历史>=1 then
    清除历史=0
    清除浏览历史()
  end
end,nil,
function(_,view,webResourceRequest)
  --Url即将跳转事件(即将加载事件)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local MT论坛=url:match'^https://bbs.binmt.cc/'
  local 帖子=url:match'bbs%.binmt%.cc/thread%-.+%-.+%-.+%.html'
  local 帖子2=url:match'bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=%d+$'
  local 板块=url:match'bbs%.binmt%.cc/forum%-.+%-.+%.html'
  local 个人页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=profile$'
  local 用户页=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=.+&do=profile'
  local 登录跳转=url:match'bbs%.binmt%.cc/member%.php%?mod=logging&action=login'
  local 打招呼=url:match'bbs%.binmt%.cc/home%.php%?mod=spacecp&ac=poke&op=send&uid=.+'
  local 消息=url:match'bbs%.binmt%.cc/home%.php%?mod=space&do=pm&subop=view&touid=.+'
  if 登录跳转 then
    进子页面("denglu")
    print2"请登录后再搜索"
    return true
   elseif 帖子 then
    进子页面("tiezi",{url})
    return true
   elseif 帖子2 then
    帖子2id=url:match('bbs%.binmt%.cc/forum%.php%?mod=viewthread&tid=(%d+)$')
    进子页面("tiezi",{"https://bbs.binmt.cc/thread-"..帖子2id.."-1-1.html"})
    return true
   elseif 用户页 or 个人页 or 消息 or 打招呼 then
    进子页面("yonghu",{url})
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
   elseif not MT论坛 and 判断域名(url)~=判断域名(获取应用数据("搜索引擎")) then
    离开本站对话框(url)
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