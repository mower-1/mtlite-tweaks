import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
bindClass=luajava.bindClass
Intent = bindClass("android.content.Intent")
Uri = bindClass("android.net.Uri")
AlertDialog = bindClass("android.app.AlertDialog")
ProgressDialog = bindClass("android.app.ProgressDialog")
import "com.google.android.material.textfield.TextInputEditText"
import "com.google.android.material.textfield.TextInputLayout"
import "androidx.recyclerview.widget.*"
import "android.content.res.ColorStateList"
Spannable = bindClass("android.text.Spannable")
SpannableStringBuilder = bindClass("android.text.SpannableStringBuilder")
LinkMovementMethod = bindClass("android.text.method.LinkMovementMethod")
ForegroundColorSpan = bindClass("android.text.style.ForegroundColorSpan")
URLSpan = bindClass("android.text.style.URLSpan")
ClickableSpan = bindClass("android.text.style.ClickableSpan")
StyleSpan = bindClass("android.text.style.StyleSpan")
TextUtils = bindClass("android.text.TextUtils")
RelativeSizeSpan = bindClass "android.text.style.RelativeSizeSpan"
SubscriptSpan = bindClass("android.text.style.SubscriptSpan")
SuperscriptSpan = bindClass "android.text.style.SuperscriptSpan"
主色,强调色,主文本色,副文本色,窗体背景色=获取主题配色()--返回整数颜色值
主色2,强调色2,主文本色2,副文本色2,窗体背景色2=获取主题配色(1)--返回十六进制#
if !获取应用数据("http抓包请求") then
  存储应用数据("http抓包请求","false")
end
if 获取应用数据("http抓包请求")=="true" then
  忽略http请求证书错误(1)
end
if !获取应用数据("跨域请求") then
  存储应用数据("跨域请求","false")
end
function print(内容)--底部
  自定义弹出(内容,nil,1,"15sp",强调色2,"13dp","18dp",fill,wrap,"50dp","0dp",主色2,nil,nil,330,nil)
end
function print2(内容)--中间
  自定义弹出(内容,nil,1,"15sp",强调色2,"13dp","18dp",fill,wrap,"50dp","0dp",主色2,nil,"中间")
end
function 进子页面(页面,参数)
  进入子页面(页面,参数)
  if 获取应用数据("跳转动画")=="true" then
    activity.overridePendingTransition(android_R.anim.fade_in,android_R.anim.fade_out)
  end
end
function 退子页面()
  退出页面()
  if 获取应用数据("跳转动画")=="true" then
    activity.overridePendingTransition(android_R.anim.fade_in,android_R.anim.fade_out)
  end
end
FusionUtil = bindClass("net.fusionapp.core.util.FusionUtil")
function 切换主题(开关,主题名)
  FusionUtil.changeTheme(activity.getLoader().getProjectDir().getAbsolutePath(), 主题名..".json")
  FusionUtil.setNightMode(开关)
  进子页面(nil,nil)
  退出页面()
end
function 设置页切换主题(开关,主题名)
  FusionUtil.changeTheme(activity.getLoader().getProjectDir().getAbsolutePath(), 主题名..".json")
  FusionUtil.setNightMode(开关)
  进子页面("shezhi",{"设置"})
  退出页面()
end
if !获取应用数据("显示FPS") then
  存储应用数据("显示FPS","false")
end
if !获取应用数据("URL超链接") then
  存储应用数据("URL超链接","true")
end
默认快捷菜单表 = {
  {text="加粗"},{text="斜体"},{text="下划线"},{text="删除线"},{text="文本背景色"},
  {text="颜色文字"},{text="彩色文字"},{text="字号文字"},{text="大小文字"},{text="混合文字"},
  {text="对齐文本"},{text="列表"},{text="表格"},{text="代码文本"},{text="引用文本"},{text="隐藏文本"},
  {text="URL 超链接"},{text="Email 超链接"},{text="网络图片"},
  {text="网络视频"},{text="水平线"},{text="联系QQ"}
}
if !获取应用数据("快捷菜单") then--Menulist
  --local data={{text="加粗"},{text="斜体"},{text="下划线"},{text="删除线"},{text="字号文字"},{text="颜色文字"},{text="彩色文字"},{text="URL 超链接"},{text="Email 超链接"},{text="网络图片"},{text="水平线"},{text="对齐文本"},{text="代码文本"},{text="引用文本"},{text="隐藏文本"},{text="网络视频"},{text="表格"},{text="列表"},{text="联系QQ"}}
  local cjson=require("cjson")
  local json=cjson.encode(默认快捷菜单表)
  存储应用数据("快捷菜单",json)
end
if !获取应用数据("帖子历史") then
  local data={}
  local cjson=require("cjson")
  local json=cjson.encode(data)
  存储应用数据("帖子收藏",json)
  存储应用数据("帖子历史",json)
  存储应用数据("浏览历史",json)
end
if !获取应用数据("自动上下页") then
  存储应用数据("自动上下页","false")
end
if !获取应用数据("自动签到") then
  存储应用数据("自动签到","false")
end
if !获取应用数据("下一页重调用") then
  存储应用数据("下一页重调用","false")
end
if !获取应用数据("跳转动画") then
  存储应用数据("跳转动画","false")
end
if !获取应用数据("下载方式") then
  存储应用数据("下载方式","true")
end
if !获取应用数据("主题模式") then
  存储应用数据("主题模式",1)
end
if !获取应用数据("圆角对话框") then
  if Build.VERSION.SDK_INT<34 then
    存储应用数据("圆角对话框","false")
    if 系统主题状态() then
      跟随主题名="ThemePuan"
     else
      跟随主题名="ThemePuliang"
    end
    切换主题(系统主题状态(),跟随主题名)
   else
    存储应用数据("圆角对话框","true")
  end
end
if !获取应用数据("网页背景色") then
  存储应用数据("网页背景色","true")
end
if !获取应用数据("拦截网址") then
  存储应用数据("拦截网址","example.com")
end
if !获取应用数据("手机UA") then
  存储应用数据("手机UA","Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36")
end
if !获取应用数据("电脑UA") then
  存储应用数据("电脑UA","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36")
end
if !获取应用数据("默认浏览页") then
  存储应用数据("默认浏览页","liulanye")
end
if !获取应用数据("隐藏应用栏") then
  存储应用数据("隐藏应用栏","false")
end
if !获取应用数据("显示悬浮按钮") then
  存储应用数据("显示悬浮按钮","true")
end
if 获取应用数据("圆角对话框")=="true" then
  if 应用主题状态() then
    activity.setTheme(android.R.style.Theme_DeviceDefault);
    --activity.setTheme(android.R.style.Theme_Holo);
   else
    activity.setTheme(android.R.style.Theme_DeviceDefault_Light);
    --activity.setTheme(android.R.style.Theme_Holo_Light);
  end
 else
  if 应用主题状态() then
    activity.setTheme(R.style.Theme_AppCompat);
    --activity.setTheme(R.style.Theme_MaterialComponents);
   else
    activity.setTheme(R.style.Theme_AppCompat_Light);
    --activity.setTheme(R.style.Theme_MaterialComponents_Light);
  end
end
if 获取应用数据("主题模式")==1 then
  if 应用主题状态()~=系统主题状态() then
    if 获取应用数据("圆角对话框")=="true" then
      if 系统主题状态() then
        跟随主题名="ThemeDark"
       else
        跟随主题名="ThemeBright"
      end
     else
      if 系统主题状态() then
        跟随主题名="ThemePuan"
       else
        跟随主题名="ThemePuliang"
      end
    end
    切换主题(系统主题状态(),跟随主题名)
  end
end
if !获取应用数据("登录参数") then
  登录参数=nil
 else
  登录参数=获取应用数据("登录参数")
end
if 悬浮按钮 then
  if 获取应用数据("显示悬浮按钮")=="true" then
    显隐悬浮按钮(1)
    悬浮按钮.layoutParams.behavior=nil
  end
end
if 侧滑栏标题 then
  设置控件圆角(获取侧滑栏(), {0, 100, 100, 0}, 窗体背景色)
end
function 隐藏控件对话框(控件名,funa)
  if 获取应用数据(控件名.."1") then
    funa()
   else
    隐藏控件=AlertDialog.Builder(activity)
    .setTitle("即将"..控件名)
    .setMessage("隐藏后点击任意音量键两次即可恢复。")
    .setPositiveButton("确定",{onClick=function(v)
        funa()
        存储应用数据(控件名.."1",1)
      end})
    .setNegativeButton("取消",nil)
    .show()
    隐藏控件.findViewById(android.R.id.message).setTextIsSelectable(true)
  end
end
function 跳转应用对话框(应用名,url,funa)
  跳转文本 = SpannableStringBuilder("网页请求打开"..应用名.."，请注意您的帐号和财产安全。\n\n链接：")
  local start = 跳转文本.length()
  跳转文本.append(url)
  local ends = 跳转文本.length()
  跳转文本.setSpan(URLSpan(url),start,ends,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
  跳转对话框=AlertDialog.Builder(this)--普通对话框
  .setTitle("网页请求打开")
  .setMessage(跳转文本)
  .setPositiveButton("打开",{onClick=funa})
  .setNegativeButton("取消",nil)
  .show()
  跳转对话框.findViewById(android.R.id.message).setTextIsSelectable(true)
  跳转对话框.findViewById(android.R.id.message).setMovementMethod(LinkMovementMethod.getInstance())
end
function 离开本站对话框(url)
  离开文本 = SpannableStringBuilder("您即将离开Mt论坛，请注意您的帐号和财产安全。\n\n链接：")
  local start = 离开文本.length()
  离开文本.append(url)
  local ends = 离开文本.length()
  离开文本.setSpan(URLSpan(url),start,ends,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
  离开对话框=AlertDialog.Builder(this)--普通对话框
  .setTitle("即将离开本站")
  .setMessage(离开文本)
  .setPositiveButton("继续访问",{onClick=function(v)
      进子页面(获取应用数据("默认浏览页"),{url})
    end})
  .setNegativeButton("取消",nil)
  .setNeutralButton("复制链接",{onClick=function(v)
      复制文本(url)
    end})
  .show()
  离开对话框.findViewById(android.R.id.message).setTextIsSelectable(true)
  离开对话框.findViewById(android.R.id.message).setMovementMethod(LinkMovementMethod.getInstance())
end
function 通用编辑框功能(bt,bt0,bt1,bt2,bt3,funa,funb,func)
  if funa==nil then
    funa=function() dialog.dismiss() end
  end
  if funb==nil then
    funb=function() dialog.dismiss() end
  end
  if func==nil then
    func=function() dialog.dismiss() end
  end
  view_table={
    LinearLayout,
    layout_width="match",
    layout_height="match",
    orientation=1,
    {
      TextInputLayout,
      id="input_layout",
      layout_height="wrap",
      layout_marginLeft="20dp",
      layout_marginRight="20dp",
      layout_width="match",
      --hint="请输入需要编解码/加解密的内容",--设置输入框提示文本
      {
        TextInputEditText,
        id="edit_text",
        text=bt0,
        layout_height="wrap",
        layout_width="match",
      },
    },
  }
  dialog=AlertDialog.Builder(activity)
  .setTitle(bt)
  .setView(loadlayout(view_table))
  .setPositiveButton(bt1,nil)
  .setNegativeButton(bt2,nil)
  .setNeutralButton(bt3,nil)
  .show()
  dialog.getButton(AlertDialog.BUTTON1).onClick=funa
  dialog.getButton(AlertDialog.BUTTON2).onClick=funb
  dialog.getButton(AlertDialog.BUTTON3).onClick=func
end
function 网页查找对话框()
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
      hint="请关键词进行查找...",--设置输入框提示文本
      {
        TextInputEditText,
        id="edit_text",
        singleLine=true;--设置单行输入，禁止换行
        layout_height="wrap",
        layout_width="match",
      },
    },
  }
  local 网页查找=AlertDialog.Builder(activity)
  .setTitle("网页查找")
  .setView(loadlayout(view_table))
  .setPositiveButton("下一个",nil)
  .setNegativeButton("取消",nil)
  .setOnDismissListener(function()
    页内查找("")
  end)
  .show()
  网页查找.getButton(AlertDialog.BUTTON1).onClick=function()
    页内查找(edit_text.text)
  end
  local window =网页查找.getWindow()
  local lp =window.getAttributes()
  lp.alpha = 0.9
  local lp = window.getAttributes();
  lp.dimAmount=0.0
  window.setAttributes(lp);
end
function 添加收藏对话框(内容1,内容2)
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
      hint="标题",--设置输入框提示文本
      {
        TextInputEditText,
        id="edit_text",
        text=内容1,
        singleLine=true;--设置单行输入，禁止换行
        layout_height="wrap",
        layout_width="match",
      },
    },
    {
      TextInputLayout,
      id="input_layout2",
      layout_marginLeft="20dp",
      layout_marginRight="20dp",
      layout_height="wrap",
      layout_width="match",
      hint="网址",--设置输入框提示文本
      {
        TextInputEditText,
        id="edit_text2",
        text=内容2,
        singleLine=true;--设置单行输入，禁止换行
        layout_height="wrap",
        layout_width="match",
      },
    },
  }
  local 添加收藏=AlertDialog.Builder(activity)
  .setTitle("添加收藏")
  .setView(loadlayout(view_table))
  .setPositiveButton("确定",{onClick=function()
      if edit_text.text~="" and edit_text2.text~="" then
        local cjson=require("cjson")
        local data=cjson.decode(获取应用数据("帖子收藏"))
        table.insert(data,1,{PageName=activity.getLoader().getPageName(),Title=edit_text.text,Text=edit_text2.text})
        local json=cjson.encode(data)
        存储应用数据("帖子收藏",json)
        print("添加成功")
       else
        print("参数nil,添加失败")
      end
    end})
  .setNegativeButton("取消",nil)
  .show()
end
function table.unique(t,bArray,mainKey)
  local check = {}
  local n = {}
  local idx = 1
  for k, v in pairs(t) do
    local judgeKey = v
    if mainKey then
      judgeKey = v[mainKey] or v
    end
    if not check[judgeKey] then
      if bArray then
        n[idx] = v
        idx = idx + 1
       else
        n[k] = v
      end
      check[judgeKey] = true
    end
  end
  return n
end
import "java.io.File"--导入File类
function 历史收藏列表(标题,存储名)
  local view_table=
  {
    LinearLayout,
    layout_width="match",
    layout_height="match",
    orientation=1,
    {
      RecyclerView,
      id="recycler_view",
      layout_width="match",
      layout_height="wrap",
      paddingLeft='15dp';--布局内左距
      paddingRight='15dp';--布局内右距
      paddingTop='10dp';--布局内顶距
    },
  }
  local cjson=require("cjson")
  local data=cjson.decode(获取应用数据(存储名))
  dialog=AlertDialog.Builder(activity)
  .setTitle(标题.."("..tostring(#data)..")")
  .setView(loadlayout(view_table))
  .setPositiveButton("确定",nil)
  .setNegativeButton("清空",{onClick=function()
      local data={}
      local cjson=require("cjson")
      local json=cjson.encode(data)
      存储应用数据(存储名,json)
      print("清除成功")
    end})
  .setNeutralButton("导入/导出",nil)
  .show()
  dialog.getButton(AlertDialog.BUTTON3).onClick=function(v)
    function 导入导出菜单(v)
      PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
      local popupMenu=PopupMenu(activity,v)
      local 主菜单=popupMenu.menu
      主菜单.add("说明")
      主菜单.add("导入")
      主菜单.add("导出")
      popupMenu.onMenuItemClick=function(item)
        switch item.title
         case "说明"
          路径="/sdcard/Download/Mt论坛Lite/"..标题..".txt"
          命名=AlertDialog.Builder(this)--普通对话框
          .setTitle("导入/导出说明")
          .setMessage([[①由于不太会写文件方面的事件，所以这里采取的是固定路径文件导出导入
②为防止不必要的报错，导出文件做了加密处理，导入只能导入导出的加密文件。

]]..标题..[[文件导出导入路径：
]]..路径)
          .setPositiveButton("知道了",nil)
          .setOnDismissListener(function()
            存储应用数据("导入导出",1)
          end)
          .show()
          命名.findViewById(android.R.id.message).setTextIsSelectable(true)--文字可复制
         case "导入"
          if 获取应用数据("导入导出") then
            路径="/sdcard/Download/Mt论坛Lite/"..标题..".txt"
            if File(路径).exists() then
              存储应用数据(存储名,ChaCha20解密("mtforumlite",读取文本(路径)))
              print"导入成功"
              dialog.hide()
             else
              print("请将文件放置于 Download/Mt论坛Lite 文件夹内，并重命名为"..标题..".txt")
            end
           else
            print"请先查看说明"
          end
         case "导出"
          if 获取应用数据("导入导出") then
            路径="/sdcard/Download/Mt论坛Lite/"..标题..".txt"
            写入文本(路径,ChaCha20加密("mtforumlite",获取应用数据(存储名)))
            print("导出位置：/sdcard/Download/Mt论坛Lite/"..标题..".txt")
           else
            print"请先查看说明"
          end
        end
      end
      -- 显示弹出菜单
      popupMenu.show()
      -- 配置背景颜色(只适合只有主菜单)
      popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
    end
    导入导出菜单(v)
  end
  local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
  local list_item={
    LinearLayout,
    layout_width="match",
    layout_height="wrap",
    {
      MaterialCardView,
      id="card",
      layout_width="match",
      layout_height="wrap",
      cardElevation="0dp",--卡片阴影强度
      radius="0dp",--卡片圆角幅度
      {
        LinearLayout,
        layout_width="match",
        layout_height="wrap",
        padding="10dp",
        Orientation=1,
        backgroundColor=窗体背景色,
        {
          TextView,
          id="Title",
          textSize="14sp",
          textStyle="bold",
          textColor=主文本色,
        },
        {
          TextView,
          id="Text",
          ellipsize="end",
          singleLine=true;--设置单行输入
          textColor=副文本色,
          textSize="10sp",
          layout_marginTop="2dp",
        },
      },
    },
  }
  recycler_view.layoutManager=LinearLayoutManager(activity)
  local data=table.unique(data,true,"Text")
  存储应用数据(存储名,cjson.encode(data))
  local adapter=LuaRecyclerAdapter(activity,data,list_item)
  adapter.clickViewId="card"
  adapter.onItemClick=function(adapter,itemView,view,pos)
    --简单获取到当前item的Data表
    local itemData = adapter.Data[pos+1]
    if itemData.Text:find("^file://") then
      进子页面(itemData.PageName,{itemData.Text,1})
     else
      进子页面(itemData.PageName,{itemData.Text})
    end
  end
  adapter.onItemLongClick=function(adapter,itemView,view,pos)
    local itemData = adapter.Data[pos+1]
    function 弹出菜单(v)
      PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
      local popupMenu=PopupMenu(activity,v)
      local 主菜单=popupMenu.menu
      主菜单.setOptionalIconsVisible(true)--无多主菜单需e设置显示图标
      主菜单.add("复制标题").setIcon(R.drawable.abc_ic_menu_copy_mtrl_am_alpha).setIconTintList(ColorStateList.valueOf(强调色))
      主菜单.add("复制链接").setIcon(R.drawable.abc_ic_menu_copy_mtrl_am_alpha).setIconTintList(ColorStateList.valueOf(强调色))
      if 存储名~="帖子收藏" and (itemData.Text):find("bbs.binmt.cc") then
        主菜单.add("添加收藏").setIcon(R.drawable.ic_save_white_24).setIconTintList(ColorStateList.valueOf(强调色))
      end
      主菜单.add("删除记录").setIcon(R.drawable.ic_delete_24dp).setIconTintList(ColorStateList.valueOf(强调色))
      popupMenu.onMenuItemClick=function(item)
        switch item.title
         case "添加收藏"
          local cjson=require("cjson")
          local data=cjson.decode(获取应用数据("帖子收藏"))
          table.insert(data,1,{PageName=(itemData.PageName),Title=(itemData.Title),Text=(itemData.Text)})
          local json=cjson.encode(data)
          存储应用数据("帖子收藏",json)
          print("添加成功")
         case "复制标题"
          复制文本(itemData.Title)
          print("已复制到剪贴板")
         case "复制链接"
          复制文本(itemData.Text)
          print("已复制到剪贴板")
         case "删除记录"
          recycler_view.getAdapter().remove(pos)
          local cjson=require("cjson")
          local data=cjson.decode(获取应用数据(存储名))
          table.remove(data,pos+1)
          local json=cjson.encode(data)
          存储应用数据(存储名,json)
        end
      end
      popupMenu.show()
      popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
    end
    弹出菜单(view)
    return true
  end
  recycler_view.adapter=adapter
end

function 编辑快捷菜单对话框()
  import "com.google.android.flexbox.*"
  import "androidx.recyclerview.widget.*"
  import "com.google.android.material.chip.Chip"
  local view_table=
  {
    LinearLayout,
    layout_width="match",
    layout_height="match",
    orientation=1,
    {
      RecyclerView,
      id="recycler_view",
      layout_width="match",
      layout_height="wrap",
      padding="10dp"
    }
  }
  local cjson=require("cjson")
  local data=cjson.decode(获取应用数据("快捷菜单"))
  --设置列表布局
  local list_item={
    LinearLayout,
    layout_width="wrap",
    layout_height="wrap",
    {
      Chip;
      layout_width="wrap";
      layout_height="wrap";
      layout_marginLeft='3dp';--布局左距
      layout_marginRight='3dp';--布局右距
      id="text",
      TextSize="15";
      TextColor=colorTextPrimary;
    };
  }
  local dialog=AlertDialog.Builder(activity)
  .setTitle("快捷菜单编辑排序")
  .setView(loadlayout(view_table))
  .setPositiveButton("保存",{onClick=function(v)
      local cjson=require("cjson")
      local json=cjson.encode(recycler_view.getAdapter().Data)
      存储应用数据("快捷菜单",json)
      print("保存成功")
    end})
  .setNegativeButton("取消",{onClick=function(v)
      local cjson=require("cjson")
      local json=cjson.encode(recycler_view.getAdapter().Data)
      local texts = {}
      local texts2 = {}
      for text in json:gmatch('"text":"([^"]+)"') do
        table.insert(texts, text)
      end
      for text in 获取应用数据("快捷菜单"):gmatch('"text":"([^"]+)"') do
        table.insert(texts2, text)
      end
      -- 按顺序一起打印所有文本
      local allTexts = table.concat(texts, ", ")
      local allTexts2 = table.concat(texts2, ", ")
      if allTexts~=allTexts2 then
        local dialog=AlertDialog.Builder(activity)
        .setTitle("温馨提示")
        .setMessage("列表发生改变，是否需要保存？")
        .setPositiveButton("是",{onClick=function(v)
            存储应用数据("快捷菜单",json)
            print("保存成功")
          end})
        .setNegativeButton("否",nil)
        .show()
      end
    end})
  .setNeutralButton("添加快捷项",nil)
  .setOnCancelListener(function()
    local cjson=require("cjson")
    local json=cjson.encode(recycler_view.getAdapter().Data)
    local texts = {}
    local texts2 = {}
    for text in json:gmatch('"text":"([^"]+)"') do
      table.insert(texts, text)
    end
    for text in 获取应用数据("快捷菜单"):gmatch('"text":"([^"]+)"') do
      table.insert(texts2, text)
    end
    -- 按顺序一起打印所有文本
    local allTexts = table.concat(texts, ", ")
    local allTexts2 = table.concat(texts2, ", ")
    if allTexts~=allTexts2 then
      local dialog=AlertDialog.Builder(activity)
      .setTitle("温馨提示")
      .setMessage("列表发生改变，是否需要保存？")
      .setPositiveButton("是",{onClick=function(v)
          存储应用数据("快捷菜单",json)
          print("保存成功")
        end})
      .setNegativeButton("否",nil)
      .show()
    end
  end)--监听对话框取消
  .show()
  local flexboxLayoutManager = ExetendFlexboxLayoutManager(this);
  --主轴为水平方向，起点在左端
  flexboxLayoutManager.setFlexDirection(FlexDirection.ROW);
  --按正常方向换行
  flexboxLayoutManager.setFlexWrap(FlexWrap.WRAP);
  --定义项目在副轴轴上如何对齐
  flexboxLayoutManager.setAlignItems(AlignItems.CENTER);
  --多个轴对齐方式
  flexboxLayoutManager.setJustifyContent(JustifyContent.FLEX_START);
  --设置最大显示行
  --flexboxLayoutManager.setMaxLine(2)
  recycler_view.setLayoutManager(flexboxLayoutManager);
  local adapt=LuaRecyclerAdapter(activity,data,list_item)
  adapt.clickViewId="text"
  adapt.onItemClick=function(
    adapter,--适配器对象
    itemView,--项目布局对象
    view,--点击的控件对象
    pos--点击的位置索引
    )
    ColorStateList = bindClass("android.content.res.ColorStateList")
    PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
    local popupMenu=PopupMenu(activity,view)
    local 主菜单=popupMenu.menu
    主菜单.setOptionalIconsVisible(true)--无多主菜单需e设置显示图标
    if pos~=0 then
      主菜单.add("左移").setIcon(R.drawable.material_ic_keyboard_arrow_left_black_24dp).setIconTintList(ColorStateList.valueOf(强调色))
    end
    if adapter.getItemCount()-1 ~= pos then
      主菜单.add("右移").setIcon(R.drawable.abc_ic_go_search_api_material).setIconTintList(ColorStateList.valueOf(强调色))
    end
    if adapter.Data[pos+1].Content then
      主菜单.add("删除").setIcon(R.drawable.ic_delete_24dp).setIconTintList(ColorStateList.valueOf(强调色))
    end
    -- 处理菜单项点击事件
    popupMenu.onMenuItemClick=function(item)
      switch item.title
       case "左移"
        local itemData = adapter.Data[pos+1]
        adapter.remove(pos)
        adapter.insert(pos-1,itemData)
        adapter.notifyDataSetChanged()
       case "右移"
        local itemData = adapter.Data[pos+1]
        adapter.remove(pos)
        adapter.insert(pos+1,itemData)
        adapter.notifyDataSetChanged()
       case "删除"
        adapter.remove(pos)
      end
    end
    -- 显示弹出菜单
    popupMenu.show()
    popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
  end
  recycler_view.adapter=adapt
  dialog.getButton(AlertDialog.BUTTON3).onClick=function()
    local TextInputLayout = luajava.bindClass "com.google.android.material.textfield.TextInputLayout"
    local TextInputEditText = luajava.bindClass "com.google.android.material.textfield.TextInputEditText"
    local view_table=
    {LinearLayout,
      layout_width="match",
      layout_height="match",
      orientation=1,
      {TextInputLayout,
        id="input_layout",
        layout_height="wrap",
        layout_marginLeft="20dp",
        layout_marginRight="20dp",
        --suffixText="后缀文本",
        --error="错误提示",
        counterEnabled="true",
        counterMaxLength="6",
        layout_width="match",
        hint="请输入标题",--设置输入框提示文本
        {TextInputEditText,
          id="edit_text",
          singleLine=true;--设置单行输入，禁止换行
          layout_height="wrap",
          layout_width="match",
        },
      },
      {TextInputLayout,
        id="input_layout2",
        layout_height="wrap",
        layout_marginLeft="20dp",
        layout_marginRight="20dp",
        --suffixText="后缀文本",
        --error="错误提示",
        layout_width="match",
        hint="请输入内容",--设置输入框提示文本
        {TextInputEditText,
          id="edit_text2",
          layout_height="wrap",
          layout_width="match",
        },
      },
    }
    local dialog=AlertDialog.Builder(activity)
    .setTitle("添加快捷项")
    .setView(loadlayout(view_table))
    .setPositiveButton("确定",nil)
    .setNegativeButton("取消",nil)
    .setNeutralButton("功能说明",nil)
    .show()
    task(100,function()
      local Context = luajava.bindClass "android.content.Context"
      import "android.view.inputmethod.InputMethodManager"
      edit_text.getContext().getSystemService(Context.INPUT_METHOD_SERVICE).toggleSoftInput(0,InputMethodManager.HIDE_NOT_ALWAYS)
      edit_text.requestFocus()
    end)
    dialog.getButton(AlertDialog.BUTTON1).onClick=function()
      local txt=edit_text.text
      local txt2=edit_text2.text
      if txt=="" then
        input_layout.setError("不可为空")
       elseif txt2=="" then
        input_layout2.setError("不可为空")
       else
        local data=adapt.Data
        table.insert(data,1,{text=txt,Content=txt2})
        adapt.notifyDataSetChanged()
        dialog.hide()
      end
    end
    dialog.getButton(AlertDialog.BUTTON3).onClick=function()
      local dialog=AlertDialog.Builder(activity)
      .setTitle("添加说明")
      .setMessage("该功能可添加一个快捷回复按钮。\n该功能要求标题不可超过六个字，长按可删除(默认功能不可删除)。")
      .setPositiveButton("确定",nil)
      .show()
    end
    edit_text.addTextChangedListener{
      onTextChanged=function()
        --事件
        if edit_text.text=="" then
          input_layout.setError("不可为空")
         elseif input_layout.getEditText().getText().length() > input_layout.getCounterMaxLength() then
          input_layout.setError("不得超过六位")
         else
          input_layout.setError(null)
        end
      end}
    edit_text2.addTextChangedListener{
      onTextChanged=function()
        if edit_text2.text=="" then
          input_layout2.setError("不可为空")
         else
          input_layout2.setError(null)
        end
      end}
  end
end