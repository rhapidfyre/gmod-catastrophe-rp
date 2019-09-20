--[[

	notrade = Can't be dropped or traded
	tradeskill = Used in a recipe for a tradeskill
	unique = Player can only have one in their inventory
	quest = Used in a quest, notification property only
	amount = how many to award per drop
	chance = percent chance 0.01 - 100 to drop on kill (85 = 85% chance to drop)
	
]]

local loot_generic = {}
	loot_generic["npc_antlion"] = {
		[1] = {
			["name"] = "Antlion Parts",
			["desc"] = "Sell to a Junk Dealer!",
			["model"] = "models/gibs/antlion_gib_large_1.mdl",
			["weight"] = 0.2,
			["notrade"] = false,
			["tradeskill"] = false,
			["unique"] = false,
			["quest"] = false,
			["amount"] = 1,
			["buy_high"] = 1,
			["buy_low"] = 1,
			["chance"] = 85
		},
		[2] = {
			["name"] = "Sulfur",
			["desc"] = "Used to create Gunpowder",
			["model"] = "models/props_wasteland/prison_toiletchunk01f.mdl",
			["weight"] = 0.01,
			["notrade"] = false,
			["tradeskill"] = true,
			["unique"] = false,
			["quest"] = false,
			["amount"] = 1,
			["buy_high"] = 1,
			["buy_low"] = 1,
			["chance"] = 50
		},
		[3] = {
			["name"] = "Bone Fragments",
			["desc"] = "Sell to a Junk Dealer",
			["model"] = "models/gibs/hgibs_scapula.mdl",
			["weight"] = 0.5,
			["notrade"] = false,
			["tradeskill"] = false,
			["unique"] = false,
			["quest"] = false,
			["amount"] = 1,
			["buy_high"] = 3,
			["buy_low"] = 2,
			["chance"] = 20
		},
		[4] = {
			["name"] = "Metal Fragments",
			["desc"] = "Used in various tradeskills",
			["model"] = "models/props_c17/canisterchunk01i.mdl",
			["weight"] = 0.1,
			["notrade"] = false,
			["tradeskill"] = false,
			["unique"] = false,
			["quest"] = false,
			["amount"] = 1,
			["buy_high"] = 3,
			["buy_low"] = 2,
			["chance"] = 20
		}
	}
	loot_generic["npc_zombie"] = {
		[1] = {
			["name"] = "Sulfur",
			["desc"] = "Used to create Gunpowder",
			["model"] = "models/props_wasteland/prison_toiletchunk01f.mdl",
			["weight"] = 0.01,
			["notrade"] = false,
			["tradeskill"] = true,
			["unique"] = false,
			["quest"] = false,
			["amount"] = 1,
			["buy_high"] = 1,
			["buy_low"] = 1,
			["chance"] = 50
		},
		[2] = {
			["name"] = "Bone Fragments",
			["desc"] = "models/gibs/hgibs_scapula.mdl",
			["model"] = "",
			["weight"] = 0.5,
			["notrade"] = false,
			["tradeskill"] = false,
			["unique"] = false,
			["quest"] = false,
			["amount"] = 1,
			["buy_high"] = 1,
			["buy_low"] = 1,
			["chance"] = 20
		},
		[3] = {
			["name"] = "Human Skull",
			["desc"] = "models/gibs/hgibs.mdl",
			["model"] = "",
			["weight"] = 1,
			["notrade"] = false,
			["tradeskill"] = false,
			["unique"] = false,
			["quest"] = false,
			["amount"] = 1,
			["buy_high"] = 1,
			["buy_low"] = 1,
			["chance"] = 10
		},
		[3] = {
			["name"] = "Unidentified Drugs",
			["desc"] = "models/props_lab/jar01b.mdl",
			["model"] = "",
			["weight"] = 1,
			["notrade"] = false,
			["tradeskill"] = false,
			["unique"] = false,
			["quest"] = false,
			["amount"] = 1,
			["buy_high"] = 1,
			["buy_low"] = 1,
			["chance"] = 5
		}
	}
	loot_generic["misc"] = {
		[1] = {
			["name"] = "Sulfur",
			["desc"] = "Used to create Gunpowder",
			["model"] = "models/props_wasteland/prison_toiletchunk01f.mdl",
			["weight"] = 0.01,
			["notrade"] = false,
			["tradeskill"] = true,
			["unique"] = false,
			["quest"] = false,
			["amount"] = 1,
			["buy_high"] = 1,
			["buy_low"] = 1,
			["chance"] = 5
		}
	}
	loot_generic["human"] = {
		[1] = {
			["name"] = "Sulfur",
			["desc"] = "Used to create Gunpowder",
			["model"] = "models/props_wasteland/prison_toiletchunk01f.mdl",
			["weight"] = 0.01,
			["notrade"] = false,
			["tradeskill"] = true,
			["unique"] = false,
			["quest"] = false,
			["amount"] = 1,
			["buy_high"] = 1,
			["buy_low"] = 1,
			["chance"] = 5
		}
	}
	loot_generic["xen"] = {
		[1] = {
			["name"] = "Sulfur",
			["desc"] = "Used to create Gunpowder",
			["model"] = "models/props_wasteland/prison_toiletchunk01f.mdl",
			["weight"] = 0.01,
			["notrade"] = false,
			["tradeskill"] = true,
			["unique"] = false,
			["quest"] = false,
			["amount"] = 1,
			["buy_high"] = 1,
			["buy_low"] = 1,
			["chance"] = 5
		}
	}

function GenLootTable(npc_class)
	local tbl_value = loot_generic[npc_class]
	if tbl_value == nil then
		tbl_value = loot_generic["misc"]
	end
	return tbl_value
end