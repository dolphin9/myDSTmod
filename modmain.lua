GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})  --GLOBAL相关照抄

PrefabFiles = {
	"xianyun",  --人物代码文件
	"xianyun_none",  --人物皮肤
    "wuqi", --武器
}
---对比老版本 主要是增加了names图片 人物检查图标 还有人物的手臂修复（增加了上臂）
--人物动画里面有个SWAP_ICON 里面的图片是在检查时候人物头像那里显示用的


----2019.05.08 修复了 人物大图显示错误和检查图标显示错误
--2020.05.31  新加人物选人界面的属性显示信息
Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/xianyun.tex" ), --存档图片
    Asset( "ATLAS", "images/saveslot_portraits/xianyun.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/xianyun.tex" ), --单机选人界面
    Asset( "ATLAS", "images/selectscreen_portraits/xianyun.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/xianyun_silho.tex" ), --单机未解锁界面
    Asset( "ATLAS", "images/selectscreen_portraits/xianyun_silho.xml" ),

    Asset( "IMAGE", "bigportraits/xianyun.tex" ), --人物大图（方形的那个）
    Asset( "ATLAS", "bigportraits/xianyun.xml" ),
	
	Asset( "IMAGE", "images/map_icons/xianyun.tex" ), --小地图
	Asset( "ATLAS", "images/map_icons/xianyun.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_xianyun.tex" ), --tab键人物列表显示的头像
    Asset( "ATLAS", "images/avatars/avatar_xianyun.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_xianyun.tex" ),--tab键人物列表显示的头像（死亡）
    Asset( "ATLAS", "images/avatars/avatar_ghost_xianyun.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_xianyun.tex" ), --人物检查按钮的图片
    Asset( "ATLAS", "images/avatars/self_inspect_xianyun.xml" ),
	
	Asset( "IMAGE", "images/names_xianyun.tex" ),  --人物名字
    Asset( "ATLAS", "images/names_xianyun.xml" ),
	
    Asset( "IMAGE", "bigportraits/xianyun_none.tex" ),  --人物大图（椭圆的那个）
    Asset( "ATLAS", "bigportraits/xianyun_none.xml" ),

--[[---注意事项
1、目前官方自从熔炉之后人物的界面显示用的都是那个椭圆的图
2、官方人物目前的图片跟名字是分开的 
3、names_esctemplate 和 esctemplate_none 这两个文件需要特别注意！！！
这两文件每一次重新转换之后！需要到对应的xml里面改对应的名字 否则游戏里面无法显示
具体为：
降names_esctemplatxml 里面的 Element name="esctemplate.tex" （也就是去掉names——）
将esctemplate_none.xml 里面的 Element name="esctemplate_none_oval" 也就是后面要加  _oval
（注意看修改的名字！不是两个都需要修改）
	]]
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

GLOBAL.PREFAB_SKINS["xianyun"] = {   --修复人物大图显示
	"xianyun_none",
}

-- The character select screen lines  --人物选人界面的描述
STRINGS.CHARACTER_TITLES.xianyun = "东方纤云"
STRINGS.CHARACTER_NAMES.xianyun = "东方纤云"
STRINGS.CHARACTER_DESCRIPTIONS.xianyun = "*逍遥门大师兄\n*是个符修\n*是个熟练掌握flag使用方法的穿越者\n*脑子有坑"
STRINGS.CHARACTER_QUOTES.xianyun = "\"活着，才是硬道理！\""

-- Custom speech strings  ----人物语言文件  可以进去自定义
STRINGS.CHARACTERS.XIANYUN = require "speech_xianyun"

-- The character's name as appears in-game  --人物在游戏里面的名字
STRINGS.NAMES.XIANYUN = "东方纤云"
STRINGS.SKIN_NAMES.xianyun_none = "东方纤云"  --检查界面显示的名字

--武器
STRINGS.NAMES.WUQI= "武器"    --名字
STRINGS.RECIPE_DESC.WUQI = "大佬来做把武器吧"  --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WUQI = "打人老疼了"  --人物检查的描述

AddMinimapAtlas("images/map_icons/xianyun.xml")  --增加小地图图标

--增加人物到mod人物列表的里面 性别为（MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL）
AddModCharacter("xianyun", "MALE") 

--武器（配方相关）
AddRecipe("wuqi",  --添加物品的配方
{Ingredient("fish", 2),Ingredient("berries", 3)},  --材料
RECIPETABS.WAR,  TECH.SCIENCE_TWO,  --制作栏和解锁的科技（这里是战斗，需要科学二本）
nil, nil, nil, nil, nil,  --是否有placer  是否有放置的间隔  科技锁  制作的数量（改成2就可以一次做两个） 需要的标签（比如女武神的配方需要女武神的自有标签才可以看得到）
"images/inventoryimages/wuqi.xml",  --配方的贴图（跟物品栏使用同一个贴图）
"wuqi.tex")

--选人界面人物三维显示
TUNING.XIANYUN_HEALTH = 150
TUNING.XIANYUN_HUNGER = 150
TUNING.XIANYUN_SANITY = 150

--生存几率
STRINGS.CHARACTER_SURVIVABILITY.xianyun = "死不了?\n\"快划掉，这是flag！\""

--选人界面初始物品显示
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.XIANYUN = {"wuqi"}

--如果你的初始物品是mod物品需要定义mod物品的图片路径 比如物品是 abc

TUNING.STARTING_ITEM_IMAGE_OVERRIDE["wuqi"] = {
	atlas = "images/inventoryimages/wuqi.xml",
	image = "wuqi.tex",
}


