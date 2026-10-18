require "import"
使用公共lua文件("libs")
import "gongyong"
应用栏标题.setText("小黑屋 - MT论坛").setVisibility(0)
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
import "com.scwang.smartrefresh.layout.SmartRefreshLayout"
import "com.scwang.smartrefresh.header.DeliveryHeader"
import "com.scwang.smartrefresh.header.TaurusHeader"
import "com.scwang.smartrefresh.header.DropBoxHeader"
import "com.google.android.material.card.MaterialCardView"
layout={
  SmartRefreshLayout,
  layout_width="match",
  RefreshHeader=TaurusHeader(this),
  id="TestLayout",
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
    layout_marginLeft='20dp';--布局左距
    layout_marginRight='20dp';--布局右距
    layout_width="match",
    layout_height="wrap",
    cardBackgroundColor=主色2,--卡片背景色
    cardElevation="0dp",--卡片阴影强度
    radius="12dp",--卡片圆角幅度
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
        layout_marginTop='2.5dp';--布局顶距
        gravity='left|center';--控件内容的重力方向
        {
          CircleImageView;--圆图控件
          layout_width='40dp';--控件宽度
          layout_height='40dp';--控件高度
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
            singleLine=true;--设置单行输入
            ellipsize='end';--多余文字用省略号显示
          },
          {
            TextView,
            id="Tag",
            layout_marginTop='4dp';--布局顶距
            textSize="12sp",
            textColor=副文本色2,
          },
        },
      },
      {
        LinearLayout,
        layout_width="match",
        layout_height="wrap",
        layout_marginTop='10dp';--布局顶距
        -- padding="24dp",
        Orientation=1,
        {
          LinearLayout,
          layout_width="wrap",
          layout_height="wrap",
          Orientation=2,
          gravity='center';--重力
          {
            MaterialCardView,
            id="cardview",--设置ID
            layout_height="18dp",
            layout_width="wrap",
            strokeWidth="1dp", --边框宽度
            strokeColor="#ff0000", --边框颜色
            layout_marginRight='5dp';--布局右距
            cardBackgroundColor=主色2,--卡片背景色
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
              textColor="#ff0000",
            },
          },
          {
            MaterialCardView,
            id="cardview2",--设置ID
            layout_height="18dp",
            layout_width="wrap",
            strokeWidth="1dp", --边框宽度
            strokeColor="#FFFF5D46", --边框颜色
            layout_marginRight='5dp';--布局右距
            cardBackgroundColor=主色2,--卡片背景色
            cardElevation="0dp",--卡片阴影强度
            radius="2dp",--卡片圆角幅度
            {
              TextView,
              id="Small_label2",
              textSize="12sp",
              layout_height="18dp",
              layout_width="wrap",
              --text="红包贴",
              layout_margin='2dp';
              layout_gravity='center';--重力
              textColor="#FFFF5D46",
            },
          },
        },

        {
          MaterialCardView,
          id="card2",
          layout_marginTop="10dp",
          layout_width="match",
          layout_height="wrap",
          cardBackgroundColor="#33bbbbbb",--卡片背景色
          cardElevation="0dp",--卡片阴影强度
          radius="12dp",--卡片圆角幅度
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
              layout_marginTop='2.5dp';--布局顶距
              gravity='left|center';--控件内容的重力方向
              {
                CircleImageView;--圆图控件
                layout_width='30dp';--控件宽度
                layout_height='30dp';--控件高度
                -- layout_margin='10dp';--控件外边距
                id='Image_Avatar2';--设置控件ID
                layout_gravity='center';--重力
              };
              {
                TextView,
                id="Name2",
                layout_marginLeft='10dp';--布局左距
                textSize="15sp",
                textStyle="bold",
                textColor=textColorPrimary,
                singleLine=true;--设置单行输入
                ellipsize='end';--多余文字用省略号显示
              },
            },
            {
              TextView,
              id="title",
              layout_marginTop='10dp';--布局顶距
              textSize="16sp",
              textStyle="bold",
              textColor=textColorPrimary,
            },
          },
        },
      },
    },
  },
}
--设置线性列表布局
recycler_view.layoutManager=LinearLayoutManager(activity)

local adapter=LuaRecyclerAdapter(activity,{},list_item)
--设置点击事件控件id,如果没有，则默认给列表项目父布局设置事件
--这里因为要给卡片控件设置事件，所以指定id为"card"
adapter.clickViewId="card"

adapter.setAdapterInterface(LuaRecyclerAdapter.AdapterInterface{
  onBindViewHolder=function(viewHolder,index)
    --获取控件并操作
    viewHolder.tag.card.onClick=function()
      function 弹出菜单(v,k)
        ColorStateList = bindClass("android.content.res.ColorStateList")
        PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
        local data=recycler_view.getAdapter().Data[k]
        local popupMenu=PopupMenu(activity,v)
        local 主菜单=popupMenu.menu
        主菜单.setOptionalIconsVisible(true)
        主菜单.add("处理人主页").setIcon(R.drawable.abc_ic_go_search_api_material).setIconTintList(ColorStateList.valueOf(强调色))
        主菜单.add("违规人主页").setIcon(R.drawable.abc_ic_go_search_api_material).setIconTintList(ColorStateList.valueOf(强调色))
        主菜单.add("复制文本").setIcon(R.drawable.abc_ic_menu_overflow_material).setIconTintList(ColorStateList.valueOf(强调色))
        -- 处理菜单项点击事件
        popupMenu.onMenuItemClick=function(item)
          switch item.title
           case "违规人主页"
            local id=data.uid
            进子页面("yonghu",{"https://bbs.binmt.cc/home.php?mod=space&uid="..id.."&do=profile"})
           case "处理人主页"
            local id=data.operatorid
            进子页面("yonghu",{"https://bbs.binmt.cc/home.php?mod=space&uid="..id.."&do=profile"})
           case "复制文本"
            local popupMenu2=PopupMenu(activity,v)
            local 主菜单2=popupMenu2.menu
            主菜单2.add("复制处理人UID").setIcon(R.drawable.abc_ic_menu_overflow_material).setIconTintList(ColorStateList.valueOf(强调色))
            主菜单2.add("复制违规人UID").setIcon(R.drawable.abc_ic_menu_overflow_material).setIconTintList(ColorStateList.valueOf(强调色))
            if data.title ~= "" then
              主菜单2.add("复制违规内容").setIcon(R.drawable.abc_ic_menu_overflow_material).setIconTintList(ColorStateList.valueOf(强调色))
            end
            主菜单2.add("一键复制内容").setIcon(R.drawable.abc_ic_menu_overflow_material).setIconTintList(ColorStateList.valueOf(强调色))
            popupMenu2.onMenuItemClick=function(item)
              switch item.title
               case "复制处理人UID"
                复制文本(data.operatorid)
                print2("处理人UID："..data.operatorid)
               case "复制违规人UID"
                复制文本(data.uid)
                print2("违规人UID："..data.uid)
               case "复制违规内容"
                复制文本(data.title)
                print2("违规内容："..data.title)
               case "一键复制内容"
                if data.title ~= "" then
                  一键复制="处理人："..data.Name2.."("..data.operatorid..")\n处理时间："..data.Tag.."\n处理方式："..data.Small_label.."["..(data.Small_label2):match("到期：(.-)$").."]\n\n违规人："..data.Name.."("..data.uid..")\n违规内容："..data.title
                 else
                  一键复制="处理人："..data.Name2.."("..data.operatorid..")\n处理时间："..data.Tag.."\n处理方式："..data.Small_label.."["..(data.Small_label2):match("到期：(.-)$").."]\n\n违规人："..data.Name.."("..data.uid..")"
                end
                复制文本(一键复制)
                print2(一键复制)
              end
            end
            popupMenu2.show()
            popupMenu2.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu2).getListView().getParent().setBackgroundColor(窗体背景色)
          end
        end
        popupMenu.show()
        popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
      end
      弹出菜单(viewHolder.tag.Small_label2,index+1)
    end
    switch(viewHolder.tag.title.text)
     case ""
      viewHolder.tag.title.setVisibility(this.uiManager.viewPager.GONE)
    end
    --[[if recycler_view.adapter.getItemCount() == (index + 1) then
      --print(1)
      Initialization()
    end]]
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

function Initialization(v)
  if v==1 then
    cid2=""
    adapter.clear()
   else
    cid2="&cid="..cid
  end
  local url="https://bbs.binmt.cc/forum.php?mod=misc&action=showdarkroom"..cid2.."&ajaxdata=json&t="..math.random(10000000,17999999).."&ajaxdata=json"
  Http.get(url,登录参数,"UTF-8",function(code,body,cookie,header)
    if code==200 then
      -- print(body)
      local i, ci = body:match("message\":\"(.+)|(.-)\"")
      if i == "1" then
        cid = ci
      end
      local body=body:match('"data":{(.+)}')
      if body then
        local body=body:gmatch("[0-9]*[1-9][0-9]*:{(.-)}")
        for v in body do -- 正则匹配循环获取指定内容
          local v="{"..v.."}"
          local cjson=require("cjson")
          local json=cjson.decode(v)
          --print(json.username)
          -- cid=json.cid
          --复制文本(dump(json))
          --[[{
  ["action"]	= "禁止访问" ;
  ["operator"]	= "康哥" ;
  ["groupexpiry"]	= "永不过期" ;
  ["operatorid"]	= "100" ;
  ["username"]	= "schoolyears" ;
  ["cid"]	= "25784" ;
  ["reason"]	= "发布不团结言论" ;
  ["uid"]	= "10290" ;
  ["dateline"]	= "2025-9-3 13:07" ;
  } ;]]
          adapter.add({
            Image_Avatar="https://bbs.binmt.cc/uc_server/avatar.php?uid="..json.uid.."&size=middle",
            Name=json.username,Tag=html转义(json.dateline),title=json.reason,
            Small_label=json.action,Small_label2="到期："..html转义(json.groupexpiry),
            Image_Avatar2="https://bbs.binmt.cc/uc_server/avatar.php?uid="..json.operatorid.."&size=middle",
            Name2=json.operator,uid=json.uid,operatorid=json.operatorid,
          })
        end
        TestLayout.finishRefresh()
        TestLayout.finishLoadMore()
       else
        -- cid=cid-1
        Initialization()
      end
     else
      TestLayout.finishRefresh()
      TestLayout.finishLoadMore()
      print("失败："..code)
    end
  end)
end

TestLayout.autoRefresh();--这个就是刷新一下。直接调整会刷新。
TestLayout.setEnableAutoLoadMore(true);--是否启用列表惯性滑动到底部时自动加载更多
TestLayout.setEnableLoadMoreWhenContentNotFull(true);--是否在列表不满一页时候开启上拉加载功能
TestLayout.setPrimaryColors({强调色,主色2});--他的颜色。
TestLayout.setEnableLoadMore(true);--上拉加载。
TestLayout.onRefresh=function(v)--刷新时加载事件。
  Initialization(1)
end
TestLayout.onLoadMore=function(v)--加载时加载事件。
  --print(123)
  Initialization()
end