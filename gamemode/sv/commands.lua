
function GM:ShowSpare1(ply)
end

function GM:ShowSpare2(ply)
	ply:ConCommand("mmo_inventory")
end

-- Find and return a player object
function SelectPlayer(name)

	local pls = player.GetAll()
	
	for k,v in pairs(pls) do
		if string.find(string.lower(v:Name()), string.lower(tostring(name))) != nil then
			return v
		end
	end
	
end


concommand.Add("hateme",function(ply, cmd, args)
    for _,v in pairs(ents.FindByClass("npc_*")) do
        if v:GetClass() ~= "npc_template_maker" then
            v:AddEntityRelationship(ply, D_HT, 99)
            v:SetEnemy(ply)
            v:UpdateEnemyMemory(ply, ply:GetPos())
            v:SetSchedule(SCHED_CHASE_ENEMY)
            
            print(v:Disposition(ply))
        end
        
    end
end)
concommand.Add("howfeel",function(ply, cmd, args)
    for _,v in pairs(ents.FindByClass("npc_*")) do
        if v:GetClass() ~= "npc_template_maker" then
            print(v:GetClass() .. " -> " .. v:Disposition(ply))
        end
        
    end
end)
concommand.Add("getkvs",function(ply, cmd, args)
	local eyetrace = ply:GetEyeTrace()
    PrintTable(eyetrace.Entity:GetKeyValues())
end)
concommand.Add("getteam",function(ply, cmd, args)
	ply:PrintMessage(HUD_PRINTTALK, "You're on team #"..ply:Team())
end)
concommand.Add("settitle",function(ply, cmd, args)
	ply:SetPlayerTitle(args[1])
	ply:PrintMessage(HUD_PRINTTALK, "Title Set: "..args[1])
end)
concommand.Add("setguild",function(ply, cmd, args)
	ply:SetGuildName(args[1])
	ply:PrintMessage(HUD_PRINTTALK, "Title Set: "..args[1])
end)
concommand.Add("giveexp",function(ply, cmd, args)
	ply:Experience(args[1])
	ply:SetPData("experience", ply:Experience())
	ply:SetNWInt("experience", ply:Experience())
	ply:PrintMessage(HUD_PRINTTALK, "EXP Set: "..ply:GetNWInt("experience"))
end)
concommand.Add("getexp",function(ply, cmd, args)
	local exp = ply:GetNWInt("experience")
	if exp == nil then exp = 0 end
	ply:PrintMessage(HUD_PRINTTALK, "Experience: "..exp.." / "..ply:GetNWInt("next_level"))
end)
concommand.Add("setnext",function(ply, cmd, args)
	ply:SetPData("next_level", args[1])
	ply:SetNWInt("next_level", args[1])
	ply:NextLevel(args[1])
	ply:PrintMessage(HUD_PRINTTALK, "EXP Set: "..args[1])
end)
concommand.Add("getnext",function(ply, cmd, args)
	local exp = ply:GetNWInt("next_level")
	if exp == nil then exp = 0 end
	ply:PrintMessage(HUD_PRINTTALK, "EXP: "..exp)
end)
concommand.Add("setlevel",function(ply, cmd, args)
	ply:SetPData("level", args[1])
	ply:SetNWInt("level", args[1])
	ply:PlayerLevel(args[1])
	ply:PrintMessage(HUD_PRINTTALK, "EXP Set: "..args[1])
end)
concommand.Add("getlevel",function(ply, cmd, args)
	local lvl = ply:GetNWInt("level")
	if lvl == nil then lvl = 1 end
	ply:PrintMessage(HUD_PRINTTALK, "You are level: "..lvl)
end)

concommand.Add("dissect",function(ply, cmd, args)
	local eyetrace = ply:GetEyeTrace()
	local ent = eyetrace.Entity
	if IsValid(ent) then
		print(ent:Health().."/"..ent:GetMaxHealth())
	end
end)

concommand.Add("stat_print",function(ply, cmd, args)
	local stat = args[1]
	local rank = args[2]
	
	print(ply:Strength())
	print(ply:Constitution())
	print(ply:Stamina())
	print(ply:Dexterity())
	print(ply:Intelligence())
	print(ply:Charisma())

end)


concommand.Add("stat_add",function(ply, cmd, args)
	local stat = args[1]
	local rank = args[2]
	
	if stat == "str" then ply:Strength(rank) end
	if stat == "dex" then ply:Dexterity(rank) end
	if stat == "con" then ply:Constitution(rank) end
	if stat == "sta" then ply:Stamina(rank) end
	if stat == "cha" then ply:Charisma(rank) end
	if stat == "int" then ply:Intelligence(rank) end

end)

concommand.Add("stat_reset",function(ply, cmd, args)
	local stat = args[1]
	local rank = args[2]
	
	ply:SetLevel(1)
	ply:SetStrength(1)
	ply:SetConstitution(1)
	ply:SetStamina(1)
	ply:SetIntelligence(1)
	ply:SetCharisma(1)
	ply:SetDexterity(1)
	ply:SetExperience(0)
	ply:SetNextLevel(100)
	ply:SetStatPoints(0)
	ply:SetHealth(100)
	ply:SetMaxHealth(100)

end)

concommand.Add("char_reset",function(ply, cmd, args)
	local stat = args[1]
	local rank = args[2]
	
	ply:Strength((ply:Strength() * -1)+1)
	ply:Dexterity((ply:Dexterity() * -1)+1)
	ply:Constitution((ply:Constitution() * -1)+1)
	ply:Stamina((ply:Stamina() * -1)+1)
	ply:Charisma((ply:Charisma() * -1)+1)
	ply:Intelligence((ply:Intelligence() * -1)+1)
	
	ply:PlayerLevel((ply:PlayerLevel() * -1)+1)
	ply:Experience((ply:Experience() * -1))
	ply:NextLevel((ply:NextLevel() * -1)+100)
	
	ply:SetMaxHealth(CalculateHitpoints(1, 1, false))
	ply:SetHealth(CalculateHitpoints(1, 1, false))

end)

concommand.Add("char_wipe",function(ply, cmd, args)	
	ply:SetNWInt("initialized", false)
	ply:SetPData("initialized", false)
	ply:SetInitialized(false)
end)

concommand.Add("char_create", function(ply, cmd, args)

	net.Start("MMO_CharCreate")
		net.Send(ply)

end)


concommand.Add("nw_vars", function(ply, cmd, args)
	print("Team:        "..tostring(ply:Team()))
	print("HP:          "..tostring(ply:Health()).."/"..tostring(ply:GetMaxHealth()))
	print("Title: 		"..tostring(ply:GetPlayerTitle()))
	print("EXP: 		"..tostring(ply:GetExperience()))
	print("Next: 		"..tostring(ply:GetNextLevel()))
	print("Level: 		"..tostring(ply:GetLevel()))
	print("Stats: 		"..tostring(ply:GetStatPoints()))
	print("Guildname: 	"..tostring(ply:GetGuildName()))
	print("Is Female: 	"..tostring(ply:GetFemale()))
	print("Hunger: 		"..tostring(ply:GetHunger()))
	print("Stamina: 	"..tostring(ply:GetStamina()))
	print("New Player: 	"..tostring(!(ply:GetInitialized())))
	print("Group #: 	"..tostring(ply:GetGroupNumber()))
	print("STR 			"..tostring(ply:GetStrength()))
	print("CON 			"..tostring(ply:GetConstitution()))
	print("STA 			"..tostring(ply:GetStamina()))
	print("DEX 			"..tostring(ply:GetDexterity()))
	print("INT 			"..tostring(ply:GetIntelligence()))
	print("CHA 			"..tostring(ply:GetCharisma()))
end)

concommand.Add("toggle_init", function(ply, cmd, args)
	ply:SetInitialized(!ply:GetInitialized())
end)
concommand.Add("istatus", function(ply, cmd, args)
	print(ply:GetInitialized())
end)

concommand.Add("forcesave", function(ply, cmd, args)
	SaveStats(ply)
end)

concommand.Add("inv_add", function(ply, cmd, args)

	local iTable = {
		[1] = {
			["name"] = "Sulfur",
			["desc"] = "Used to create Gunpowder",
			["model"] = "models/props_wasteland/prison_toiletchunk01f.mdl",
			["weight"] = 0.01,
			["amount"] = 100,
		},
		[2] = {
			["name"] = "Charcoal",
			["desc"] = "Used to create Gunpowder",
			["model"] = "models/props_wasteland/prison_toiletchunk01f.mdl",
			["weight"] = 0.01,
			["amount"] = 100,
		},
		[3] = {
			["name"] = "Saltpeter",
			["desc"] = "Used to create Gunpowder",
			["model"] = "models/props_wasteland/prison_toiletchunk01f.mdl",
			["weight"] = 0.01,
			["amount"] = 100,
		},
		[4] = {
			["name"] = "Metal Fragments",
			["desc"] = "Used to create stuff",
			["model"] = "models/props_wasteland/prison_toiletchunk01f.mdl",
			["weight"] = 0.01,
			["amount"] = 100,
		}
	}
	
	for k,v in pairs(iTable) do
		local prop = ents.Create("prop_physics_multiplayer")
		prop:SetModel(iTable[k]["model"])
		prop:SetPos(ply:EyePos() + ply:GetAimVector()*16)
		prop:Spawn()
		
		prop:SetGMProp(true)
		prop:SetPropName(iTable[k]["name"])
		prop:SetPropDescription(iTable[k]["desc"])
		prop:SetWeight(iTable[k]["weight"])
		prop:SetAmount(iTable[k]["amount"])
	end
	
end)

concommand.Add("inv_wipe", function(ply, cmd, args)
	table.Empty(ply.Inventory)
	net.Start("MMO_InvUpdate")
		net.WriteTable(ply.Inventory)
		net.Send(ply)
	table.Empty(ply.BankInventory)
	net.Start("MMO_BankUpdate")
		net.WriteTable(ply.BankInventory)
		net.Send(ply)
end)

concommand.Add("inv_show", function(ply, cmd, args)
	print("~~~~~~~PLAYER INVENTORY~~~~~~~")
	PrintTable(ply.Inventory)
	print("~~~~~~~ BANK INVENTORY ~~~~~~~")
	PrintTable(ply.BankInventory)
	
	net.Start("MMO_InvUpdate")
		net.WriteTable(ply.Inventory)
		net.Send(ply)
	net.Start("MMO_BankUpdate")
		net.WriteTable(ply.BankInventory)
		net.Send(ply)
end)


concommand.Add("forcesave", function(ply, cmd, args)
	SaveStats(ply)
end)

concommand.Add("setteam", function(ply, cmd, args)
	ply:SetTeam(args[1])
end)

concommand.Add("settrade", function(ply, cmd, args)
	if args[1] == "str" then ply:SetStrength(args[2])
	elseif args[1] == "sta" then ply:SetStamina(args[2])
	elseif args[1] == "con" then ply:SetConstitution(args[2])
	elseif args[1] == "dex" then ply:SetDexterity(args[2])
	elseif args[1] == "int" then ply:SetIntelligence(args[2])
	elseif args[1] == "cha" then ply:SetCharisma(args[2])
	elseif args[1] == "gun" then ply:SetGunsmithing(args[2])
	end
end)

concommand.Add("setcash", function(ply, cmd, args)
	ply:SetMoney(args[1])
end)
concommand.Add("getmodel", function(ply, cmd, args)
	print(ply:GetModel())
end)
