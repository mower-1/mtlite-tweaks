--[[**
 * @Name: Function_bottom.lua
 * @Date: 2022-02-06 10:35:16
 * @Description: No special instructions
 *
**]]

-- load the "import" module,
-- which is use to import Java class and lua module
require "import"

-- Android base class library
-- if you don't need these, please remove them
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.Color"
-- Inflate the layout for this page
-- activity.setContentView(loadlayout(layout))

-- this page using the provided parameters.
-- args=...
local uiManager=this.uiManager
local colors=uiManager.getColors()
import "android.content.res.ColorStateList"
colorRipple=ColorStateList.valueOf(0x44444444)
--[[
local function 波纹(id,颜色)
  import "android.content.res.ColorStateList"
  local attrsArray = {android.R.attr.selectableItemBackgroundBorderless}
  local typedArray =activity.obtainStyledAttributes(attrsArray)
  ripple=typedArray.getResourceId(0,0)
  Pretend=activity.Resources.getDrawable(ripple)
  Pretend.setColor(ColorStateList(int[0].class{int{}},int{颜色}))
  id.setBackground(Pretend.setColor(ColorStateList(int[0].class{int{}},int{颜色})))
end
]]
local function 波纹(id, color)
  import "android.content.res.ColorStateList"
  import "android.graphics.drawable.RippleDrawable"
  -- 创建波纹效果
  local colorStateList = ColorStateList.valueOf(color)
  local rippleDrawable = RippleDrawable(colorStateList, nil, nil)
  id.setBackground(rippleDrawable)
end
-- TODO :
local function Input_field(a)
  import "android.content.res.ColorStateList"
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
      prefixText="* ",
      prefixTextColor=ColorStateList.valueOf(0xffff0000),
      --suffixText="后缀文本",
      --error="错误提示",
      layout_width="match",
      hint="请输入"..a,--设置输入框提示文本
      {TextInputEditText,
        id="edit_text",
        singleLine=true;--设置单行输入，禁止换行
        layout_height="wrap",
        layout_width="match",
      },
    },
    {TextInputLayout,
      --id="input_layout",
      layout_height="wrap",
      layout_marginLeft="20dp",
      layout_marginRight="20dp",
      --suffixText="后缀文本",
      --error="错误提示",
      layout_width="match",
      hint="请输入名称",--设置输入框提示文本
      {TextInputEditText,
        id="edit_text2",
        singleLine=true;--设置单行输入，禁止换行
        layout_height="wrap",
        layout_width="match",
      },
    },
  }

  local dialog=AlertDialog.Builder(activity)
  .setTitle(a.." 超链接")
  .setView(loadlayout(view_table))
  .setPositiveButton("确定",nil)
  .setNegativeButton("取消",nil)
  .show()
  task(100,function()
    local Context = luajava.bindClass "android.content.Context"
    import "android.view.inputmethod.InputMethodManager"
    edit_text.getContext().getSystemService(Context.INPUT_METHOD_SERVICE).toggleSoftInput(0,InputMethodManager.HIDE_NOT_ALWAYS)
    edit_text.requestFocus()
  end)
  dialog.getButton(AlertDialog.BUTTON1).onClick=function()
    local text=edit_text.text
    if text=="" then
      input_layout.setError(a.."不可为空")
     else
      local text2=edit_text2.text
      if text2=="" then
        text2=text
      end
      if a== "URL" then
        加载Js([[
          insertText(document.getElementById('needmessage'),"[url=]]..text..']'..text2..[[[/url]\n");
        ]])
       else
        加载Js([[
          insertText(document.getElementById('needmessage'),"[email=]]..text..']'..text2..[[[/email]\n");
        ]])
      end
      dialog.hide()
    end
  end
  edit_text.addTextChangedListener{
    onTextChanged=function()
      --事件
      if edit_text.text=="" then
        input_layout.setError(a.."不可为空")
       else
        input_layout.setError(null)
      end
    end
  }
end
function 选色器对话框(选项)
  function CircleButton(view,InsideColor)
    import "android.graphics.drawable.GradientDrawable"
    drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(InsideColor)
    drawable.setCornerRadii({360,360,360,360,360,360,360,360});
    view.setBackgroundDrawable(drawable)
  end
  import "com.google.android.material.card.MaterialCardView"
  local yuxuan={
    LinearLayout;
    orientation="vertical";
    layout_height="fill";
    layout_width="fill";
    gravity="center",
    {
      MaterialCardView,
      layout_height="100dp";
      layout_width="100dp";
      id="mmp5",
    };
    {
      TextView,
      text="#000000",
      id="mmp4",
      layout_width="80%w";
      layout_height="50dp";
      gravity="center",
    };
    --滑条一
    {
      FrameLayout;
      layout_height="50dp";
      layout_width="fill";
      {
        TextView,
        text="R",
        layout_gravity="left",
        layout_width="10%w";
        layout_height="50dp";
        gravity="center",
      };
      {
        SeekBar;
        id="seek_red";
        max=255;
        progress=1;
        layout_gravity="center",
        layout_width="70%w";
        layout_height="50dp";
      },
      {
        TextView,
        layout_gravity="right",
        text="00",
        id="mmp1",
        layout_width="10%w";
        layout_height="50dp";
        gravity="center",
      };
    },
    --滑条二
    {
      FrameLayout;
      layout_height="50dp";
      layout_width="fill";
      {
        TextView,
        layout_gravity="left",
        text="G",
        layout_width="10%w";
        layout_height="50dp";
        gravity="center",
      };
      {
        SeekBar;
        id="seek_green";
        max=255;
        progress=1;
        layout_gravity="center",
        layout_width="70%w";
        layout_height="50dp";
      },
      {
        TextView,
        text="00",
        id="mmp2",
        layout_gravity="right",
        layout_width="10%w";
        layout_height="50dp";
        gravity="center",
      };
    },
    --滑条三
    {
      FrameLayout;
      layout_height="50dp";
      layout_width="fill";
      {
        TextView,
        text="B",
        layout_gravity="left",
        layout_width="10%w";
        layout_height="50dp";
        gravity="center",
      };
      {
        SeekBar;
        max=255;
        progress=1;
        id="seek_blue";
        layout_gravity="center",
        layout_width="70%w";
        layout_height="50dp";
      },
      {
        TextView,
        text="00",
        layout_gravity="right",
        id="mmp3",
        layout_width="10%w";
        layout_height="50dp";
        gravity="center",
      };
    },
  }
  local 取色器=loadlayout(yuxuan)
  local PorterDuff = luajava.bindClass "android.graphics.PorterDuff"
  local PorterDuffColorFilter = luajava.bindClass "android.graphics.PorterDuffColorFilter"
  seek_red.ProgressDrawable.setColorFilter(PorterDuffColorFilter(0xFFFF0000,PorterDuff.Mode.SRC_ATOP))
  seek_red.Thumb.setColorFilter(PorterDuffColorFilter(0xFFFF0000,PorterDuff.Mode.SRC_ATOP))

  seek_green.ProgressDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FF00,PorterDuff.Mode.SRC_ATOP))
  seek_green.Thumb.setColorFilter(PorterDuffColorFilter(0xFF00FF00,PorterDuff.Mode.SRC_ATOP))

  seek_blue.ProgressDrawable.setColorFilter(PorterDuffColorFilter(0xFF0000FF,PorterDuff.Mode.SRC_ATOP))
  seek_blue.Thumb.setColorFilter(PorterDuffColorFilter(0xFF0000FF,PorterDuff.Mode.SRC_ATOP))

  CircleButton(mmp5,0xFF000000)
  --SeekBar绑定监听(一个接口，三个方法)
  seek_red.setOnSeekBarChangeListener{
    onProgressChanged=function(SeekBar,progress)
      local progress=progress+1
      local a=string.upper(Integer.toHexString(progress-1))
      if #a==1 then
        a="0"..a
      end
      mmp1.setText(a)
      local d=mmp1.getText()..mmp2.getText()..mmp3.getText()
      mmp4.setText("#"..d)
      CircleButton(mmp5,int("0xFF"..d))
    end
  }

  seek_green.setOnSeekBarChangeListener{
    onProgressChanged=function(SeekBar,progress)
      local progress=progress+1
      local b=string.upper(Integer.toHexString(progress-1))
      if #b==1 then
        b="0"..b
      end
      mmp2.setText(b)
      local d=mmp1.getText()..mmp2.getText()..mmp3.getText()
      mmp4.setText("#"..d)
      CircleButton(mmp5,int("0xFF"..d))
    end
  }

  seek_blue.setOnSeekBarChangeListener{
    onProgressChanged=function(SeekBar,progress)
      local progress=progress+1
      local c=string.upper(Integer.toHexString(progress-1))
      if #c==1 then
        c="0"..c
      end
      mmp3.setText(c)
      local d=mmp1.getText()..mmp2.getText()..mmp3.getText()
      mmp4.setText("#"..d)
      CircleButton(mmp5,int("0xFF"..d))
    end
  }
  local dialog=AlertDialog.Builder(activity)
  .setView(取色器)
  .setTitle(选项.."选色器")
  .setPositiveButton("确定", {
    onClick=function(view)
      if 选项=="文字" then
        加载Js([[
        var str = window.getSelection().toString();
        //var strtxt=document.getElementById("needmessage").value;
        if (str){
            changeText("needmessage","[color=]]..mmp4.getText()..[[]","[/color]")
            //insertText(document.getElementById('needmessage'),"[color=]]..mmp4.getText()..[[]"+str+"[/color]");
            //document.getElementById("needmessage").value=strtxt.replace(str,"[color=]]..mmp4.getText()..[[]"+str+"[/color]");
        }else{
             //popup.open('请选中一段文字', 'alert');
             insertText(document.getElementById('needmessage'),"[color=]]..mmp4.getText()..[[][/color]");
        }
        ]])
       else
        加载Js([[
        var str = window.getSelection().toString();
        //var strtxt=document.getElementById("needmessage").value;
        if (str){
            changeText("needmessage","[backcolor=]]..mmp4.getText()..[[]","[/backcolor]")
            //insertText(document.getElementById('needmessage'),"[backcolor=]]..mmp4.getText()..[[]"+str+"[/backcolor]");
            //document.getElementById("needmessage").value=strtxt.replace(str,"[backcolor=]]..mmp4.getText()..[[]"+str+"[/backcolor]");
        }else{
             //popup.open('请选中一段文字', 'alert');
             insertText(document.getElementById('needmessage'),"[backcolor=]]..mmp4.getText()..[[][/backcolor]");
        }
        ]])
      end
    end
  })
  .setNeutralButton("取消",nil)
  .show()
end
function copy(text)
  activity.getSystemService("clipboard").text=text
  print("已复制链接")
end

local allowSuffixes = {"jpeg","jpg","png","gif","tif","bmp","ico","psd","webp"}
local maxSize = 6291456

--获取文件后缀名
function getFileExtension(file)
  local String = luajava.bindClass "java.lang.String"
  local name = String(file.getName())
  return name.substring(name.lastIndexOf(".")+1)
end
function indexOf(value,tbl)
  for k,v in pairs(tbl) do
    if v == value then
      return true;
    end
  end
  return false;
end
local function Http_upload(fileSrc,zhacai)
  import "okhttp3.*"
  print("上传中,请稍后")
  if fileSrc then
    local File = luajava.bindClass "java.io.File"
    local path=File(fileSrc)
    if not indexOf(getFileExtension(path),allowSuffixes) then
      print("不支持的文件格式",path.getName())
      return
    end
    if path.length() > maxSize then
      print("图片",path.getName(),"超出大小限制")
      return
    end
    Http.get("https://img.binmt.cc/",function(code,content,cookie,header)
      if code==200 then
        local x_csrf_token = content:match('csrf%-token" content="(.-)">')
        import "java.net.URLEncoder"

        if not x_csrf_token then
          print("错误，上传token获取为空，请重试")
          return
        end

        local URLEncoder = luajava.bindClass "java.net.URLEncoder"

        local requestBody = MultipartBody.Builder()
        .setType(MultipartBody.FORM)
        .addFormDataPart("file",URLEncoder.encode(path.getName(), "UTF-8"),
        RequestBody.create(MediaType.parse("multipart/form-data"), path))
        .build()

        local request = Request.Builder()
        .url("https://img.binmt.cc/upload")
        .header("Referer","https://img.binmt.cc/")
        .header("x-csrf-token",x_csrf_token)
        .header("Cookie",cookie)
        .post(requestBody)
        .build();
        local okhttp = OkHttpClient();
        local callx = okhttp.newCall(request);
        callx.enqueue(Callback{
          onFailure=function( call, e)
            --请求失败
            print("哦哦，失败了")
            --zhacai(String(e.body().bytes()).toString())
          end,
          onResponse=function(call, response)
            --请求成功
            local code=response.code()
            local header=response.headers()
            local data=response.body().string()
            import "java.lang.Runnable"
            activity.runOnUiThread(Runnable{
              run = function()
                zhacai(code,data,header)
              end
            })

          end
        });

       else
        print("失败:"..code)
      end
    end)
   else
    print("目录为空,该目录无法获取")
  end
end

local function Upload_pictures(fileSrc)
  Http_upload(fileSrc,function(code,data,head) --print(code,heaf)
    if code==200 then
      local cjson=require("cjson")
      local json=cjson.decode(data)
      -- print(data)
      if json.status then
        print(json.message or "如果没问题应该成功了")
        edit_text.text=tostring(json.data.links.url or "")
        copy(json.data.links.url or "")
       else
        print("失败",json.message)
      end
     else
      print("失败:"..code)
    end
  end)
end

function popup(v,i)
  ColorStateList = luajava.bindClass("android.content.res.ColorStateList")
  PopupMenu = bindClass("androidx.appcompat.widget.PopupMenu")
  local popupMenu=PopupMenu(activity,v)
  local 主菜单=popupMenu.menu
  主菜单.setOptionalIconsVisible(true)
  --主菜单.add("title1").setIcon(R.drawable.abc_ic_menu_overflow_material).setIconTintList(ColorStateList.valueOf(强调色))
  if i==1 then
    主菜单.add("QQ收藏解析")
    主菜单.add("Remit免费图床")
    主菜单.add("PICUI图床")
    主菜单.add("Imglt图床")
    主菜单.add("16图床")
    主菜单.add("imgcc云图床")
    主菜单.add("惜染外链网盘")
   elseif i==2 then
    主菜单.add("居左").setIcon(R.drawable.material_ic_keyboard_arrow_left_black_24dp).setIconTintList(ColorStateList.valueOf(强调色))
    主菜单.add("居中").setIcon(R.drawable.mtrl_ic_arrow_drop_up).setIconTintList(ColorStateList.valueOf(强调色))
    主菜单.add("居右").setIcon(R.drawable.material_ic_keyboard_arrow_right_black_24dp).setIconTintList(ColorStateList.valueOf(强调色))
  end
  popupMenu.onMenuItemClick=function(item)
    switch item.title
     case "QQ收藏解析"
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
          hint="请输入QQ收藏链接",--设置输入框提示文本
          {
            TextInputEditText,
            id="qqshoucang",
            singleLine=true;--设置单行输入，禁止换行
            layout_height="wrap",
            layout_width="match",
          },
        },
      }
      local 解析对话框=AlertDialog.Builder(activity)
      .setTitle("QQ收藏解析")
      .setView(loadlayout(view_table))
      --.setCancelable(false)--禁止使用返回按键
      .setPositiveButton("确定",nil)
      .setNegativeButton("取消",nil)
      .show()
      解析对话框.getButton(AlertDialog.BUTTON1).onClick=function()
        input_layout.setError(nil)
        if qqshoucang.text~="" then
          if qqshoucang.text:match("sharechain.qq.com") then
            print"正在解析，请稍等..."
            local 请求头={["User-Agent"]="Mozilla/5.0 (Linux; Android 9; STF-AL00 Build/HUAWEISTF-AL00; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/71.0.3578.99 Mobile Safari/537.36"}--模拟安卓浏览器访问
            Http.get(qqshoucang.text,"UTF-8",请求头,function(code,content)
              if code~=200 then
                print("网络异常，请检查网络配置"..code)
                return true
              end
              解析对话框.hide()
              print"解析成功"
              if content:match("内容可能违反相关法规") or content:match("分享资源已经删除") then
                print("远程文档失效异常")
               else
                数据=content:match("<article.->%s+(.-)%s+</article>"):gsub("<div%s+class=\"note%-content\">","")
                :gsub("<div.->","\n"):gsub("</div>","")
                :gsub("<p.->",""):gsub("</p>","\n")
                :gsub("<br%s+/>",""):gsub("&nbsp;"," ")
                :gsub("<font.->",""):gsub("</font>","")
                :gsub("<span.->",""):gsub("</span>","")
                :gsub("<a.->",""):gsub("</a>","")
                :gsub("<b.->",""):gsub("</b>","")
                :gsub("<em.->",""):gsub("</em>","")
                :gsub("<img%s+src=\"","[插入图片]("):gsub("\"%s+/>",")\n")
                :gsub("<i.->","\n"):gsub("</strike>.-</i>","")
                :gsub("<s.->",""):gsub("</s>","")
                :gsub("<u.->",""):gsub("</u>","")
                -- 提取图片链接的函数
                local function extractImageLinks(text)
                  local links = {}
                  for link in text:gmatch("%[插入图片%]%(([^%)]+)%)") do
                    table.insert(links, link)
                  end
                  return links
                end
                local imageLinks = extractImageLinks(数据)
                解析成功对话框=AlertDialog.Builder(this)
                .setTitle("图片解析直链("..#imageLinks..")")
                .setCancelable(false)--禁止使用返回按键
                .setSingleChoiceItems(imageLinks,-1,{onClick=function(v,p)
                    链接=imageLinks[p+1]
                  end})
                .setPositiveButton("确定",{onClick=function(v)
                    edit_text.setText(链接)
                  end})--弹框按钮
                .setNegativeButton("取消",nil)
                .setNeutralButton("查看图片",nil)
                .show();
                解析成功对话框.getButton(AlertDialog.BUTTON3).onClick=function()
                  对话框查看图片("查看图片",链接)
                end
              end
            end)
           else
            input_layout.setError"非QQ收藏链接无法解析"
          end
         else
          input_layout.setError("链接不可为空！")
        end
      end
     case "Remit免费图床"
      进子页面(获取应用数据("默认浏览页"),{"https://img.remit.ee/"})
     case "PICUI图床"
      进子页面(获取应用数据("默认浏览页"),{"https://picui.cn/upload"})
     case "Imglt图床"
      进子页面(获取应用数据("默认浏览页"),{"https://www.imglt.com/"})
     case "16图床"
      进子页面(获取应用数据("默认浏览页"),{"https://111666.best/"})
     case "imgcc云图床"
      进子页面(获取应用数据("默认浏览页"),{"https://www.imgcc.cloud/"})
     case "惜染外链网盘"
      进子页面(获取应用数据("默认浏览页"),{"https://www.mpimg.cn/upload.php"})
      
     case "居左"
      加载Js([[var str = window.getSelection().toString();
          if (str){
             changeText("needmessage","[align=left]","[/align]")
          }else{
             insertText(document.getElementById('needmessage'),"[align=left][/align]");
          }]])
     case "居中"
      加载Js([[var str = window.getSelection().toString();
          if (str){
             changeText("needmessage","[align=center]","[/align]")
          }else{
             insertText(document.getElementById('needmessage'),"[align=center][/align]");
          }]])
     case "居右"
      加载Js([[var str = window.getSelection().toString();
          if (str){
             changeText("needmessage","[align=right]","[/align]")
          }else{
             insertText(document.getElementById('needmessage'),"[align=right][/align]");
          }]])
    end
  end
  popupMenu.show()
  popupMenu.getClass().getDeclaredField("mPopup").setAccessible(true).get(popupMenu).getListView().getParent().setBackgroundColor(窗体背景色)
end

import "com.google.android.material.chip.Chip"
local layout={
  LinearLayout;
  layout_width="fill";
  id="bottom",
  layout_height="40dp";
  visibility='gone';--隐藏控件
  background=窗体背景色2;--布局背景
  orientation='horizontal';--布局方向
  {
    HorizontalScrollView,
    layout_width="match",
    layout_height="match_parent",
    {
      LinearLayout,
      layout_width="wrap",
      layout_height="match_parent",
      orientation="horizontal",
    },
  },
};

local viewGroup=this.uiManager.getViewPager().parent
viewGroup.addView(loadlayout(layout))
local 滚动区=bottom.getChildAt(0)
pcall(function() 滚动区.setHorizontalScrollBarEnabled(false) end)
local 快捷栏=滚动区.getChildAt(0)

local cjson=require("cjson")
local data=cjson.decode(获取应用数据("快捷菜单"))

--原来这一栏由 LuaRecyclerAdapter 托管：底栏默认 GONE，回复时切成可见，RecyclerView
--会在这一帧重建全部 ViewHolder，而 Fusion 的 Lua 适配器此时要么读到失效的 LuaTable
--（Inconsistency detected / Invalid item position），要么把布局当成 LuaFunction 强转
--LuaTable（ClassCastException），两种都是直接闪退。这里只是一组固定按钮，不需要
--回收复用，改成普通 LinearLayout 逐个添加。
local function 快捷菜单点击(itemData)
  switch(itemData.text)
   case "加粗"
    加载Js([[
        var str = window.getSelection().toString();
        //var strtxt=document.getElementById("needmessage").value;
        if (str){
            changeText("needmessage","[b]","[/b]")
            // document.getElementById("needmessage").value=strtxt.replace(str,"[b]"+str+"[/b]");
        }else{
             //popup.open('请选中一段文字', 'alert');
             insertText(document.getElementById('needmessage'),"[b][/b]");
        }
        ]])
   case "斜体"
    加载Js([[
        var str = window.getSelection().toString();
        //var strtxt=document.getElementById("needmessage").value;
        if (str){
             changeText("needmessage","[i]","[/i]")
             //document.getElementById("needmessage").value=strtxt.replace(str,"[i]"+str+"[/i]");
        }else{
             //popup.open('请选中一段文字', 'alert');
             insertText(document.getElementById('needmessage'),"[i][/i]");
        }
        ]])
   case "下划线"
    加载Js([[
        var str = window.getSelection().toString();
        //var strtxt=document.getElementById("needmessage").value;
        if (str){
             changeText("needmessage","[u]","[/u]")
             //document.getElementById("needmessage").value=strtxt.replace(str,"[u]"+str+"[/u]");
        }else{
             //popup.open('请选中一段文字', 'alert');
             insertText(document.getElementById('needmessage'),"[u][/u]");
        }
        ]])
   case "删除线"
    加载Js([[
        var str = window.getSelection().toString();
        //var strtxt=document.getElementById("needmessage").value;
        if (str){
             changeText("needmessage","[s]","[/s]")
             //document.getElementById("needmessage").value=strtxt.replace(str,"[s]"+str+"[/s]");
        }else{
             //popup.open('请选中一段文字', 'alert');
             insertText(document.getElementById('needmessage'),"[s][/s]");
        }
        ]])
   case "字号文字"
    加载Js([[
        window.androlua.callLuaFunction("print2",'文字大小可选1~9')
        //popup.open('文字大小可选1~9', 'alert');
        var str = window.getSelection().toString();
        //var strtxt=document.getElementById("needmessage").value;
        if (str){
             changeText("needmessage","[size=1~9]","[/size]")
             //document.getElementById("needmessage").value=strtxt.replace(str,"[size=1~9]"+str+"[/size]");
        }else{
             //popup.open('请选中一段文字', 'alert');
             insertText(document.getElementById('needmessage'),"[size=1~9][/size]");
        }
        ]])
   case "文本背景色"
    选色器对话框("背景")
   case "颜色文字"
    选色器对话框("文字")
   case "彩色文字"
    --[==[加载Js([[
        var str = window.getSelection().toString();
        //var strtxt=document.getElementById("needmessage").value;
        if (str){
set_rainbow(str, "0000FF","FF0000");
function set_rainbow(wr_text, wr_rgb1, wr_rgb2) { //设置彩虹文字
    var wr_code, wr_rgb, r, g, b, i, j, istep;
    var r1, g1, b1, r2, g2, b2;
    r1 = g1 = b1 = r2 = g2 = b2 = 0;
    r = 0;
    g = 0;
    b = 0;
    istep = 0;
    wr_code = '';
    istep = 40;
    r = 255;
    i = 1;
    j = 0;
    do {
        if (wr_text.charCodeAt(j) != 32) {
            if (g + istep < 256) {
                if (i == 1) g += istep;
            } else if (i == 1) {
                i = 2;
                g = 255;
            }
            if (r - istep > -1) {
                if (i == 2) r -= istep;
            } else if (i == 2) {
                i = 3;
                r = 0;
            }
            if (b + istep < 256) {
                if (i == 3) b += istep;
            } else if (i == 3) {
                i = 4;
                b = 255;
            }
            if (g - istep > -1) {
                if (i == 4) g -= istep;
            } else if (i == 4) {
                i = 5;
                g = 0;
            }
            if (r + istep < 256) {
                if (i == 5) r += istep;
            } else if (i == 5) {
                i = 6;
                r = 255;
            }
            if (b - istep > -1) {
                if (i == 6) b -= istep;
            } else if (i == 6) {
                i = 1;
                b = 0;
            }
            wr_rgb = '';
            wr_rgb += parseInt(r).toString(16).length == 1 ? 0 + parseInt(r).toString(16) : parseInt(r).toString(16);
            wr_rgb += parseInt(g).toString(16).length == 1 ? 0 + parseInt(g).toString(16) : parseInt(g).toString(16);
            wr_rgb += parseInt(b).toString(16).length == 1 ? 0 + parseInt(b).toString(16) : parseInt(b).toString(16);
            wr_rgb = wr_rgb.toUpperCase();
            wr_code += '[color=#' + wr_rgb + ']' + wr_text.charAt(j) + '[/color]';
        } else {
            wr_code += wr_text.charAt(j);
        }
        j++;
    } while ( j < wr_text.length );
    changeText("needmessage",wr_code);
    //document.getElementById("needmessage").value=strtxt.replace(wr_text,wr_code);
    }
        }else{
             //popup.open('请选中一段文字', 'alert');
             window.androlua.callLuaFunction("print2",'请选中一段文字')
        }
        ]])]==]
    加载Js([[
     var str = window.getSelection().toString();
if (str){
    set_random_gradient(str);
    
    function set_random_gradient(wr_text) { //设置随机颜色渐变文字
        var wr_code, wr_rgb, r, g, b, j, hue, saturation, lightness;
        wr_code = '';
        j = 0;
        
        // 生成随机起始色调 (0-360度)
        var startHue = Math.floor(Math.random() * 360);
        
        // 计算每个字符的色调增量，确保整个文本覆盖完整的色彩范围
        var nonSpaceChars = wr_text.replace(/ /g, '').length;
        var hueStep = 360 / (nonSpaceChars || 1);
        
        // 调整饱和度和亮度的范围，找到更好的平衡点
        // 饱和度: 70%-95% (确保颜色鲜艳)
        // 亮度: 45%-75% (避免太暗或太亮)
        var minSaturation = 70;
        var maxSaturation = 95;
        var minLightness = 45;
        var maxLightness = 75;
        
        // 随机选择饱和度和亮度，但保持在可读范围内
        var baseSaturation = minSaturation + Math.random() * (maxSaturation - minSaturation);
        var baseLightness = minLightness + Math.random() * (maxLightness - minLightness);
        
        var currentHue = startHue;
        
        do {
            if (wr_text.charCodeAt(j) != 32) {
                // 使用HSL颜色模型，通过改变色调实现平滑渐变
                // 保持饱和度和亮度在可读范围内
                wr_rgb = hslToRgb(currentHue / 360, baseSaturation / 100, baseLightness / 100);
                
                // 转换为十六进制
                var hexColor = 
                    (wr_rgb[0] << 16 | wr_rgb[1] << 8 | wr_rgb[2]).toString(16).padStart(6, '0').toUpperCase();
                
                wr_code += '[color=#' + hexColor + ']' + wr_text.charAt(j) + '[/color]';
                
                // 增加色调值，确保在0-360范围内循环
                currentHue = (currentHue + hueStep) % 360;
            } else {
                wr_code += wr_text.charAt(j);
            }
            j++;
        } while ( j < wr_text.length );
        
        changeText("needmessage",wr_code);
    }
    
    // HSL到RGB的转换函数
    function hslToRgb(h, s, l) {
        var r, g, b;
        
        if (s === 0) {
            r = g = b = l; // 灰色
        } else {
            var hue2rgb = function(p, q, t) {
                if (t < 0) t += 1;
                if (t > 1) t -= 1;
                if (t < 1/6) return p + (q - p) * 6 * t;
                if (t < 1/2) return q;
                if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
                return p;
            };
            
            var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
            var p = 2 * l - q;
            r = hue2rgb(p, q, h + 1/3);
            g = hue2rgb(p, q, h);
            b = hue2rgb(p, q, h - 1/3);
        }
        
        return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
    }
} else {
    window.androlua.callLuaFunction("print2",'请选中一段文字')
}
     ]])
   case "大小文字"
    加载Js([[
     var str = window.getSelection().toString();
if (str){
    set_random_size(str);
    
    function set_random_size(wr_text) { //设置随机大小文字
        var wr_code, j;
        wr_code = '';
        j = 0;
        
        // 定义可选的字号范围
        var sizeOptions = [1, 2, 3, 4, 5, 6];
        
        // 记录上一个字符的大小，用于避免连续重复
        var lastSize = null;
        
        do {
            if (wr_text.charCodeAt(j) != 32) {
                // 生成随机大小，但避免与上一个字符相同
                var randomSize;
                var attempts = 0;
                
                do {
                    randomSize = sizeOptions[Math.floor(Math.random() * sizeOptions.length)];
                    attempts++;
                    
                    // 如果尝试次数过多，允许重复（避免无限循环）
                    if (attempts > 3) break;
                } while (randomSize === lastSize && sizeOptions.length > 1);
                
                lastSize = randomSize;
                
                wr_code += '[size=' + randomSize + ']' + wr_text.charAt(j) + '[/size]';
            } else {
                wr_code += wr_text.charAt(j);
                // 空格不重置lastSize，这样下一个字符仍然会避免与上一个非空格字符相同
            }
            j++;
        } while ( j < wr_text.length );
        
        changeText("needmessage",wr_code);
    }
} else {
    window.androlua.callLuaFunction("print2",'请选中一段文字')
}
     ]])
   case "混合文字"
    加载Js([[
     var str = window.getSelection().toString();
if (str){
    set_mixed_style(str);
    
    function set_mixed_style(wr_text) { //设置混合样式文字
        var wr_code, j, hue, saturation, lightness;
        wr_code = '';
        j = 0;
        
        // 生成随机起始色调 (0-360度)
        var startHue = Math.floor(Math.random() * 360);
        
        // 计算每个字符的色调增量
        var nonSpaceChars = wr_text.replace(/ /g, '').length;
        var hueStep = 360 / (nonSpaceChars || 1);
        
        // 设置饱和度和亮度的范围
        var minSaturation = 70;
        var maxSaturation = 95;
        var minLightness = 45;
        var maxLightness = 75;
        
        // 随机选择饱和度和亮度
        var baseSaturation = minSaturation + Math.random() * (maxSaturation - minSaturation);
        var baseLightness = minLightness + Math.random() * (maxLightness - minLightness);
        
        // 定义可选的字号范围
        var sizeOptions = [1, 2, 3, 4, 5, 6];
        
        // 记录上一个字符的大小，用于避免连续重复
        var lastSize = null;
        
        var currentHue = startHue;
        
        do {
            if (wr_text.charCodeAt(j) != 32) {
                // 生成颜色
                var rgb = hslToRgb(currentHue / 360, baseSaturation / 100, baseLightness / 100);
                var hexColor = (rgb[0] << 16 | rgb[1] << 8 | rgb[2]).toString(16).padStart(6, '0').toUpperCase();
                
                // 生成随机大小，但避免与上一个字符相同
                var randomSize;
                var attempts = 0;
                
                do {
                    randomSize = sizeOptions[Math.floor(Math.random() * sizeOptions.length)];
                    attempts++;
                    
                    // 如果尝试次数过多，允许重复（避免无限循环）
                    if (attempts > 3) break;
                } while (randomSize === lastSize && sizeOptions.length > 1);
                
                lastSize = randomSize;
                
                // 组合颜色和大小标签
                wr_code += '[color=#' + hexColor + '][size=' + randomSize + ']' + wr_text.charAt(j) + '[/size][/color]';
                
                // 增加色调值
                currentHue = (currentHue + hueStep) % 360;
            } else {
                wr_code += wr_text.charAt(j);
            }
            j++;
        } while ( j < wr_text.length );
        
        changeText("needmessage",wr_code);
    }
    
    // HSL到RGB的转换函数
    function hslToRgb(h, s, l) {
        var r, g, b;
        
        if (s === 0) {
            r = g = b = l; // 灰色
        } else {
            var hue2rgb = function(p, q, t) {
                if (t < 0) t += 1;
                if (t > 1) t -= 1;
                if (t < 1/6) return p + (q - p) * 6 * t;
                if (t < 1/2) return q;
                if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
                return p;
            };
            
            var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
            var p = 2 * l - q;
            r = hue2rgb(p, q, h + 1/3);
            g = hue2rgb(p, q, h);
            b = hue2rgb(p, q, h - 1/3);
        }
        
        return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
    }
} else {
    window.androlua.callLuaFunction("print2",'请选中一段文字')
}
     ]])
   case "URL 超链接"
    Input_field("URL")
   case "Email 超链接"
    Input_field("Email")
   case "网络图片"
    import "android.content.res.ColorStateList"
    local TextInputLayout = luajava.bindClass "com.google.android.material.textfield.TextInputLayout"
    local TextInputEditText = luajava.bindClass "com.google.android.material.textfield.TextInputEditText"
    local view_table=
    {LinearLayout;--线性控件
      orientation='vertical';--布局方向
      layout_width="match",
      layout_height="match",
      {FrameLayout,
        layout_width="match",
        layout_height="match",
        {TextInputLayout,
          id="input_layout",
          layout_height="wrap",
          layout_marginLeft="20dp",
          layout_marginRight="20dp",
          prefixText="* ",
          prefixTextColor=ColorStateList.valueOf(0xffff0000),
          suffixText="ㅤ  ㅤ",
          --error="错误提示",
          layout_width="match",
          hint="请输入链接",--设置输入框提示文本
          {TextInputEditText,
            id="edit_text",
            singleLine=true;--设置单行输入，禁止换行
            --layout_marginRight='25dp';
            layout_height="wrap",
            layout_width="match",
          },
        },
        {
          ImageView;--图片控件
          layout_width='25dp';--图片宽度
          layout_height='25dp';--图片高度
          src='Upload';--图片路径
          id='image';--设置控件ID
          --ColorFilter='';--图片着色
          ColorFilter=副文本色2;--设置图片着色
          scaleType='fitXY';--图片拉伸
          layout_marginRight='30dp';
          --layout_marginTop='5dp';--布局顶距
          layout_gravity='center|right';--重力
        };
      },
      {
        CheckBox;--复选控件
        layout_width='fill';--控件宽度
        layout_height='fill';--控件高度
        id="check",
        layout_marginLeft="18dp",
        text='点击图片，打开图片链接';--显示文字
        textSize='16sp';--文字大小
        textColor=副文本色2;--文字颜色
      };
    }

    local dialog=AlertDialog.Builder(activity)
    .setTitle("网络图片")
    .setView(loadlayout(view_table))
    .setPositiveButton("确定",nil)
    .setNegativeButton("取消",nil)
    .setNeutralButton("其他图床",nil)
    .show()
    task(100,function()
      local Context = luajava.bindClass "android.content.Context"
      import "android.view.inputmethod.InputMethodManager"
      edit_text.getContext().getSystemService(Context.INPUT_METHOD_SERVICE).toggleSoftInput(0,InputMethodManager.HIDE_NOT_ALWAYS)
      edit_text.requestFocus()
    end)
    dialog.getButton(AlertDialog.BUTTON1).onClick=function()
      local text=edit_text.text
      if text=="" then
        input_layout.setError("链接不可为空")
       else
        if check.checked then
          加载Js([[
           insertText(document.getElementById('needmessage'),"[url=]]..text..'][img]'..text..[[[/img][/url]\n");
          ]])
         else
          加载Js([==[
           insertText(document.getElementById('needmessage'),"[img]]==]..text..[[[/img]\n");
          ]])
        end
        dialog.hide()
      end
    end
    dialog.getButton(AlertDialog.BUTTON3).onClick=function(v)
      popup(v,1)
    end
    edit_text.addTextChangedListener{
      onTextChanged=function()
        --事件
        if edit_text.text=="" then
          input_layout.setError("链接不可为空")
         else
          input_layout.setError(null)
        end
      end
    }
    import "android.graphics.Color"
    image.onClick=function(v)--控件点击事件
      local Intent = luajava.bindClass "android.content.Intent"
      local intent=Intent("android.intent.action.GET_CONTENT")
      .setType("image/*")
      .addCategory("android.intent.category.OPENABLE")
      activity.startActivityForResult(intent,1)
      function onActivityResult(requestCode,resultCode,data)
        if data then
          import "uri2path"
          Upload_pictures(uri2path(data.data))
        end
      end
    end;
    波纹(image,Color.parseColor(强调色2))
   case "水平线"
    加载Js([[
     insertText(document.getElementById('needmessage'),'[hr]\n');
    ]])
   case "对齐文本"
    popup(view,2)
   case "代码文本"
    加载Js([[var str = window.getSelection().toString();
          if (str){
             changeText("needmessage","[code]","[/code]")
          }else{
             insertText(document.getElementById('needmessage'),"[code][/code]");
          }]])
   case "引用文本"
    加载Js([[var str = window.getSelection().toString();
          if (str){
             changeText("needmessage","[quote]","[/quote]")
          }else{
             insertText(document.getElementById('needmessage'),"[quote][/quote]");
          }]])
   case "隐藏文本"
    加载Js([[var str = window.getSelection().toString();
          if (str){
             changeText("needmessage","[hide]","[/hide]")
          }else{
             insertText(document.getElementById('needmessage'),"[hide][/hide]");
          }]])
   case "表格"
    加载Js([[
     //popup.open('请自行搭配使用', 'alert');
     window.androlua.callLuaFunction("print2",'请自行搭配使用')
     insertText(document.getElementById('needmessage'),'[table][tr][td]文本[/td][/tr][/table]\n');
    ]])
   case "网络视频"
    加载Js([[var str = window.getSelection().toString();
          if (str){
             changeText("needmessage","[media=x,500,375]","[/media]")
          }else{
             insertText(document.getElementById('needmessage'),"[media=x,500,375]视频地址[/media]");
          }]])
   case "列表"
    加载Js([[
     //popup.open('请自行搭配使用', 'alert');
     window.androlua.callLuaFunction("print2",'请自行搭配使用')
     insertText(document.getElementById('needmessage'),`[list=A]
[*] list可以是字母或者数字。
[*] 他将会自动依次排列。
[/list]\n`);
    ]])
   case "联系QQ"
    加载Js([[
     insertText(document.getElementById('needmessage'),'[qq]QQ号[/qq]\n');
    ]])
   default
    加载Js([[
     insertText(document.getElementById('needmessage'),']]..itemData.Content..[[');
    ]])
  end
end

--逐个塞进横向布局。按钮数量固定（最多十几个），不需要 ViewHolder 复用。
local 密度=activity.getResources().getDisplayMetrics().density
local function dp(值) return math.floor(值*密度+0.5) end
--套一层 pcall：万一某些主题下 Chip 构造失败，也只是没有快捷按钮，不至于整页打不开
pcall(function()
  for _,项 in ipairs(data or {}) do
    local chip=Chip(activity)
    chip.setText(项.text or "")
    chip.setTextSize(15)
    chip.setTextColor(主文本色 or 0xFF000000)
    chip.setCheckable(false)
    chip.setOnClickListener(function() 快捷菜单点击(项) end)
    local lp=LinearLayout.LayoutParams(-2,-1)
    lp.leftMargin=dp(5)
    lp.rightMargin=dp(5)
    快捷栏.addView(chip,lp)
  end
end)