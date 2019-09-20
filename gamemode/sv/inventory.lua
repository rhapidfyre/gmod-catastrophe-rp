
-- Call to keep the inventory updated
function KeepUpdated(ply)
	print("[DEBUG] Sending Inventory Update ["..tostring(ply.Inventory).."] to Client...")
	net.Start("MMO_InvUpdate")
		net.WriteTable(ply.Inventory)
		net.Send(ply)
end

-- Merge Item Function
local function MergeItem(ent, ply, iName, iDesc, iWeight, iModel, iAmount)

	-- Consistencies
	if iName	== nil then iName = "NAME MISSING" end
	if iDesc	== nil then iDesc = "DESC MISSING" end
	if iWeight	== nil then iWeight = 0.0 end
	if iModel	== nil then iModel = "models/error.mdl" end
	if iAmount == nil then iAmount = 1 end
	
	-- Use FLAG for checking if it exists in the inventory
	local flag = false
	local key = 0
	
	-- Since each key's value is a table for the item's information, we have to cycle through it.
	for k,v in pairs(ply.Inventory) do
		if (ply.Inventory[k]["name"] == iName) then
			flag = true
			key = k
		end
		print(ply.Inventory[k])
		print("Table Key: "..tostring(k))
	end
	
	-- Another FLAG for removing the prop if it was added
	local remove = false
	if flag then
		-- Item exists, increase the count
		net.Start("MMO_PickupSound")
			net.Send(ply)
		ply.Inventory[key]["amount"] = ply.Inventory[key]["amount"] + iAmount
		remove = true
	else
		-- Item doesn't exist in player's inventory, add it.
		local new_item = {
			["name"] = iName,
			["desc"] = iDesc,
			["weight"] = iWeight,
			["amount"] = iAmount,
			["model"] = iModel
		}
		net.Start("MMO_PickupSound")
			net.Send(ply)
		table.insert(ply.Inventory, new_item)
		remove = true
	end
	
	-- Delete the prop from the world if it was added to prevent picking up multiples from one item
	if remove == true then ent:Remove() end
	
	KeepUpdated(ply)

end

-- This is really just useful if a player is trying to pick up a dropped item.
-- Inventory drops, and inventory overflows spew props out into the world.
local function PickupItem(ply, key)

	if (key == IN_USE) then
		local eyetrace = ply:GetEyeTraceNoCursor()
		local ent = eyetrace.Entity
		if IsValid(ent) then
			if ent:GetClass() == "prop_physics_multiplayer" then
				if ent:GetGMProp() then
					if ply:GetPos():Distance(ent:GetPos()) < 128 then
						local iName 	= ent:GetPropName()
						local iDesc 	= ent:GetPropDescription()
						local iWeight 	= ent:GetWeight()
						local iAmount	= ent:GetAmount()
						local iModel	= ent:GetModel()
						
						MergeItem(ent, ply, iName, iDesc, iWeight, iModel, iAmount)
					else
						ply:PrintMessage(HUD_PRINTTALK, "You are too far away to pick up that prop!")
					end
				else
					print("[DEBUG] Entity is not a gamemode prop!")
				end
			end
		end
	end
	
end

hook.Add("KeyPress", "PickupItem", PickupItem)

local function DecreaseHunger(value)

end

local function DecreaseThirst(value)

end

local function MakeBankTerminal()

end

local function IncreaseStat(stattype, value)
	
end

-- Consume Item Function
net.Receive("MMO_Consume", function(len, ply)
	local iName = net.ReadString()
	local has_item = false
	local index = nil
	for k,v in pairs(ply.Inventory) do
		if ply.Inventory[k]["name"] == iName then
			has_item = true
			index = k
		end
	end
	
	if has_item then
	
		-- Do effect based on item name
		local donotconsume = false
		if 		iName == "9mm Ammunition" then ply:Give("item_ammo_pistol")
		elseif 	iName == "9mm Pistol" then ply:Give("weapon_pistol")
		elseif 	iName == "SMG Ammo" then ply:Give("item_ammo_smg1")
		elseif 	iName == "357 Ammo" then ply:Give("item_ammo_357")
		elseif 	iName == "Submachine Gun" then ply:Give("weapon_smg1")
		elseif 	iName == "357 Revolver" then ply:Give("weapon_357")
		elseif 	iName == "Pulse Ammo" then ply:Give("item_ammo_ar2")
		elseif 	iName == "Crossbow Bolt" then ply:Give("item_ammo_crossbow")
		elseif 	iName == "Shotgun" then ply:Give("weapon_shotgun")
		elseif 	iName == "AR2 Combine Rifle" then ply:Give("weapon_ar2")
		elseif 	iName == "Rebar Crossbow" then ply:Give("weapon_crossbow")
		elseif 	iName == "Zombie Sandwich" then DecreaseHunger(20)
		elseif 	iName == "Combine Bagged Lunch" then DecreaseHunger(50)
		elseif 	iName == "Can of Headcrab Soup" then DecreaseHunger(75)
		elseif 	iName == "Headcrab Meat Sandwich" then DecreaseHunger(100)
		elseif 	iName == "Box of Grilled Antlion" then DecreaseHunger(250)
		elseif 	iName == "Fresh Antlion Stew" then DecreaseHunger(600)
		elseif 	iName == "Army Issued MRE" then DecreaseHunger(1000)
		elseif 	iName == "Pond Water" then DecreaseThirst(20)
		elseif 	iName == "Orange Juice" then DecreaseThirst(50)
		elseif 	iName == "Captain Jacks Rum" then DecreaseThirst(75)
		elseif 	iName == "Fresh Milk" then DecreaseThirst(100)
		elseif 	iName == "Fresh Cola" then DecreaseThirst(325)
		elseif 	iName == "Energy SIX" then DecreaseThirst(600)
		elseif 	iName == "Mystic Mountain" then DecreaseThirst(1000)
		elseif 	iName == "Frag Grenade" then ply:Give("weapon_frag")
		elseif 	iName == "RPG Ammunition" then ply:Give("item_rpg_round")
		elseif 	iName == "Frag Grenade" then ply:Give("weapon_frag")
		elseif 	iName == "Rocket Launcher" then ply:Give("weapon_rpg")
		elseif 	iName == "Gravity Gun" then ply:Give("weapon_physcannon")
		elseif 	iName == "Mobile Bank Terminal" then MakeBankTerminal()
		elseif 	iName == "Buggy" then ply:SetHasBuggy(true)
		elseif 	iName == "Airboat" then ply:SetHasAirboat(true)
		elseif 	iName == "Steroid Tablet" then IncreaseStat(25)
		elseif 	iName == "Dopamine Tablet" then IncreaseStat(25)
		elseif 	iName == "Morphine Tablet" then IncreaseStat(25)
		elseif 	iName == "Nootropic Tablet" then IncreaseStat(25)
		elseif 	iName == "Modafinil Tablet" then IncreaseStat(25)
		elseif 	iName == "Opiate Tablet" then IncreaseStat(25)
		elseif 	iName == "Steroid Injection" then IncreaseStat(50)
		elseif 	iName == "Dopamine Injection" then IncreaseStat(50)
		elseif 	iName == "Morphine Injection" then IncreaseStat(50)
		elseif 	iName == "Nootrophic Injection" then IncreaseStat(50)
		elseif 	iName == "Modafinil Injection" then IncreaseStat(50)
		elseif 	iName == "Opiate Injection" then IncreaseStat(50)
		elseif 	iName == "Small Health Vial" then TempRegen(50)
		elseif 	iName == "Medium Health Vial" then TempRegen(50)
		elseif 	iName == "Large Health Vial" then TempRegen(50)
		elseif 	iName == "Small Health Kit" then ReplaceHitpoints(25)
		elseif 	iName == "Medium Health Kit" then ReplaceHitpoints(100)
		elseif 	iName == "Large Health Kit" then ReplaceHitpoints(250)
		else
			donotconsume = true
		end
		
		if !donotconsume then
			local newcount = ply.Inventory[index]["amount"]
			ply.Inventory[index]["amount"] = newcount - 1
			
			RemoveZeroes(ply)
			
			net.Start("MMO_InvUpdate")
				net.WriteTable(ply.Inventory)
				net.Send(ply)
		end

	end
end)

-- Destroy Item Function
net.Receive("MMO_InvDelete", function(len, ply)

	local iDelete = net.ReadTable()
	
	table.remove(ply.Inventory[iDelete])
	
	-- Keep the player inventory up to date
	KeepUpdated(ply)

end)

-- Drop Item Function
net.Receive("MMO_InvDrop", function(len, ply)

	-- Since each key's value is a table for the item's information, we have to cycle through it.
	local iName = net.ReadString()
	local iAmount = net.ReadInt(32)
	
	local index = nil
	for k,v in pairs(ply.Inventory) do
		if (ply.Inventory[k]["name"] == iName) then
			index = k
		end
	end
	
	if index == nil then
		return
	else
	
		local total = ply.Inventory[index]["amount"]
		if total < iAmount then iAmount = total end
		
	
		local balance = total - iAmount
		
		local prop = ents.Create("prop_physics_multiplayer")
		prop:SetModel(ply.Inventory[index]["model"])
		prop:SetPos(ply:EyePos() + ply:GetAimVector() * 16)
		prop:SetAngles(ply:GetAngles())
		prop:Spawn()
		prop.DroppedTime = CurTime()
		
		prop:SetPropName(ply.Inventory[index]["name"])
		prop:SetPropDescription(ply.Inventory[index]["desc"])
		prop:SetAmount(iAmount)
		prop:SetWeight(ply.Inventory[index]["weight"])
		prop:SetGMProp(true)
		
		if balance == 0 then 
			table.remove(ply.Inventory, index)
		else
			ply.Inventory[index]["amount"] = balance
		end
		
		KeepUpdated(ply)
		
	end
	
end)