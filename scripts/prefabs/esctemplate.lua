
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {}

-- 初始物品
local start_inv = {
	"spear", --自带一个长矛
}
-- 当人物复活的时候
local function onbecamehuman(inst)
	-- 设置人物的移速（1表示1倍于wilson）
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "esctemplate_speed_mod", 1)
end
--当人物死亡的时候
local function onbecameghost(inst)
	-- 变成鬼魂的时候移除速度修正
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "esctemplate_speed_mod")
end

-- 重载游戏或者生成一个玩家的时候
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end


--这个函数将在服务器和客户端都会执行
--一般用于添加小地图标签等动画文件或者需要主客机都执行的组件（少数）
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "esctemplate.tex" )
end

-- 这里的的函数只在主机执行  一般组件之类的都写在这里
local master_postinit = function(inst)
	-- 人物音效
	inst.soundsname = "willow"

	--最喜欢的食物  名字 倍率（1.2）
	inst.components.foodaffinity:AddPrefabAffinity("baconeggs", TUNING.AFFINITY_15_CALORIES_HUGE)
	-- 三维	
	inst.components.health:SetMaxHealth(TUNING.ESCTEMPLATE_HEALTH)
	inst.components.hunger:SetMax(TUNING.ESCTEMPLATE_HUNGER)
	inst.components.sanity:SetMax(TUNING.ESCTEMPLATE_SANITY)
	
	-- 伤害系数
    inst.components.combat.damagemultiplier = 1
	
	-- 饥饿速度
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("esctemplate", prefabs, assets, common_postinit, master_postinit, start_inv)
