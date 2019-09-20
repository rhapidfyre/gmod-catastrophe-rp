
-- Generates the loot table
function GenLootTable(npc_class)

	-- Set key to the NPC Class to retrieve appropriate loot
	local tbl_value = loot_generic[npc_class]
	
	-- If the key doesn't exist, pick some generic loot
	if tbl_value == nil then
		tbl_value = loot_generic["misc"]
	end
	
	-- Return table of items
	return tbl_value
end

local function LootWindow(ply, ragdoll)

	-- Verify player is on the list of eligible looters by checking who killed it
	local distance = ply:GetPos():Distance(ragdoll:GetPos())
	if distance < LOOT_DISTANCE then
	
		net.Start("MMO_LootOpen")
			net.WriteString(ragdoll.LootTable)
			
			-- Must be given entity so client and tell server what body is being looted
			net.WriteEntity(ragdoll)	
			net.Send(ply)
	else
		ply:PrintMessage(HUD_PRINTCENTER, "Too far away!")
	end
end

local function LootBody(ply, key)
	if key == IN_USE then
		local eyetrace = ply:GetEyeTrace()
		local ent = eyetrace.Entity
		if IsValid(ent) then
			if ent:IsRagdoll() then
                if ent:GetNWBool("lootable") or ent.Owner == ply then
                    LootWindow(ply, ent)
                end
			end
		end
	end
end
hook.Add("KeyPress", "LootCorpse", LootBody)

-- Generate loot on spawn rather than death.
hook.Add("OnEntityCreated", "BuildLoot", function(npc)

	if npc:IsNPC() then
	
		local loot_options = GenLootTable(npc:GetClass())
		local loot_table = {}
		
		for k,item in pairs(loot_options) do
			local rarity  = item["chance"]
			local randnum = nil
			
			-- Check rarity of the item
			if rarity < 100 then
			
				-- Roll chance to drop
				if math.random(0, 1000) <= (rarity*10) then
					table.insert(loot_table, item)
				end
			else
				table.insert(loot_table, item)
			end
		end
		
		-- Change the table to json, less shit to process
		local json_table = util.TableToJSON(loot_table)
		npc.LootTable = json_table
	end
	
end)

net.Receive("MMO_LootAll", function(len, ply)

	local ragdoll = net.ReadEntity()
	local ragCopy = table.Copy(util.JSONToTable(ragdoll.LootTable))
	for k,v in pairs(ragCopy) do
	
		local iName 	= ragCopy[k]["name"]
		local iAmount 	= ragCopy[k]["amount"]
		local plyCopy	= table.Copy(ply.Inventory)
		
		-- Use FLAG for checking if it exists in the inventory
		local flag = false
		local ke_y = 0
		
		-- Since each key's value is a table for the item's information, we have to cycle through it.
		for key,val in pairs(ply.Inventory) do
			if (plyCopy[key]["name"] == iName) then
				flag = true
				ke_y = key
			end
		end
		if flag then
			print("[DEBUG] Adding "..iName.." to current existing inventory item at index ("..tostring(ke_y)..")")
			-- Item exists, increase the count
			net.Start("MMO_PickupSound")
				net.Send(ply)
			ply.Inventory[ke_y]["amount"] = plyCopy[ke_y]["amount"] + iAmount
		else
			print("[DEBUG] "..iName.." didn't exist previously in the player's inventory.")
			
			-- Item doesn't exist in player's inventory, add it.
			net.Start("MMO_PickupSound")
				net.Send(ply)
			table.insert(ply.Inventory, ragCopy[k])
		end
	end
	
	-- Delete the prop from the world if it was added to prevent picking up multiples from one item
	ragdoll:Remove()
	
	KeepUpdated(ply)
	
end)

net.Receive("MMO_LootItem", function(len, ply)
	local amount = net.ReadInt(32)
	local iName = net.ReadString()
	local ragdoll = net.ReadEntity()
	local ragCopy = table.Copy(ragdoll.LootTable)
	print("[DEBUG] Receiving "..amount.." "..iName.." from "..tostring(ragdoll))
	
	local key = nil
	for k,v in pairs(ragdoll.LootTable) do
		if ragCopy[k]["name"] == iName then
			key = k
			print("[DEBUG] Found item in loot table")
		end
	end
	
	net.Start("MMO_PickupSound")
		net.Send(ply)
	
	ragdoll.LootTable[key]["amount"] = ragCopy[key]["amount"] - amount
	
	table.insert(ply.Inventory, ragCopy[key])	
	
	if ragdoll.LootTable[key]["amount"] <= 0 then
		table.remove(ragdoll.LootTable, key)
	end
	
	if #ragdoll.LootTable <= 0 then
		ragdoll:Remove()
	end
end)



















