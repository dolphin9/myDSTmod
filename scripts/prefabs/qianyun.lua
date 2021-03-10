
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
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "qianyun_speed_mod", 1)
end
--当人物死亡的时候
local function onbecameghost(inst)
	-- 变成鬼魂的时候移除速度修正
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "qianyun_speed_mod")
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
	inst.MiniMapEntity:SetIcon( "qianyun.tex" )
end

local function HealingTick(inst)

	local hunger_bonus_mult = 1
    local health_bonus_mult = 1
    local sanity_bonus_mult = 1

	local bonus_hunger_per_tick = 0
	local bonus_health_per_tick = 1
	local bonus_sanity_per_tick = -1

	local hunger_tick = bonus_hunger_per_tick * hunger_bonus_mult
    local health_tick = bonus_health_per_tick * health_bonus_mult
    local sanity_tick = bonus_sanity_per_tick * sanity_bonus_mult

	if inst.components.sanity ~= nil and inst.components.sanity:GetPercentWithPenalty() > .8 and inst.components.health ~= nil and inst.components.health:GetPercent() <1 then
        inst.components.sanity:DoDelta(sanity_tick, true)
		inst.components.health:DoDelta(health_tick, true, nil, true)
    end

end


local function DoSelfhealing(inst)

	inst:DoPeriodicTask(1, function() HealingTick(inst) end)

end


-- 这里的的函数只在主机执行  一般组件之类的都写在这里
local master_postinit = function(inst)
	-- 人物音效
	inst.soundsname = "willow"

	--最喜欢的食物  名字 倍率（1.2）
	inst.components.foodaffinity:AddPrefabAffinity("baconeggs", TUNING.AFFINITY_15_CALORIES_HUGE)
	-- 三维	
	inst.components.health:SetMaxHealth(TUNING.QIANYUN_HEALTH)
	inst.components.hunger:SetMax(TUNING.QIANYUN_HUNGER)
	inst.components.sanity:SetMax(TUNING.QIANYUN_SANITY)
	
	-- 伤害系数
    inst.components.combat.damagemultiplier = 1
	
	-- 饥饿速度
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

	DoSelfhealing(inst)
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("qianyun", prefabs, assets, common_postinit, master_postinit, start_inv)
