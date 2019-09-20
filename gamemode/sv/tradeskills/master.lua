
net.Receive("MMO_DoCombination", function(len, ply)

	-- Retrieve the item the player wants to create
	local ItemToCreate 	= net.ReadTable()
	local tradeskill 	= net.ReadString()
	print("[DEBUG] Received command to conduct tradeskill operation... ("..tradeskill..")")
	
	-- Copy the table into a table so we can screw with it, without messing up the existing table
	local table_copy = nil
	local skillLevel = nil
	if tradeskill == "Gunsmithing" then
		table_copy = table.Copy(recipes_gunsmithing)
		skillLevel = ply:GetGunsmithing()
	elseif tradeskill == "Engineering" then
		table_copy = table.Copy(recipes_engineering)
		skillLevel = ply:GetEngineering()
	elseif tradeskill == "Researching" then
		table_copy = table.Copy(recipes_researching)
		skillLevel = ply:GetResearching()
	elseif tradeskill == "Demolitions" then
		table_copy = table.Copy(recipes_demolitions)
		skillLevel = ply:GetDemolitions()
	elseif tradeskill == "Baking" then
		table_copy = table.Copy(recipes_baking)
		skillLevel = ply:GetBaking()
	elseif tradeskill == "Brewing" then
		table_copy = table.Copy(recipes_brewing)
		skillLevel = ply:GetBrewing()
	end
	
	-- Cancel this whole thing if the tradeskill doesn't exist to avoid console errors
	if table_copy == nil then return end
	
	-- Verify it exists, that the player isn't trying to make something else or cheat
	local exists = false
	local iName = nil
	for k,v in pairs(table_copy) do
		if k == ItemToCreate["name"] then
		exists = true
		iName = k
		end
	end
	
	-- Change ownership of table info from client to server's copy
	ItemToCreate = table_copy[iName]
	local trivial = ItemToCreate["trivial"] 
	print("[DEBUG] Item exists within the recipe system: ("..tostring(exists)..")")
	
	-- if it does not exist, suspend operations immediately
	if !exists then
		net.Start("MMO_Fail")
			net.WriteString("exists")
			net.Send(ply)
		print("[CAT Tradeskill] WARNING! "..tostring(ply).." attempted to craft "..tostring(ItemToCreate["name"]).." but it was not found in the recipe table!!")
		return
	end
	
	-- Copy table into a table of just recipes
	local recipe = table_copy[iName]["recipe"]
	
	-- Check that the player has all the recipe items, and enough of each
	local has_items = false
	local recipe_has = table.Count(recipe)
	local ply_has = 0
	for k,v in pairs(ply.Inventory) do
		for a,b in pairs(recipe) do
			if ply.Inventory[k]["name"] == a then
				if ply.Inventory[k]["amount"] >= b then
					ply_has = ply_has + 1
				end
			end
		end
	end
	
	if recipe_has <= ply_has then has_items = true end
	print("[DEBUG] Player has all the items required: ("..tostring(has_items)..") "..tostring(recipe_has).." <= "..tostring(ply_has))

	-- If they don't have it, send an MMO_Fail message
	if !has_items then
		net.Start("MMO_Fail")
			net.WriteString("insufficient")
			net.Send(ply)
		print("[DEBUG] Player does not have enough required items to craft specified item.")
		return
	end
	
	-- Decrease amount player has of each item by amount recipe used
	for k,v in pairs(recipe) do
		for a,b in pairs(ply.Inventory) do
			if ply.Inventory[a]["name"] == k then
				ply.Inventory[a]["amount"] = ply.Inventory[a]["amount"] - v
				print("[DEBUG] Reducing amount of "..ply.Inventory[a]["name"].." player has "..tostring(ply.Inventory[a]["amount"]).."-"..v)
			end
		end
	end
	
	RemoveZeroes(ply)

	-- Check to see if the player fails the combination
	local failed = false
	local rate_min = 0.05	-- Minimum chance to fail
	local rate_max = 0.95	-- Maximum success rate
	local rate = 0.035		-- Hardcoded, has no meaning
	
	local failure_rate = ((rate)-((0.015)*(ply:GetIntelligence()*0.01)))
	if failure_rate <= 0 then failure_rate = 0.005 end
	local final_rate = ((rate_max)-((trivial-skillLevel)*(failure_rate)))
	
	if final_rate < rate_min then final_rate = rate_min
	elseif final_rate > rate_max then final_rate = rate_max
	end
	
	final_rate = math.Round(final_rate * 100, 2)
	local fail_chance = math.Round(math.Rand(0.0001, 1) * 100, 2)
	print("[DEBUG] If "..tostring(fail_chance).." > "..tostring(final_rate).." then combination fails!")
	if fail_chance > final_rate then failed = true end
	
	-- Calculate the time it will take to craft the item
	local craft_time = 5 + trivial
	local deduction = ply:GetIntelligence() * 2
	craft_time = craft_time - deduction
	if craft_time < 1 then craft_time = 1 end
	
		-- Send MMO_Countdown with an Integer value of how long it will take (in seconds)
		if craft_time > 1 then
			net.Start("MMO_CountDown")
				net.WriteInt(craft_time, 8)
				net.Send(ply)
		end
		
	-- Create a timer that will fire with given time above
	--timer.Create(ply:UniqueID().."_crafttimer", craft_time, 1, function()
	
		-- If the player fails, send MMO_Fail net message with string = reason
		if failed then
			net.Start("MMO_Fail")
				net.WriteString("skill")
				net.Send(ply)
		
		-- If the player passes,
		else
		
			-- Check if the item they're making already exists
			local exists = false
			local index = nil
			for k,v in pairs(ply.Inventory) do
				if ply.Inventory[k]["name"] == ItemToCreate["name"] then
					exists = true
					index = k
				end
			end
			
			-- If it does, increase the count by the amount the recipe yields
			if exists and index ~= nil then
				ply.Inventory[index]["amount"] = ply.Inventory[index]["amount"] + ItemToCreate["amount"]
				
			-- If it does not, add it to their inventory
			else
				table.insert(ply.Inventory, ItemToCreate)
			end
			
			-- Send MMO_Pass net message with string of item name
			net.Start("MMO_Pass")
				net.WriteString(ItemToCreate["name"])
				net.Send(ply)
                
            sound.Play("items/ammo_pickup.wav", ply:GetPos())
		
		end
		-- Don't forget to update the player inventory
		net.Start("MMO_InvUpdate")
			net.WriteTable(ply.Inventory)
			net.Send(ply)
			
		-- Check for skill increase
		local increase = false
		local chance = 0
		if skillLevel < 200 then
			skill_mod = ((0.1)-((ply:GetIntelligence()/200) * (0.1)))
			chance = (1 / (((skill_mod)*(trivial))+1))
		end
		
		if chance > 1 then chance = 1
		elseif chance < 0.01 then chance = 0.01
		end
		
		chance = math.Round(chance * 100, 2)
		
		-- Only increase skill if the player's skill level is less than the trivial
		local check_chances = math.Round(math.Rand(0.0001, 1) * 100, 2)
		if check_chances <= chance and skillLevel < trivial then
			increase = true
		end
		print("[DEBUG] If "..tostring(check_chances).." > "..tostring(chance).." then skill does NOT increase!")
		
		-- If skill increases, send MMO_SkillUp with string of skill name
		if increase then
			if tradeskill == "Gunsmithing" then ply:SetGunsmithing(ply:GetGunsmithing() + 1)
			elseif tradeskill == "Engineering" then ply:SetEngineering(ply:GetEngineering() + 1)
			elseif tradeskill == "Demolitions" then ply:SetDemolitions(ply:GetDemolitions() + 1)
			elseif tradeskill == "Researching" then ply:SetResearching(ply:GetResearching() + 1)
			end
			net.Start("MMO_SkillUp")
				net.WriteString(tradeskill)
				net.Send(ply)
		end
	--end)
		
	-- Create a hook where if the player moves, the above timer gets canceled
	
		-- Send MMO_Fail with string "moved" to notify player of cancelation
	
end)