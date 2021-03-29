

local foods = {
    xianguo= {
        health = 10,
        hunger = 5,
        cooked_health = 5,
        cooked_hunger = 15,
        seed_weight = 0,
        perishtime = TUNING.PERISH_MED,
        cooked_perishtime = TUNING.PERISH_MED,
        sanity = 15,
        cooked_sanity = 10,
        --float_settings = float_settings,  --判断是否可以漂浮
        --cooked_float_settings = cooked_float_settings,    --判断煮熟了是否可以漂浮
        --dryable = dryable,    --是否可以晾干？
        --halloweenmoonmutable_settings = halloweenmoonmutable_settings,
        secondary_foodtype = FOODTYPE.BERRY,    -- 后期可以改成种子
        --lure_data = lure_data,
    }
}
-----------------------

local function MakeVeggie(name)
    -- 加载资源
    local assets =
    {
        Asset("ANIM", "anim/"..name..".zip"),
        Asset("IMAGE", "images/foods/"..name..".tex"),
        Asset("ATLAS", "images/foods/"..name..".xml"),
    }

    local assets_cooked =
    {
        Asset("ANIM", "anim/"..name..".zip"),
        Asset("IMAGE", "images/foods/"..name.."_cooked.tex"),
        Asset("ATLAS", "images/foods/"..name.."_cooked.xml"),  --*********此处要改
    }

    --预制物列表
    local prefabs =
    {
        name .."_cooked",
        "spoiled_food",
    }

    -----如果有种子的话
    --[[
    if has_seeds then
        table.insert(prefabs, name.."_seeds")
    end
    local seeds_prefabs = has_seeds and { "farm_plant_"..name } or nil

    -----如果要做大号作物的话
    local assets_oversized = {}
    if has_seeds then
        table.insert(prefabs, name.."_oversized")
        table.insert(prefabs, name.."_oversized_waxed")
        table.insert(prefabs, name.."_oversized_rotten")
        table.insert(prefabs, "splash_green")
        
        table.insert(assets_oversized, Asset("ANIM", "anim/"..PLANT_DEFS[name].build..".zip"))
    end
    
    -----生成种子实体(等要用的时候再去veggies抄吧)
    local function fn_seeds()
    end
    ]]--

    local function fn()
        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("idle")

        -- 可烹饪
        inst:AddTag("cookable")  
        -- 是否可以漂浮（可以）
        MakeInventoryFloatable(inst)
     
        --如果有种子
        --[[        
        if not SEEDLESS[name] then
            --weighable (from weighable component) added to pristine state for optimization
            inst:AddTag("weighable_OVERSIZEDVEGGIES")
        end
        ]]

        inst.entity:SetPristine() ----????

        if not TheWorld.ismastersim then
            return inst
        end

        ---- edible 食用
        inst:AddComponent("edible")
        inst.components.edible.healthvalue = foods[name].health
        inst.components.edible.hungervalue = foods[name].hunger
        inst.components.edible.sanityvalue = foods[name].sanity      
        inst.components.edible.foodtype = FOODTYPE.VEGGIE
        inst.components.edible.secondaryfoodtype = foods[name].secondary_foodtype

        --- perishable 是否可腐烂
        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(foods[name].perishtime)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        --- 可堆叠
        inst:AddComponent("stackable")
        --- 可检查
        inst:AddComponent("inspectable")
        --- 可储存
        inst:AddComponent("inventoryitem")

        MakeSmallBurnable(inst)     --可燃
        MakeSmallPropagator(inst)   --???
        
        --- 诱饵？
        inst:AddComponent("bait")
        --- 流通？
        inst:AddComponent("tradable")
        --- 烹饪
        inst:AddComponent("cookable")
        inst.components.cookable.product = name.."_cooked"

        if TheNet:GetServerGameMode() == "quagmire" then
            event_server_data("quagmire", "prefabs/foods").master_postinit(inst)
        end

        MakeHauntableLaunchAndPerish(inst) ---？？？

        return inst
    end
    
    local function fn_cooked()
        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("cooked")

        --- 可漂浮
        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(foods[name].cooked_perishtime)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = foods[name].cooked_health
        inst.components.edible.hungervalue = foods[name].cooked_hunger
        inst.components.edible.sanityvalue = foods[name].cooked_sanity or 0
        inst.components.edible.foodtype = FOODTYPE.VEGGIE
        inst.components.edible.secondaryfoodtype = foods[name].secondary_foodtype

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        ---------------------        

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")

        if TheNet:GetServerGameMode() == "quagmire" then
            event_server_data("quagmire", "prefabs/foods").master_postinit_cooked(inst)
        end

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

    local exported_prefabs = {}

    table.insert(exported_prefabs, Prefab(name, fn, assets, prefabs))
    table.insert(exported_prefabs, Prefab(name.."_cooked", fn_cooked, assets_cooked))

    return exported_prefabs
end

return unpack(MakeVeggie("xianguo"))


