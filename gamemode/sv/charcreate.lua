
-- Set up consistencies
local valid_teams  = {
	[1] = true,
	[2] = true
}
local valid_stats = {
	["str"] = true,
	["con"] = true,
	["dex"] = true,
	["sta"] = true,
	["int"] = true,
	["cha"] = true
}
local valid_models = {
	["models/player/group03/male_01.mdl"] = true,
	["models/player/group03/male_02.mdl"] = true,
	["models/player/group03/male_03.mdl"] = true,
	["models/player/group03/male_04.mdl"] = true,
	["models/player/group03/male_05.mdl"] = true,
	["models/player/group03/male_06.mdl"] = true,
	["models/player/group03/male_07.mdl"] = true,
	["models/player/group03/male_08.mdl"] = true,
	["models/player/group03/male_09.mdl"] = true,
	["models/player/group03/female_01.mdl"] = true,
	["models/player/group03/female_02.mdl"] = true,
	["models/player/group03/female_03.mdl"] = true,
	["models/player/group03/female_04.mdl"] = true,
	["models/player/group03/female_05.mdl"] = true,
	["models/player/group03/female_06.mdl"] = true,
	["models/player/combine_soldier.mdl"] = true,
	["models/player/combine_soldier_prisonguard.mdl"] = true,
	["models/player/police.mdl"] = true,
	["models/player/combine_super_soldier.mdl"] = true
}

-- Check that all the PData information is valid. If it's not, assign defaults.
local function LoadConsistency(ply)

	-- Model consistency
	if !(valid_models[ply:GetModel()]) then
		if ply:Team() == 1 then
			-- Female is a bool so it is always be true or false. Not checking consistency.
			if ply:GetFemale() then ply:SetModel("models/player/group03/male_01.mdl")
			else ply:SetModel("models/player/group03/female_01.mdl")
			end
		else
			ply:SetModel("models/player/combine_soldier.mdl")
		end
	end
	
	-- HP / Constitution / Level consistency
	if (ply:GetLevel() <= 0) then ply:SetLevel(1) end
	if (ply:GetConstitution() <= 0) then ply:SetConstitution(1) end	
	local calc_max_hp = CalculateHitpoints(ply:GetConstitution(), ply:GetLevel(), false)
	if (ply:GetMaxHealth() ~= calc_max_hp) then ply:SetMaxHealth(calc_max_hp) end
	if (ply:Health() <= 0) then ply:SetHealth(calc_max_hp) end
	
	-- If the player hasn't played in a half hour, set their HP back to full.
	-- GetLastPlayed is NOT implemented yet [DEBUG]
	--if ((ply:GetLastPlayed() + 1800) <= os.time()) then ply:SetHealth(ply:GetMaxHealth()) end
	
	-- Since we can't check consistency for stat points, trades, and stats because people put points into them,
	-- We're just going to make sure they're not negative or zero, and set them to 1 if they are.
	if ply:GetEngineering() <= 0 then ply:SetEngineering(1) end
	if ply:GetGunsmithing() <= 0 then ply:SetGunsmithing(1) end
	if ply:GetDemolitions() <= 0 then ply:SetDemolitions(1) end
	if ply:GetResearching() <= 0 then ply:SetResearching(1) end
	if ply:GetBaking() <= 0 then ply:SetBaking(1) end
	if ply:GetBrewing() <= 0 then ply:SetBrewing(1) end
	if ply:GetScavenging() <= 0 then ply:SetScavenging(1) end
	if ply:GetStrength() <= 0 then ply:SetStrength(1) end
	if ply:GetDexterity() <= 0 then ply:SetDexterity(1) end
	if ply:GetStamina() <= 0 then ply:SetStamina(1) end
	if ply:GetIntelligence() <= 0 then ply:SetIntelligence(1) end
	if ply:GetCharisma() <= 0 then ply:SetCharisma(1) end
	
	-- This is the consistency that will suck for players. Since NextLevel's formula is dependent on the previous
	--[[ level's maximum, if the consistency is fucked for it, then we're resetting them to level 1.
	if ply:GetNextLevel() <= 99 then
		ply:SetNextLevel(100)
		ply:SetLevel(1)
		ply:SetExperience(1)
		-- Let's give the player a warning, because this consistency check is going to fucking hurt.
		ply:PrintMessage(HUD_PRINTTALK, "[WARNING] Major file corruption issue. You have been reset to Level 1.")
		ply:PrintMessage(HUD_PRINTTALK, "[WARNING] Please contact a Game Master/Admin IMMEDIATELY!")
	end]]
	
	-- If any of these casuals are 0 or less, benefit of the doubt, set to 1000 (full)
	if ply:GetHunger() <= 0 then ply:SetHunger(1000) end
	if ply:GetThirst() <= 0 then ply:SetThirst(1000) end
	if ply:GetEndurance() <= 0 then ply:SetEndurance(100) end
	if ply:GetOxygen() <= 0 then ply:SetOxygen(1000) end
	
	-- No consistency for cash. Not giving people money if the PData failed.
	
	if ply:GetExperience() < 0 then ply:SetExperience(0) end
	
	if ply:GetPlayerTitle() == "" then ply:SetPlayerTitle("Fresh Meat") end
	if ply:GetGuildName() == "" then ply:GetGuildName("None") end
    
    if ply.Inventory == nil then ply.Inventory = {} end
    if ply.BankInventory == nil then ply.BankInventory = {} end
	
	-- Spawn the player after loading stats and information
	if (ply:Team() ~= 1 and ply:Team() ~= 2) then
		ply:SetTeam(math.random(1,2))
		print("[DEBUG] Team was not 1 or 2, setting random...")
	end
	timer.Simple(0.25, function()
		ply:Spawn()
	end)
	
end

net.Receive("MMO_LoadChar", function(len, ply)

	local init_valid = ply:GetPData("initialized")
	if init_valid then ply:SetInitialized(init_valid) end

	if ply:GetInitialized() then
	
		ply:SetTeam(tonumber(ply:GetPData("team")))
		print("[DEBUG] Loaded Team #"..ply:GetPData("team").." from file (PData).")
		
		ply:SetModel(ply:GetPData("model"))
		ply:SetMaxHealth(ply:GetPData("hp_maximum"))
		ply:SetHealth(ply:GetPData("hp_current"))
		
		ply:SetLevel(ply:GetPData("level"))
		ply:SetStatPoints(ply:GetPData("statpoints"))
		ply:SetEngineering(ply:GetPData("engineering"))
		ply:SetDemolitions(ply:GetPData("demolitions"))
		ply:SetResearching(ply:GetPData("researching"))
		ply:SetScavenging(ply:GetPData("scavenging"))
		ply:SetNextLevel(ply:GetPData("nextlevel"))
		ply:SetExperience(ply:GetPData("experience"))
		ply:SetFemale(ply:GetPData("female"))
		ply:SetMoney(ply:GetPData("money"))
		ply:SetHunger(ply:GetPData("hunger"))
		ply:SetThirst(ply:GetPData("thirst"))
		ply:SetEndurance(ply:GetPData("endurance"))
		ply:SetOxygen(ply:GetPData("oxygen"))
		ply:SetGuildName(ply:GetPData("guildname"))
		ply:SetPlayerTitle(ply:GetPData("playertitle"))
		ply:SetStrength(ply:GetPData("strength"))
		ply:SetConstitution(ply:GetPData("constitution"))
		ply:SetStamina(ply:GetPData("stamina"))
		ply:SetDexterity(ply:GetPData("dexterity"))
		ply:SetIntelligence(ply:GetPData("intelligence"))
		ply:SetCharisma(ply:GetPData("charisma"))
		ply:SetGroupNumber(ply:GetPData("groupnumber"))
		ply:SetBaking(ply:GetPData("baking"))
		ply:SetBrewing(ply:GetPData("brewing"))
		
		if ply:GetGroupNumber() == "" or ply:GetGroupNumber() == nil then
			ply:SetGroupNumber(0)
		end
		
		local inv = util.JSONToTable(ply:GetPData("inventory"))
		local bankinv = util.JSONToTable(ply:GetPData("bankinventory"))
		
		-- Give the server a milisecond to process the conversion before setting it.
		timer.Simple(0.25, function()
			ply.Inventory = inv
            ply.BankInventory = bankinv
			net.Start("MMO_InvUpdate")
				net.WriteTable(inv)
				net.Send(ply)
		end)
		
		timer.Simple(0.1, function()
			LoadConsistency(ply)
		end)
	
	else
		net.Start("MMO_CharCreate")
			net.WriteInt(1, 4)
			net.Send(ply)
	end
	
	timer.Simple(0.25, function() ply:Spawn() end)
	
end)

net.Receive("MMO_CharSubmit", function(len, ply)

	-- Receive Client's Information
	local team_choice 	= net.ReadInt(8)
	local gender 		= net.ReadBool()
	local plymodel 		= net.ReadString()
	local statboost 	= net.ReadString()
	

	-- Check for consistency, that is, that the information the client sent us is valid
	-- If the table does not have the client's request in it, set a default.
	if !valid_teams[team_choice] then
		team_choice = math.random(1,2)
	end
	
	if !valid_stats[statboost] then
		statboost = "lol"
	end
	
	if !valid_models[plymodel] then
		if team_choice == 1 then
			if gender then 	plymodel = "models/player/group03/female_01.mdl"
			else 			plymodel = "models/player/group03/male_01.mdl"
			end
		else
			plymodel = "models/player/combine_soldier.mdl"
		end
	end
	
	-- Set the team
	ply:SetTeam(team_choice)
	
	-- Short delay in spawning them to give time for the script to assign their team first
	-- Otherwise, a Combine player's first experience will be getting shredded by rebels.
	timer.Simple(0.25, function()
		ply:Spawn()
	end)
	
	timer.Simple(1, function()
	
		-- Run first time set up for networked vars
		ply:SetInitialized(true)
		ply:SetModel(plymodel)
		ply:SetMaxHealth(CalculateHitpoints(ply:GetConstitution(), ply:GetLevel(), false))
		ply:SetLevel(1)						-- New players begin at level 1
		ply:SetStatPoints(0)				-- No stat increase points
		ply:SetEngineering(1)				-- Tradeskills start at Level 1
		ply:SetDemolitions(1)
		ply:SetResearching(1)
		ply:SetGunsmithing(1)
		ply:SetScavenging(1)
		ply:SetBrewing(1)
		ply:SetBaking(1)
		ply:SetNextLevel(100)				-- Level 2 requires 100 experience points
		ply:SetExperience(1)				-- Start with 1 EXP point
		ply:SetFemale(gender)				-- If true, player is a female model
		ply:SetMoney(0)						-- Newbies don't have cash
		ply:SetHunger(1000)					-- Max hunger to start
		ply:SetThirst(1000)					-- Max thirst to start
		ply:SetEndurance(100)				-- Max endurance at start
		ply:SetOxygen(100)					-- Oxygen always full unless under water
		ply:SetGuildName("NA")				-- "NA" guild removes tag visibility
		ply:SetGroupNumber(0)
		ply:SetPlayerTitle("Fresh Meat")	-- Title stays Fresh Meat until changed by player
        ply.Inventory = {}
        ply.BankInventory = {}
		
		-- Set up all stats to begin at 1
		ply:SetStrength(ply:GetStrength() + 1)
		ply:SetConstitution(ply:GetConstitution() + 1)
		ply:SetStamina(ply:GetStamina() + 1)
		ply:SetDexterity(ply:GetDexterity() + 1)
		ply:SetIntelligence(ply:GetIntelligence() + 1)
		ply:SetCharisma(ply:GetCharisma() + 1)
		
		-- Give a +2 boost to the stat chosen
		timer.Simple(0.1, function()
			if statboost == "str"     then	ply:SetStrength(ply:GetStrength() + 2)
			elseif statboost == "con" then	ply:SetConstitution(ply:GetConstitution() + 2)
			elseif statboost == "sta" then	ply:SetStamina(ply:GetStamina() + 2)
			elseif statboost == "dex" then	ply:SetDexterity(ply:GetDexterity() + 2)
			elseif statboost == "int" then	ply:SetIntelligence(ply:GetIntelligence() + 2)
			else					  		ply:SetCharisma(ply:GetCharisma() + 2)
			end
			ply:SetMaxHealth(CalculateHitpoints(ply:GetConstitution(), 1, false))
			ply:SetHealth(ply:GetMaxHealth())
		end)
		
	end)
	
	ply:PrintMessage(HUD_PRINTTALK, "Character Approved! Welcome to Catastrophe RPG!")
	ply:PrintMessage(HUD_PRINTTALK, " ")
	ply:PrintMessage(HUD_PRINTTALK, "You have been sent to your home city.")
	ply:PrintMessage(HUD_PRINTTALK, "You may get quests to complete, or just head outside if you're ready!")
	ply:PrintMessage(HUD_PRINTTALK, "You will lose experience if you die.")
	
	net.Start("MMO_CharAccept")
		net.Send(ply)
	
	-- Save all the new stats so they are not lost after loading in the first time
	timer.Simple(1, function() SaveStats(ply) end)
	
end)















