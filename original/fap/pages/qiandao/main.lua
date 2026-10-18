require "import"
使用公共lua文件("libs")
import "gongyong"
应用栏标题.setText("签到 - MT论坛").setVisibility(0)
获取浏览器(0).getSettings().setUserAgentString(获取应用数据("手机UA"))
加载网页(nil,"https://bbs.binmt.cc/k_misign-sign.html")
定时器状态,定时器状态2,定时器状态3=false,false,false
function onKeyDown(keyCode, keyEvent)
  if keyCode == KeyEvent.KEYCODE_BACK then
    if 定时器状态 then
      ti.stop()
    end
    if 定时器状态2 then
      ti2.stop()
    end
    if 定时器状态3 then
      ti3.stop()
    end
    退子页面()
    return true
  end
end
传递数据=...

function 时间日期秒计算(前,后)
  local str1 = 前--"2021-11-11 11:11:11"
  local y1,m1,d1,h1,m2,s1 = string.match(str1,"(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")

  local str2 = 后--"2021-11-11 11:11:11"
  local y2,m2,d2,h2,m3,s2 = string.match(str2,"(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
  local time1 = os.time({year=tonumber(y2),month=tonumber(m2),day=tonumber(d2),hour=tonumber(h2), min=tonumber(m3), sec=tonumber(s2)})

  local time2 = os.time({year=tonumber(y1),month=tonumber(m1),day=tonumber(d1),hour=tonumber(h1), min=tonumber(m2), sec=tonumber(s1)})

  function ToolGetDayKeyByUnixTime(unixTime,hour)
    if hour == nil then hour = 0 end
    local retStr = os.date("%Y-%m-%d %H:%M:%S",unixTime)
    local time = unixTime
    local data = os.date("*t",time)
    if data.hour < hour then
      time = time - 24*60*60
    end
    local data2 = os.date("*t",time)
    data2.hour = 0
    data2.min = 0
    data2.sec = 0
    local time2 = os.time(data2)
    local dayKey = os.date("Key%Y%m%d",time2)
    local timeBase = time2
    return dayKey,retStr,timeBase
  end
  local dayKey,str = ToolGetDayKeyByUnixTime(time1,4)
  dayKey,str = ToolGetDayKeyByUnixTime(time2,4)
  function ToolNumberOfDaysInterval(unixTime1,unixTime2,dayFlagHour)
    if dayFlagHour == nil then dayFlagHour = 0 end
    local key1,str1,time1 = ToolGetDayKeyByUnixTime(unixTime1,dayFlagHour)
    local key2,str2,time2 = ToolGetDayKeyByUnixTime(unixTime2,dayFlagHour)
    local sub = math.abs(time2 - time1)/(24*60*60)
    return sub
  end
  local sub = ToolNumberOfDaysInterval(time1,time2,4)
  local sub=tointeger(sub)*24

  local h11,m11,s11 = string.match(str1,"(%d+):(%d+):(%d+)")
  local h21,m21,s21 = string.match(str2,"(%d+):(%d+):(%d+)")
  local time1 = h11 * 3600 + m11 * 60 + s11
  local time2 = h21 * 3600 + m21 * 60 + s21
  local sub=(tointeger(time2 - time1))+sub

  return tonumber(sub)
end
function v(h)
  if tointeger(h)-tointeger(os.date("%H"))==1 then
    return 01
   elseif tointeger(h)-tointeger(os.date("%H"))<0 then
    return 01
   else
    return 00
  end
end
function f(h,m)
  if tointeger(时间日期秒计算(os.date("22-01-01 00:%M:%S"),os.date("22-01-01 "..tonumber(v(h))..":"..tostring(m)..":00"))) < 600 and tointeger(时间日期秒计算(os.date("22-01-01 00:%M:%S"),os.date("22-01-01 "..tonumber(v(h))..":"..tostring(m)..":00"))) >=0 then
    获取浏览器().evaluateJavascript([[if(!document.getElementById('signresult')){
  //popup.open('今天已经签到过了 自动刷新倒计时', 'alert');
  window.androlua.callLuaFunction('print','今天已经签到过了\n自动刷新倒计时')
  }else{
  //popup.open('开始倒计时咯', 'alert');
  window.androlua.callLuaFunction('print','开始倒计时咯')
  }]],function end)
    import"cjson"
    获取浏览器().evaluateJavascript("_=()=>document.body.innerText;_()",{
      onReceiveValue=function(content)
        content=cjson.decode(content)
        point=content:match'累计签到\n.+天\n(.-)\n今日排行'
        --  print(point)
        if point=="已签到" then
          ti2=Ticker()
          ti2.Period=100
          ti2.onTick=function()
            if ltime==tointeger(时间日期秒计算(os.date("22-01-01 00:%M:%S"),os.date("22-01-01 "..tonumber(v(h))..":"..tostring(m)..":00"))) then
              -- print(ltime)
              task(200,function()
                刷新网页()
              end)
              ti2.stop()
            end
          end
          --启动Ticker定时器
          ti2.start()
          定时器状态2=true
        end
      end,})
    local a=0
    ti=Ticker()
    ti.Period=100
    ti.onTick=function()
      if tointeger(os.date("%M")) ==tointeger(m) then
        ti3=Ticker()
        ti3.Period=500
        ti3.onTick=function()
          if a<= 4 then
            获取浏览器().evaluateJavascript([[
          if(document.getElementById('signresult')){
          document.getElementById('signresult').click();
          }else{
          document.getElementsByClassName('f_c')[0].click();
          }]],function end)
            a=a+1
           else
            ti3.stop()
          end
        end
        --启动Ticker定时器
        ti3.start()
        定时器状态3=true
        --停止Ticker定时器
        --ti.stop()
       else
        获取浏览器().evaluateJavascript([[
     if(document.getElementById('signresult')){
         document.getElementById('signresult').innerHTML="倒计时: "+]]..时间日期秒计算(os.date("22-01-01 00:%M:%S"),os.date("22-01-01 "..tonumber(v(h))..":"..tostring(m)..":00"))..[[;
     }else{
       //  var ttxt=document.getElementsByClassName("f_c")[0].innerHTML;
         document.getElementsByClassName("f_c")[0].innerHTML="倒计时: "+]]..时间日期秒计算(os.date("22-01-01 00:%M:%S"),os.date("22-01-01 "..tonumber(v(h))..":"..tostring(m)..":00"))..[[;
     }
     ]],function end)
      end
    end
    --启动Ticker定时器
    ti.start()
    定时器状态=true
    --停止Ticker定时器
    --ti.stop()
   else
    print("只支持10分钟以内")
  end
end
function 显示时间选择弹窗()
  TimePickerDialog(activity,
  {onTimeSet=function(view, hourOfDay, minute)
      f(hourOfDay,minute)
      --print(hourOfDay.."点:"..minute.."分")
    end},tointeger(os.date("%H")), tointeger(os.date("%M")), true)
  .show()
end
function onMenuItemClick(title)
  switch(title) do
   case "签到定时"
    显示时间选择弹窗()
  end
end
左上角按钮().onClick=function(v)
  if 定时器状态 then
    ti.stop()
  end
  if 定时器状态2 then
    ti2.stop()
  end
  if 定时器状态3 then
    ti3.stop()
  end
  退子页面()
end;
右上角按钮(0,1).onClick=function(v)
  function 弹出菜单(v)
    PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")--使用布局的弹窗
    local popupMenu=PopupMenu(activity,v)
    local 主菜单=popupMenu.menu
    主菜单.add("网页查找")
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
       case "网页刷新"
        刷新网页()
       case "浏览器打开"
        浏览器打开(获取网址())
       case "复制链接"
        复制文本(获取网址())
       case "退出页面"
        if 定时器状态 then
          ti.stop()
        end
        if 定时器状态2 then
          ti2.stop()
        end
        if 定时器状态3 then
          ti3.stop()
        end
        退子页面()
      end
    end
    popupMenu.show()
    popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
  end
  弹出菜单(v)
end;
function onFloatingActionButtonClick(v)
  刷新网页()
end

绑定,自动签到=0,0
页面事件处理(nil,--可填写页面，需开预加载
function(superCall,view,url,favicon)
  --页面开始加载事件
  ltime1=System.currentTimeMillis()
end,
function(superCall,view,url)
  --页面加载结束事件
  ltime2=System.currentTimeMillis()
  ltime=(tointeger(ltime2)-tointeger(ltime1))/1000
  --print("加载用时 "..ltime.."秒 请保持网速\n如当前网速过慢，请重进本页面")
  if ltime<1.3 then
    ltime=1
   elseif ltime>1 and ltime<2 then
    ltime=2
   else
    ltime=3
  end
  if 获取应用数据("网页背景色")=="true" then
    加载Js([[document.body.style.backgroundColor = "]]..窗体背景色2..[[";]])
  end
  if 获取应用数据("显示FPS")=="true" then
    view.evaluateJavascript("Display_fps();",function end)
  end
  if 传递数据 and 自动签到==0 then
    自动签到=自动签到+1
    view.evaluateJavascript([[
          if(document.getElementById('signresult')){
          document.getElementById('signresult').click();
          }else{
          document.getElementsByClassName('f_c')[0].click();
          }]],function end)
  end
end,nil,
function(_,view,webResourceRequest)
  local url=tostring(webResourceRequest.getUrl())--链接转换
  local 登录跳转=url:match'bbs%.binmt%.cc/member%.php%?mod=logging&action=login'
  local 需绑定=url:match'bbs%.binmt%.cc/home%.php%?mod=spacecp&ac=plugin&id=comiis_sms:comiis_setup&mobile=2'
  local 好友表=url:match'bbs%.binmt%.cc/home%.php%?mod=space&uid=%d+$'
  if 登录跳转 then
    进子页面("denglu")
    return true
   elseif 需绑定 then
    if 绑定>0 then
      print2"请返回主页绑定手机号后使用"
     else
      绑定=绑定+1
    end
    return true
   elseif 好友表 then
    return true
   elseif not url:find("^https?://") and not url:find("^file://") then--判断是否是跳转外部应用链接并进行设置功能
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
end,
function(superCall,view,url)
  --页面资源加载监听
  local packagej=url:match'&formhash=(.+)&' or url:match'&formhash=(.+)'
  if packagej then
    存储应用数据("签到参数",packagej)
    print2("获取登录参数配置成功")
  end
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