
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {}

-- 初始物品
local start_inv = {
	"wuqi", --自带wuqi
	"xianguo",
	"xianguo",
	"xianguo",
	"xianguo",
	"xianguo",
}
-- 当人物复活的时候
local function onbecamehuman(inst)
	-- 设置人物的移速（1表示1倍于wilson）
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "xianyun_speed_mod", 1)
end
--当人物死亡的时候
local function onbecameghost(inst)
	-- 变成鬼魂的时候移除速度修正
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "xianyun_speed_mod")
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
	inst.MiniMapEntity:SetIcon( "xianyun.tex" )
end

local function HealingTick(inst)

	if inst.components.sanity ~= nil and inst.replica.sanity:GetCurrent() > 5 and inst.components.health ~= nil and inst.components.health:GetPercent() <1 then

		local currentSanity = inst.components.sanity:GetPercent()
		local currentHealth = inst.components.health:GetPercent()

		local sanity_penalty = math.ceil((1 - currentHealth)/0.2)
		local health_bonus = 1  --level up

		if currentSanity < .5 then
			health_bonus = health_bonus * 2
		end
		
		if inst.replica.sanity:GetCurrent() >= sanity_penalty then
			inst.components.sanity:DoDelta(sanity_penalty * -1 , true)
			inst.components.health:DoDelta(sanity_penalty * health_bonus, true, nil, true)
		end
    end

end


local function DoSelfhealing(inst)

	inst:DoPeriodicTask(3, function() HealingTick(inst) end)

end


-- 这里的的函数只在主机执行  一般组件之类的都写在这里
local master_postinit = function(inst)
	-- 人物音效
	inst.soundsname = "willow"

	--最喜欢的食物  名字 倍率（1.2）
	inst.components.foodaffinity:AddPrefabAffinity("xianguo", TUNING.AFFINITY_15_CALORIES_HUGE)
	-- 三维	
	inst.components.health:SetMaxHealth(TUNING.XIANYUN_HEALTH)
	inst.components.hunger:SetMax(TUNING.XIANYUN_HUNGER)
	inst.components.sanity:SetMax(TUNING.XIANYUN_SANITY)
	
	-- 伤害系数
    inst.components.combat.damagemultiplier = 1
	
	-- 饥饿速度
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

	DoSelfhealing(inst)
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("xianyun", prefabs, assets, common_postinit, master_postinit, start_inv)
