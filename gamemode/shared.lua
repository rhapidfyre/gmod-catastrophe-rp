
include("sh_vars.lua")
for _, v in pairs(file.Find("catastropherp/gamemode/sh/*.lua","LUA")) do include("sh/" .. v) end
for _, v in pairs(file.Find("catastropherp/gamemode/sh/items/*.lua","LUA")) do include("sh/items/" .. v) end
for _, v in pairs(file.Find("catastropherp/gamemode/sh/loot/*.lua","LUA")) do include("sh/loot/" .. v) end
for _, v in pairs(file.Find("catastropherp/gamemode/sh/tradeskills/*.lua","LUA")) do include("sh/tradeskills/" .. v) end


-- Credits
GM.Name 	= "Catastrophe RPG"
GM.Author	= "RhapidFyre"

function GM:OnEntityCreated(ent)

	if CLIENT then
	if ent:GetClass() == "class C_ClientRagdoll" then
		ent:Remove()
	end
	end

	if ent:IsNPC() or ent:IsPlayer() then
		ent:InstallDataTable()
		ent:NetworkVar("Int",0,"Strength")
		ent:NetworkVar("Int",1,"Constitution")
		ent:NetworkVar("Int",2,"Stamina")
		ent:NetworkVar("Int",3,"Dexterity")
		ent:NetworkVar("Int",4,"Intelligence")
		ent:NetworkVar("Int",5,"Charisma")
		ent:NetworkVar("Int",6,"Level")
		ent:NetworkVar("Int",7,"StatPoints")
		ent:NetworkVar("Int",8,"Engineering")
		ent:NetworkVar("Int",9,"Demolitions")
		ent:NetworkVar("Int",10,"Researching")
		ent:NetworkVar("Int",11,"Gunsmithing")
		ent:NetworkVar("Int",12,"Scavenging")
		ent:NetworkVar("Int",13,"GroupNumber")
		ent:NetworkVar("Int",14,"Amount")
		ent:NetworkVar("Int",15,"Brewing")
		ent:NetworkVar("Int",16,"Baking")
		ent:NetworkVar("Bool",0,"Initialized")
		ent:NetworkVar("Bool",1,"Female")
		ent:NetworkVar("Bool",2,"GMProp")
		ent:NetworkVar("Bool",3,"HasBuggy")
		ent:NetworkVar("Bool",4,"HasAirboat")
		ent:NetworkVar("Float",0,"Money")
		ent:NetworkVar("Float",1,"Experience")
		ent:NetworkVar("Float",2,"NextLevel")
		ent:NetworkVar("Float",3,"Hunger")
		ent:NetworkVar("Float",4,"Thirst")
		ent:NetworkVar("Float",5,"Endurance")
		ent:NetworkVar("Float",6,"Oxygen")
		ent:NetworkVar("Float",7,"Weight")
		ent:NetworkVar("Float",8,"Bank")
		ent:NetworkVar("String",0,"GuildName")
		ent:NetworkVar("String",1,"PlayerTitle")
		ent:NetworkVar("String",2,"PropName")
		ent:NetworkVar("String",3,"PropDescription")
		ent:NetworkVar("Vector",0,"SpawnPoint")
		ent.BankInventory = {}
		ent.Inventory = {}
		ent:SetAmount(1)
		ent:SetWeight(1)
	else
		ent:InstallDataTable()
		ent:NetworkVar("Int",0,"Amount")
		ent:NetworkVar("Bool",0,"GMProp")
		ent:NetworkVar("Float",0,"Weight")
		ent:NetworkVar("String",0,"PropName")
		ent:NetworkVar("String",1,"PropDescription")
	end
	
	if SERVER then
		if ent:GetClass() == "npc_vortigaunt" then
		elseif ent:GetClass() == "npc_barney" then
			ent:SetLevel(125)
			ent:SetDexterity(124)
			ent:SetConstitution(56)
			ent:SetStamina(20)
            ent:Give("weapon_pistol")
			ent:SetKeyValue("additionalequipment", "weapon_pistol")
			ent:SetPropName("Barney Calhoun")
		elseif ent:GetClass() == "npc_breen" then
			ent:SetLevel(125)
			ent:SetDexterity(124)
			ent:SetConstitution(56)
			ent:SetStamina(20)
            ent:Give("weapon_ar2")
			ent:SetKeyValue("additionalequipment", "weapon_ar2")
			ent:SetPropName("Wallace Breen")
		elseif ent:GetClass() == "npc_kleiner" then
			ent:SetLevel(125)
			ent:SetDexterity(124)
			ent:SetConstitution(56)
			ent:SetStamina(20)
			ent:SetPropName("Dr. Kleiner")
            ent:Give("weapon_pistol")
			ent:SetKeyValue("additionalequipment", "weapon_pistol")
		elseif ent:GetClass() == "npc_gman" then
			ent:SetLevel(125)
			ent:SetDexterity(124)
			ent:SetConstitution(56)
			ent:SetStamina(20)
			ent:SetPropName("The G-Man")
		elseif ent:GetClass() == "npc_mossman" then
			ent:SetLevel(125)
			ent:SetDexterity(124)
			ent:SetConstitution(56)
			ent:SetStamina(20)
			ent:SetPropName("Dr. Mossman")
            ent:Give("weapon_pistol")
			ent:SetKeyValue("additionalequipment", "weapon_pistol")
		elseif ent:GetClass() == "npc_eli" then
			ent:SetLevel(125)
			ent:SetDexterity(124)
			ent:SetConstitution(56)
			ent:SetStamina(20)
			ent:SetPropName("Eli Vance")
            ent:Give("weapon_pistol")
			ent:SetKeyValue("additionalequipment", "weapon_pistol")
		elseif ent:GetClass() == "npc_alyx" then
			ent:SetLevel(125)
			ent:SetDexterity(124)
			ent:SetConstitution(56)
			ent:SetStamina(20)
            ent:Give("weapon_pistol")
			ent:SetKeyValue("additionalequipment", "weapon_pistol")
			ent:SetPropName("Alyx Vance")
		elseif ent:GetClass() == "npc_vortigaunt" then
			ent:SetLevel(125)
			ent:SetDexterity(124)
			ent:SetConstitution(56)
			ent:SetStamina(20)
			ent:SetPropName("A Junk Dealer")
		end
	end
	
end