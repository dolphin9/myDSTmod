local assets =
{
    Asset("ANIM", "anim/cave_banana_tree.zip"),
    Asset("MINIMAP_IMAGE", "cave_banana_tree_stump"),
    Asset("MINIMAP_IMAGE", "cave_banana_tree_burnt"),
}

local prefabs_bush =
{
    "xianguo"
}


local bush_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
   --inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeSmallObstaclePhysics(inst, .25)
    
    inst.MiniMapEntity:SetIcon("xianguo_bush.png")  -- 小地图图片

    inst:AddTag("plant")
    inst:AddTag("bush")

    inst.AnimState:SetBank("xianguo_bush")      -- 动画
    inst.AnimState:SetBuild("xianguo_bush")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2) ---????

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
    inst.components.pickable:SetUp("xianguo", TUNING.CAVE_BANANA_GROW_TIME) --
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    inst.components.pickable.makefullfn = makefullfn
--------------上面这堆函数要自己写

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(tree_chopped)
    inst.components.workable:SetOnWorkCallback(tree_chop)

    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    ---------------------
    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
    MakeNoGrowInWinter(inst)
    ---------------------

    inst.components.burnable:SetOnIgniteFn(tree_startburn)
    inst.components.burnable:SetOnBurntFn(tree_burnt)

    inst.OnSave = tree_onsave
    inst.OnLoad = tree_onload

    return inst

end


return Prefab("xianguo_bush", bush_fn, assets, prefabs_bush),