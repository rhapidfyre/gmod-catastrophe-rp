--[[

	notrade = Can't be dropped or traded
	tradeskill = Used in a recipe for a tradeskill
	unique = Player can only have one in their inventory
	quest = Used in a quest, notification property only
	amount = how many to award per drop
	chance = percent chance 0.01 - 100 to drop on kill (85 = 85% chance to drop)
	
]]

local loot_generic = {
	["npc_antlion"] = {
		[1] = jk_antlion_parts,
		[2] = tr_sulfur_rare,
		[3] = jk_bonefrags,
		[4] = tr_ameat
	},
	["npc_zombie"] = {
		[1] = tr_sulfur,
		[2] = jk_bonefrags,
		[3] = jk_skull_human,
		[4] = tr_zmeat,
		[5] = tr_drugs
	},
	["npc_combine_s"] = {
		[1] = tr_sulfur,
		[2] = tr_drugs,
		[3] = item_ar2_ammo,
		[4] = item_ar2,
		[5] = tr_metalfrags
	},
	["npc_metropolice"] = {
		[1] = tr_sulfur,
		[2] = tr_drugs,
		[3] = item_pistol_ammo,
		[4] = tr_metalfrags
	},
	["npc_citizen"] = {
		[1] = tr_sulfur,
		[2] = tr_drugs,
		[3] = item_smg,
		[4] = item_smg_ammo,
		[5] = tr_metalfrags
	},
	["npc_headcrab"] = {
		[1] = tr_cmeat
	},
	["misc"] = {
		[1] = tr_sulfur,
		[2] = jk_bonefrags
	},
	["human"] = {
		[1] = tr_sulfur
	},
	["xen"] = {
		[1] = tr_sulfur
	}
}