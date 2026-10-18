require "import"
使用公共lua文件("libs")
import "gongyong"
应用栏标题.setText("当前在线 - MT论坛").setVisibility(0)
if 获取应用数据("显示悬浮按钮")=="false" then
  显隐悬浮按钮(1)
  悬浮按钮.layoutParams.behavior=nil
end
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    退子页面()
    return true
  end
end
左上角按钮().onClick=function(v)
  退子页面()
end;
function onFloatingActionButtonClick(v)
  recycler_view.smoothScrollToPosition(0);
end
if 登录参数==nil then
  print2"请登录后查看"
  退子页面()
end
import "androidx.swiperefreshlayout.widget.SwipeRefreshLayout"
import "com.google.android.material.card.MaterialCardView"
layout={
  SwipeRefreshLayout,
  layout_width="match",
  id="refresh",
  layout_height="match",
  {
    RecyclerView,
    id="recycler_view",
    layout_width="match",
    layout_height="wrap",
  },
}
设置布局(layout)
--设置列表布局
local list_item={
  LinearLayout,
  layout_width="match",
  layout_height="wrap",
  {
    MaterialCardView,
    id="card",
    layout_margin="10dp",
    layout_width="match",
    layout_height="wrap",
    cardBackgroundColor=主色2,--卡片背景色
    cardElevation="0dp",--卡片阴影强度
    radius="12dp",--卡片圆角幅度
    {
      FrameLayout;--帧布局
      layout_width='fill';--布局宽度
      layout_height='wrap';--布局高度
      {
        LinearLayout,
        layout_width="match",
        layout_height="wrap",
        padding="13dp",
        Orientation=1,
        {
          LinearLayout,
          layout_width="match",
          layout_height="wrap",
          Orientation=2,
          gravity='left|center';--控件内容的重力方向
          {
            CircleImageView;--圆图控件
            layout_width='40dp';--控件宽度
            layout_height='40dp';--控件高
            -- layout_margin='10dp';--控件外边距
            id='Image_Avatar';--设置控件ID
            layout_gravity='center';--重力
          };
          {
            LinearLayout,
            layout_width="wrap",
            layout_marginLeft='10dp';--布局左距
            layout_height="wrap",
            Orientation=1,
            {
              TextView,
              id="Name",
              textSize="15sp",
              textStyle="bold",
              textColor=textColorPrimary,
            },
            {
              TextView,
              id="title",
              layout_marginTop='4dp';--布局顶距
              textSize="12sp",
              textColor=副文本色2,
            },
          },
        },
      },
      {
        TextView,
        id="tag",
        textSize="15sp",
        textStyle="bold",
        padding="13dp",
        visibility='gone';--隐藏控件
        --layout_gravity='center';--重力
        textColor=textColorPrimary,
      },
      {
        MaterialCardView,
        id="cardview",--设置ID
        layout_height="18dp",
        layout_width="wrap",
        layout_margin="5dp",
        --rotation=-45,
        layout_gravity='right';--重力
        --strokeWidth="1dp", --边框宽度
        --strokeColor="#FFFF5D46", --边框颜色
        --layout_marginRight='5dp';--布局右距
        cardBackgroundColor=0x00000000,--卡片背景色
        cardElevation="0dp",--卡片阴影强度
        radius="2dp",--卡片圆角幅度
        {
          TextView,
          id="Small_label",
          textSize="12sp",
          layout_height="18dp",
          layout_width="wrap",
          --text="红包贴",
          layout_margin='2dp';
          layout_gravity='center';--重力
          --textColor="#FFFF5D46",
        },
      },
    },
  },
}


--设置线性列表布局
recycler_view.layoutManager=LinearLayoutManager(activity)
recycler_view.setLayoutManager(StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL))
local adapter=LuaRecyclerAdapter(activity,{},list_item)

--设置点击事件控件id,如果没有，则默认给列表项目父布局设置事件
--这里因为要给卡片控件设置事件，所以指定id为"card"
adapter.clickViewId="card"
adapter.onItemClick=function(adapter,itemView,view,pos)
  --简单获取到当前item的Data表
  local itemData = adapter.Data[pos+1]
  if itemData.uid then
    --https://bbs.binmt.cc/home.php?mod=space&uid="..itemData.uid.."&do=profile
    进子页面("yonghu",{"https://bbs.binmt.cc/home.php?mod=space&uid="..itemData.uid.."&do=profile"})
  end
end

adapter.setAdapterInterface(LuaRecyclerAdapter.AdapterInterface{
  onBindViewHolder=function(viewHolder,index)
    --获取控件并操作
    --print(viewHolder.tag.控件id)
    switch(viewHolder.tag.Small_label.text)
     case ""
      viewHolder.tag.cardview.setVisibility(this.uiManager.viewPager.GONE)
     case "管理员"
      viewHolder.tag.cardview.strokeWidth=1
      local Color = luajava.bindClass "android.graphics.Color"
      viewHolder.tag.cardview.strokeColor=Color.parseColor("#FFDC0000")
      viewHolder.tag.Small_label.setTextColor(0xFFDC0000)
     case "超级版主"
      viewHolder.tag.cardview.strokeWidth=1
      local Color = luajava.bindClass "android.graphics.Color"
      viewHolder.tag.cardview.strokeColor=Color.parseColor("#FFFF5D46")
      viewHolder.tag.Small_label.setTextColor(0xFFFF5D46)
     case "版主"
      viewHolder.tag.cardview.strokeWidth=1
      local Color = luajava.bindClass "android.graphics.Color"
      viewHolder.tag.cardview.strokeColor=Color.parseColor("#66A9C9")
      viewHolder.tag.Small_label.setTextColor(0xFF66A9C9)
     case "会员"
      viewHolder.tag.cardview.strokeWidth=1
      local Color = luajava.bindClass "android.graphics.Color"
      viewHolder.tag.cardview.strokeColor=Color.parseColor("#00000000")--colorPrimary)
      viewHolder.tag.Small_label.setTextColor(Color.parseColor("#00000000"))--colorPrimary))
      -- viewHolder.tag.cardview.setVisibility(this.uiManager.viewPager.GONE)
    end
    if viewHolder.tag.tag.text ~= "" then
      viewHolder.tag.tag.setVisibility(this.uiManager.viewPager.VISIBLE)
    end
  end
})
--设置适配器
recycler_view.adapter=adapter
local function html转义(content)
  local content=content:gsub("amp;","") or content;
  local content=content:gsub("&nbsp;"," ") or content;
  local content=content:gsub("&lt;","<") or content;
  local content=content:gsub("&gt;",">") or content;
  local content=content:gsub("&amp;","&") or content;
  local content=content:gsub("&quot;",'"') or content;
  local content=content:gsub("&#39;","'") or content;
  local content=content:gsub("&#47","/") or content;
  local content=content:gsub("#x27","\\") or content;
  local content=content:gsub("&#x60","`") or content;
  local content=content:gsub("&copy","©") or content;
  return content
end

local function Picture_processing(url)
  if url:match(".+online_admin") then
    Administrator=Administrator+1
    return "管理员"
   elseif url:match(".+online_supermod") then
    Super_moderator=Super_moderator+1
    return "超级版主"
   elseif url:match(".+online_moderator") then
    Moderator=Moderator+1
    return "版主"
   elseif url:match(".+online_member") then
    Moember=Moember+1
    return "会员"
  end
end
function Initialization(v)
  adapter.clear()
  Administrator = 0
  Super_moderator = 0
  Moderator = 0
  Moember = 0
  local url="https://bbs.binmt.cc/forum.php?showoldetails=yes#online"
  local ua={["User-Agent"]="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.87 Safari/537.36"}
  Http.get(url,登录参数,"UTF-8",ua,function(code,body,cookie,header)
    if code==200 then
      --print(body)
      local nr=body:match('id="online"(.-)</div>')
      local zx,hy,ys,yk=nr:match('class="xs1">.-<strong>(.-)</strong>.-<strong>(.-)</strong>.-<strong>(.-)</strong>.-<strong>(.-)</strong>')
      local body=body:match('id="onlinelist"(.+)fixed_top_nv')
      if body then
        --print(body)
        local body=body:gmatch("<li(.-)</li>")
        for v in body do -- 正则匹配循环获取指定内容
          -- local uid=v:match('uid%-(.+)%.html')
          -- local username=v:match("<a.+>(.-)</a>")
          local reason=v:match('title="(.-)">')
          local url,username=v:match('href="(.-)">(.-)</a>')
          local uid=url:match('uid%-(.+)%.html')
          local src=v:match('src="(.-)"')
          adapter.add({
            Image_Avatar="https://bbs.binmt.cc/uc_server/avatar.php?uid="..uid.."&size=middle",
            Name=username,title=reason,uid=uid,Small_label=Picture_processing(src)
          })
        end
        local data=adapter.Data
        table.insert(data,1,{tag="在线人数："..zx.."\n会员人数："..Moember.."\n管理员人数："..Administrator.."\n超级版主人数："..Super_moderator.."\n版主人数："..Moderator.."\n隐身人数："..ys.."\n游客人数："..yk})
        adapter.notifyDataSetChanged()
        refresh.refreshing=false
       else
        print("获取失败")
        refresh.refreshing=false
      end
     else
      refresh.refreshing=false
      print("失败："..code)
    end
  end)
end
Initialization()
refresh.setColorSchemeColors({强调色})
.setProgressViewEndTarget(true,activity.getHeight()*0.12)
.setOnRefreshListener{
  onRefresh=function()
    Initialization()
  end
}
refresh.setRefreshing(true);
