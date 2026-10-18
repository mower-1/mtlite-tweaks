local bindClass = luajava.bindClass
local uiManager = activity.uiManager

function 打印应用信息(packageName)
  local packageManager = activity.getPackageManager()
  local applicationInfo = packageManager.getApplicationInfo(packageName, 0)
  local 软件名 = packageManager.getApplicationLabel(applicationInfo)
  local packageInfo = packageManager.getPackageInfo(packageName, 0)
  local 版本名 = packageInfo.versionName
  local 版本号 = packageInfo.versionCode
  return 软件名,版本名,版本号
end

function 获取包名()
  return tostring(activity.getPackageName())
end

function 判断是否有该权限(权限)
  local PackageManager = bindClass("android.content.pm.PackageManager")
  return activity.checkSelfPermission(权限) == PackageManager.PERMISSION_GRANTED
end

function 申请权限(权限, 请求码)
  local ActivityCompat = bindClass("androidx.core.app.ActivityCompat")
  ActivityCompat.requestPermissions(activity, 权限, 请求码)
end

function 使用公共lua文件(路径)
  local projectDir = activity.loader.projectDir.path
  local includePath = 路径 and ("/"..路径.."/?.lua") or "/?.lua"
  package.path = package.path..";"..projectDir..includePath
end

function 状态栏颜色(color)
  if Build.VERSION.SDK_INT >= 21 then
    local window = activity.getWindow()
    window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
    window.setStatusBarColor(color)
  end
end

function 退出页面()
  activity.finish()
end

function 退出程序()
  if activity.getLoader().getPageName()=="main" then
    os.exit()
   else
    activity.finishAffinity()
  end
end

function 进入子页面(页面, 参数)
  local targetPage = 页面 or activity.getLoader().getPageName()
  if 参数 then
    activity.newActivity(targetPage, 参数)
   else
    activity.startFusionActivity(targetPage)
  end
end

local color = bindClass("android.graphics.Color")
function 转换颜色值(c)
  if type(c) == "number" then return c & 0xFFFFFFFF end
  if type(c) == "string" then
    local n = tonumber(c)
    if n then return n & 0xFFFFFFFF end
    local suc,r = pcall(color.parseColor,c)
    if suc and r then return r & 0xFFFFFFFF end
  end
  return 0xFF000000
end

--获取主题配置
local themeConfig=uiManager.themeConfig
function 应用主题状态()
  return themeConfig.isNightMode()
end
local Context = bindClass("android.content.Context")
local UiModeManager = bindClass("android.app.UiModeManager")
local Configuration = bindClass("android.content.res.Configuration")
function 系统主题状态()
  local uiModeManager = activity.getSystemService(Context.UI_MODE_SERVICE)
  local currentNightMode = uiModeManager.getNightMode()
  if currentNightMode == UiModeManager.MODE_NIGHT_YES then
    return true
   else
    return false
  end
end

local viewConfig=uiManager.viewConfig
function 获取主题配色(i)
  local colors = uiManager.Colors
  if i then
    return
    colors.colorPrimary,
    colors.colorAccent,
    colors.textColorPrimary,
    colors.textColorSecondary,
    colors.windowBackground
   else
    return
    转换颜色值(colors.colorPrimary),
    转换颜色值(colors.colorAccent),
    转换颜色值(colors.textColorPrimary),
    转换颜色值(colors.textColorSecondary),
    转换颜色值(colors.windowBackground)
  end
end

local GradientDrawable = bindClass("android.graphics.drawable.GradientDrawable")
function 设置控件圆角(id, 圆角, 颜色)
  local drawable = GradientDrawable()
  drawable.setShape(drawable.RECTANGLE)
  drawable.setColor(颜色 or 0xFFFFFFFF)
  if type(圆角) == "number" then
    drawable.setCornerRadius(圆角)
   elseif type(圆角) == "table" then
    local radii = {
      圆角[1] or 0, 圆角[1] or 0, -- 左上
      圆角[2] or 0, 圆角[2] or 0, -- 右上
      圆角[3] or 0, 圆角[3] or 0, -- 右下
      圆角[4] or 0, 圆角[4] or 0 -- 左下
    }
    drawable.setCornerRadii(radii)
  end
  id.setBackground(drawable)
end

local OnClickListener = bindClass("net.fusionapp.core.ui.indicator.IndicatorController$OnClickListener")
local BasePagerAdapter = bindClass("net.fusionapp.core.ui.adapter.BasePagerAdapter")
local viewPager = uiManager.viewPager -- 获取页视图组件
local indicator = uiManager.indicatorController -- 获取指示器组件
function 设置布局(布局)
  local viewList = ArrayList()
  viewList.add(loadlayout(布局))
  viewPager.setAdapter(BasePagerAdapter(viewList))
end

function 跳转指示器页(页数)
  viewPager.setCurrentItem(页数)
end

function 指示器点击事件(点击按钮事件,长按按钮事件)
  indicator.setOnClickListener(OnClickListener{
    onClick=点击按钮事件,
    onLongClick=长按按钮事件
  })
end

function 屏幕旋转(添加值)
  activity.setRequestedOrientation(添加值);
end

android_R = bindClass("android.R")
if activity.packageName=="net.fusionapp" then
  R = bindClass("net.fusionapp.R")
 else
  R = bindClass("net.fusionapp.core.R")
end
function 跳转动画(动画类型)
  local 动画列表 = {
    {R.anim.abc_grow_fade_in_from_bottom, R.anim.abc_shrink_fade_out_from_bottom},--1:从中间往上移动缩放
    {R.anim.abc_slide_in_bottom, R.anim.abc_slide_out_bottom},--2:从下面移动上来
    {R.anim.abc_slide_in_top, R.anim.abc_slide_out_top},--3:从上往下移动
    {R.anim.design_snackbar_in, R.anim.design_snackbar_out},--4:瞬间替换布局
    {R.anim.fragment_open_enter, R.anim.fragment_close_exit},--5:缩放进入
    {R.anim.fragment_close_enter, R.anim.fragment_close_exit},--6:缩放退出
    {R.anim.fragment_fade_enter, R.anim.fragment_fade_exit},--7:阴影淡入
    {R.anim.slide_right_in, R.anim.slide_right_out} -- 8: 从右进入
  }
  local 进入动画, 退出动画
  if 动画类型 and 动画列表[动画类型] then
    进入动画, 退出动画 = 动画列表[动画类型][1], 动画列表[动画类型][2]
   else
    -- 默认动画 (瞬间替换布局)
    进入动画, 退出动画 = android_R.anim.fade_in,android_R.anim.fade_out
  end
  activity.overridePendingTransition(进入动画, 退出动画)
end

function 清除数据()
  local am = activity.getSystemService("activity")
  am.clearApplicationUserData()
end

local 主色,强调色,主文本色,副文本色,窗体背景色=获取主题配色()
local 主色2,强调色2,主文本色2,副文本色2,窗体背景色2=获取主题配色(1)
local MaterialCardView = bindClass("com.google.android.material.card.MaterialCardView")
local MaterialButton = bindClass("com.google.android.material.button.MaterialButton")
local RecyclerView = bindClass("androidx.recyclerview.widget.RecyclerView")
local LinearLayoutManager = bindClass("androidx.recyclerview.widget.LinearLayoutManager")
local File = bindClass("java.io.File")
local Formatter = bindClass("android.text.format.Formatter")
local AlertDialog = bindClass("android.app.AlertDialog")
function 清理缓存(CacheData,清理选项)
  -- 创建布局
  if 清理选项 then
    layout = {
      ScrollView,
      layout_width = "match",
      {
        LinearLayout,
        layout_width = "match",
        padding = "12dp",
        orientation = "vertical",
        {
          MaterialCardView,
          layout_width = "match",
          layout_margin = "12dp",
          radius = "8dp",
          elevation = "4",
          cardBackgroundColor = 主色,
          {
            RecyclerView,
            layout_width = "match",
            nestedScrollingEnabled = false,
            overScrollMode = 2,
            id = "recycler",
          },
        },
        {
          LinearLayout,
          layout_width = "match",
          orientation = "vertical",
          gravity = "right",
          {
            -- 原有的清理按钮
            MaterialButton,
            layout_width = "wrap_content",
            layout_marginRight = "12dp",
            backgroundColor = 强调色,
            textColor = 0xffffffff,
            cornerRadius = "8dp",
            text = "确定清理 (0 B)",
            id = "clear_bt",
          },
          {
            -- 新添加的刷新按钮
            MaterialButton,
            layout_width = "wrap_content",
            layout_marginRight = "12dp",
            backgroundColor = "#FFFF5252", -- 蓝色背景
            textColor = 0xffffffff,
            cornerRadius = "8dp",
            text = "清除数据",
            id = "refresh_bt", -- 新按钮的ID
          },
        },
      },
    }
   else
    layout = {
      ScrollView,
      layout_width = "match",
      {
        LinearLayout,
        layout_width = "match",
        padding = "12dp",
        orientation = "vertical",
        {
          MaterialCardView,
          layout_width = "match",
          layout_margin = "12dp",
          radius = "8dp",
          elevation = "4",
          cardBackgroundColor = 主色,
          {
            RecyclerView,
            layout_width = "match",
            nestedScrollingEnabled = false,
            overScrollMode = 2,
            id = "recycler",
          },
        },
        {
          MaterialButton,
          layout_gravity = "right",
          
          layout_marginRight = "12dp",
          backgroundColor = 强调色,
          textColor = 0xffffffff,
          cornerRadius = "8dp",
          text = "确定清理 (0 B)",
          id = "clear_bt",
        },
      },
    }
  end

  设置布局(layout)
  -- 列表项布局
  list_layout = {
    MaterialCardView,
    layout_height = "wrap",
    layout_width = "match",
    elevation = 0,
    radius = 0,
    cardBackgroundColor = 主色,
    id = "card",
    {
      CheckBox,
      layout_margin = "13dp",
      layout_marginLeft = "15dp",
      layout_marginRight = "23dp",
      paddingLeft = "7dp",
      textSize = "17sp",
      textColor = 主文本色,
      id = "check",
    },
  }
  -- 设置适配器
  recycler.layoutManager = LinearLayoutManager(activity)
  list_adapter = LuaRecyclerAdapter(activity, list_layout).setClickViewId("card")
  recycler.setAdapter(list_adapter)

  -- 计算目录大小（优化递归）
  function GetDirSize(dir)
    local size = 0
    local dirFile = File(dir)
    if dirFile.exists() and dirFile.isDirectory() then
      local files = dirFile.listFiles()
      if files then
        for _, child in ipairs(luajava.astable(files)) do
          if child.isDirectory() then
            size = size + GetDirSize(child.toString())
           else
            size = size + child.length()
          end
        end
      end
    end
    return size
  end

  -- 更新缓存列表
  function UpdateCacheList()
    list_adapter.clear()
    for _, value in ipairs(CacheData) do
      local size = GetDirSize(value.dir)
      list_adapter.add{check = value.text.." ("..Formatter.formatFileSize(activity, size)..")"}
    end
  end
  UpdateCacheList()

  -- 删除目录（优化递归）
  function DeleteDir(dir)
    local dirFile = File(dir)
    if dirFile.exists() then
      if dirFile.isDirectory() then
        local children = dirFile.listFiles()
        if children then
          for _, child in ipairs(luajava.astable(children)) do
            DeleteDir(child.toString())
          end
        end
      end
      dirFile.delete()
    end
  end

  -- 列表项点击事件
  list_adapter.onItemClick = function(adapter, itemView, view, pos)
    local check = view.getChildAt(0)
    check.setChecked(not check.checked)
  end

  -- 延迟设置复选框监听器
  task(100, function()
    for i = 0, list_adapter.itemCount - 1 do
      local child = recycler.getChildAt(i)
      if child then
        local check = child.getChildAt(0)
        check.setOnCheckedChangeListener {
          onCheckedChanged = function(view, checked)
            local totalSize = 0
            for j = 0, list_adapter.itemCount - 1 do
              local childItem = recycler.getChildAt(j)
              if childItem then
                local cb = childItem.getChildAt(0)
                if cb.checked then
                  totalSize = totalSize + GetDirSize(CacheData[j+1].dir)
                end
              end
            end
            clear_bt.setText("确定清理 ("..Formatter.formatFileSize(activity, totalSize)..")")
          end
        }
      end
    end
  end)

  if 清理选项 then
    refresh_bt.onClick = function()
      AlertDialog.Builder(this)--普通对话框
      --.setCancelable(false)--禁止使用返回按键
      .setTitle("是否清除应用全部数据？")
      .setPositiveButton("否",nil)
      .setNegativeButton("是",{onClick=function(v)
        清除数据()
      end})
      .show()
    end
  end

  -- 清理按钮点击事件
  clear_bt.onClick = function()
    local deleted = false
    local totalCleaned = 0

    for i = 0, list_adapter.itemCount - 1 do
      local child = recycler.getChildAt(i)
      if child then
        local check = child.getChildAt(0)
        if check.checked then
          local size = GetDirSize(CacheData[i+1].dir)
          DeleteDir(CacheData[i+1].dir)
          check.setChecked(false)
          totalCleaned = totalCleaned + size
          deleted = true
        end
      end
    end

    if deleted then
      UpdateCacheList()
      clear_bt.setText("确定清理 (0 B)")
      print("已清理 "..Formatter.formatFileSize(activity, totalCleaned))
     else
      print("请选择要清理的项目")
    end
  end
end

local SwitchMaterial = bindClass("com.google.android.material.switchmaterial.SwitchMaterial")
function 简易设置功能布局(设置列表,callback,callback2)
  --布局定义
  local layout = {
    LinearLayout,
    layout_width = "match",
    layout_height = "match",
    orientation = 1,
    {
      ListView,
      id = "listView",
      DividerHeight = 0,
      layout_width = "fill",
      layout_height = "fill",
    }
  }
  --设置项原位置
  --设置项布局模板
  local settingTemplates = {
    { -- 标题样式
      LinearLayout,
      Focusable = true,
      layout_width = "fill",
      layout_height = "wrap",
      {
        TextView,
        id = "title",
        textStyle = "bold",
        textSize = "14dp",
        textColor = 强调色,
        layout_marginTop = "16dp",
        layout_marginLeft = "16dp",
      },
    },
    { -- 简单设置项样式
      LinearLayout,
      layout_width = "fill",
      layout_height = "56dp",
      gravity = "center_vertical",
      {
        TextView,
        id = "subtitle",
        textSize = "16dp",
        textColor = 主文本色,
        layout_marginLeft = "16dp",
      },
    },
    { -- 带描述的设置项样式
      LinearLayout,
      layout_width = "fill",
      layout_height = "56dp",
      orientation = "vertical",
      gravity = "center_vertical",
      {
        TextView,
        id = "subtitle",
        textSize = "16dp",
        textColor = 主文本色,
        layout_marginLeft = "16dp",
      },
      {
        TextView,
        id = "message",
        textSize = "13dp",
        layout_marginLeft = "16dp",
        textColor = 副文本色,
      },
    },
    { -- 带开关的设置项样式
      LinearLayout,
      gravity = "center",
      layout_width = "fill",
      layout_height = "56dp",
      {
        LinearLayout,
        orientation = "vertical",
        layout_height = "fill",
        gravity = "center_vertical",
        layout_weight = "1",
        {
          TextView,
          layout_marginLeft = "16dp",
          textSize = "16dp",
          textColor = 主文本色,
          id = "subtitle",
        },
      },
      {
        SwitchMaterial,
        clickable = false,
        Focusable = false,
        layout_marginRight = "16dp",
        id = "status",
      },
    },
    { -- 带开关的设置项样式
      LinearLayout,
      gravity = "center",
      layout_width = "fill",
      layout_height = "56dp",
      {
        LinearLayout,
        orientation = "vertical",
        layout_height = "fill",
        gravity = "center_vertical",
        layout_weight = "1",
        {
          TextView,
          layout_marginLeft = "16dp",
          textSize = "16dp",
          textColor = 主文本色,
          id = "subtitle",
        },
        {
          TextView,
          id = "message",
          textSize = "13dp",
          layout_marginLeft = "16dp",
          textColor = 副文本色,
        },
      },
      {
        SwitchMaterial,
        clickable = false,
        Focusable = false,
        layout_marginRight = "16dp",
        id = "status",
      },
    },
    { -- 分割线
      LinearLayout,
      layout_width = "fill",
      layout_height = "0dp",
      gravity = "center_vertical",
      {
        View,
        layout_width = "fill",
        layout_height = "1.2dp",
        layout_marginTop = "0dp", 
        layout_marginBottom = "0dp",
        backgroundColor = "#bdbdbd",
      },
    },
  }
  local adapter = LuaMultiAdapter(this, 设置列表, settingTemplates)
  设置布局(layout)
  listView.setAdapter(adapter)
  listView.setOnItemClickListener(AdapterView.OnItemClickListener {
    onItemClick = function(parent, view, position, id)
      local item = 设置列表[position + 1]
      local title = view.Tag.subtitle and view.Tag.subtitle.Text or ""
      if view.Tag.status ~= nil then
        local checked = not view.Tag.status.Checked
        item.status.Checked = checked
        存储应用数据(title, tostring(checked))
      end
      callback(title,item)
      adapter.notifyDataSetChanged()
    end})
  listView.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
    onItemLongClick=function(parent, view, position, id)
      local item = 设置列表[position + 1]
      local title = view.Tag.subtitle and view.Tag.subtitle.Text or ""
      callback2(title,item)
      adapter.notifyDataSetChanged()
      return true
    end})
end

function 屏幕全屏()
  local Build = bindClass("android.os.Build")
  local View = bindClass("android.view.View")
  local WindowManager = bindClass("android.view.WindowManager")
  local window = activity.getWindow()
  window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
  local decorView = window.getDecorView()
  local uiFlags = View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
  if Build.VERSION.SDK_INT >= 28 then
    decorView.setSystemUiVisibility(uiFlags | View.SYSTEM_UI_FLAG_LAYOUT_STABLE)
    local lp = window.getAttributes()
    lp.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
    window.setAttributes(lp)
   else
    decorView.setSystemUiVisibility(uiFlags)
    local success, result = pcall(function()
      local lp = window.getAttributes()
      if lp.layoutInDisplayCutoutMode ~= nil then
        lp.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
        window.setAttributes(lp)
      end
    end)
  end
end

function 存储应用数据(key,value)
  activity.setSharedData(key,value)
  return true
end

function 获取应用数据(key)
  local data = activity.getSharedData(key)
  return data
end

应用栏 = uiManager.appBarLayout
function 显隐应用栏(i)
  if i then
    应用栏.setVisibility(0)
   else
    应用栏.setVisibility(8)
  end
end
标题栏 = uiManager.toolbar
function 显隐标题栏(i)
  if i then
    标题栏.getChildAt(0).setVisibility(0)
   else
    标题栏.getChildAt(0).setVisibility(8)
  end
end
标题栏 = uiManager.toolbar
应用栏标题 = 标题栏.TitleView
应用栏子标题 = 标题栏.SubtitleView
搜索栏 = uiManager.searchEditText
function 左上角按钮()
  return 标题栏.getChildAt(0).getChildAt(0).getChildAt(0)
end
function 右上角按钮(i,i2)
  if i==nil or i==1 then
    return 标题栏.getChildAt(0).getChildAt(0).getChildAt(2).getChildAt(i2)
   elseif i==2 then
    return 标题栏.getChildAt(0).getChildAt(2).getChildAt(i2)
   else
    return 标题栏.getChildAt(0).getChildAt(0).getChildAt(2).getChildAt(i2)
  end
end

local indicatorView=uiManager.indicatorView
local pagerAdapter=uiManager.pagerAdapter
function 浏览页指示器标题(i)
  return indicatorView.Navigator.TitleContainer.getChildAt(i)
end

侧滑栏 = uiManager.drawerLayout
侧滑栏壁纸 = uiManager.drawerWallpaper
侧滑栏头像 = uiManager.drawerHeaderAvatarImageView
侧滑栏标题 = uiManager.drawerHeaderMainTextView
侧滑栏子标题 = uiManager.drawerHeaderSecondaryTextView
function 获取侧滑栏()
  return 侧滑栏.getChildAt(1)
end
function 开关侧滑栏(i)
  if i then
    侧滑栏.closeDrawer(3)--开
   else
    侧滑栏.openDrawer(3)--关
  end
end
悬浮按钮 = uiManager.FloatingActionButton
function 显隐悬浮按钮(i)
  if i then
    悬浮按钮.setVisibility(0)
   else
    悬浮按钮.setVisibility(8)
  end
end
if 悬浮按钮 then
  显隐悬浮按钮()
end

function 获取浏览页(n)
  if n then
    return uiManager.getPage(n)
  else
    return uiManager.currentPage
  end
end

function 获取浏览器(n)
  return 获取浏览页(n).webView
end

function 获取标题()
  return 获取浏览器().getTitle()
end

function 获取网址()
  local url = 获取浏览器().getUrl()
  return url or ""
end

function 浏览器打开(链接)
  if not 链接 or 链接 == "" then
    print("链接不可为空")
    return false
  end
  local Uri = bindClass("android.net.Uri")
  local Intent = bindClass("android.content.Intent")
  local PackageManager = bindClass("android.content.pm.PackageManager")
  local uri = Uri.parse(链接)
  local scheme = uri.getScheme()
  if scheme == "file" then
    print("不支持打开本地网页")
    return false
  end
  local intent = Intent("android.intent.action.VIEW", uri)
  local resolveInfo = activity.getPackageManager().queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
  if not resolveInfo or resolveInfo.size() == 0 then
    print("没有用于打开的应用")
    return false
  end
  activity.startActivity(Intent.createChooser(intent, "选择打开方式"))
  return true
end

function 复制文本(a)
  if(Context==nil)then
    import "android.content.Context"
  end
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(a)
end

local File = bindClass("java.io.File")
function 写入文本(path, str)
  File(path).parentFile.mkdirs()
  io.open(path, "w"):write(str):close()
end

function 读取文本(path)
  if File(path).isFile() then
    return (io.open(path):read("*a"))
  end
end

function 加载Js(str,callback)
  if not pcall(function()
      获取浏览器().evaluateJavascript(str,callback or function() end)
    end) then
    获取浏览器().loadUrl("javascript:"..str)
  end
end

function 加载网页(num,url)
  if num then
    num=num-1
  end
  获取浏览器(num).loadUrl(url)
end

function 去除加载进度条(num)
  if num then
    num=num-1
  end
  获取浏览器(num).parent.removeViewAt(2)
end

function 停止加载()
  获取浏览器().stopLoading()
end

function 刷新网页()
  获取浏览器().reload()
end

function 网页是否可前进()
  return 获取浏览器().canGoForward()
end

function 网页是否可后退()
  return 获取浏览器().canGoBack()
end

function 网页前进()
  获取浏览器().goForward()
end

function 网页后退()
  获取浏览器().goBack()
end

function 网页是否可前进后退数(num)
  return 获取浏览器().canGoBackOrForward(num)
end

function 网页前进后退数(num)
  获取浏览器().goBackOrForward(num)
end

function 返回网页顶部()
  获取浏览器().scrollTo(0,0)
end

function 页内查找(str)
  获取浏览器().findAll(str)
end

function 清除浏览历史()
  获取浏览器().clearHistory()
end

function 屏蔽网页复制文本()
  加载Js([[document.execCommand=function(){return true;};//覆写execCommand属性指向空函数]])
end

--FA1蓝奏云自动填密码源码
function 蓝奏云自动填写密码2(蓝奏云密码, 蓝奏云链接)
  if 蓝奏云链接 == nil or 蓝奏云链接 == "" or 蓝奏云链接 == true or 蓝奏云链接 == "true" or 蓝奏云链接 == "auto" or 蓝奏云链接 == "自动" or 蓝奏云链接 == "自动识别" then
    return 蓝奏云自动填写密码2(蓝奏云密码, "lanzou")
   elseif 蓝奏云链接 == false or 蓝奏云链接 == "false" or 蓝奏云链接 == "disable" or 蓝奏云链接 == "disabled" or 蓝奏云链接 == "全局" or 蓝奏云链接 == "禁用" or 蓝奏云链接 == "停用" then
    return 蓝奏云自动填写密码2(蓝奏云密码, ".")
   elseif 蓝奏云链接:find("://") then
    return 蓝奏云自动填写密码2(蓝奏云密码, 蓝奏云链接:match("://(.+)"))
   elseif 蓝奏云链接:find("%?") then
    return 蓝奏云自动填写密码2(蓝奏云密码, 蓝奏云链接:match("(.+)%?"))
   elseif 获取浏览器().getUrl():find(蓝奏云链接) then
    加载Js("var hsdbql='" .. 蓝奏云密码 .. "';var _0xodd='jsjiami.com.v6',_0x2e78=[_0xodd,'EsOGwpo=','wrQlwrnCiEg=','w4Rxwq/CicKjeS/DkyfDhREaw4wS','Oyod','lFfkuRLjTbpsjNHiHami.cofmV.vF6S=='];(function(_0x45658b,_0xa6ed42,_0x51c273){var _0x5a2c04=function(_0x12512e,_0x2e9f6a,_0x369b63,_0x3f254c,_0x54c60e){_0x2e9f6a=_0x2e9f6a>>0x8,_0x54c60e='po';var _0x4339f9='shift',_0x17dab4='push';if(_0x2e9f6a<_0x12512e){while(--_0x12512e){_0x3f254c=_0x45658b[_0x4339f9]();if(_0x2e9f6a===_0x12512e){_0x2e9f6a=_0x3f254c;_0x369b63=_0x45658b[_0x54c60e+'p']();}else if(_0x2e9f6a&&_0x369b63['replace'](/[lFfkuRLTbpNHHfVFS=]/g,'')===_0x2e9f6a){_0x45658b[_0x17dab4](_0x3f254c);}}_0x45658b[_0x17dab4](_0x45658b[_0x4339f9]());}return 0x73c54;};return _0x5a2c04(++_0xa6ed42,_0x51c273)>>_0xa6ed42^_0x51c273;}(_0x2e78,0x88,0x8800));var _0x4503=function(_0x3d0e16,_0x3f02a8){_0x3d0e16=~~'0x'['concat'](_0x3d0e16);var _0x24b5f7=_0x2e78[_0x3d0e16];if(_0x4503['IwCXEN']===undefined){(function(){var _0x28c38f=typeof window!=='undefined'?window:typeof process==='object'&&typeof require==='function'&&typeof global==='object'?global:this;var _0x7da736='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';_0x28c38f['atob']||(_0x28c38f['atob']=function(_0x45f3ee){var _0x5b438f=String(_0x45f3ee)['replace'](/=+$/,'');for(var _0x45beee=0x0,_0x52aa91,_0x1aa319,_0x1d9fd4=0x0,_0x5f2820='';_0x1aa319=_0x5b438f['charAt'](_0x1d9fd4++);~_0x1aa319&&(_0x52aa91=_0x45beee%0x4?_0x52aa91*0x40+_0x1aa319:_0x1aa319,_0x45beee++%0x4)?_0x5f2820+=String['fromCharCode'](0xff&_0x52aa91>>(-0x2*_0x45beee&0x6)):0x0){_0x1aa319=_0x7da736['indexOf'](_0x1aa319);}return _0x5f2820;});}());var _0x5a6c86=function(_0x48dfbd,_0x3f02a8){var _0xa7a50e=[],_0x866bea=0x0,_0x2a2513,_0x4b6040='',_0x405890='';_0x48dfbd=atob(_0x48dfbd);for(var _0x2698ea=0x0,_0x5c55a6=_0x48dfbd['length'];_0x2698ea<_0x5c55a6;_0x2698ea++){_0x405890+='%'+('00'+_0x48dfbd['charCodeAt'](_0x2698ea)['toString'](0x10))['slice'](-0x2);}_0x48dfbd=decodeURIComponent(_0x405890);for(var _0x3457e2=0x0;_0x3457e2<0x100;_0x3457e2++){_0xa7a50e[_0x3457e2]=_0x3457e2;}for(_0x3457e2=0x0;_0x3457e2<0x100;_0x3457e2++){_0x866bea=(_0x866bea+_0xa7a50e[_0x3457e2]+_0x3f02a8['charCodeAt'](_0x3457e2%_0x3f02a8['length']))%0x100;_0x2a2513=_0xa7a50e[_0x3457e2];_0xa7a50e[_0x3457e2]=_0xa7a50e[_0x866bea];_0xa7a50e[_0x866bea]=_0x2a2513;}_0x3457e2=0x0;_0x866bea=0x0;for(var _0x214c05=0x0;_0x214c05<_0x48dfbd['length'];_0x214c05++){_0x3457e2=(_0x3457e2+0x1)%0x100;_0x866bea=(_0x866bea+_0xa7a50e[_0x3457e2])%0x100;_0x2a2513=_0xa7a50e[_0x3457e2];_0xa7a50e[_0x3457e2]=_0xa7a50e[_0x866bea];_0xa7a50e[_0x866bea]=_0x2a2513;_0x4b6040+=String['fromCharCode'](_0x48dfbd['charCodeAt'](_0x214c05)^_0xa7a50e[(_0xa7a50e[_0x3457e2]+_0xa7a50e[_0x866bea])%0x100]);}return _0x4b6040;};_0x4503['vTDmMw']=_0x5a6c86;_0x4503['vrJzPV']={};_0x4503['IwCXEN']=!![];}var _0x2ffeac=_0x4503['vrJzPV'][_0x3d0e16];if(_0x2ffeac===undefined){if(_0x4503['kNVMBx']===undefined){_0x4503['kNVMBx']=!![];}_0x24b5f7=_0x4503['vTDmMw'](_0x24b5f7,_0x3f02a8);_0x4503['vrJzPV'][_0x3d0e16]=_0x24b5f7;}else{_0x24b5f7=_0x2ffeac;}return _0x24b5f7;};var v=document['getElementById'](_0x4503('0','nav@'))[_0x4503('1','g&Qi')]=hsdbql;document[_0x4503('2','uOKd')](_0x4503('3','s(%C'))['click']();;_0xodd='jsjiami.com.v6';")
    return true
   else
    return false
  end
end

local CookieSyncManager = bindClass("android.webkit.CookieSyncManager")
local CookieManager = bindClass("android.webkit.CookieManager")
function 获取网页Cookie(url)--获取
  local cookieManager = CookieManager.getInstance()
  return cookieManager.getCookie(url)
end
function 清除网页Cookie(url, cookieName)--删除
  local cookieManager = CookieManager.getInstance()
  if cookieManager == nil then
    print("错误：Cookie为空")
    return
  end
  if cookieName then
    cookieManager.setCookie(url, cookieName .. "=; Expires=Thu, 01 Jan 1970 00:00:00 GMT")
   else
    cookieManager.removeSessionCookie()
    cookieManager.removeAllCookie()
  end
end

local viewPager=uiManager.viewPager
local OnPageChangeListener = bindClass("androidx.viewpager.widget.ViewPager$OnPageChangeListener")
local WebViewMenuSupport = bindClass("net.fusionapp.core.ui.fragment.WebViewMenuSupport")
function 单页监听禁长按(num,funa,funb)
  if num then
    num=num-1
  end
  if funa==nil then
    funa=function(菜单)
      return 菜单
    end
  end
  if funb==nil then
    funb=function(title) end
  end
  获取浏览页(num).setMenuInterface(WebViewMenuSupport.Interface{
    onMenuItemCreate=funa,
    onMenuItemClick=funb,
  })
end

local WebInterface=bindClass("net.fusionapp.core.ui.fragment.WebInterface")
local URLDecoder = bindClass("java.net.URLDecoder")
local WebViewClient=bindClass("android.webkit.WebViewClient")--导入类
local Uri = bindClass("android.net.Uri")
local Intent = bindClass("android.content.Intent")
function 页面事件处理(num,页面开始加载事件,页面加载结束事件,连接错误事件,Url即将跳转事件,加载页面资源时,加载url制定的资源,加载SSL证书错误时,请求返回HTTP错误码时)
  if num then
    num=num-1
  end
  if 页面开始加载事件==nil then
    页面开始加载事件=function() end
  end
  if 页面加载结束事件==nil then
    页面加载结束事件=function() end
  end
  if 连接错误事件==nil then
    连接错误事件=function() end
  end
  if Url即将跳转事件==nil then
    Url即将跳转事件=function() end
  end
  if 加载页面资源时==nil then
    加载页面资源时=function() end
  end
  if 加载url制定的资源==nil then
    加载url制定的资源=function()
      return nil
    end
  end
  if 加载SSL证书错误时==nil then
    加载SSL证书错误时=function(superCall, view, sslErrorHandler, sslError)
      sslErrorHandler.proceed()
    end
  end
  if 请求返回HTTP错误码时==nil then
    请求返回HTTP错误码时=function() end
  end
  获取浏览器(num).setWebViewClient(luajava.override(WebViewClient,{
    onPageStarted=页面开始加载事件,
    onPageFinished=页面加载结束事件,
    onReceivedError=连接错误事件,
    shouldOverrideUrlLoading=Url即将跳转事件,
    onLoadResource=加载页面资源时,
    shouldInterceptRequest=加载url制定的资源,
    onReceivedSslError=加载SSL证书错误时,
    onReceivedHttpError=请求返回HTTP错误码时
  }))
end

local PackageManager = bindClass("android.content.pm.PackageManager")
local WindowManager = bindClass("android.view.WindowManager")
local WebChromeClient = bindClass("android.webkit.WebChromeClient")
local ActivityInfo = bindClass("android.content.pm.ActivityInfo")
local MimeTypeMap = bindClass("android.webkit.MimeTypeMap")
local FrameLayout = bindClass("android.widget.FrameLayout")
local Gravity = bindClass("android.view.Gravity")
local Activity = bindClass("android.app.Activity")
local MaterialAlertDialogBuilder = bindClass("com.google.android.material.dialog.MaterialAlertDialogBuilder")
local LinearLayout = bindClass("android.widget.LinearLayout")
local TextInputLayout = bindClass("com.google.android.material.textfield.TextInputLayout")
local TextInputEditText = bindClass("com.google.android.material.textfield.TextInputEditText")
local AlertDialog = bindClass("android.app.AlertDialog")
function 单页文件上传影视解决(num,网页JS执行超时,获取标题事件,获取到网页图标,网页提示框,网页确认框,网页输入框,控制台消息,页面加载进度,网页权限申请,网页定位权限,旋转方式,是否允许多选)
  local isFullScreen = false
  local customView = nil
  local fileRequestCode = 12345
  local orientation
  local uploadFile
  if num then
    num=num-1
  end
  if 网页JS执行超时==nil then
    网页JS执行超时=function() end
  end
  if 获取标题事件==nil then
    获取标题事件=function() end
  end
  if 获取到网页图标==nil then
    获取到网页图标=function() end
  end
  if 网页提示框==nil then
    网页提示框=function(superCall,view,url,message,result)
      if url:match("^file://") then
        url="本地网页"
       else
        url=url:match("https?://([^/]+)") or url
      end
      网页提示弹框=AlertDialog.Builder(activity)
      .setTitle("来自 "..url.." 的网页提示")
      .setMessage(message)
      .setPositiveButton("确定",{onClick=function(v)
        result.confirm()
      end})
      .setNegativeButton("取消",{onClick=function(v)
        result.cancel()
      end})
      .setOnCancelListener(function()
        result.cancel()
      end)--监听对话框取消
      .show()
      网页提示弹框.findViewById(android.R.id.message).setTextIsSelectable(true)--文字可复制
      return true
    end
  end
  if 网页确认框==nil then
    网页确认框=function(superCall,view,url,message,result)
      if url:match("^file://") then
        url="本地网页"
       else
        url=url:match("https?://([^/]+)") or url
      end
      网页确认弹框=AlertDialog.Builder(activity)
      .setTitle("来自 "..url.." 的网页确认")
      .setMessage(message)
      .setPositiveButton("确定",{onClick=function(v)
        result.confirm()
      end})
      .setNegativeButton("取消",{onClick=function(v)
        result.cancel()
      end})
      .setOnCancelListener(function()
        result.cancel()
      end)--监听对话框取消
      .show()
      网页确认弹框.findViewById(android.R.id.message).setTextIsSelectable(true)--文字可复制
      return true
    end
  end
  if 网页输入框==nil then
    网页输入框=function(superCall,view,url,message,value,result)
      if url:match("^file://") then
        url="本地网页"
       else
        url=url:match("https?://([^/]+)") or url
      end
      local view_wysrdhk={
        LinearLayout,
        layout_width="match",
        layout_height="match",
        orientation=1,
        {
          TextView;
          id="Prompt",
          layout_marginTop="5dp";--上
          --layout_marginBottom="5dp",--下
          layout_marginLeft="24dp",--左
          layout_marginRight="24dp",--右
          layout_width="match";
          layout_height="wrap",
          layout_gravity="center",
          text=message;
          textSize="14sp",
        };
        {
          EditText;
          id="edit";
          layout_marginTop="5dp";
          layout_marginLeft="20dp",
          layout_marginRight="20dp",
          layout_width="match";
          layout_height="wrap",
          layout_gravity="center",
          text=value or "";
        };
      }
      网页输入对话框=AlertDialog.Builder(activity)
      .setTitle("来自 "..url.." 的网页显示")
      .setView(loadlayout(view_wysrdhk))
      .setPositiveButton("确定",{onClick=function(v)
          if edit.text~="" then
            result.confirm(edit.text)
           else
            result.confirm()
          end
        end})
      .setNegativeButton("取消",{onClick=function(v)
          result.cancel()
        end})
      .setNeutralButton("退出",{onClick=function(v)
          网页后退()
          result.cancel()
        end})
      .setOnCancelListener(function()
        result.cancel()
      end)
      .show()
      edit.setOnFocusChangeListener(bindClass("android.view.View$OnFocusChangeListener"){
        onFocusChange=function(v,hasFocus)
          if hasFocus then
            Prompt.setTextColor(0xFF2196F3)
          end
        end
      })
      Prompt.setTextIsSelectable(true)--文字可复制
      return true
    end
  end
  if 控制台消息==nil then
    控制台消息=function()
      return true
    end
  end
  if 页面加载进度==nil then
    页面加载进度=function() end
  end
  if 网页权限申请==nil then
    网页权限申请=function() end
  end
  if 网页定位权限==nil then
    网页定位权限=function() end
  end
  获取浏览器(num).setWebChromeClient(luajava.override(WebChromeClient,{--重写WebChromeClient
    onJsTimeout=网页JS执行超时,
    onJsAlert=网页提示框,
    onJsConfirm=网页确认框,
    onJsPrompt=网页输入框,
    onReceivedTitle=获取标题事件,
    onReceivedIcon=获取到网页图标,
    onConsoleMessage=控制台消息,
    onProgressChanged=页面加载进度,
    onPermissionRequest=网页权限申请,
    onGeolocationPermissionsShowPrompt=网页定位权限,
    onShowFileChooser=function(a, view, valueCallback, fileChooserParams)--网页上传文件触发事件
      uploadFile=valueCallback
      local intent = fileChooserParams.createIntent()
      local mimeTypeMap = MimeTypeMap.getSingleton()
      if not mimeTypeMap.hasMimeType(intent.getType()) then
        intent.setType("*/*")
      end
      if 是否允许多选 then
        intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE,true)
        activity.startActivityForResult(intent, fileRequestCode)
       else
        activity.startActivityForResult(intent, 1);
      end
      return true;
    end,
    onShowCustomView=function(superCall, view, callback)--ai优化版--视频全屏操作会执行这个方法，想要自己做全屏的可以在这里处理
      isFullScreen = true
      customView = view
      --将 View 覆盖在根布局上面
      local lp = FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT)
      lp.gravity = Gravity.TOP
      activity.addContentView(view, lp)
      if 旋转方式 then
        if 旋转方式==1 then
          --自动旋转屏幕
          activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR);
         elseif 旋转方式==2 then
          --自动横屏，且限制于横屏
          activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
         elseif 旋转方式==3 then
          --竖屏
          activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        end
       else
        --系统默认
        activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);
      end
      --修改状态栏状态
      pcall(function()
        local window = activity.getWindow()
        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN)
      end)
      --设置屏幕常亮
      activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    end,
    onHideCustomView=function(superCall)--视频退出全屏触发的方法
      isFullScreen = false
      --设置屏幕方向为跟随系统
      activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED)
      --恢复状态栏原始状态
      pcall(function()
        local window = activity.getWindow()
        window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
      end)
      --设置取消屏幕常亮
      activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
      --网页前进
      网页前进()
      --移除全屏显示的 View
      if customView then
        customView.getParent().removeView(customView)
        customView = nil
      end
    end,
  }))--上方为WebChromeClient重设置
  if 是否允许多选 then
    onActivityResult=function(requestCode,resultCode,intent)
      if requestCode == fileRequestCode then
        if resultCode == Activity.RESULT_CANCELED then
          if uploadFile~=nil then
            uploadFile.onReceiveValue(nil)
            return
          end
        end
        local results
        if resultCode == Activity.RESULT_OK then
          if uploadFile==nil or type(uploadFile)=="number" then
            return
          end
          if intent ~= nil then
            local dataString = intent.getDataString()
            local clipData = intent.getClipData()
            if clipData ~= nil then
              results = Uri[clipData.getItemCount()]
              for i = 0,clipData.getItemCount()-1 do
                local item = clipData.getItemAt(i)
                results[i] = item.getUri()
              end
            end
            if dataString ~= nil then
              results = Uri[1]
              results[0]=Uri.parse(dataString)
            end
          end
        end
        if results~=nil then
          uploadFile.onReceiveValue(results)
          uploadFile = nil
        end
      end
    end
   else
    onActivityResult=function(req,res,intent)
      if (res == Activity.RESULT_CANCELED) then
        if(uploadFile~=nil )then
          uploadFile.onReceiveValue(nil);
        end
      end
      local results
      if (res == Activity.RESULT_OK)then
        if(uploadFile==nil or type(uploadFile)=="number")then
          return;
        end
        if (intent ~= nil) then
          local dataString = intent.getDataString();
          local clipData = intent.getClipData();
          if (clipData ~= nil) then
            results = Uri[clipData.getItemCount()];
            for i = 0,clipData.getItemCount()-1 do
              local item = clipData.getItemAt(i);
              results[i] = item.getUri();
            end
          end
          if (dataString ~= nil) then
            results = Uri[1];
            results[0]=Uri.parse(dataString)
          end
        end
      end
      if(results~=nil)then
        uploadFile.onReceiveValue(results);
        uploadFile = nil;
      end
    end
  end
end

local Context = bindClass("android.content.Context")
local DownloadManager = bindClass("android.app.DownloadManager")
local function 系统下载(filepath,filename,url)--目录，名称，直链
  local downloadManager = activity.getSystemService(Context.DOWNLOAD_SERVICE)
  local request=DownloadManager.Request(Uri.parse(url))
  request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_MOBILE|DownloadManager.Request.NETWORK_WIFI)
  request.setDestinationInExternalPublicDir(filepath,filename)
  request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
  downloadManager.enqueue(request)
  if string.find(filename, "/") then
    print("已开始下载，请在通知栏查看进度\n存储在 "..filepath.."/"..string.sub(filename, 1, string.find(filename, "/") - 1).." 目录")
   else
    print("已开始下载，请在通知栏查看进度\n存储在 "..filepath.." 目录")
  end
end

local File = bindClass("java.io.File")
local URLUtil = bindClass("android.webkit.URLUtil")
local Build = bindClass("android.os.Build")
local Environment = bindClass("android.os.Environment")
local Base64 = bindClass("android.util.Base64")
local ProgressDialog = bindClass("android.app.ProgressDialog")
function 单页监听下载(num,下载方式,下载目录,下载文件夹)
  if num then
    num=num-1
  end
  if 下载方式 then
    if 下载目录 then
      fullPath = ("/storage/emulated/0/"..下载目录)
     else
      下载目录="Download"
      fullPath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
    end
    获取浏览器(num).setDownloadListener{
      onDownloadStart=function(url,userAgent,contentDisposition,mimetype,contentLength)
        xzxxjzjdk= ProgressDialog(this)
        xzxxjzjdk.setProgressStyle(ProgressDialog.STYLE_SPINNER)
        xzxxjzjdk.setMessage("正在加载下载文件信息...")
        xzxxjzjdk.setCancelable(true)--设置是否可以通过点击Back键取消
        xzxxjzjdk.setCanceledOnTouchOutside(true)--设置在点击Dialog外是否取消Dialog进度条
        xzxxjzjdk.show()--显示
        --文件名称转换+文件类型转换
        local filename=URLUtil.guessFileName(url, contentDisposition, mimeType);--文件名
        local ext = MimeTypeMap.getSingleton().getExtensionFromMimeType(mimetype)--扩展名(文件类型)
        local c = ext and ext ~= "" and ext or mimetype
        function isUUID(filename)
            local pattern = table.concat({
            "^", string.rep("%x", 8), "%-",
            string.rep("%x", 4), "%-",
            string.rep("%x", 4), "%-",
            string.rep("%x", 4), "%-",
            string.rep("%x", 12), "$"
          })
          return filename:match(pattern) ~= nil
        end
        function isUUIDFile(filename)
          -- 分离文件名和扩展名（以最后一个点分隔）
          local name = filename:match("(.+)%.[^%.]+$") or filename
          return isUUID(name) -- 复用上述UUID检测函数
        end
        local a=URLDecoder.decode(filename)--文件名解码
        if a:match(".*%.bin$") or a:match(".*%.gz$") or a:match(".*%.php$") or a:match(".*%.aspx$") or isUUIDFile(a) or a:match("[%*/\\\"<>%?%|:]") or a:match("^[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]%.[^%.]+$") or 获取网址():match("www.ilanzou.com") then
          local url=URLDecoder.decode(url)
          a = url:match("&n=(.-)$")--苦力怕论坛
          or url:match("%?fn=(.-)$")--蓝奏云
          or url:match("&download_name=(.-)&")--小飞机
          or url:match("%?attname=(.-)&")--MT管理器
          or url:match("&attname=(.-)$")--steam
          or url:match("filename=\"(.-)\"")--蒲公英+文叔叔
          or url:match("filename=(.-)&")--123云盘+github
          or url:match("fileName=(.-)&")--蓝奏云
          or url:match("filename=(.-)$")--其他的尝试
          or url:match("sharepoint.cn") and url:match(".*/(.-)$")
          or !(c:match("application/")) and a:match("(.*)%.bin$") and a:match("(.*)%.bin$").."."..c
          or a

          if a then
            if string.len(a) > 60 then
              a = string.sub(a, -40)
            end
            a = string.gsub(a , "[%*/\\\"<>%?%|:]", "")
          end
        end

        local units = {"B", "KB", "MB", "GB"}
        -- 初始化文件大小和单位索引
        local size = contentLength
        local unitIndex = 1
        -- 循环计算文件大小及单位
        while size >= 1024 and unitIndex < #units do
          size = size / 1024
          unitIndex = unitIndex + 1
        end
        -- 格式化输出文件大小及单位
        local b = string.format("%.2f", size) .. " " .. units[unitIndex]

        local urls = string.len(url) > 600 and "链接过长，为防止卡顿已隐藏" or url:find("^blob") and url.."\n\n下载问题：该下载协议处理不完善，请前往浏览器进行操作" or (!URLUtil.isHttpUrl(url) and !URLUtil.isHttpsUrl(url) and !URLUtil.isDataUrl(url) and !(url:find("^blob"))) and url.."\n\n下载问题：未知下载协议，请前往浏览器进行操作" or url

        文件名称=a

        function 下载对话框(Positive, Negative, Neutral, funa, funb, func)
          xzxxjzjdk.dismiss()--关闭
          if not activity.isFinishing() then
            if funa==nil then
              funa=function()
                xzdhbjk.dismiss()
              end
            end
            if funb==nil then
              funb=function()
                xzdhbjk.dismiss()
              end
            end
            if func==nil then
              func=function()
                xzdhbjk.dismiss()
              end
            end
            local xiazaiduihuakuang={
              LinearLayout,
              layout_width="match",
              layout_height="match",
              orientation=1, -- 垂直方向
              gravity="center_vertical",
              {
                LinearLayout,
                layout_width="match",
                layout_height="wrap",
                orientation=0, -- 水平方向
                gravity="center_vertical",
                --layout_marginTop="8dp",
                --layout_marginBottom="8dp",
                layout_marginLeft="24dp",
                layout_marginRight="24dp",
                {
                  TextView,
                  id="wjxx",
                  layout_width="wrap",
                  layout_height="wrap",
                  text="文件名称：",
                  textSize="14sp",
                  layout_marginRight="-5dp", -- 文字和输入框间距
                };
                {
                  EditText,
                  id="edit",
                  layout_width="0dp",
                  layout_height="wrap",
                  layout_weight="1", -- 使用权重填满剩余空间
                  hint="请输入自定义文件名称...",
                  singleLine=true,
                  textSize="14sp",
                  text=文件名称,
                  --hintTextColor=0xFF888888, -- 提示文字颜色
                  --textColor=0xFF000000, -- 输入文字颜色
                };
              };
              {
                TextView,
                id="wjxx2",
                layout_width="wrap",
                layout_height="wrap",
                layout_marginLeft="24dp",
                layout_marginRight="24dp",
                text="文件大小："..b.."\n\n文件类型："..c.."\n\n文件直链："..urls,
                textSize="14sp",
                --layout_marginRight="8dp", -- 文字和输入框间距
              };
            }
            xzdhbjk=AlertDialog.Builder(activity)
            .setTitle("下载文件")
            .setView(loadlayout(xiazaiduihuakuang))
            .setPositiveButton(Positive,nil)
            .setNegativeButton(Negative,nil)
            .setNeutralButton(Neutral,nil)
            .show()
            wjxx.setTextIsSelectable(true)--文字可复制
            wjxx2.setTextIsSelectable(true)--文字可复制
            xzdhbjk.getButton(AlertDialog.BUTTON1).onClick=funa
            xzdhbjk.getButton(AlertDialog.BUTTON2).onClick=funb
            xzdhbjk.getButton(AlertDialog.BUTTON3).onClick=func
          end
        end

        local path = fullPath
        if Build.VERSION.SDK_INT >= 29 then --Build.VERSION_CODES.Q
          path = Environment.DIRECTORY_DOWNLOADS--获取下载路径
        end
        
        function base64write(data,wjm)
          local file = File(fullPath,wjm)
          file.delete()
          file.createNewFile()
          local decodedData = Base64.decode(data, Base64.DEFAULT)
          local output = activity.ContentResolver.openOutputStream(Uri.fromFile(file))
          output.write(decodedData)
          output.close()
          print("已尝试开始下载\n存储在"..tostring(fullPath))
        end

        if URLUtil.isHttpUrl(url) or URLUtil.isHttpsUrl(url) then
          下载对话框("直接下载", "复制直链", "浏览器下载",
          function(v)
            if edit.text~="" then
              xzdhbjk.dismiss()
              if 下载文件夹 then
                系统下载(下载目录,下载文件夹..edit.text,url)
               else
                系统下载(下载目录,edit.text,url)
              end
             else
              edit.error="文件名不可为空！"
            end
          end,
          function(v)
            print"已尝试复制直链，请自行查看剪贴板"
            activity.getSystemService("clipboard").setText(url)
            xzdhbjk.dismiss()
          end,
          function(v)
            print"已尝试跳转浏览器..."
            activity.startActivity(Intent("android.intent.action.VIEW",Uri.parse(url)))
            xzdhbjk.dismiss()
          end)
         elseif URLUtil.isDataUrl(url) then
          --是否base64编码
          下载对话框("直接下载", "复制链接", "浏览器打开",
          function(v)
            if edit.text~="" then
              xzdhbjk.dismiss()
              if url:find("^data:(.-)(;base64),(.-)$") then
                local mime,data=url:match("^data:(.-);base64,(.-)$")
                base64write(data,edit.text)
               else
                local mime,data=url:match("^data:(.-),(.-)$")
                io.open(path.."/"..edit.text,"w+"):write(URLDecoder.decode(data)):close()
              end
             else
              edit.error="文件名不可为空！"
            end
          end,
          function(v)
            activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(获取网址())
            print"已尝试复制链接，请自行查看剪贴板"
            xzdhbjk.dismiss()
          end,
          function(v)
            if 获取网址():find("^file:///") then
              print"本地网页不支持浏览器打开\n请自行获取源码前往浏览器操作"
             else
              activity.startActivity(Intent("android.intent.action.VIEW",Uri.parse(获取网址())))
              print"已尝试跳转浏览器..."
            end
            xzdhbjk.dismiss()
          end)
         else
          下载对话框("知道了", "复制链接", "浏览器打开",nil,
          function(v)
            activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(获取网址())
            print"已尝试复制链接，请自行查看剪贴板"
            xzdhbjk.dismiss()
          end,
          function(v)
            if 获取网址():find("^file:///") then
              print"本地网页不支持浏览器打开\n请自行获取源码前往浏览器操作"
             else
              activity.startActivity(Intent("android.intent.action.VIEW",Uri.parse(获取网址())))
              print"已尝试跳转浏览器..."
            end
            xzdhbjk.dismiss()
          end)
        end
      end
    }
   else
    获取浏览器(num).setDownloadListener{
      onDownloadStart=function(url,userAgent,contentDisposition,mimetype,contentLength)
      if 获取网址():find("^file:///") then
              print"本地网页不支持浏览器打开\n请自行获取源码前往浏览器操作"
             else
        if URLUtil.isHttpUrl(url) or URLUtil.isHttpsUrl(url) then
          activity.startActivity(Intent("android.intent.action.VIEW",Uri.parse(url)))
         else
          activity.startActivity(Intent("android.intent.action.VIEW",Uri.parse(获取网址())))
        end
        end
      end
    }
  end
end

local Toast = bindClass("android.widget.Toast")
local Gravity = bindClass("android.view.Gravity")
local CardView = bindClass("androidx.cardview.widget.CardView")
local TextView = bindClass("android.widget.TextView")
local LinearLayout = bindClass("android.widget.LinearLayout")
function 自定义弹出(弹出内容,文字位置,文字粗细,文字大小,文字颜色,上下内边距,左右内边距,背景宽,背景高,背景圆,背景阴影,背景颜色,消息长短,弹出位置,上下位置调试,左右位置调试)
  上下位置调试=上下位置调试 or 0
  左右位置调试=左右位置调试 or 0
  if 消息长短 then
    消息长短=Toast.LENGTH_LONG
   else
    消息长短=Toast.LENGTH_SHORT
  end
  if 文字粗细 then
    文字粗细=true
   else
    文字粗细=false
  end
  if 弹出位置=="顶部" then
    弹出位置=Gravity.TOP
   elseif 弹出位置=="中间" then
    弹出位置=Gravity.CENTER
   else
    弹出位置=Gravity.BOTTOM
  end
  if 文字位置=="居左" then
    文字位置="left"
   elseif 文字位置 == "居右" then
    文字位置="right"
   else
    文字位置="center"
  end
  layout={
    LinearLayout;
    {
      CardView;
      CardBackgroundColor=背景颜色;
      elevation=背景阴影;
      layout_width=背景宽;
      layout_height=背景高;
      radius=背景圆;
      {
        TextView;
        textSize=文字大小;
        --padding='15dp';--内边距
        paddingTop=上下内边距;--布局内顶距
        paddingBottom=上下内边距;--布局内底距
        paddingLeft=左右内边距;--布局内左距
        paddingRight=左右内边距;--布局内右距
        TextColor=文字颜色;
        layout_width=背景宽;
        layout_height=背景高;
        gravity=文字位置;
        text=弹出内容;
        id="text";
      };
    };
  }
  kwdbtc = Toast.makeText(activity, nil, 消息长短).setGravity(弹出位置, 左右位置调试, 上下位置调试).setView(loadlayout(layout)).show()
  --text.Text=tostring(内容)
  text.getPaint().setFakeBoldText(文字粗细)--文字加粗
end

local Base64 = bindClass("android.util.Base64")
local GCMParameterSpec = bindClass("javax.crypto.spec.GCMParameterSpec")
local SecureRandom = bindClass("java.security.SecureRandom")
local Cipher = bindClass("javax.crypto.Cipher")
local MessageDigest = bindClass("java.security.MessageDigest")
local SecretKeySpec = bindClass("javax.crypto.spec.SecretKeySpec")
function Base64编码(data)
  return Base64.encodeToString(String(data).getBytes(),Base64.NO_WRAP);
end
function Base64解码(data)
  return String(Base64.decode(data,Base64.DEFAULT)).toString()
end
local function toBytes(input)--设置编码tojbyte
  return String(input).getBytes("UTF-8")
end
local function generateKey2(key)
  local md = MessageDigest.getInstance("SHA-256")
  local keyBytes = md.digest(toBytes(key))
  return keyBytes
end
local function generateNonce(length)
  local nonce = byte[length]
  SecureRandom().nextBytes(nonce)
  return nonce
end
function ChaCha20加密(key, data)
  local nonce = generateNonce(12)
  local keySpec = SecretKeySpec(generateKey2(key), "ChaCha20")
  local paramSpec = GCMParameterSpec(128, nonce)
  local cipher = Cipher.getInstance("ChaCha20/Poly1305/NoPadding")
  cipher.init(Cipher.ENCRYPT_MODE, keySpec, paramSpec)
  local encryptedBytes = cipher.doFinal(toBytes(data))
  local combined = byte[#nonce + #encryptedBytes]
  System.arraycopy(nonce, 0, combined, 0, #nonce)
  System.arraycopy(encryptedBytes, 0, combined, #nonce, #encryptedBytes)
  return tostring(Base64.encodeToString(combined, Base64.DEFAULT))
end
function ChaCha20解密(key, encryptedData)
  local combined = Base64.decode(encryptedData, Base64.DEFAULT)
  local nonce = byte[12]
  System.arraycopy(combined, 0, nonce, 0, 12)
  local ciphertext = byte[#combined - 12]
  System.arraycopy(combined, 12, ciphertext, 0, #combined - 12)
  local keySpec = SecretKeySpec(generateKey2(key), "ChaCha20")
  local paramSpec = GCMParameterSpec(128, nonce)
  local cipher = Cipher.getInstance("ChaCha20/Poly1305/NoPadding")
  cipher.init(Cipher.DECRYPT_MODE, keySpec, paramSpec)
  local decryptedBytes = cipher.doFinal(ciphertext)
  return tostring(String(decryptedBytes, "UTF-8"))
end

function 忽略http请求证书错误()
  import "javax.net.ssl.HostnameVerifier"
  import "javax.net.ssl.HttpsURLConnection"
  import "javax.net.ssl.SSLContext"
  import "javax.net.ssl.X509TrustManager"
  import "javax.security.cert.X509Certificate"
  import "java.security.SecureRandom"
  pcall(function()
    local mSSLContext=SSLContext.getInstance("SSL")
    mSSLContext.init(nil,{
      X509TrustManager{
        getAcceptedIssuers=function()
          return X509Certificate[0]
        end,
      }
    },SecureRandom())
    HttpsURLConnection.setDefaultHostnameVerifier(HostnameVerifier{
      verify=function(str,mSSLSession)
        return true
      end
    })
    HttpsURLConnection.setDefaultSSLSocketFactory(mSSLContext.getSocketFactory())
  end)
end

-- =============== ai签名开始 ===============
-- 导入必要的Java类
local PackageManager = luajava.bindClass("android.content.pm.PackageManager")
local MessageDigest = luajava.bindClass("java.security.MessageDigest")
local StringBuilder = luajava.bindClass("java.lang.StringBuilder")
local CertificateFactory = luajava.bindClass("java.security.cert.CertificateFactory")
local ByteArrayInputStream = luajava.bindClass("java.io.ByteArrayInputStream")
local Build = luajava.bindClass("android.os.Build")

-- 将字节数组转换为十六进制字符串
function bytesToHex(bytes, withColon, useUpperCase)
  withColon = withColon == nil and true or withColon
  useUpperCase = useUpperCase == nil and true or useUpperCase
  local sb = StringBuilder()
  local format = useUpperCase and "%X" or "%x"
  for i = 0, #bytes - 1 do
    local b = bytes[i] & 0xFF
    if b < 0x10 then
      sb.append("0")
    end
    sb.append(string.format(format, b))
    if withColon and i < #bytes - 1 then
      sb.append(":")
    end
  end
  return sb.toString()
end
-- 获取应用签名证书（兼容Android所有版本）
function getSignatures(packageName)
  packageName = packageName or activity.getPackageName()
  local flags
  if Build and Build.VERSION.SDK_INT >= 28 then
    flags = PackageManager.GET_SIGNING_CERTIFICATES
   else
    flags = PackageManager.GET_SIGNATURES
  end

  local pm = activity.getPackageManager()
  local info = pm.getPackageInfo(packageName, flags)

  if Build and Build.VERSION.SDK_INT >= 28 then
    return info.signingInfo.getApkContentsSigners()
   else
    return info.signatures
  end
end
-- 获取证书原始字节数据
function getCertificateBytes(packageName)
  local signatures = getSignatures(packageName)
  return signatures[0].toByteArray()
end
-- 计算数据的指定哈希值
function calculateHash(data, algorithm, withColon, useUpperCase)
  local success, result = pcall(function()
    local digest = MessageDigest.getInstance(algorithm)
    local hashBytes = digest.digest(data)
    return bytesToHex(hashBytes, withColon, useUpperCase)
  end)

  if success then
    return result
   else
    print("计算"..algorithm.."失败: "..tostring(result))
    return nil
  end
end

-- 获取应用证书HASH值（兼容旧方法）
function 获取应用证书HASH码(packageName)
  packageName = packageName or activity.getPackageName()
  local signatures = getSignatures(packageName)
  return signatures[0].hashCode()
end
-- 获取应用证书CRC32值
function 获取应用证书CRC32码(packageName)
  packageName = packageName or activity.getPackageName()
  local CRC32 = luajava.bindClass("java.util.zip.CRC32")

  local pm = activity.getPackageManager()
  local packageInfo = pm.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)

  if not packageInfo.signatures or #packageInfo.signatures == 0 then
    return -1
  end

  local signatureBytes = packageInfo.signatures[0].toByteArray()
  local crc = CRC32()
  crc.update(signatureBytes)
  return crc.getValue()
end
-- 获取应用证书哈希值（带包名参数）
function 获取应用证书哈希值(algorithm, packageName, withColon, useUpperCase)
  packageName = packageName or activity.getPackageName()
  local certBytes = getCertificateBytes(packageName)
  return calculateHash(certBytes, algorithm, withColon, useUpperCase)
end
-- 获取指定数据哈希值
function 获取指定数据哈希值(data, algorithm, withColon, useUpperCase)
  if type(data) == "string" then
    data = {string.byte(data, 1, -1)}
  end
  return calculateHash(data, algorithm, withColon, useUpperCase)
end
-- =============== ai签名结束 ===============

function 对话框文件管理器(文件夹路径)
  import "android.content.Intent"
  import "java.io.File"
  import "android.content.FileProvider"
  import "androidx.core.content.FileProvider"
  import "android.util.DisplayMetrics"
  MaterialAlertDialogBuilder = luajava.bindClass "com.google.android.material.dialog.MaterialAlertDialogBuilder"
  AlertDialog = luajava.bindClass "android.app.AlertDialog"

  local 选中文件索引 = -1
  
  local File = luajava.bindClass("java.io.File")
  local dirFile = File(文件夹路径)

  local function 获取文件列表()
    local 文件列表, 时间列表, 大小列表 = {}, {}, {}

    if dirFile.exists() and dirFile.isDirectory() then
      local files = dirFile.listFiles()

      -- 首先将所有文件信息收集到一个表中
      local 文件信息表 = {}
      for i = 0, #files - 1 do
        local file = files[i]
        if file.isFile() then
          local 文件名 = file.getName()
          local lastModified = file.lastModified()
          local size = file.length()

          table.insert(文件信息表, {
            文件名 = 文件名,
            修改时间 = lastModified,
            文件大小 = size
          })
        end
      end

      -- 按修改时间排序，时间越新的排在前面
      table.sort(文件信息表, function(a, b)
        return a.修改时间 > b.修改时间
      end)

      -- 填充返回的表
      for i, info in ipairs(文件信息表) do
        table.insert(文件列表, info.文件名)

        local calendar = luajava.bindClass("java.util.Calendar").getInstance()
        calendar.setTimeInMillis(info.修改时间)

        local year = calendar.get(luajava.bindClass("java.util.Calendar").YEAR)
        local month = calendar.get(luajava.bindClass("java.util.Calendar").MONTH) + 1
        local day = calendar.get(luajava.bindClass("java.util.Calendar").DAY_OF_MONTH)
        local hour = calendar.get(luajava.bindClass("java.util.Calendar").HOUR_OF_DAY)
        local minute = calendar.get(luajava.bindClass("java.util.Calendar").MINUTE)

        local dateStr = string.format("%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
        table.insert(时间列表, dateStr)

        local sizeStr
        if info.文件大小 < 1024 then
          sizeStr = string.format("%d B", info.文件大小)
         elseif info.文件大小 < 1024 * 1024 then
          sizeStr = string.format("%.2f KB", info.文件大小 / 1024)
         elseif info.文件大小 < 1024 * 1024 *1024 then
          sizeStr = string.format("%.2f MB", info.文件大小 / (1024 * 1024))
         else
          sizeStr = string.format("%.2f GB", info.文件大小 / (1024 * 1024 * 1024))
        end
        table.insert(大小列表, sizeStr)
      end
     else
      print("路径不存在或不是文件夹: "..文件夹路径)
    end

    return 文件列表, 时间列表, 大小列表
  end

  local function 创建显示列表(文件列表, 时间列表, 大小列表)
    local 显示列表 = {}
    for i = 1, #文件列表 do
      table.insert(显示列表, string.format("%s\n%s %s",
      文件列表[i], 时间列表[i], 大小列表[i]))
    end
    return 显示列表
  end

  local function 打开文件(文件名)
    local 文件 = File(文件夹路径, 文件名)
    if not 文件.exists() then
      print("文件不存在: "..文件名)
      return
    end

    -- APK 文件处理
    if 文件名:match("%.apk$") then
      安装APK(tostring(文件))
      return
    end

    local intent = luajava.newInstance("android.content.Intent", "android.intent.action.VIEW")
    local uri = FileProvider.getUriForFile(activity, activity.getPackageName()..".FileProvider", 文件)
    intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

    -- 文件类型与 MIME 类型映射
    local mimeTypes = {
      [".jpg"] = "image/*", [".jpeg"] = "image/*", [".png"] = "image/*",
      [".gif"] = "image/*", [".bmp"] = "image/*", [".webp"] = "image/*",

      [".mp4"] = "video/*", [".avi"] = "video/*", [".mov"] = "video/*",
      [".mkv"] = "video/*", [".flv"] = "video/*", [".wmv"] = "video/*",
      [".3gp"] = "video/*", [".webm"] = "video/*",

      [".txt"] = "text/plain", [".pdf"] = "application/pdf",
      [".doc"] = "application/msword", [".docx"] = "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      [".xls"] = "application/vnd.ms-excel", [".xlsx"] = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      [".ppt"] = "application/vnd.ms-powerpoint", [".pptx"] = "application/vnd.openxmlformats-officedocument.presentationml.presentation",
      [".md"] = "text/plain", [".rtf"] = "application/rtf", [".odt"] = "application/vnd.oasis.opendocument.text",
      [".lua"] = "text/plain", [".css"] = "text/css", [".html"] = "text/html",
      [".htm"] = "text/html", [".xml"] = "text/xml", [".js"] = "application/javascript",
      [".json"] = "application/json",

      -- 新增支持类型
      [".zip"] = "application/zip", [".rar"] = "application/x-rar-compressed",
      [".mp3"] = "audio/mpeg", [".wav"] = "audio/wav"
    }

    local mimeType = "application/octet-stream"
    for ext, type in pairs(mimeTypes) do
      if 文件名:match("%"..ext.."$") then
        mimeType = type
        break
      end
    end

    intent.setDataAndType(uri, mimeType)

    local packageManager = activity.getPackageManager()
    if intent.resolveActivity(packageManager) ~= nil then
      activity.startActivity(intent)
     else
      -- 尝试通用文本方式
      local fallbackIntent = luajava.newInstance("android.content.Intent", "android.intent.action.VIEW")
      fallbackIntent.setDataAndType(uri, "text/plain")
      fallbackIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
      fallbackIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

      if fallbackIntent:resolveActivity(packageManager) ~= nil then
        activity.startActivity(fallbackIntent)
       else
        print("没有应用可以打开文件: "..文件名)
        -- 显示提示
        AlertDialog.Builder(activity)
        .setTitle("无法打开文件")
        .setMessage("没有找到可以打开此文件的应用\n文件类型: "..mimeType)
        .setPositiveButton("确定", nil)
        .show()
      end
    end
  end

  local function 删除文件(文件名)
    local 文件 = File(文件夹路径, 文件名)
    if 文件.exists() then
      if 文件.delete() then
        return true
       else
        print("删除失败: "..文件名)
      end
     else
      print("文件不存在: "..文件名)
    end
    return false
  end

  local function 显示文件选择器()
    local 文件列表, 时间列表, 大小列表 = 获取文件列表()
    local 显示列表 = 创建显示列表(文件列表, 时间列表, 大小列表)
    local 文件数量 = "("..#文件列表..")"

    local dialog = AlertDialog.Builder(activity)
    .setTitle(文件夹路径..文件数量)
    .setSingleChoiceItems(显示列表, 选中文件索引, {
      onClick = function(dialog, which)
        选中文件索引 = which
      end
    })
    .setPositiveButton("打开",nil)
    .setNeutralButton("删除",nil)
    .setNegativeButton("取消", nil)
    .create()
    .show()
    dialog.getButton(AlertDialog.BUTTON1).onClick=function()
      if 选中文件索引 >= 0 then
        local 文件名 = 文件列表[选中文件索引 + 1]
        打开文件(文件名)
       else
        print"请选择文件后进行操作"
      end
    end
    dialog.getButton(AlertDialog.BUTTON3).onClick=function(v)
      if 选中文件索引 >= 0 then
        local 文件名 = 文件列表[选中文件索引 + 1]
        AlertDialog.Builder(activity)
        .setTitle("确认删除")
        .setMessage("确定要永久删除\""..文件名.."\"文件?")
        .setPositiveButton("删除", {
          onClick = function(confirmDialog)
            if 删除文件(文件名) then
              -- 显示删除成功提示
              AlertDialog.Builder(activity)
              .setTitle("删除成功")
              .setMessage("已删除文件: "..文件名)
              .setPositiveButton("确定",nil)
              .setOnDismissListener(function()
                dialog.dismiss()
                选中文件索引 = -1 -- 重置选中索引
                显示文件选择器() -- 刷新列表
              end)
              .show()
            end
          end
        })
        .setNegativeButton("取消", nil)
        .show()
       else
        print"请选择文件后进行操作"
      end
    end
  end
  显示文件选择器()
end

function 调用QQ打开链接(链接)
  local Uri = bindClass("android.net.Uri")
  local Intent = bindClass("android.content.Intent")
  url="mqqapi://forward/url?url_prefix="..链接.."&souce=oicqzone.com&version=1&src_type=web"
  intent = Intent(Intent.ACTION_VIEW)
  intent.setData(Uri.parse(url))
  activity.startActivity(intent)
end

function 联系QQ2(qqNUM)
  local Uri=luajava.bindClass"android.net.Uri"
  local Intent = luajava.bindClass "android.content.Intent"
  local url="mqqapi://card/show_pslcard?src_type=internal&version=1&uin="..qqNUM.."&card_type=person&source=qrcode"
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end

function 加QQ群(qqNUM)
  local Uri=luajava.bindClass"android.net.Uri"
  local Intent = luajava.bindClass "android.content.Intent"
  local s = "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=" .. qqNUM .. "&card_type=group&source=qrcode"
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(s)))
end