
-- Search the inventory for anything with a zero value, and remove it
function RemoveZeroes(ply)

	local changed = false
	for k,v in pairs(ply.Inventory) do
		if ply.Inventory[k]["amount"] <= 0 then
			table.remove(ply.Inventory, k)
			changed = true
		end
	end
	
	-- If the inventory changed, send an update.
	if changed then
		net.Start("MMO_InvUpdate")
			net.WriteTable(ply.Inventory)
			net.Send(ply)
	end
end

-- Clean up expired corpses and props on server tick
hook.Add("ServerTick", "CleanRagdolls", function()
	for k,v in pairs(ents.FindByClass("prop_ragdoll")) do
		if ((v.DeathTime + DECAY_TIMER) - CurTime() < 1) then
			print("[CAT "..tostring(os.date("%d/%m/%Y @ %H:%M:%S")).."] Removing expired corpse ["..tostring(v).."] @ ("..tostring(v:GetPos())..")")
			v:Remove()
		end
	end
	for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do
		if isnumber(v.DroppedTime) then
			if (v.DroppedTime + DECAY_ITEM) < CurTime() then
				print("[CAT "..tostring(os.date("%d/%m/%Y @ %H:%M:%S")).."] Removing abandoned prop ["..tostring(v:GetPropName()).."] @ ("..tostring(v:GetPos())..")")
				v:Remove()
			end
		end
	end
end)

-- Every 6 seconds the server will "Tick", to trigger events such as HP Regen and more.
timer.Create("ServerTicker", 6, 0, function()
	hook.Run("ServerTick")
end)


function SaveStats(ply)

	print("[CAT "..tostring(os.date("%d/%m/%Y @ %H:%M:%S")).."] Saving "..ply:Name().."'s stats to file...")
	if ply:Team() == 1 or ply:Team() == 2 then
		ply:SetPData("initialized",ply:GetInitialized())
		ply:SetPData("team",ply:Team())
		ply:SetPData("model",ply:GetModel())
		ply:SetPData("hp_maximum",ply:GetMaxHealth())
		ply:SetPData("hp_current",ply:Health())
		ply:SetPData("level",ply:GetLevel())
		ply:SetPData("statpoints",ply:GetStatPoints())
		ply:SetPData("engineering",ply:GetEngineering())
		ply:SetPData("demolitions",ply:GetDemolitions())
		ply:SetPData("researching",ply:GetResearching())
		ply:SetPData("scavenging",ply:GetScavenging())
		ply:SetPData("nextlevel",ply:GetNextLevel())
		ply:SetPData("experience",ply:GetExperience())
		ply:SetPData("female",ply:GetFemale())
		ply:SetPData("money",ply:GetMoney())
		ply:SetPData("hunger",ply:GetHunger())
		ply:SetPData("thirst",ply:GetThirst())
		ply:SetPData("endurance",ply:GetEndurance())
		ply:SetPData("oxygen",ply:GetOxygen())
		ply:SetPData("guildname",ply:GetGuildName())
		ply:SetPData("playertitle",ply:GetPlayerTitle())
		ply:SetPData("strength",ply:GetStrength())
		ply:SetPData("constitution",ply:GetConstitution())
		ply:SetPData("stamina",ply:GetStamina())
		ply:SetPData("dexterity",ply:GetDexterity())
		ply:SetPData("intelligence",ply:GetIntelligence())
		ply:SetPData("charisma",ply:GetCharisma())
		ply:SetPData("groupnumber",ply:GetGroupNumber())
		ply:SetPData("baking",ply:GetBaking())
		ply:SetPData("brewing",ply:GetBrewing())
		
		local inv 		= util.TableToJSON(ply.Inventory)
		local bankinv 	= util.TableToJSON(ply.BankInventory)
		
		ply:SetPData("inventory", inv)
		ply:SetPData("bankinventory", bankinv)
		
		print("[CAT "..tostring(os.date("%d/%m/%Y @ %H:%M:%S")).."] Stats have been saved for "..ply:Name()..".")
		
	else
		print("[CAT "..tostring(os.date("%d/%m/%Y @ %H:%M:%S")).."] Failed to save "..ply:Name().."'s stats - Player is not in the game world!")
	end
end

timer.Create("SavePlayerStats", SAVE_INTVL, 0, function()
	for _,saveply in pairs(player.GetAll()) do
		SaveStats(saveply)
	end
end)