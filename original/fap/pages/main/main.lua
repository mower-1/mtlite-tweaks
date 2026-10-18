require "import"
使用公共lua文件("libs")
import "gongyong"
状态栏颜色(窗体背景色)
function drawRubik()
  import "android.graphics.RectF"
  return LuaDrawable(function(c,p,d)
    local b = d.bounds
    local width = b.right
    local height = b.bottom
    local scaleState = {
      0,width/24,width/12,
      width/24,width/12,width/8,
      width/12,width/8,width/6
    }
    local directState = {true,true,true,true,true,true,true,true,true}
    local addNum = width/6/30
    p.setColor(强调色)
    return function(c)
      local t = os.clock()
      for k,v in ipairs(scaleState) do
        if directState[k] then
          directState[k]=scaleState[k]<width/6
          scaleState[k]=scaleState[k]+addNum
         else
          directState[k]=scaleState[k]<=0
          scaleState[k]=scaleState[k]-addNum
        end
      end
      c.drawRect(RectF(scaleState[1],scaleState[1],width/3-scaleState[1],height/3-scaleState[1]),p);
      c.drawRect(RectF(width/3+scaleState[2],scaleState[2],width/3*2-scaleState[2],height/3-scaleState[2]),p);
      c.drawRect(RectF(width/3*2+scaleState[3],scaleState[3],width-scaleState[3],height/3-scaleState[3]),p);
      c.drawRect(RectF(scaleState[4],height/3+scaleState[4],width/3-scaleState[4],height/3*2-scaleState[4]),p);
      c.drawRect(RectF(width/3+scaleState[5],height/3+scaleState[5],width/3*2-scaleState[5],height/3*2-scaleState[5]),p);
      c.drawRect(RectF(width/3*2+scaleState[6],height/3+scaleState[6],width-scaleState[6],height/3*2-scaleState[6]),p);
      c.drawRect(RectF(scaleState[7],height/3*2+scaleState[7],width/3-scaleState[7],height-scaleState[7]),p);
      c.drawRect(RectF(width/3+scaleState[8],height/3*2+scaleState[8],width/3*2-scaleState[8],height-scaleState[8]),p);
      c.drawRect(RectF(width/3*2+scaleState[9],height/3*2+scaleState[9],width-scaleState[9],height-scaleState[9]),p);
      d.invalidateSelf();
    end
  end)
end
local aly={
  FrameLayout;
  layout_height="fill";
  layout_width="fill";
  background=窗体背景色2;
  {
    TextView;
    layout_height="20%w";
    gravity="center";
    layout_gravity="center";
    textSize="18sp";
    layout_width="20%w";
    backgroundDrawable=drawRubik();
  };
};
--设置整体布局(aly)
PackageManager = bindClass("android.content.pm.PackageManager")
Manifest = bindClass("android.Manifest")
对话框文本 = SpannableStringBuilder("欢迎使用Mt论坛Lite，根据相关政策规定，在使用前您需要先认真阅读并同意《用户协议》与《隐私政策》及《免责声明》后才能开始使用本软件。")
对话框文本.append("\n\n")
对话框文本.append("本软件二改于Mt论坛Lite，原版已开源，如有兴趣可点击下方链接前往查看。")
对话框文本.append("\n开源地址：https://wwi.lanzouo.com/b0d1pmq7a")
对话框文本.setSpan(ClickableSpan({
  onClick=function(view)
    进子页面("xingxiye",{3})
  end,
  updateDrawState=function(ds)
    ds.setColor(强调色) --设置颜色
    ds.setUnderlineText(false) --去掉下划线
  end
}),37,43,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
对话框文本.setSpan(ClickableSpan({
  onClick=function(view)
    进子页面("xingxiye",{2})
  end,
  updateDrawState=function(ds)
    ds.setColor(强调色) --设置颜色
    ds.setUnderlineText(false) --去掉下划线
  end
}),44,50,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
对话框文本.setSpan(ClickableSpan({
  onClick=function(view)
    进子页面("xingxiye",{1})
  end,
  updateDrawState=function(ds)
    ds.setColor(强调色) --设置颜色
    ds.setUnderlineText(false) --去掉下划线
  end
}),51,57,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
对话框文本.setSpan(ForegroundColorSpan(转换颜色值("#FFFF0000")),70,108,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
对话框文本.setSpan(URLSpan("https://wwi.lanzouo.com/b0d1pmq7a"),113,146,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
对话框文本2 = SpannableStringBuilder("本软件需使用存储权限\n用于资源保存、图片保存、下载等。")
对话框文本2.setSpan(StyleSpan(1),0,27,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
function 申请权限功能()--申请权限快捷
  请求码=101
  function onRequestPermissionsResult(requestCode, permissions, grantResults)
    if requestCode==请求码 then
      local count = 0
      for i=0,#permissions-1 do
        if grantResults[i] == PackageManager.PERMISSION_GRANTED then
          count = count + 1
          if permissions[i]==Manifest.permission.WRITE_EXTERNAL_STORAGE then
            进子页面("zhuye")
            退出页面()
          end
         else
          if permissions[i]==Manifest.permission.WRITE_EXTERNAL_STORAGE then
            print("权限未通过或拉取失败，可尝试前往设置手动授予权限")
          end
        end
      end
    end
  end
  权限列表 ={
    Manifest.permission.READ_EXTERNAL_STORAGE,
    Manifest.permission.WRITE_EXTERNAL_STORAGE}
  申请权限(权限列表,请求码)
end
local function strict_url_match(text)
  local pattern = "^https?://" .. -- 协议
  "[%a%d%-]+%.[%a%d%-%.]+" .. -- 域名
  "[:%d]*" .. -- 端口
  "[/%a%d%-_~%.]*" .. -- 路径
  "[%?%a%d%-_~%.=%&%%]*" .. -- 查询参数
  "[#%a%d%-_~%.=%&%%]*" -- 锚点
  return string.match(text, pattern)
end
local 传递数据=activity.getIntent().getStringExtra("SchemeData")
if 判断是否有该权限("android.permission.WRITE_EXTERNAL_STORAGE") then
  if 传递数据 then
    if 传递数据:match("^fusion://") then
      传递数据=传递数据:match("^fusion://(.-)$")
     elseif 传递数据:match("^mtforumlite://") then
      传递数据=传递数据:match("^mtforumlite://(.-)$")
    end
    帖子=传递数据:match'bbs%.binmt%.cc/thread%-.+%-.+%-.+%.html'
    if strict_url_match(传递数据) then
      if 传递数据:match("^https://ssl.ptlogin2.qq.com/") and 传递数据:match("bbs.binmt.cc") then
        进子页面("denglu",{传递数据})
       elseif 帖子 then
        进子页面("tiezi",{传递数据})
       else
        进子页面(获取应用数据("默认浏览页"),{传递数据})
      end
     elseif 传递数据:match("/storage/emulated/0/.+.html") or 传递数据:match("/storage/emulated/0/.+.mht") or 传递数据:match("/storage/emulated/0/.+.txt") or 传递数据:match("/storage/emulated/0/.+.json") or 传递数据:match("/storage/emulated/0/.+.mp4") or 传递数据:match("/storage/emulated/0/.+.mp3") or 传递数据:match("/storage/emulated/0/.+.jpg") or 传递数据:match("/storage/emulated/0/.+.jpeg") or 传递数据:match("/storage/emulated/0/.+.png") or 传递数据:match("/storage/emulated/0/.+.gif") then
      if File(传递数据).exists() then
        进子页面(获取应用数据("默认浏览页"),{传递数据,1})
       else
        print2("路径错误或文件不存在")
      end
     elseif 传递数据:match("^search/") then
      local 传递数据=URL解码(传递数据)
      进子页面("sousuo",{传递数据:match("^search/(.-)$")})
     elseif 传递数据=="GitHub" then
      进子页面("liulanye",{"GitHub移动工作台",1})
     else
      进子页面("zhuye")
    end
   else
    进子页面("zhuye")
  end
  退出页面()
 else
  问候语=AlertDialog.Builder(this)
  .setTitle("欢迎ε(*･ω･)_/ﾟ:･☆")
  .setMessage(对话框文本)
  .setCancelable(false)
  .setPositiveButton("下一步",{onClick=function(v)
      权限申请=AlertDialog.Builder(this)
      --.setTitle("温馨提示")
      .setMessage(对话框文本2)
      .setCancelable(false)
      .setPositiveButton("同意",nil)
      .setNegativeButton("拒绝",{onClick=function(v)
          退出程序()
        end})
      .show()
      权限申请.findViewById(android.R.id.message).setTextIsSelectable(true)--文字可复制
      权限申请.getButton(AlertDialog.BUTTON1).onClick=function()
        申请权限功能()
      end
      local window =权限申请.getWindow()
      local lp =window.getAttributes()
      lp.dimAmount=0.0
      window.setAttributes(lp);
    end})
  .setNegativeButton("退出",{onClick=function(v)
      退出程序()
    end})--弹框按钮
  .show()
  local window =问候语.getWindow()
  local lp =window.getAttributes()
  lp.dimAmount=0.0
  window.setAttributes(lp);
  问候语.findViewById(android.R.id.message).setTextIsSelectable(true)--文字可复制
  --超链接&点击事件允许点击
  问候语.findViewById(android.R.id.message).setMovementMethod(LinkMovementMethod.getInstance())
end