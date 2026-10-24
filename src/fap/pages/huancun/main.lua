require "import"
使用公共lua文件("libs")
import "gongyong"
import "androidx.recyclerview.widget.*"
import "com.google.android.material.card.MaterialCardView"

应用栏标题.setText("已缓存的帖子").setVisibility(0)
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    退子页面()
    return true
  end
end
左上角按钮().onClick=function(v)
  退子页面()
end;
右上角按钮(0,0).onClick=function(v)
  local 数量=#帖子缓存表()
  if 数量==0 then
    print2("还没有可清空的缓存")
    return
  end
  AlertDialog.Builder(this)
  .setTitle("清空全部缓存？")
  .setMessage("共 "..数量.." 篇，删除后无法恢复")
  .setPositiveButton("清空",{onClick=function()
    清空帖子缓存()
    刷新列表()
    print("已清空全部帖子缓存")
  end})
  .setNegativeButton("取消",nil)
  .show()
end;

--列表页主体：ScrollView + 卡片逐条排，不经过 RecyclerView 适配器，
--点击打开、长按删除都是直接挂在控件上，条数再多也不复用视图
local 布局={
  ScrollView,
  layout_width="match",
  layout_height="match",
  fillViewport=true,
  id="缓存滚动区",
  {
    LinearLayout,
    id="列表容器",
    layout_width="match",
    layout_height="wrap",
    orientation=1,
    paddingBottom="24dp",
  },
}
设置布局(布局)
local 容器=列表容器

function onFloatingActionButtonClick(v)
  pcall(function() 缓存滚动区.fullScroll(33) end)--滚回顶部
end

local 单条布局={
  MaterialCardView,
  layout_width="match",
  layout_height="wrap",
  cardBackgroundColor=主色2,
  cardElevation="0dp",
  radius="12dp",
  {
    LinearLayout,
    layout_width="match",
    layout_height="wrap",
    orientation=1,
    padding="14dp",
    {
      TextView,
      id="条目标题",
      layout_width="match",
      layout_height="wrap",
      textSize="15sp",
      textStyle="bold",
      textColor=主文本色,
      maxLines=2,
      ellipsize="end",
    },
    {
      TextView,
      id="条目时间",
      layout_width="match",
      layout_height="wrap",
      layout_marginTop="4dp",
      textSize="12sp",
      textColor=副文本色,
    },
  },
}

local function dp(值)
  return math.floor(值*activity.getResources().getDisplayMetrics().density+0.5)
end

local function 打开(v)
  进子页面("tiezi",{v.url})
end

local function 删除确认(v)
  AlertDialog.Builder(this)
  .setTitle("删除缓存")
  .setMessage("删除「"..(v.title or ("帖子"..tostring(v.tid))).."」的缓存？\n删除后原帖再被删将无法找回。")
  .setPositiveButton("删除",{onClick=function()
    删除帖子缓存(v.tid)
    刷新列表()
    print("已删除该条缓存")
  end})
  .setNegativeButton("取消",nil)
  .show()
end

function 刷新列表()
  容器.removeAllViews()
  local t=帖子缓存表()
  if #t==0 then
    容器.addView(loadlayout({
      TextView,
      layout_width="match",
      layout_height="wrap",
      paddingTop="80dp",
      gravity="center",
      textSize="14sp",
      textColor=副文本色,
      text="还没有缓存的帖子\n\n在帖子页右上角 ⋮ 菜单点「缓存帖子」\n即可保存当前页面（含已加载的评论）",
    }))
    return
  end
  for i=1,#t do
    local v=t[i]
    local 卡片=loadlayout(单条布局)
    --loadlayout 的根节点带 layout_margin 会崩（根的 LayoutParams 是普通 LayoutParams，
    --没有 setMargins），所以卡片边距在加载后程序化设置
    local lp=LinearLayout.LayoutParams(-1,-2)
    lp.setMargins(dp(16),dp(6),dp(16),dp(8))
    卡片.setLayoutParams(lp)
    条目标题.setText(v.title or ("帖子"..tostring(v.tid)))
    条目时间.setText("缓存于 "..tostring(v.time).."　·　点按打开，长按删除")
    卡片.setOnClickListener(function() 打开(v) end)
    卡片.setLongClickable(true)
    卡片.setOnLongClickListener(function()
      删除确认(v)
      return true
    end)
    容器.addView(卡片)
  end
end
刷新列表()
