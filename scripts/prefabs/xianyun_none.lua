local assets =
{
	Asset( "ANIM", "anim/xianyun.zip" ),
	Asset( "ANIM", "anim/ghost_xianyun_build.zip" ),
}

local skins =
{
	normal_skin = "xianyun",
	ghost_skin = "ghost_xianyun_build",
}

local base_prefab = "xianyun"

local tags = {"BASE" ,"XIANYUN", "CHARACTER"}

return CreatePrefabSkin("xianyun_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	skin_tags = tags,
	
	build_name_override = "xianyun",
	rarity = "Character",
})