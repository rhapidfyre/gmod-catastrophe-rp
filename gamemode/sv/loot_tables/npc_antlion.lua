
--[[ Antlion Loot Table
local lootOptions = {}
	lootOptions[key] = {
		["name"] = Name of the prop to be spawned
		["desc"] = Short Description of what it's for
		["weight"] = Reasonable weight amount
		["amount"] = Should be 1
		["chance"] = Percent chance to drop
		["notrade"] = Can the players drop/trade/bank this item?
		["quest"] = Is this item used in a Quest?
	lootOptions[1] = {
		["name"] = "Antlion Parts",
		["desc"] = "Sell to a Junk Dealer!",
		["model"] = "models/gibs/antlion_gib_large_1.mdl",
		["weight"] = 0.2,
		["notrade"] = false,
		["tradeskill"] = false,
		["quest"] = false,
		["amount"] = 1,
		["chance"] = 0.85
	}
	lootOptions[2] = {
		["name"] = "Sulfur",
		["desc"] = "Used to create Gunpowder",
		["model"] = "models/props_wasteland/prison_toiletchunk01f.mdl",
		["weight"] = 0.01,
		["notrade"] = false,
		["tradeskill"] = true,
		["quest"] = false,
		["amount"] = 1,
		["chance"] = 0.50
	}
	lootOptions[3] = {
		["name"] = "Bone Fragments",
		["desc"] = "models/gibs/hgibs_scapula.mdl",
		["model"] = "",
		["weight"] = 0.5,
		["notrade"] = false,
		["tradeskill"] = false,
		["quest"] = false,
		["amount"] = 1,
		["chance"] = 0.20
	}
	lootOptions[4] = {
		["name"] = "A Lost Medallion",
		["desc"] = "Quest Item",
		["model"] = "",
		["weight"] = 0.01,
		["notrade"] = true,
		["tradeskill"] = false,
		["quest"] = true,
		["amount"] = 1,
		["chance"] = 0.05
	}

-- Returns table
function AntlionLoot()
	return lootOptions
end]]
