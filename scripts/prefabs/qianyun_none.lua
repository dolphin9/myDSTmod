local assets =
{
	Asset( "ANIM", "anim/qianyun.zip" ),
	Asset( "ANIM", "anim/ghost_qianyun_build.zip" ),
}

local skins =
{
	normal_skin = "qianyun",
	ghost_skin = "ghost_qianyun_build",
}

local base_prefab = "qianyun"

local tags = {"BASE" ,"QIANYUN", "CHARACTER"}

return CreatePrefabSkin("qianyun_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	skin_tags = tags,
	
	build_name_override = "qianyun",
	rarity = "Character",
})